/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 25.06.13
 * Time: 10:46
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons.buttons {

    import breakdance.core.sound.SoundManager;
    import breakdance.template.Template;

    import com.hogargames.display.buttons.ButtonWithText;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class ButtonWithText extends com.hogargames.display.buttons.ButtonWithText {

        private var _useBold:Boolean;

        public function ButtonWithText (mc:MovieClip, useBold:Boolean = true) {
            super (mc);
            this.useBold = useBold;
        }

        public function get tf ():TextField {
            return _tf;
        }

        override public function set text (text:String):void {
            if (text && useBold) {
                text = "<b>" + text + "</b>";
            }
            super.text =  (text);
        }

        public function get useBold ():Boolean {
            return _useBold;
        }

        public function set useBold (value:Boolean):void {
            _useBold = value;
            text = text;
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
                SoundManager.instance.playSound(Template.SND_BUTTON_DOWN);
            }
        }

    }
}
