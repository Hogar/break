/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.01.14
 * Time: 16:10
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons.buttons {

    import breakdance.template.Template;

    import com.hogargames.display.GraphicStorage;

    public class DebugButton extends GraphicStorage {

        private var btn:ButtonWithText;

        public function DebugButton (text:String = "") {
            super (Template.createSymbol (Template.DEBUG_BUTTON));
            this.text = text;
        }

        public function set text (value:String):void {
            if (btn) {
                btn.text = value;
            }
        }

        public function get text ():String {
            if (btn) {
                return btn.text;
            }
            else {
                return null;
            }
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            btn = new ButtonWithText (mc ["btn"]);
        }
    }
}
