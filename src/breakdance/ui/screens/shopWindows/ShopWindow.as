package breakdance.ui.screens.shopWindows {

    import breakdance.BreakdanceApp;
    import breakdance.core.server.ServerApi;
    import breakdance.core.sound.SoundManager;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.screens.shopWindows.events.SelectShopItemEvent;
    import breakdance.ui.screens.shopWindows.tshirtConstructor.TshirtConstructor;
    import breakdance.user.AppUser;
    import breakdance.user.UserPurchasedItem;

    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class ShopWindow extends WindowWithList {

        private var appUser:AppUser;

        private var tshirtConstructor:TshirtConstructor;
        private var shopList:ShopList;

        private var newItemsTimer:Timer;

        private static const BUTTON_APPLY_X:int = 487;

        public function ShopWindow () {
            appUser = BreakdanceApp.instance.appUser;
            super ();
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            tfTitle.text = textsManager.getText ("shop");
            btnApply.text = "<b>" + textsManager.getText ("buy") + "</b>";
            btnSell.text = "";
        }

        override public function onShow ():void {
            super.onShow ();
            var i:int;
            for (i = 0; i < tabs.length; i++)  {
                tabs [i].newItemsSelection = false;
            }

            var newItems:Vector.<String> = appUser.newItems;
            var numNewItems:int = newItems.length;
            for (i = 0; i < numNewItems; i++)  {
                var newItem:String = newItems [i];
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (newItem);
                if (shopItem) {
                    getTabByCategory (shopItem.category).newItemsSelection = true;
                }
            }
        }

        override public function onHide ():void {
            super.onHide ();
            selectTab (null);
        }

        override public function destroy ():void {
            if (tshirtConstructor) {
                tshirtConstructor.destroy ();
                tshirtConstructor = null;
            }
            if (shopList) {
                shopList.destroy ();
                shopList = null;
            }
            if (newItemsTimer) {
                newItemsTimer.removeEventListener (TimerEvent.TIMER, timerListener);
                newItemsTimer.stop ();
                newItemsTimer = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            btnApply.x = BUTTON_APPLY_X;
            btnSell.visible = false;

            shopList = new ShopList (mc ["mcShopList"]);
            shopList.addEventListener (SelectShopItemEvent.SELECT_SHOP_ITEM, selectShopItemListener);
            tshirtConstructor = new TshirtConstructor (mc ["mcTshirtConstructor"]);

            var newShopItemsTime:int = parseInt (StaticData.instance.getSetting ("new_shop_items_time"));
            newItemsTimer = new Timer (newShopItemsTime * 1000);
            newItemsTimer.addEventListener (TimerEvent.TIMER, timerListener);
        }

        override protected function selectTab (tab:TabButton):void {
            newItemsTimer.reset ();
            newItemsTimer.stop ();
            super.selectTab (tab);
            var i:int;
            for (i = 0; i < tabs.length; i++) {
                tabs [i].selected = (tab == tabs [i]);
            }
            if (tab) {
                newItemsTimer.start ();
                var items:Vector.<ShopItem>;
                var currentDressingItemId:String;
                appUser.character.startFitting ();
				trace('ShopWindow : selectTab  '+tab)
                switch (tab) {
                    case btnTabBody:
                        items = ShopItemCollection.instance.getShopItemsByCategory (ShopItemCategory.BODY);
                        var body:UserPurchasedItem = appUser.character.body;
                        if (body) {
                            currentDressingItemId = body.itemId;
                        }
                        break;
                    case btnTabHead:
                        items = ShopItemCollection.instance.getShopItemsByCategory (ShopItemCategory.HEAD);
                        var head:UserPurchasedItem = appUser.character.head;
                        if (head) {
                            currentDressingItemId = head.itemId;
                        }
                        break;
                    case btnTabHands:
                        items = ShopItemCollection.instance.getShopItemsByCategory (ShopItemCategory.HANDS);
                        var hands:UserPurchasedItem = appUser.character.hands;
                        if (hands) {
                            currentDressingItemId = hands.itemId;
                        }
                        break;
                    case btnTabLegs:
                        items = ShopItemCollection.instance.getShopItemsByCategory (ShopItemCategory.LEGS);
                        var legs:UserPurchasedItem = appUser.character.legs;
                        if (legs) {
                            currentDressingItemId = legs.itemId;
                        }
                        break;
                    case btnTabShoes:
                        items = ShopItemCollection.instance.getShopItemsByCategory (ShopItemCategory.SHOES);
                        var shoes:UserPurchasedItem = appUser.character.shoes;
                        if (shoes) {
                            currentDressingItemId = shoes.itemId;
                        }
                        break;
                    case btnTabMusic:
                        items = ShopItemCollection.instance.getShopItemsByCategory (ShopItemCategory.MUSIC);
                        var music:UserPurchasedItem = appUser.character.music;
                        if (music) {
                            currentDressingItemId = music.itemId;
                        }
                        break;
                    case btnTabCover:
                        items = ShopItemCollection.instance.getShopItemsByCategory (ShopItemCategory.COVER);
                        var cover:UserPurchasedItem = appUser.character.cover;
						trace('cover  '+appUser.character.cover)
                        if (cover) {
                            currentDressingItemId = cover.itemId;
                        }
                        break;
                    case btnTabOther:
                        items = ShopItemCollection.instance.getShopItemsByCategory (ShopItemCategory.OTHER);
                        var other:UserPurchasedItem = appUser.character.other;
                        if (other) {
                            currentDressingItemId = other.itemId;
                        }
                        break;
                }

                if (
                        (tutorialManager.currentStep == TutorialStep.SHOP_SELECT_CATEGORY_2) ||
                        (tutorialManager.currentStep == TutorialStep.SHOP_SELECT_CATEGORY_3)
                ) {
                    currentDressingItemId = null;
                    shopList.lockMouseWheel ();
                }
                else {
                    shopList.unLockMouseWheel ();
                }

                if (tab == btnTabTshirts) {
                    tshirtConstructor.show ();
                }
                else {
                    tshirtConstructor.hide ();
                    if (items) {
                        shopList.init (items, currentDressingItemId);

                    }
                }
            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setButtonsState (shopItem:ShopItem):void {
            btnApply.enable = (shopItem && !appUser.itemIsPurchased (shopItem.id));
            btnSell.enable = false;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        override protected function clickListener_btnClose (event:MouseEvent):void {
            super.clickListener_btnClose (event);
            if (tutorialManager.currentStep == TutorialStep.SHOP_CLOSE) {
                tutorialManager.completeStep (TutorialStep.SHOP_CLOSE);
            }
        }

        override protected function clickListener_apply (event:MouseEvent):void {
            var selectedItem:ShopItem = shopList.selectedShopItem;
            if (selectedItem) {
                if (!appUser.itemIsPurchased (selectedItem.id)) {
                    if (appUser.hasCurrencyForBuyItem (selectedItem, true)) {
                        TransactionOverlay.instance.show ();
                        ServerApi.instance.query (ServerApi.BUY_ITEM, { item_id: selectedItem.id}, onResponse);
                        SoundManager.instance.playSound(Template.SND_COINS);
                        if (tutorialManager.currentStep == TutorialStep.SHOP_BUY_ITEM_1) {
                            tutorialManager.completeStep (TutorialStep.SHOP_BUY_ITEM_1);
                        }
                        if (tutorialManager.currentStep == TutorialStep.SHOP_BUY_ITEM_2) {
                            tutorialManager.completeStep (TutorialStep.SHOP_BUY_ITEM_2);
                        }
                        if (tutorialManager.currentStep == TutorialStep.SHOP_BUY_ITEM_3) {
                            tutorialManager.completeStep (TutorialStep.SHOP_BUY_ITEM_3);
                        }
                        CONFIG::mixpanel {
//                            BreakdanceApp.mixpanel.track(
//                                    'shop',
//                                    {buy:selectedItem.id}
//                            );
                        }
                    }
                }
            }
        }

        private function onResponse (response:Object):void {
            TransactionOverlay.instance.hide ();

            if (response.response_code == 1) {
                var itemId:String = null;
                if (shopList.selectedShopItem) {
                    itemId = shopList.selectedShopItem.id;
                }
                appUser.onBuyItem (response, shopList.selectedShopItem.id);
            }

            setButtonsState (shopList.selectedShopItem);
        }

        private function selectShopItemListener (event:SelectShopItemEvent):void {
            var shopItem:ShopItem = event.shopItem;
            setButtonsState (shopItem);
            if (shopItem) {
                if (tutorialManager.currentStep == TutorialStep.SHOP_SELECT_ITEM_2) {
                    if (shopItem.id == TutorialManager.SHOP_ITEM_2) {
                        tutorialManager.completeStep (TutorialStep.SHOP_SELECT_ITEM_2);
                    }
                }
                if (tutorialManager.currentStep == TutorialStep.SHOP_SELECT_ITEM_3) {
                    if (shopItem.id == TutorialManager.SHOP_ITEM_3) {
                        tutorialManager.completeStep (TutorialStep.SHOP_SELECT_ITEM_3);
                    }
                }
            }
        }

        private function timerListener (event:TimerEvent):void {
            newItemsTimer.stop ();
            if (currentTab) {
                var category:String = getCategoryByTab (currentTab);
                if (category) {
                    var newItems:Vector.<String> = appUser.newItems;
                    var numNewItems:int = newItems.length;
                    var itemsForRemoving:Array = [];
                    for (var i:int = 0; i < numNewItems; i++) {
                        var newItem:String = newItems [i];
                        var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (newItem);
                        if (shopItem) {
                            if (shopItem.category == category) {
                                itemsForRemoving.push (newItem);
                            }
                        }
                    }
                    if (itemsForRemoving.length > 0) {
                        ServerApi.instance.query (ServerApi.REMOVE_USER_NEWS, {ids: itemsForRemoving.toString()}, onRemoveUserNewsResponse);
                        appUser.removeNewItems (itemsForRemoving);
                    }
                }
            }
        }

        public function onRemoveUserNewsResponse (response:Object):void {
            //
        }

    }
}