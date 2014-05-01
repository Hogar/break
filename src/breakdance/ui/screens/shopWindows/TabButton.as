/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 30.08.13
 * Time: 12:08
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows {

    import breakdance.ui.commons.buttons.Button;

    import flash.display.MovieClip;

    public class TabButton extends Button {

        private var mcSelectIcon:MovieClip;

        private var _newItemsSelection:Boolean = false;

        public function TabButton (mc:MovieClip) {
            super (mc);
            newItemsSelection = false;
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcSelectIcon = getElement ("mcSelectIcon");
        }

        /**
         * Мигание магазина при появлении новых предметов.
         */
        public function get newItemsSelection ():Boolean {
            return _newItemsSelection;
        }

        public function set newItemsSelection (value:Boolean):void {
            _newItemsSelection = value;
            mcSelectIcon.visible = value;
            mcSelectIcon.gotoAndPlay (1);
        }

    }
}
