/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.07.13
 * Time: 21:33
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.danceMovesWindow {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.danceMoves.DanceMoveCategory;
    import breakdance.ui.commons.buttons.ButtonWithText;

    import flash.display.MovieClip;

    public class DanceMovesCategoryTab extends ButtonWithText implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var _danceMoveCategory:DanceMoveCategory;

        public function DanceMovesCategoryTab (mc:MovieClip) {
            super (mc);
        }

        public function get danceMoveCategory ():DanceMoveCategory {
            return _danceMoveCategory;
        }

        public function set danceMoveCategory (value:DanceMoveCategory):void {
            _danceMoveCategory = value;
            setTexts ();
        }

        public function setTexts ():void {
            if (_danceMoveCategory) {
                text = "<b>" + _danceMoveCategory.name + "</b>";
            }
            else {
                text = "";
            }
        }

        override public function destroy ():void {
            super.destroy ();
            textsManager.addTextContainer (this);
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            textsManager.addTextContainer (this);
        }
    }
}
