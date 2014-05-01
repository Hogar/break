/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.12.13
 * Time: 14:08
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import flash.display.MovieClip;

    public class BattlePlayerAvatarContainer extends AvatarContainer {

        private static const AVATAR_X:int = 0;
        private static const AVATAR_Y:int = 0;

        public function BattlePlayerAvatarContainer (mc:MovieClip) {
            super (mc);
        }

        override protected function positionAvatar ():void {
            if (avatar) {
                avatar.scaleX = avatar.scaleY = 1;
                avatar.x = AVATAR_X;
                avatar.y = AVATAR_Y;
            }
        }
    }
}
