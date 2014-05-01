/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.12.13
 * Time: 13:46
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import breakdance.IPlayerData;

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class AvatarContainer extends GraphicStorage {

        protected var mcAvatarContainer:Sprite;
        protected var avatar:Avatar;

        private static const AVATAR_SCALE:Number = .6;
        private static const AVATAR_X:int = 19;
        private static const AVATAR_Y:int = 17;

        public function AvatarContainer (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function initByPlayerData (player:IPlayerData):void {
            if (avatar) {
                avatar.initByPlayerData (player);
            }
        }

        override public function destroy ():void {
            if (avatar) {
                avatar.destroy ();
                avatar = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcAvatarContainer = getElement ("mcAvatarContainer");
            avatar = new Avatar ();
            mcAvatarContainer.addChild (avatar);
            positionAvatar ();
        }

        protected function positionAvatar ():void {
            if (avatar) {
                avatar.scaleX = avatar.scaleY = AVATAR_SCALE;
                avatar.x = AVATAR_X;
                avatar.y = AVATAR_Y;
            }
        }
    }
}
