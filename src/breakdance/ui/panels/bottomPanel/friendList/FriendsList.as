/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 03.07.13
 * Time: 18:07
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.bottomPanel.friendList {

    import breakdance.BreakdanceApp;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.server.ServerApi;
    import breakdance.core.server.ServerUtils;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.ui.panels.bottomPanel.*;
    import breakdance.user.AppUser;
    import breakdance.user.FriendData;

    import com.greensock.TweenLite;
    import com.hogargames.debug.Tracer;
    import com.hogargames.display.scrolls.AbstractResizableStepScroll;
    import com.hogargames.display.scrolls.MotionType;

    import flash.display.InteractiveObject;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class FriendsList extends AbstractResizableStepScroll {

        private var addFriendItem:AddFriendItem;
        private var items:Vector.<FriendsListItem> = new Vector.<FriendsListItem> ();

        private var currentFriendData:FriendData;

        private static const NUM_VISIBLE_ITEMS:int = 6;
        private static const STEP:int = 71;
        private static const HEIGHT:int = 90;
        private static const TWEEN_TIME:Number = .3;

        public function FriendsList (mc:MovieClip) {
            super (mc, NUM_VISIBLE_ITEMS, STEP, NUM_VISIBLE_ITEMS * STEP, HEIGHT);
            motionType = MotionType.X;
        }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

        public function init (friends:Vector.<FriendData>):void {
            clear ();
            //add scroll elements:
            var numFriends:int = friends.length;
            items = new Vector.<FriendsListItem> ();
            for (var i:int = 0; i < numFriends; i++) {
                var friendsListItem:FriendsListItem = new FriendsListItem ();
                friendsListItem.friendData = friends [i];
                friendsListItem.addEventListener (Event.CHANGE, changeListener);
                friendsListItem.addEventListener (MouseEvent.CLICK, clickListener);
                container.addChild (friendsListItem);
                items.push (friendsListItem);
            }
            addFriendItem.x = (i) * STEP;
            container.addChild (addFriendItem);

            //set scroll params:
            this.numItems = numFriends + 1;
            moveTo (0);

            reposition ();
        }

        override public function clear ():void {
            if (container.contains (addFriendItem)) {
                container.removeChild (addFriendItem);
            }
            for (var i:int = 0; i < items.length; i++) {
                var friendsListItem:FriendsListItem = items [i];
                friendsListItem.removeEventListener (Event.CHANGE, changeListener);
                friendsListItem.removeEventListener (MouseEvent.CLICK, clickListener);
                if (container.contains (friendsListItem)) {
                    container.removeChild (friendsListItem);
                }
                friendsListItem.destroy ();
            }
        }

        override public function destroy ():void {
            clear ();
            if (addFriendItem) {
                addFriendItem.removeEventListener (MouseEvent.CLICK, clickListener_inviteFriends);
                addFriendItem.destroy ();
                addFriendItem = null;
            }
            super.destroy ();
        }

//////////////////////////////////
//PROTECTED:
//////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            //создаём кнопки:
            btnNext = new TypeButton (getElement (BTN_NEXT));
            btnPrevious = new TypeButton (getElement (BTN_PREVIOUS));
            if (btnBegin) {
                btnBegin = new TypeButton (getElement (BTN_BEGIN));
            }
            if (btnEnd) {
                btnEnd = new TypeButton (getElement (BTN_END));
            }
            addFriendItem = new AddFriendItem ();
            addFriendItem.addEventListener (MouseEvent.CLICK, clickListener_inviteFriends);
        }

        override protected function move (targetCoordinate:Number):void {
            if (motionType == MotionType.X) {
                TweenLite.to (container, TWEEN_TIME, {x: targetCoordinate});
            }
            else if (motionType == MotionType.Y) {
                TweenLite.to (container, TWEEN_TIME, {y: targetCoordinate});
            }
        }

        override protected function activateButton (btn:InteractiveObject):void {
            if (btn != null) {
                TypeButton (btn).enable = true;
            }
        }

        override protected function deactivateButton (btn:InteractiveObject):void {
            if (btn != null) {
                TypeButton (btn).enable = false;
            }
        }

//////////////////////////////////
//PRIVATE:
//////////////////////////////////

        private function reposition ():void {
            var i:int = 0;
            var friendsListItem:FriendsListItem;
            var onlineItems:Vector.<FriendsListItem> = new Vector.<FriendsListItem> ();
            var offlineItems:Vector.<FriendsListItem> = new Vector.<FriendsListItem> ();
            for (i = 0; i < items.length; i++) {
                friendsListItem = items [i];
                if (friendsListItem.isOnline ()) {
                    onlineItems.push (friendsListItem);
                }
                else {
                    offlineItems.push (friendsListItem);
                }
            }

            onlineItems.sort (sortByLevels);
            offlineItems.sort (sortByLevels);

            for (i = 0; i < onlineItems.length; i++) {
                friendsListItem = onlineItems [i];
                friendsListItem.x = i * STEP;
            }
            for (var j:int = 0; j < offlineItems.length; j++) {
                friendsListItem = offlineItems [j];
                friendsListItem.x = (i + j) * STEP;
            }
            addFriendItem.x = (i + j) * STEP;
        }

        private static function sortByLevels (item1:FriendsListItem, item2:FriendsListItem):Number {
            var itemLevel1:int = 0;
            var itemLevel2:int = 0;
            if (item1.friendData) {
                itemLevel1 = item1.friendData.level;
            }
            if (item2.friendData) {
                itemLevel2 = item2.friendData.level;
            }
            if (itemLevel1 > itemLevel2) {
                return -1;
            }
            else if (itemLevel2 > itemLevel1) {
                return 1;
            }
            else {
                return 0;
            }
        }

//////////////////////////////////
//LISTENERS:
//////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var appUser:AppUser = BreakdanceApp.instance.appUser;
            if (appUser.installed) {
                var friendsListItem:FriendsListItem = FriendsListItem (event.currentTarget);
                if (friendsListItem.friendData) {
                    currentFriendData = friendsListItem.friendData;
                    TransactionOverlay.instance.show ();
                    ServerApi.instance.query (ServerApi.USER_GET_LIST, {uids:currentFriendData.uid}, onUserGetList);
                }
            }

        }

        private function onUserGetList (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (!response.data) {
                //
            }
            else {
                if (currentFriendData) {
                    var data:Object = response.data;
                    var appUser:AppUser = BreakdanceApp.instance.appUser;
                    var userFriends:Vector.<FriendData> = appUser.userAppFriends;
                    for (var i:int = 0; i < userFriends.length; i++) {
                        var friendData:FriendData = userFriends [i];
                        if (friendData.uid == currentFriendData.uid) {
                            var userObject:Object = data [currentFriendData.uid];
                            if (userObject) {
                                ServerUtils.initInitialPlayer (friendData, userObject);
                                appUser.currentFriendData = currentFriendData;
//                                Tracer.log ("распарсили друга " + currentFriendData.uid);
                            }
                        }
                        else {
//                            Tracer.log ("друг " + friendData.uid + " не подходит.");
                        }
                    }
                }
                currentFriendData = null;
            }
        }

        /**
         * @private
         */
        override protected function clickListener_btnEnd (event:MouseEvent):void {
            moveTo (currentMovingIndex + NUM_VISIBLE_ITEMS);
        }

        /**
         * @private
         */
        override protected function clickListener_btnBegin (event:MouseEvent):void {
            moveTo (currentMovingIndex - NUM_VISIBLE_ITEMS);
        }

        private function clickListener_inviteFriends (event:MouseEvent):void {
            JsApi.instance.query (JsApi.INVITE_FRIENDS, onInviteFriend);
        }

        private function onInviteFriend (response:JsQueryResult):void {
            //
        }

        private function changeListener (event:Event):void {
            reposition ();
        }
    }
}
