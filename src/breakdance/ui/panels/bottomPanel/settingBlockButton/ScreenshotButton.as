/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.11.13
 * Time: 22:03
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.bottomPanel.settingBlockButton {

    import breakdance.BreakdanceApp;
    import breakdance.core.sound.SoundManager;
    import breakdance.events.BreakDanceAppEvent;
    import breakdance.template.Template;
    import breakdance.ui.panels.bottomPanel.*;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class ScreenshotButton extends TypeButton {

        private var mcBlick:MovieClip;

        public function ScreenshotButton (mc:MovieClip) {
            super (mc);
        }

        override public function destroy ():void {
            BreakdanceApp.instance.appDispatcher.removeEventListener (BreakDanceAppEvent.END_CHARACTER_MOVING, endCharacterMovingListener);
            super.destroy ();
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcBlick = getElement ("mcBlick");
            BreakdanceApp.instance.appDispatcher.addEventListener (BreakDanceAppEvent.END_CHARACTER_MOVING, endCharacterMovingListener);
        }

        override protected function mouseDownListener (event:MouseEvent):void {
            super.mouseDownListener (event);
            if (!selected && enable) {
                SoundManager.instance.playSound(Template.SND_CAMERA_SHOT);
            }
        }

        private function endCharacterMovingListener (event:BreakDanceAppEvent):void {
            mcBlick.gotoAndPlay (1);
        }
    }
}
