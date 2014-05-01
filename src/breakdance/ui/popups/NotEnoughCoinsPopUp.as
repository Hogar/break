/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 28.01.14
 * Time: 7:04
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.template.Template;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;

    public class NotEnoughCoinsPopUp extends TwoTextButtonsPopUp {

        public function NotEnoughCoinsPopUp () {
            super (Template.createSymbol (Template.TWO_BUTTONS_CHARACTER_POPUP));
        }

        override public function setTexts ():void {
            tfTitle.text = textsManager.getText ("notEnoughCoinsTitle");
            tf.htmlText = textsManager.getText ("notEnoughCoinsText");
            btn1.text = textsManager.getText ("buyCoins");
            btn2.text = textsManager.getText ("no");
        }

        override protected function onClickFirstButton ():void {
            PopUpManager.instance.bucksToCoinsPopUp.show ();
            hide ();
        }

        override protected function onClickSecondButton ():void {
            hide ();
        }
    }
}
