/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.09.13
 * Time: 11:33
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.selectDanceRoutineBlock {

    import breakdance.GlobalConstants;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.ButtonWithTwoTexts;

    /**
     * Элемент блока выбора танц. движений для выбора оригинальных танц. движений.
     */
    public class SelectOriginalDanceMoveButton extends ButtonWithTwoTexts implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        /**
         * Элемент селектора (панели выбора танц. движений).
         */
        public function SelectOriginalDanceMoveButton () {
            super (Template.createSymbol (Template.MOVE_CHOICE_ORIGINAL_ITEM));
            text2 = "<FONT COLOR='#00ff00'>" + GlobalConstants.ORIGINAL_MOVE_STAMINA + "/?" + "</FONT>";
        }

        public function setTexts ():void {
            text = "<b><FONT COLOR='#00ff00'>" + textsManager.getText ("originalMove") + "</FONT></b>";
        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);
            super.destroy ();
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            textsManager.addTextContainer (this);
        }

    }
}
