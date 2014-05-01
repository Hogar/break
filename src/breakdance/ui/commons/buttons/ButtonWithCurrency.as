/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.02.14
 * Time: 14:22
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons.buttons {

    import com.hogargames.utils.MovieClipUtilities;

    import flash.display.MovieClip;

    public class ButtonWithCurrency extends ButtonWithTwoTexts {

        private var currencyIcon:MovieClip;

        public function ButtonWithCurrency (mc:MovieClip) {
            super (mc);
        }

        public function setCurrency (value:int, type:String):void {
            text2 = "<b>" + String (value) + "</b>";
            MovieClipUtilities.gotoAndStop (currencyIcon, type);
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            currencyIcon = getElement ("mcCurrency");
            currencyIcon.stop ();
        }

    }
}
