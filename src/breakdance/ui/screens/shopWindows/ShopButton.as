/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.08.13
 * Time: 19:20
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows {

    import breakdance.ui.commons.buttons.Button;

    import com.hogargames.utils.MovieClipUtilities;

    import flash.display.MovieClip;

    public class ShopButton extends Button {

        private var mcSelectedIcon:MovieClip;
        private var mcIcon1:MovieClip;
        private var mcIcon2:MovieClip;
        private var mcIcon3:MovieClip;
        private var mcIcon4:MovieClip;

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
            mcIcon1.visible = !value;
            mcIcon2.visible = !value;
            mcIcon3.visible = !value;
            mcIcon4.visible = !value;
            mcSelectedIcon.gotoAndPlay (1);
        }

        override public function set selected (value:Boolean):void {
            super.selected = value;
        }

        override public function set enable (value:Boolean):void {
            super.enable = value;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            mcSelectedIcon = getElement ("mcSelectedIcon");
            mcIcon1 = getElement ("mcIcon1");
            mcIcon2 = getElement ("mcIcon2");
            mcIcon3 = getElement ("mcIcon3");
            mcIcon4 = getElement ("mcIcon4");
            super.initGraphicElements ();
        }

        override protected function setSkin (id:String):void {
            MovieClipUtilities.gotoAndStop (mc, id);
            switch (id) {
                case UP:
                    mcIcon1.gotoAndPlay (1);
                    break;
                case OVER:
                    mcIcon2.gotoAndPlay (1);
                    break;
                case DOWN:
                    mcIcon3.gotoAndPlay (1);
                    break;

            }
        }

    }
}
