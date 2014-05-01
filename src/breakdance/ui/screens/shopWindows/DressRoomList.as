/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.08.13
 * Time: 11:30
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows {

    import breakdance.BreakdanceApp;
    import breakdance.ui.screens.shopWindows.events.SelectUserPurchaseItemEvent;
    import breakdance.user.UserPurchasedItem;

    import com.hogargames.utils.NumericalUtilities;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class DressRoomList extends List {

        private var _selectedUserPurchasedItem:UserPurchasedItem;

        private var dressRoomListItems:Vector.<DressRoomListItem> = new Vector.<DressRoomListItem> ();

        public function DressRoomList (mc:MovieClip) {
            super (mc);
        }

        /////////////////////////////////////////////
        //PUBLIC:
        /////////////////////////////////////////////

        public function init (shopItems:Vector.<UserPurchasedItem>, currentDressingItem:UserPurchasedItem):void {
            clear ();
            //add scroll elements:
            var numShopItems:int = shopItems.length;
            var itemForSelect:UserPurchasedItem;//Элемент списка для выделения текущей одетой одежды.
            var itemForSelectPosition:int;//Позиция элемента списка для выделения текущей одетой одежды (для автоматической перемотки).
            for (var i:int = 0; i < numShopItems; i++) {
                var dressRoomListItem:DressRoomListItem = new DressRoomListItem ();
                var currentUserPurchasedItem:UserPurchasedItem = shopItems [i];
                dressRoomListItem.userPurchasedItem = currentUserPurchasedItem;
                var curRow:int = Math.floor (i / NUM_COLUMNS);
                var curColumn:int = i - curRow * NUM_COLUMNS;
                if (currentUserPurchasedItem == currentDressingItem) {
                    itemForSelect = currentUserPurchasedItem;
                    itemForSelectPosition = curRow + 1;
                }
                dressRoomListItem.x = curColumn * STEP;
                dressRoomListItem.y = curRow * STEP;
                dressRoomListItem.addEventListener (MouseEvent.CLICK, clickListener);
                container.addChild (dressRoomListItem);
                dressRoomListItems.push (dressRoomListItem);

            }

            //set scroll params:
            this.numItems = curRow + 1;

            if (itemForSelect) {
                setSelectedUserPurchaseItem (itemForSelect);
                var movingIndex:int = NumericalUtilities.correctValue (
                        itemForSelectPosition - numVisibleItems, 0, getMaxMovingIndex ());
                moveTo (movingIndex);
            }
            else {
                setSelectedUserPurchaseItem (null);
                moveTo (0);
            }
        }

        override public function clear ():void {
            for (var i:int = 0; i < dressRoomListItems.length; i++) {
                var dressRoomListItem:DressRoomListItem = dressRoomListItems [i];
                dressRoomListItem.removeEventListener (MouseEvent.CLICK, clickListener);
                if (container.contains (dressRoomListItem)) {
                    container.removeChild (dressRoomListItem);
                }
                dressRoomListItem.destroy ();
            }
            dressRoomListItems = new Vector.<DressRoomListItem> ();
            _selectedUserPurchasedItem = null;
        }

        public function get selectedUserPurchasedItem ():UserPurchasedItem {
            return _selectedUserPurchasedItem;
        }

        override public function destroy ():void {
            clear ();
            super.destroy ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setSelectedUserPurchaseItem (userPurchaseItem:UserPurchasedItem):void {
            _selectedUserPurchasedItem = userPurchaseItem;
            for (var i:int = 0; i < dressRoomListItems.length; i++) {
                var dressRoomListItem:DressRoomListItem = dressRoomListItems [i];
                dressRoomListItem.selected = (userPurchaseItem && (dressRoomListItem.userPurchasedItem == userPurchaseItem));
            }
            if (_selectedUserPurchasedItem) {
                BreakdanceApp.instance.appUser.character.fittingPurchasedItem (userPurchaseItem);
            }
            dispatchEvent (new SelectUserPurchaseItemEvent (_selectedUserPurchasedItem));
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var dressRoomListItem:DressRoomListItem = DressRoomListItem (event.currentTarget);
            if (dressRoomListItem && dressRoomListItem.enable) {
                setSelectedUserPurchaseItem (dressRoomListItem.userPurchasedItem);
            }
        }
    }
}
