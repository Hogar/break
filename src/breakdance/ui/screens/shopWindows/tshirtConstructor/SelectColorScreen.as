/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.08.13
 * Time: 1:31
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.tshirtConstructor {

    import breakdance.BreakdanceApp;
    import breakdance.ui.commons.buttons.Button;
    import breakdance.ui.screens.shopWindows.tshirtConstructor.events.SelectColorEvent;
    import breakdance.user.UserPurchasedItem;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class SelectColorScreen extends ScreenWithTShirt {

        private var btnRed:Button;
        private var btnLightbrown:Button;
        private var btnBrown:Button;
        private var btnOrange:Button;
        private var btnYellow:Button;
        private var btnGreen:Button;
        private var btnLightblue:Button;
        private var btnBlue:Button;
        private var btnPurple:Button;
        private var btnWhite:Button;
        private var btnBlack:Button;

        private var buttons:Vector.<Button>;

        public function SelectColorScreen (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function onShow ():void {
            super.onShow ();
            selectColor (TshirtColor.WHITE);
        }

        override public function setTshirtImage (image:String):void {
            super.setTshirtImage (image);
            var purchasedItems:Vector.<UserPurchasedItem> = BreakdanceApp.instance.appUser.purchasedItems;
            var totalPurchasedItems:int = purchasedItems.length;
            var i:int;
            var button:Button;
            var numButtons:int = buttons.length;
            for (i = 0; i < numButtons; i++) {
                button = buttons [i];
                button.enable = true;
            }
            for (i = 0; i < totalPurchasedItems; i++) {
                var purchasedItem:UserPurchasedItem = purchasedItems [i];
                if (purchasedItem.itemId == image) {
                    button = getButtonByColor (purchasedItem.color);
                    if (button) {
                        button.enable = false;
                    }
                }
            }
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            btnRed = new Button (getElement ("btnRed"));
            btnLightbrown = new Button (getElement ("btnLightbrown"));
            btnBrown = new Button (getElement ("btnBrown"));
            btnOrange = new Button (getElement ("btnOrange"));
            btnYellow = new Button (getElement ("btnYellow"));
            btnGreen = new Button (getElement ("btnGreen"));
            btnLightblue = new Button (getElement ("btnLightblue"));
            btnBlue = new Button (getElement ("btnBlue"));
            btnPurple = new Button (getElement ("btnPurple"));
            btnWhite = new Button (getElement ("btnWhite"));
            btnBlack = new Button (getElement ("btnBlack"));

            buttons = new Vector.<Button> ();

            buttons.push (btnRed);
            buttons.push (btnLightbrown);
            buttons.push (btnBrown);
            buttons.push (btnOrange);
            buttons.push (btnYellow);
            buttons.push (btnGreen);
            buttons.push (btnLightblue);
            buttons.push (btnBlue);
            buttons.push (btnPurple);
            buttons.push (btnWhite);
            buttons.push (btnBlack);

            btnRed.addEventListener (MouseEvent.CLICK, clickListener);
            btnLightbrown.addEventListener (MouseEvent.CLICK, clickListener);
            btnBrown.addEventListener (MouseEvent.CLICK, clickListener);
            btnOrange.addEventListener (MouseEvent.CLICK, clickListener);
            btnYellow.addEventListener (MouseEvent.CLICK, clickListener);
            btnGreen.addEventListener (MouseEvent.CLICK, clickListener);
            btnLightblue.addEventListener (MouseEvent.CLICK, clickListener);
            btnBlue.addEventListener (MouseEvent.CLICK, clickListener);
            btnPurple.addEventListener (MouseEvent.CLICK, clickListener);
            btnWhite.addEventListener (MouseEvent.CLICK, clickListener);
            btnBlack.addEventListener (MouseEvent.CLICK, clickListener);

            btnRed.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnLightbrown.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnBrown.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnOrange.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnYellow.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnGreen.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnLightblue.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnBlue.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnPurple.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnWhite.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnBlack.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function getButtonByColor (color:String):Button {
            var button:Button;
            if (color) {
                switch (color) {
                    case TshirtColor.RED:
                        button = btnRed;
                        break;
                    case TshirtColor.LIGHT_BROWN:
                        button = btnLightbrown;
                        break;
                    case TshirtColor.BROWN:
                        button = btnBrown;
                        break;
                    case TshirtColor.ORANGE:
                        button = btnOrange;
                        break;
                    case TshirtColor.YELLOW:
                        button = btnYellow;
                        break;
                    case TshirtColor.GREEN:
                        button = btnGreen;
                        break;
                    case TshirtColor.LIGHT_BLUE:
                        button = btnLightblue;
                        break;
                    case TshirtColor.BLUE:
                        button = btnBlue;
                        break;
                    case TshirtColor.PURPLE:
                        button = btnPurple;
                        break;
                    case TshirtColor.WHITE:
                        button = btnWhite;
                        break;
                    case TshirtColor.BLACK:
                        button = btnBlack;
                        break;
                }
            }
            return button;
        }

        private function selectColor (color:String):void {
            var button:Button = getButtonByColor (color);
            selectColorButton (button);
            setTshirtColor (color);
        }

        private function selectColorButton (button:Button):void {
            for (var i:int = 0; i < buttons.length; i++) {
                var currentButton:Button = buttons [i];
                currentButton.selected = (currentButton == button);
            }
        }

        private function selectColorByButton (button:Button):String {
            var color:String = null;
            switch (button) {
                case btnRed:
                    color = TshirtColor.RED;
                    break;
                case btnLightbrown:
                    color = TshirtColor.LIGHT_BROWN;
                    break;
                case btnBrown:
                    color = TshirtColor.BROWN;
                    break;
                case btnOrange:
                    color = TshirtColor.ORANGE;
                    break;
                case btnYellow:
                    color = TshirtColor.YELLOW;
                    break;
                case btnGreen:
                    color = TshirtColor.GREEN;
                    break;
                case btnLightblue:
                    color = TshirtColor.LIGHT_BLUE;
                    break;
                case btnBlue:
                    color = TshirtColor.BLUE;
                    break;
                case btnPurple:
                    color = TshirtColor.PURPLE;
                    break;
                case btnWhite:
                    color = TshirtColor.WHITE;
                    break;
                case btnBlack:
                    color = TshirtColor.BLACK;
                    break;
            }
            return color;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function rollOverListener (event:MouseEvent):void {
            var color:String = selectColorByButton (Button (event.currentTarget));
            selectColor (color);
        }

        private function clickListener (event:MouseEvent):void {
            var color:String = selectColorByButton (Button (event.currentTarget));
            selectColor (color);
            dispatchEvent (new SelectColorEvent (color));
        }

    }
}
