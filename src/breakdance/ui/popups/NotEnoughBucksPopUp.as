/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 28.01.14
 * Time: 7:02
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.template.Template;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;

    public class NotEnoughBucksPopUp extends TwoTextButtonsPopUp {

        public function NotEnoughBucksPopUp () {
            super (Template.createSymbol (Template.TWO_BUTTONS_CHARACTER_POPUP));
        }

        override public function setTexts ():void {
            tfTitle.text = textsManager.getText ("notEnoughBucksTitle");
            tf.htmlText = textsManager.getText ("notEnoughBucksText");
            btn1.text = textsManager.getText ("buyBucks");
            btn2.text = textsManager.getText ("no");
        }

        override protected function onClickFirstButton ():void {
            PopUpManager.instance.bucksOffersPopUp.show ();
            hide ();
        }

        override protected function onClickSecondButton ():void {
            hide ();
        }


    }
}
