/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 25.06.13
 * Time: 10:45
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons.buttons {

    import breakdance.core.sound.SoundManager;
    import breakdance.template.Template;

    import com.hogargames.display.buttons.Button;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class Button extends com.hogargames.display.buttons.Button {

        public function Button (mc:MovieClip) {
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
                SoundManager.instance.playSound (Template.SND_BUTTON_DOWN);
            }
        }

    }
}
