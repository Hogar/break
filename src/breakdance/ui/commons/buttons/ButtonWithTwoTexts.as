/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 25.07.13
 * Time: 22:09
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons.buttons {

    import flash.display.MovieClip;
    import flash.text.TextField;

    public class ButtonWithTwoTexts extends ButtonWithText {

        private var tf2:TextField;

        public function ButtonWithTwoTexts (mc:MovieClip) {
            super (mc);
        }

        /**
         * Текст кнопки.
         */
        public function get text2 ():String {
            return tf2.htmlText;
        }

        public function set text2 (value:String):void {
            tf2.htmlText = value;
        }

        /**
         * @inheritDoc
         */
        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            tf2 = TextField (getElement ("tf", mc.tf2));
        }
    }
}
