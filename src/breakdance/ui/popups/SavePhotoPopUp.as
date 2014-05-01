/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 24.02.14
 * Time: 10:13
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.BreakdanceApp;
    import breakdance.events.BreakDanceAppEvent;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;

    public class SavePhotoPopUp extends TwoTextButtonsPopUp {

        public function SavePhotoPopUp () {
            super (Template.createSymbol (Template.TWO_BUTTONS_CHARACTER_POPUP));
        }

        override public function setTexts ():void {
            tfTitle.text = textsManager.getText ("savePhotoTitle");
            tf.htmlText = textsManager.getText ("savePhotoText");
            btn1.text = textsManager.getText ("save");
            btn2.text = textsManager.getText ("cancel2");
        }

        override public function hide ():void {
            var tutorialManager:TutorialManager = TutorialManager.instance;
            if (tutorialManager.currentStep == TutorialStep.CREATE_SCREEN_SHOT) {
                tutorialManager.completeStep (TutorialStep.CREATE_SCREEN_SHOT);
            }
            super.hide ();
        }

        override protected function onClickFirstButton ():void {
            if (BreakdanceApp.instance.appUser.installed) {
                BreakdanceApp.instance.appDispatcher.dispatchEvent (new BreakDanceAppEvent (BreakDanceAppEvent.CREATE_SCREEN_SHOT));
            }
            hide ();
            CONFIG::mixpanel {
//                BreakdanceApp.mixpanel.track(
//                        'save_photo',
//                        {'accept':true}
//                );
            }
        }

        override protected function onClickSecondButton ():void {
            hide ();
            CONFIG::mixpanel {
//                BreakdanceApp.mixpanel.track(
//                        'save_photo',
//                        {'accept':false}
//                );
            }
        }
    }
}
