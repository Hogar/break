/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 14.08.13
 * Time: 13:11
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.editCharacterPopUp {

    import breakdance.ui.commons.Avatar;

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class FaceItem extends GraphicStorage {

        private var mcSelector:Sprite;
        private var mcContainer:Sprite;
        private var avatar:Avatar;

        private var _selected:Boolean;

        private const AVATAR_X:int = 36;
        private const AVATAR_Y:int = 36;

        public function FaceItem (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get selected ():Boolean {
            return _selected;
        }

        public function set selected (value:Boolean):void {
            _selected = value;
            mcSelector.visible = _selected;
        }

        public function get emotionId ():int {
            return avatar.faceId;
        }

        public function set emotionId (value:int):void {
            avatar.faceId = value;
        }

        public function get hairstyleId ():int {
            return avatar.hairId;
        }

        public function set hairstyleId (value:int):void {
            avatar.hairId = value;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            mcSelector = getElement ("mcSelector");
            mcContainer = getElement ("mcContainer");
            avatar = new Avatar ();
            avatar.x = AVATAR_X;
            avatar.y = AVATAR_Y;
            mcContainer.addChild (avatar);

            buttonMode = true;
            useHandCursor = true;
        }
    }
}
