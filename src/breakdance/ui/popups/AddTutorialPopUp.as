/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 14.02.14
 * Time: 18:03
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.BreakdanceApp;
    import breakdance.core.server.ServerApi;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;

    public class AddTutorialPopUp extends TwoTextButtonsPopUp {

        public function AddTutorialPopUp () {
            super (Template.createSymbol (Template.TWO_BUTTONS_CHARACTER_POPUP));
        }

        override public function setTexts ():void {
            tfTitle.text = textsManager.getText ("addTutorialTitle");
            tf.htmlText = textsManager.getText ("addTutorialText");
            btn1.text = textsManager.getText ("yes");
            btn2.text = textsManager.getText ("no");
        }

        override protected function onClickFirstButton ():void {
            ServerApi.instance.query (ServerApi.DELETE_USER, {}, onDeleteUser);
            hide ();
        }

        override protected function onClickSecondButton ():void {
            ServerApi.instance.query (ServerApi.SAVE_TUTORIAL_STEP, {tutorial_id:TutorialStep.SKIP_TUTOR}, onSaveTutorialStep);
            hide ();
        }

        private function onDeleteUser (response:Object):void {
            PopUpManager.instance.createCharacterPopUp.show ();
            TutorialManager.instance.reset ();
            BreakdanceApp.instance.appUser.installed = false;
        }

        private function onSaveTutorialStep (response:Object):void {
            //
        }

    }
}
