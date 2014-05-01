/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.12.13
 * Time: 18:49
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.template.Template;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.ui.screenManager.events.ScreenManagerEvent;

    public class LeaveScreenPopUp extends TwoTextButtonsPopUp {

        public function LeaveScreenPopUp () {
            super (Template.createSymbol(Template.TWO_BUTTONS_CHARACTER_POPUP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            btn1.text = textsManager.getText ("yes");
            btn2.text = textsManager.getText ("no");
            tfTitle.text = textsManager.getText ("acceptLeaveScreenTitle");
            tf.text = "";
        }

        override public function destroy ():void {
            super.destroy ();
            ScreenManager.instance.removeEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            ScreenManager.instance.addEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
        }

        override protected function onClickFirstButton ():void {
            ScreenManager.instance.acceptLeaveScreen ();
            hide ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function navigateToListener (event:ScreenManagerEvent):void {
            hide ();
        }
    }
}
