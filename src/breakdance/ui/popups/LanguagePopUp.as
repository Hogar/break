/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 16.10.13
 * Time: 19:32
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.basePopUps.BasePopUp;
    import breakdance.ui.tutorial.TutorialOverlay;

    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    public class LanguagePopUp extends BasePopUp implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;
        private var tutorialOverlay:TutorialOverlay;

        private var tfTitle:TextField;
        private var btnRu:ButtonWithText;
        private var btnEn:ButtonWithText;

        public function LanguagePopUp () {
            super (Template.createSymbol (Template.LANGUAGE_POP_UP));
            tutorialOverlay = TutorialOverlay.instance;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
            super.show ();
            var area:Rectangle = new Rectangle (170, 128, 470, 263);
            var showingAreas:Vector.<Rectangle> = new <Rectangle> [area];
            tutorialOverlay.show ();
            tutorialOverlay.showHidingBackground (showingAreas);
            tutorialOverlay.hideArrow ();
            tutorialOverlay.hideNextButton ();
            tutorialOverlay.setText (null);
        }

        override public function hide ():void {
            super.hide ();
            tutorialOverlay.hide ();
        }

        public function setTexts ():void {
            tfTitle.text = textsManager.getText ("language");
            btnRu.text = textsManager.getText ("russian");
            btnEn.text = textsManager.getText ("english");
            btnEn.selected = false;
            btnRu.selected = false;
            switch (textsManager.currentLanguage) {
                case TextsManager.RU:
                    btnRu.selected = true;
                    break;
                case TextsManager.EN:
                    btnEn.selected = true;
                    break;
            }
        }

        override public function destroy ():void {
            if (btnRu) {
                btnRu.destroy ();
            }
            if (btnEn) {
                btnEn.destroy ();
            }
            btnRu = null;
            btnEn = null;
            textsManager.removeTextContainer (this);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            tfTitle = getElement ("tfTitle");
            btnRu = new ButtonWithText (mc ["btnRu"]);
            btnEn = new ButtonWithText (mc ["btnEn"]);

            btnRu.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnRu.addEventListener (MouseEvent.CLICK, clickListener);
            btnEn.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnEn.addEventListener (MouseEvent.CLICK, clickListener);

            textsManager.addTextContainer (this);
        }

        private function rollOverListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btnRu:
                    textsManager.setCurrentLanguage (TextsManager.RU, false);
                    break;
                case btnEn:
                    textsManager.setCurrentLanguage (TextsManager.EN, false);
                    break;
            }
        }

        private function clickListener (event:MouseEvent):void {
            hide ();
            PopUpManager.instance.createCharacterPopUp.show ();
        }

    }
}
