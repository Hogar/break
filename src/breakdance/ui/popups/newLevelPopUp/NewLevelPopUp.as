/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 13.12.13
 * Time: 14:46
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.newLevelPopUp {

    import breakdance.BreakdanceApp;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.server.ServerApi;
    import breakdance.data.awards.Award;
    import breakdance.data.awards.AwardCollection;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.data.shop.ShopItemConditionType;
    import breakdance.template.Template;
    import breakdance.ui.commons.ItemView;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.ui.screenManager.events.ScreenManagerEvent;
    import breakdance.user.UserLevel;
    import breakdance.user.UserLevelCollection;

    import flash.display.Sprite;
    import flash.text.TextField;

    public class NewLevelPopUp extends TwoTextButtonsPopUp {
        private var mcUnlockedItem:Sprite;
        private var tfUnlock:TextField;
        private var mcItem:Sprite;
        private var item:ItemView;

        private var tfReward:TextField;
        private var mcBucks:Sprite;
        private var tfBucks:TextField;
        private var mcCoins:Sprite;
        private var tfCoins:TextField;
        private var tfDivision:TextField;

        private var currentLevel:int = 0;

        private var delayShow:Boolean = false;

        public function NewLevelPopUp () {
            super (Template.createSymbol (Template.NEW_LEVEL_POP_UP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
            if (ScreenManager.instance.currentScreenId == ScreenManager.BATTLE_SCREEN) {
                delayShow = true;
            }
            else {
                super.show ();
            }
        }

        override public function setTexts ():void {
            super.setTexts ();
            tfTitle.htmlText = textsManager.getText ("newLevel");
            tfUnlock.htmlText = textsManager.getText ("unlock");
            tfReward.htmlText = textsManager.getText ("reward");
            btn1.text = textsManager.getText ("share");
            btn2.text = textsManager.getText ("close");

            var levelData:UserLevel = UserLevelCollection.instance.getUserLevel (currentLevel);
            var previousLevelData:UserLevel = UserLevelCollection.instance.getUserLevel (currentLevel - 1);
            if (
                    levelData &&
                    (
                            (levelData.id == 1) ||
                            (previousLevelData && (levelData.division > previousLevelData.division)))
                    )
            {
                var txtNewDivision:String = textsManager.getText ("newDivision");
                txtNewDivision = txtNewDivision.replace ("#1", levelData.maxMoves);
                txtNewDivision = txtNewDivision.replace ("#2", levelData.maxStamina);
                tfDivision.htmlText = txtNewDivision;
            }
            else {
                tfDivision.text = "";
            }
        }

        public function setLevel (value:int):void {
            currentLevel = value;
            var levelData:UserLevel = UserLevelCollection.instance.getUserLevel (currentLevel);
            if (levelData) {
                tf.text = String (value);
                var awardData:Award = AwardCollection.instance.getAward (levelData.award);
                if (awardData) {
                    tfReward.visible = ((awardData.coins != 0) || (awardData.bucks != 0));
                    if (awardData.coins != 0) {
                        mcCoins.visible = true;
                        tfCoins.htmlText = "<b>" + String (awardData.coins) + "</b>";
                    }
                    else {
                        mcCoins.visible = false;
                    }
                    if (awardData.bucks != 0) {
                        mcBucks.visible = true;
                        tfBucks.htmlText = "<b>" + String (awardData.bucks) + "</b>";
                    }
                    else {
                        mcBucks.visible = false;
                    }

                    var shopItems:Vector.<ShopItem> = ShopItemCollection.instance.list;
                    var newUnlockedItem:Vector.<String> = new Vector.<String> ();
                    if (currentLevel > 1) {
                        for (var i:int = 0; i < shopItems.length; i++) {
                            var shopItem:ShopItem = shopItems [i];
                            if (shopItem.conditionType == ShopItemConditionType.LEVEL) {
                                if (parseInt (shopItem.conditionValue) == currentLevel) {
                                    var newItems:Vector.<String> = BreakdanceApp.instance.appUser.newItems;
                                    newUnlockedItem.push (shopItem.id);
                                    if (newItems.indexOf (shopItem.id) == -1) {
                                        BreakdanceApp.instance.appUser.addNewItem (shopItem.id);
                                        ServerApi.instance.query (ServerApi.ADD_USER_NEWS, {item_id:shopItem.id}, onAddUserNewsResponse);
                                    }
                                    else {
//                                    trace ("да такая штука уже есть у меня.");
                                    }
                                }
                            }
                        }
                    }

                    if (newUnlockedItem.length > 0) {
                        mcUnlockedItem.visible = true;
                        item.startItemsShowing (newUnlockedItem);
                    }
                    else {
                        mcUnlockedItem.visible = false;
                    }
                }
            }
            else {
                mcUnlockedItem.visible = false;
                tfReward.visible = false;
                mcBucks.visible = false;
                mcCoins.visible = false;
            }
            setTexts ();
        }

        override public function destroy ():void {
            item.destroy ();
            ScreenManager.instance.removeEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcUnlockedItem = getElement ("mcUnlockedItem");
            tfUnlock = getElement ("tfUnlock", mcUnlockedItem);
            mcItem = getElement ("mcItem", mcUnlockedItem);
            item = new ItemView ();
            mcItem.addChild (item);

            tfReward = getElement ("tfReward");
            mcBucks = getElement ("mcBucks");
            tfBucks = getElement ("tfBucks", mcBucks);
            mcCoins = getElement ("mcCoins");
            tfCoins = getElement ("tfCoins", mcCoins);
            tfDivision = getElement ("tfDivision");

            ScreenManager.instance.addEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
        }

        override protected function onClickFirstButton ():void {
            var txtNewLevel:String = textsManager.getText ("newLevel2");
            txtNewLevel = txtNewLevel.replace ("#1", currentLevel);
            JsApi.instance.query (JsApi.WRITE_WALL, onWriteWall, [txtNewLevel]);
            hide ();
        }

        private function onWriteWall (response:JsQueryResult):void {
            //
        }

        override protected function onClickSecondButton ():void {
            hide ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function onAddUserNewsResponse (response:Object):void {
            //
        }

        private function navigateToListener (event:ScreenManagerEvent):void {
            if (delayShow) {
                super.show ();
                delayShow = false;
            }
        }

    }
}
