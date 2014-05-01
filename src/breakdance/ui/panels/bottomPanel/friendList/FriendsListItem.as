/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 03.07.13
 * Time: 19:07
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.bottomPanel.friendList {

    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.Button;
    import breakdance.user.FriendData;

    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.ImageLoader;
    import com.hogargames.debug.Tracer;
    import com.hogargames.display.elements.ImageContainer;
    import com.hogargames.utils.TextFieldUtilities;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;

    public class FriendsListItem extends Button {

        private var mcUserPic:Sprite;
        private var tfName:TextField;
        private var tfLevel:TextField;
        private var mcPvpIndicator:Sprite;
        private var mcPvpIndicator2:Sprite;

        private var userPicContainer:ImageContainer;
        private var imageLoader:ImageLoader;

        private var userPicWidth:int;
        private var userPicHeight:int;

        private var _friendData:FriendData;

        public function FriendsListItem () {
            super (Template.createSymbol (Template.FRIENDS_LIST_ITEM));
            buttonMode = true;
            useHandCursor = true;
            friendData = null;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get friendData ():FriendData {
            return _friendData;
        }

        public function set friendData (value:FriendData):void {
            if (_friendData) {
                _friendData.removeEventListener (Event.CHANGE, changeListener);
            }
            _friendData = value;
            if (_friendData) {
                _friendData.addEventListener (Event.CHANGE, changeListener);
                if (_friendData.avatarUrl) {
                    //userPicContainer.loadImage(_friendData.avatarUrl);
                    try {
                        //create an ImageLoader:
                        if (imageLoader) {
                            imageLoader.dispose (true);
                        }
                        imageLoader = new ImageLoader (
                                _friendData.avatarUrl,
                                {
                                    name: "photo1",
                                    container: userPicContainer,
                                    width: userPicWidth,
                                    height: userPicHeight,
                                    scaleMode: "proportionalInside",
                                    onComplete: onImageLoad
                                }
                        );
                        imageLoader.load ();
                    }
                    catch (error:Error) {
                        Tracer.log ("ERROR: " + error.message);
                    }

                }
                tfName.text = _friendData.shortName;
                if (_friendData.level != -1) {
                    tfLevel.text = String (_friendData.level);
                }
                else {
                    tfLevel.text = "";
                }
                changeListener (null);
            }
            else {
                userPicContainer.clear ();
                tfName.text = "";
                tfLevel.text = "";
            }
        }

        public function isOnline ():Boolean {
            return mcPvpIndicator.visible;
        }

        override public function destroy ():void {
            userPicContainer.destroy ();
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcUserPic = getElement ("mcUserPic");
            mcPvpIndicator = getElement ("mcPvpIndicator");
            mcPvpIndicator2 = getElement ("mcPvpIndicator2");
            userPicWidth = mcUserPic.width;
            userPicHeight = mcUserPic.height;
            userPicContainer = new ImageContainer (userPicWidth, userPicHeight);
            mcUserPic.addChild (userPicContainer);
            tfName = getElement ("tfName");
            tfLevel = getElement ("tfLevel");

            mcPvpIndicator.visible = false;

            TextFieldUtilities.setBold (tfName);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////


        //when the image loads, fade it in from alpha:0 using TweenLite
        private function onImageLoad (event:LoaderEvent):void {
//            TweenLite.from (event.target.content, 1, {alpha: 0});
        }

        private function changeListener (event:Event):void {
            if (_friendData) {
                mcPvpIndicator.visible = _friendData.isOnline;
                mcPvpIndicator2.visible = _friendData.isOnline;
                dispatchEvent (new Event (Event.CHANGE));
            }
        }


    }
}
