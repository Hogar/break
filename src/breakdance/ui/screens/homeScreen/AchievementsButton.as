/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.03.14
 * Time: 12:02
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.homeScreen {

    import breakdance.ui.commons.buttons.ButtonWithText;

    import com.hogargames.utils.NumericalUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class AchievementsButton extends ButtonWithText {

        private var tf2Container:MovieClip;
        private var tf3Container:MovieClip;
        private var tf2:TextField;
        private var tf3:TextField;
        private var tfPercent:TextField;
        private var tfPercent2:TextField;
        private var tfPercent3:TextField;
        private var mcProgress:MovieClip;

        private static const TEXT_INDENT:int = 4;
        private static const PERCENT_INDENT:int = 3;

        public function AchievementsButton (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function setPercents (value:int):void {
            text = String (value);
            value = NumericalUtilities.correctValue (value, 1, 100);
            mcProgress.gotoAndStop (value);
        }

        override public function set text (text:String):void {
            super.text = (text);
            if (text && useBold) {
                text = "<b>" + text + "</b>";
            }
            tf2.htmlText = text;
            tf3.htmlText = text;
            tf.width = tf2.width = tf3.width = Math.ceil (tf.textWidth + 4);
            tf.x = tf2.x = tf3.x = - Math.floor (tf.width / 2) - TEXT_INDENT;
            tfPercent.x = tfPercent2.x = tfPercent3.x = tf.x + tf.width - PERCENT_INDENT;

        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            var tfContainer:Sprite = getElement ("tf");
            tfPercent = getElement ("tfPercent", tfContainer);

            tf2Container = getElement ("tf2");
            var tf2Container2:Sprite = getElement ("tf", tf2Container);
            tf2 = getElement ("tf", tf2Container2);
            tfPercent2 = getElement ("tfPercent", tf2Container2);

            tf3Container = getElement ("tf3");
            var tf3Container2:Sprite = getElement ("tf", tf3Container);
            tf3 = getElement ("tf", tf3Container2);
            tfPercent3 = getElement ("tfPercent", tf3Container2);

            mcProgress = getElement ("mcProgress");

            setPercents (0);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        /**
         * @private
         */
        override protected function rollOverListener (event:MouseEvent):void {
            super.rollOverListener (event);
            tf3Container.gotoAndPlay (1);
        }

        /**
         * @private
         */
        override protected function rollOutListener (event:MouseEvent):void {
            super.rollOutListener (event);
            tf2Container.gotoAndPlay (1);
        }

    }
}
