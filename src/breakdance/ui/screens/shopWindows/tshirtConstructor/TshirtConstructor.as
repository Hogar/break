/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.08.13
 * Time: 1:11
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.tshirtConstructor {

    import breakdance.BreakdanceApp;
    import breakdance.core.server.ServerApi;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.screens.shopWindows.tshirtConstructor.events.PurchaseTshirtEvent;
    import breakdance.ui.screens.shopWindows.tshirtConstructor.events.SelectColorEvent;
    import breakdance.ui.screens.shopWindows.tshirtConstructor.events.SelectImageEvent;

    import com.hogargames.app.screens.IScreen;
    import com.hogargames.app.screens.ScreensContainer;
    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class TshirtConstructor extends GraphicStorage implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var currentImage:String;
        private var currentColor:String;

        //скрины:
        private var screenContainer:ScreensContainer;//Элемент для работы со скринами.

        private var selectImageScreen:SelectImageScreen;
        private var selectColorScreen:SelectColorScreen;
        private var purchaseScreen:PurchaseScreen;

        //кнопки:
        private var btnStep1:ButtonWithText;
        private var btnStep2:ButtonWithText;
        private var btnStep3:ButtonWithText;

        private var mcButtonsBackground:MovieClip;

        protected var tutorialManager:TutorialManager;

        private static const COLOR_1:uint = 0x9D9D9D;
        private static const COLOR_2:uint = 0x0000000;

        public function TshirtConstructor (mc:MovieClip) {
            tutorialManager = TutorialManager.instance;
            var containerForScreens:Sprite = new Sprite ();
            mc.addChildAt (containerForScreens, 1);
            screenContainer = new ScreensContainer (containerForScreens);
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        private function reset ():void {
            currentImage = null;
            currentColor = null;
            openScreen (selectImageScreen);
        }

        public function show ():void {
            reset ();
            visible = true;
        }

        public function hide ():void {
            reset ();
            visible = false;
        }

        public function setTexts ():void {
            btnStep1.text = textsManager.getText ("step1");
            btnStep2.text = textsManager.getText ("step2");
            btnStep3.text = textsManager.getText ("step3");
            setButtonsTextColors ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            selectImageScreen = new SelectImageScreen (mc ["mcSelectImageScreen"]);
            selectColorScreen = new SelectColorScreen (mc ["mcSelectColorScreen"]);
            purchaseScreen = new PurchaseScreen (mc ["mcPurchaseScreen"]);

            if (selectImageScreen.parent) {
                selectImageScreen.parent.removeChild (selectImageScreen);
            }
            if (selectColorScreen.parent) {
                selectColorScreen.parent.removeChild (selectColorScreen);
            }
            if (purchaseScreen.parent) {
                purchaseScreen.parent.removeChild (purchaseScreen);
            }

            btnStep1 = new ButtonWithText (mc ["btnStep1"]);
            btnStep2 = new ButtonWithText (mc ["btnStep2"]);
            btnStep3 = new ButtonWithText (mc ["btnStep3"]);

            mcButtonsBackground = getElement ("mcButtonsBackground");

            selectImageScreen.addEventListener (SelectImageEvent.SELECT_IMAGE, selectImageListener);
            selectColorScreen.addEventListener (SelectColorEvent.SELECT_COLOR, selectColorListener);
            purchaseScreen.addEventListener (PurchaseTshirtEvent.PURCHASE, purchaseTshirtListener);
            purchaseScreen.addEventListener (PurchaseTshirtEvent.PURCHASE_AND_DRESS, purchaseTshirtListener);

            btnStep1.addEventListener (MouseEvent.CLICK, clickListener);
            btnStep2.addEventListener (MouseEvent.CLICK, clickListener);
            btnStep3.addEventListener (MouseEvent.CLICK, clickListener);

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function openScreen (screen:IScreen):void {
            btnStep1.enable = false;
            btnStep2.enable = false;
            btnStep3.enable = false;
            mcButtonsBackground.gotoAndStop (1);
            if (screen) {
                screenContainer.open (screen);
                switch (screen) {
                    case (selectImageScreen):
                        mcButtonsBackground.gotoAndStop (2);
                        break;
                    case (selectColorScreen):
                        selectColorScreen.setTshirtImage (currentImage);
                        mcButtonsBackground.gotoAndStop (3);
                        break;
                    case (purchaseScreen):
                        purchaseScreen.setTshirtImage (currentImage);
                        purchaseScreen.setTshirtColor (currentColor);
                        mcButtonsBackground.gotoAndStop (4);
                        break;
                }
            }
            else {
                screenContainer.closeAll ();
            }
            setButtonsTextColors ();
        }

        private function setButtonsTextColors ():void {
            btnStep1.tf.textColor = COLOR_1;
            btnStep2.tf.textColor = COLOR_1;
            btnStep3.tf.textColor = COLOR_1;
            switch (screenContainer.currentScreen) {
                case (selectImageScreen):
                    btnStep1.tf.textColor = COLOR_2;
                    break;
                case (selectColorScreen):
                    btnStep1.tf.textColor = COLOR_2;
                    btnStep2.tf.textColor = COLOR_2;
                    break;
                case (purchaseScreen):
                    btnStep1.tf.textColor = COLOR_2;
                    btnStep2.tf.textColor = COLOR_2;
                    btnStep3.tf.textColor = COLOR_2;
                    break;
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case (btnStep1):
                    //
                    break;
                case (btnStep2):
                    openScreen (selectColorScreen);
                    break;
                case (btnStep3):
                    openScreen (purchaseScreen);
                    break;
            }
        }

        private function selectImageListener (event:SelectImageEvent):void {
            currentImage = event.imageId;
            openScreen (selectColorScreen);
            var itemId:String;
            if (tutorialManager.currentStep == TutorialStep.SHOP_SELECT_ITEM_1) {
                itemId = TutorialManager.SHOP_ITEM_1;
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (itemId);
                if (shopItem.category == ShopItemCategory.T_SHIRTS) {
                    tutorialManager.completeStep (TutorialStep.SHOP_SELECT_ITEM_1);
                }
            }
        }

        private function selectColorListener (event:SelectColorEvent):void {
            currentColor = event.color;
            openScreen (purchaseScreen);
        }

        private function purchaseTshirtListener (event:PurchaseTshirtEvent):void {
            var onResponseFunction:Function = onResponseWithDress;
            if (event.type == PurchaseTshirtEvent.PURCHASE) {
                onResponseFunction = onResponseWithNoDress
            }
            ServerApi.instance.query (ServerApi.BUY_ITEM, { item_id: currentImage, color:currentColor}, onResponseFunction);
            if (tutorialManager.currentStep == TutorialStep.SHOP_BUY_ITEM_1) {
                tutorialManager.completeStep (TutorialStep.SHOP_BUY_ITEM_1);
            }
        }

        private function onResponseWithDress (response:Object):void {
            onResponse (response, true);
        }

        private function onResponseWithNoDress (response:Object):void {
            onResponse (response, false);
        }

        private function onResponse (response:Object, withDress:Boolean):void {
            TransactionOverlay.instance.hide ();
            if (response.response_code == 1) {
                BreakdanceApp.instance.appUser.onBuyItem (response, currentImage, currentColor, withDress);
            }
            reset ();
        }

    }
}
