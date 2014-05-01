/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.03.14
 * Time: 9:49
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.bottomPanel.mainMenuButtons {

    import com.hogargames.utils.NumericalUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;

    public class AchievementButton extends MainMenuButton {

        private var mcIcon3:Sprite;
        private var tf:TextField;
        private var tfPercent:TextField;
        private var mcProgress:MovieClip;

        private static const BUTTON_WIDTH:int = 64;
        private static const TEXT_INDENT:int = 4;
        private static const PERCENT_INDENT:int = 3;

        public function AchievementButton (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function setPercents (value:int):void {
            tf.htmlText = String (value);
            tf.width =  Math.ceil (tf.textWidth + 4);
            tf.x = BUTTON_WIDTH / 2 - Math.floor (tf.width / 2) - TEXT_INDENT;
            tfPercent.x = tf.x + tf.width - PERCENT_INDENT;
            value = NumericalUtilities.correctValue (value, 1, 100);
            mcProgress.gotoAndStop (value);
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            mcIcon3 = getElement ("mcIcon", mcIcon2);
            tf = getElement ("tf", mcIcon3);
            tfPercent = getElement ("tfPercent", mcIcon3);
            mcProgress = getElement ("mcProgress", mcIcon3);

            setPercents (0);

        }

    }
}
