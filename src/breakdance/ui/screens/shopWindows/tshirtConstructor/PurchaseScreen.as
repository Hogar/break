/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.08.13
 * Time: 10:35
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.tshirtConstructor {

    import breakdance.core.texts.ITextContainer;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.screens.shopWindows.tshirtConstructor.events.PurchaseTshirtEvent;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class PurchaseScreen extends ScreenWithTShirt implements ITextContainer {

        private var btnBuy:ButtonWithText;
        private var btnBuyAndDress:ButtonWithText;

        public function PurchaseScreen (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function onShow ():void {
            btnBuy.enable = !Boolean (tutorialManager.currentStep == TutorialStep.SHOP_BUY_ITEM_1);
            super.onShow ();
        }

        public function setTexts ():void {
            btnBuy.text = textsManager.getText ("buy");
            btnBuyAndDress.text = textsManager.getText ("buyAndDress");
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            btnBuy = new ButtonWithText (getElement ("btnBuy"));
            btnBuyAndDress = new ButtonWithText (getElement ("btnBuyAndDress"));

            btnBuy.addEventListener (MouseEvent.CLICK, clickListener);
            btnBuyAndDress.addEventListener (MouseEvent.CLICK, clickListener);

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var color:String = null;
            switch (event.currentTarget) {
                case btnBuy:
                    dispatchEvent (new PurchaseTshirtEvent (PurchaseTshirtEvent.PURCHASE));
                    break;
                case btnBuyAndDress:
                    dispatchEvent (new PurchaseTshirtEvent (PurchaseTshirtEvent.PURCHASE_AND_DRESS));
                    break;
            }
        }

    }
}
