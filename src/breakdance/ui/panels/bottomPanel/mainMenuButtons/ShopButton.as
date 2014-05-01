/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.01.14
 * Time: 16:31
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.bottomPanel.mainMenuButtons {

    import flash.display.MovieClip;

    public class ShopButton extends MainMenuButton {

        private var mcSelectedIcon:MovieClip;
        private var mcIcon3:MovieClip;

        private var _newItemsSelection:Boolean = false;

        public function ShopButton (mc:MovieClip) {
            super (mc);
            newItemsSelection = false;
        }

        /////////////////////////////////////////////
        //PUBLIC:
        /////////////////////////////////////////////

        /**
         * Мигание магазина при появлении новых предметов.
         */
        public function get newItemsSelection ():Boolean {
            return _newItemsSelection;
        }

        public function set newItemsSelection (value:Boolean):void {
            _newItemsSelection = value;
            mcSelectedIcon.visible = value;
            mcIcon3.visible = !value;
            mcSelectedIcon.gotoAndPlay (1);
        }

        /////////////////////////////////////////////
        //PROTECTED:
        /////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            if (mcIcon2) {
                mcIcon3 = getElement ("mcIcon", mcIcon2);
                mcSelectedIcon = getElement ("mcSelectedIcon", mcIcon2);
            }
            super.initGraphicElements ();
        }

    }
}
