/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.08.13
 * Time: 13:08
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows {

    import breakdance.BreakdanceApp;
    import breakdance.core.server.ServerApi;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.screens.shopWindows.events.SelectUserPurchaseItemEvent;
    import breakdance.user.AppUser;
    import breakdance.user.UserPurchasedItem;

    import flash.events.MouseEvent;

    public class DressRoomWindow extends WindowWithList {

        private var dressRoomList:DressRoomList;

        private var sellingItemId:int;

        public function DressRoomWindow () {
            super ();
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            tfTitle.text = textsManager.getText ("dressRoom");
            btnApply.text = "<b>" + textsManager.getText ("dress") + "</b>";
            btnSell.text = "<b>" + textsManager.getText ("sell") + "</b>";
        }

        override public function destroy ():void {
            if (dressRoomList) {
                dressRoomList.destroy ();
                dressRoomList.removeEventListener (SelectUserPurchaseItemEvent.SELECT_USER_PURCHASE_ITEM, selectUserPurchaseItemListener);
                dressRoomList = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            dressRoomList = new DressRoomList (mc ["mcShopList"]);
            dressRoomList.addEventListener (SelectUserPurchaseItemEvent.SELECT_USER_PURCHASE_ITEM, selectUserPurchaseItemListener);
            mc ["mcTshirtConstructor"].visible = false;//Скрываем видимость конструктора футболок

            btnSell.addEventListener (MouseEvent.CLICK, clickListener_sell);
        }

        override protected function selectTab (tab:TabButton):void {
            super.selectTab (tab);
            var i:int;
            for (i = 0; i < tabs.length; i++) {
                tabs [i].selected = (tab == tabs [i]);
            }
            if (tab) {
                var category:String;
                var currentDressingPurchasedItem:UserPurchasedItem;
                var appUser:AppUser = BreakdanceApp.instance.appUser;
                appUser.character.startFitting ();
                switch (tab) {
                    case btnTabTshirts:
                        category = ShopItemCategory.T_SHIRTS;
                        currentDressingPurchasedItem = appUser.character.body;
                        break;
                    case btnTabBody:
                        category = ShopItemCategory.BODY;
                        currentDressingPurchasedItem = appUser.character.body;
                        break;
                    case btnTabHead:
                        category = ShopItemCategory.HEAD;
                        currentDressingPurchasedItem = appUser.character.head;
                        break;
                    case btnTabHands:
                        category = ShopItemCategory.HANDS;
                        currentDressingPurchasedItem = appUser.character.hands;
                        break;
                    case btnTabLegs:
                        category = ShopItemCategory.LEGS;
                        currentDressingPurchasedItem = appUser.character.legs;
                        break;
                    case btnTabShoes:
                        category = ShopItemCategory.SHOES;
                        currentDressingPurchasedItem = appUser.character.shoes;
                        break;
                    case btnTabMusic:
                        category = ShopItemCategory.MUSIC;
                        currentDressingPurchasedItem = appUser.character.music;
                        break;
                    case btnTabCover:
                        category = ShopItemCategory.COVER;
                        currentDressingPurchasedItem = appUser.character.cover;
                        break;
                    case btnTabOther:
                        category = ShopItemCategory.OTHER;
                        currentDressingPurchasedItem = appUser.character.other;
                        break;
                }

                var allPurchasedItems:Vector.<UserPurchasedItem> = appUser.purchasedItems;
                var totalPurchasedItems:int = allPurchasedItems.length;
                var purchasedItems:Vector.<UserPurchasedItem> = new Vector.<UserPurchasedItem>;
                for (i = 0; i < totalPurchasedItems; i++) {
                    var userPurchasedItem:UserPurchasedItem = allPurchasedItems [i];
                    var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (userPurchasedItem.itemId);
                    if (shopItem) {
                        if (shopItem.category == category) {
                            purchasedItems.push (userPurchasedItem);
                        }
                    }
                }

                if (
                        (tutorialManager.currentStep == TutorialStep.SHOP_SELECT_CATEGORY_2) ||
                        (tutorialManager.currentStep == TutorialStep.SHOP_SELECT_CATEGORY_3)
                ) {
                    currentDressingPurchasedItem = null;
                    dressRoomList.lockMouseWheel ();
                }
                else {
                    dressRoomList.unLockMouseWheel ();
                }

                dressRoomList.init (purchasedItems, currentDressingPurchasedItem);

            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setButtonsState (userPurchaseItem:UserPurchasedItem):void {
            if (userPurchaseItem) {
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (userPurchaseItem.itemId);
                var shopItemCategory:String = shopItem.category;
                if (shopItemCategory != ShopItemCategory.OTHER) {
                    btnSell.enable = true;
                }
                if (BreakdanceApp.instance.appUser.character.hasDressedItem (userPurchaseItem)) {
                    btnSell.enable = false;
                    if (
                            shopItemCategory == ShopItemCategory.COVER ||
                            shopItemCategory == ShopItemCategory.MUSIC
                            ) {
                        btnApply.text = "<b>" + textsManager.getText ("remove") + "</b>";
                    }
                    else {
                        btnApply.text = "<b>" + textsManager.getText ("undress") + "</b>";
                    }
                }
                else {
                    if (
                            shopItemCategory == ShopItemCategory.COVER ||
                            shopItemCategory == ShopItemCategory.MUSIC
                            ) {
                        btnApply.text = "<b>" + textsManager.getText ("put") + "</b>";
                    }
                    else {
                        btnApply.text = "<b>" + textsManager.getText ("dress") + "</b>";
                    }
                }
                btnApply.enable = true;
            }
            else {
                var currentCategory:String = getCategoryByTab (currentTab);
                if (
                        (currentCategory == ShopItemCategory.MUSIC) ||
                        (currentCategory == ShopItemCategory.COVER)
                ) {
                    btnApply.text = "<b>" + textsManager.getText ("put") + "</b>";
                }
                else {
                    btnApply.text = "<b>" + textsManager.getText ("dress") + "</b>";
                }
                btnApply.enable = false;
                btnSell.enable = false;
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        override protected function clickListener_btnClose (event:MouseEvent):void {
            super.clickListener_btnClose (event);
            if (tutorialManager.currentStep == TutorialStep.DRESS_ROOM_CLOSE) {
                tutorialManager.completeStep (TutorialStep.DRESS_ROOM_CLOSE);
            }
        }

        override protected function clickListener_apply (event:MouseEvent):void {
            var selectedUserPurchasedItem:UserPurchasedItem = dressRoomList.selectedUserPurchasedItem;
            var appUser:AppUser = BreakdanceApp.instance.appUser;
            if (appUser.character.hasDressedItem (selectedUserPurchasedItem)) {
                appUser.character.undressing (selectedUserPurchasedItem);
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (selectedUserPurchasedItem.itemId);
                var shopItemCategory:String = shopItem.category;
                if (
                        shopItemCategory == ShopItemCategory.COVER ||
                        shopItemCategory == ShopItemCategory.MUSIC
                ) {
                    btnApply.text = "<b>" + textsManager.getText ("put") + "</b>";
                }
                else {
                    btnApply.text = "<b>" + textsManager.getText ("dress") + "</b>";
                }
            }
            else {
                appUser.character.dressing (selectedUserPurchasedItem);
                if (
                        shopItemCategory == ShopItemCategory.COVER ||
                        shopItemCategory == ShopItemCategory.MUSIC
                        ) {
                    btnApply.text = "<b>" + textsManager.getText ("remove") + "</b>";
                }
                else {
                    btnApply.text = "<b>" + textsManager.getText ("undress") + "</b>";
                }
            }
            if (tutorialManager.currentStep == TutorialStep.DRESS_ROOM_SET_ITEM_1) {
                tutorialManager.completeStep (TutorialStep.DRESS_ROOM_SET_ITEM_1);
            }
            if (tutorialManager.currentStep == TutorialStep.DRESS_ROOM_SET_ITEM_2) {
                tutorialManager.completeStep (TutorialStep.DRESS_ROOM_SET_ITEM_2);
            }
            setButtonsState (selectedUserPurchasedItem);
        }

        private function selectUserPurchaseItemListener (event:SelectUserPurchaseItemEvent):void {
            var userPurchasedItem:UserPurchasedItem = event.userPurchasedItem;
            setButtonsState (userPurchasedItem);
            if (userPurchasedItem) {
                if (tutorialManager.currentStep == TutorialStep.DRESS_ROOM_SELECT_ITEM_1) {
                    if (userPurchasedItem.itemId == TutorialManager.DRESS_ROOM_ITEM_1) {
                        tutorialManager.completeStep (TutorialStep.DRESS_ROOM_SELECT_ITEM_1);
                    }
                }
                if (tutorialManager.currentStep == TutorialStep.DRESS_ROOM_SELECT_ITEM_2) {
                    if (userPurchasedItem.itemId == TutorialManager.DRESS_ROOM_ITEM_2) {
                        tutorialManager.completeStep (TutorialStep.DRESS_ROOM_SELECT_ITEM_2);
                    }
                }
            }
        }


        private function clickListener_sell (event:MouseEvent):void {
            TransactionOverlay.instance.show ();
            var userPurchasedItem:UserPurchasedItem = dressRoomList.selectedUserPurchasedItem;
            sellingItemId = userPurchasedItem.id;
            ServerApi.instance.query (ServerApi.SELL_ITEM, { user_item_id: userPurchasedItem.id}, onResponse);
        }

        private function onResponse (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (response.response_code == 1) {
                BreakdanceApp.instance.appUser.onSellItem (response, sellingItemId);
                selectTab (currentTab);
            }
        }

    }
}
