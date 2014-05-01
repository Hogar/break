/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.11.13
 * Time: 3:13
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.bottomPanel {

    import breakdance.core.sound.SoundManager;
    import breakdance.template.Template;

    import com.hogargames.display.buttons.ButtonWithText;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class TypeButtonWithText extends ButtonWithText {

        public function TypeButtonWithText (mc:MovieClip) {
            super (mc);
        }

        override protected function rollOverListener (event:MouseEvent):void {
            super.rollOverListener (event);
            if (!selected && enable) {
//                SoundManager.instance.playSound(Template.SND_BUTTON_OVER);
            }
        }

        override protected function mouseDownListener (event:MouseEvent):void {
            super.mouseDownListener (event);
            if (!selected && enable) {
                SoundManager.instance.playSound (Template.SND_TAPE_DECK_IN_2);
            }
        }
    }
}
