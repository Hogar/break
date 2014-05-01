/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.09.13
 * Time: 9:33
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.selectDanceRoutineBlock {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.ButtonWithTwoTexts;

    /**
     * Кнопка для панели выбора связки танц. движений.
     */
    public class SelectPanelItem extends ButtonWithTwoTexts implements ITextContainer {

        protected var textsManager:TextsManager = TextsManager.instance;

        /**
         * Элемент селектора (панели выбора танц. движений).
         */
        public function SelectPanelItem () {
            super (Template.createSymbol (Template.MOVE_CHOICE_ITEM));
        }

        public function setTexts ():void {

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
