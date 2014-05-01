/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.09.13
 * Time: 14:45
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.battlePopUp {

    import breakdance.battle.model.IBattle;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.popups.basePopUps.OneTextButtonPopUp;
    import breakdance.ui.screenManager.ScreenManager;

    import com.hogargames.utils.StringUtilities;

    import flash.display.MovieClip;

    public class BattleDefeatPopUp extends OneTextButtonPopUp implements IBattlePopUp {

        private var mcResult:MovieClip;
        private var coins:int = 0;
        private var _battle:IBattle;

        private var tutorialManager:TutorialManager;

        public function BattleDefeatPopUp () {
            tutorialManager = TutorialManager.instance;
            super (Template.createSymbol (Template.BATTLE_DEFEAT_POPUP));
            useShowAnimation = false;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            if (coins != 0) {
                var tfDefeat:String = textsManager.getText ("defeat");

                var suffix:String = "";
                if (textsManager.currentLanguage == TextsManager.RU) {
                    suffix = StringUtilities.getRussianSuffix1 (coins);
                }
                if (textsManager.currentLanguage == TextsManager.EN) {
                    suffix = StringUtilities.getEnglishSuffixForNumber (coins);
                }
                var coinsAsString:String = String (Math.abs (coins));
                coinsAsString = "- " + coinsAsString;

                tfDefeat = tfDefeat.replace ("#1", coinsAsString);
                tfDefeat = tfDefeat.replace ("#2", suffix);

                tf.htmlText = "<i>" + tfDefeat + "</i>";
            }
            else {
                tf.htmlText = "";
            }


            tfTitle.htmlText = textsManager.getText ("defeatTitle");
            btn1.text = textsManager.getText ("complete");
        }

        public function setCoins (value:int):void {
            coins = value;
            setTexts ();
        }

        override public function show ():void {
         	super.show ();
            mcResult.gotoAndPlay (1);
        }

        public function set battle (value:IBattle):void {
            _battle = value;
        }

        override public function hide ():void {
         	super.hide ();
            if (tutorialManager.currentStep == TutorialStep.BATTLE_MAIN) {
                tutorialManager.setStep (TutorialStep.BATTLE_OPEN);
            }
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcResult = getElement ("mcResult");
        }

        override protected function onClickFirstButton ():void {
            ScreenManager.instance.navigateBeforeBattle ();
            hide ();
        }
    }
}
