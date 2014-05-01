/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.11.13
 * Time: 9:41
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.bottomPanel.mainMenuButtons {

    import breakdance.core.sound.SoundManager;
    import breakdance.template.Template;

    import com.hogargames.display.buttons.Button;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class MainMenuButton extends Button {

        private var mcIcon:MovieClip;
        protected var mcIcon2:MovieClip;
        private var mcButtonIcon:MovieClip;

        private var mcIconHit:MovieClip;

        private var _pushed:Boolean = false;
        private var _iconVisible:Boolean = true;

        private static const HIDE_FRAME:String = "hide";
        private static const SHOW_FRAME:String = "show";
        private static const OUT_FRAME:String = "out";
        private static const OVER_FRAME:String = "over";
        private static const DOWN_FRAME:String = "down";
        private static const UP_FRAME:String = "up";

        public function MainMenuButton (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get pushed ():Boolean {
            return _pushed;
        }

        public function set pushed (value:Boolean):void {
            if (_pushed != value) {
                if (value) {
                    mcButtonIcon.gotoAndPlay (DOWN_FRAME);
                    SoundManager.instance.playSound (Template.SND_TAPE_DECK_IN);
                }
                else {
                    mcButtonIcon.gotoAndPlay (UP_FRAME);
                    SoundManager.instance.playSound (Template.SND_TAPE_DECK_OUT);
                }
            }
            _pushed = value;
        }

        public function get iconVisible ():Boolean {
            return _iconVisible;
        }

        public function set iconVisible (value:Boolean):void {
            if (_iconVisible != value) {
                if (value) {
                    showIcon ();
                }
                else {
                    hideIcon ();
                }
            }
            _iconVisible = value;
        }

        public function get hitWidth ():int {
            if (mcIconHit) {
                return mcIconHit.width;
            }
            else {
                return 0;
            }
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            if (mc ["mcIcon"]) {
                mcIcon = getElement ("mcIcon");
                mcIcon2 = getElement ("mcIcon", mcIcon);
                mcIcon.mouseEnabled = false;
                mcIcon.mouseChildren = false;
            }

            mcButtonIcon = getElement ("mcButtonIcon");
            if (enable) {
                showIcon ();
            }
            else {
                hideIcon ();
            }
            if (_pushed) {
                mcButtonIcon.gotoAndPlay (DOWN_FRAME);
            }
            else {
                mcButtonIcon.gotoAndPlay (UP_FRAME);
            }

            if (hit) {
                if (hit ["mcIconHit"]) {
                    mcIconHit = getElement ("mcIconHit", hit);
                }
            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function hideIcon ():void {
            if (mcIcon) {
                mcIcon.gotoAndPlay (HIDE_FRAME);
            }
            if (mcIconHit) {
                mcIconHit.visible = false;
            }
        }

        private function showIcon ():void {
            if (mcIcon) {
                mcIcon.gotoAndPlay (SHOW_FRAME);
            }
            if (mcIconHit) {
                mcIconHit.visible = true;
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        override protected function rollOverListener (event:MouseEvent):void {
            super.rollOverListener (event);
            if (!selected && enable) {
                if (mcIcon2) {
                    mcIcon2.gotoAndPlay (OVER_FRAME);
                }
            }
        }

        override protected function rollOutListener (event:MouseEvent):void {
            super.rollOutListener (event);
            if (!selected && enable) {
                if (mcIcon2) {
                    mcIcon2.gotoAndPlay (OUT_FRAME);
                }
            }
        }

    }
}
