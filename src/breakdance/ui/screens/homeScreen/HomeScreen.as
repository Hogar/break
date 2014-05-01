package breakdance.ui.screens.homeScreen {

    import breakdance.BreakdanceApp;
    import breakdance.battle.data.BattleData;
    import breakdance.core.server.ServerApi;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.Screen;
    import breakdance.core.ui.events.ScreenEvent;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.collections.CollectionType;
    import breakdance.data.collections.CollectionTypeCollection;
    import breakdance.data.consumables.Consumable;
    import breakdance.data.consumables.ConsumableCollection;
    import breakdance.data.consumables.RestoreStaminaConsumable;
    import breakdance.socketServer.SocketServerManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.Button;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.popups.battleListPopUp.BattleListPopUp;
    import breakdance.ui.popups.topPlayersListPopUp.TopPlayersPopUp;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.ui.screenManager.events.ScreenManagerEvent;
    import breakdance.ui.screens.danceMovesWindow.DanceMovesWindow;
    import breakdance.ui.screens.guessMoveGameScreen.GuessMoveGameScreen;
    import breakdance.ui.screens.shopWindows.DressRoomWindow;
    import breakdance.ui.screens.shopWindows.ShopWindow;
    import breakdance.user.AppUser;
    import breakdance.user.FriendData;
    import breakdance.user.UserCollectionData;
    import breakdance.user.UserPurchasedConsumable;
    import breakdance.user.events.ChangeUserEvent;

    import com.hogargames.app.screens.IScreen;
    import com.hogargames.app.screens.ScreensContainer;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;

    public class HomeScreen extends Screen {

        //скрины:
        private var screenContainer:ScreensContainer;//Элемент для работы со скринами.
        private var shopWindow:ShopWindow;
        private var dressRoomWindow:DressRoomWindow;
        private var danceMoviesWindow:DanceMovesWindow;
        private var guessMoveGameScreen:GuessMoveGameScreen;

        private var mcPlayerPanel:Sprite;
        private var mcFriendPanel:Sprite;

        private var btn5Steps:Button;

        private var btnWaterBottle:Button;
        private var btnTicket:Button;
        private var btnBattle:Button;
        private var btnAchievements:AchievementsButton;
        private var btnHome:Button;

        private var tfName:TextField;
        private var tfLevel:TextField;

        private var fiveStepsAwardId:String;

        private var appUser:AppUser;
        private var textsManager:TextsManager;

        private static const BUTTON_INDENT_Y_FOR_TOOLTIP:int = 34;
        private static const SOFT_HALL:String = "soft_hall";

        public function HomeScreen () {
            appUser = BreakdanceApp.instance.appUser;
            textsManager = TextsManager.instance;
            fiveStepsAwardId = StaticData.instance.getSetting ("award_5_steps");
            super (Template.createSymbol (Template.HOME_SCREEN));
            var containerForScreens:Sprite = new Sprite ();
            addChild (containerForScreens);
            screenContainer = new ScreensContainer (containerForScreens);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function destroy ():void {
            if (shopWindow) {
                shopWindow.removeEventListener (ScreenEvent.HIDE_SCREEN, hideScreenListener);
                shopWindow.destroy ();
                shopWindow = null;
            }

            if (dressRoomWindow) {
                dressRoomWindow.removeEventListener (ScreenEvent.HIDE_SCREEN, hideScreenListener);
                dressRoomWindow.destroy ();
                dressRoomWindow = null;
            }

            if (danceMoviesWindow) {
                danceMoviesWindow.removeEventListener (ScreenEvent.HIDE_SCREEN, hideScreenListener);
                danceMoviesWindow.destroy ();
                danceMoviesWindow = null;
            }
            if (guessMoveGameScreen) {
                guessMoveGameScreen.removeEventListener(ScreenEvent.HIDE_SCREEN, hideScreenListener);
                guessMoveGameScreen.destroy();
                guessMoveGameScreen = null;
            }
            if (btn5Steps) {
                destroyButton (btn5Steps);
                btn5Steps = null;
            }
            if (btnWaterBottle) {
                destroyButton (btnWaterBottle);
                btnWaterBottle = null;
            }
            if (btnTicket) {
                destroyButton (btnTicket);
                btnTicket = null;
            }
            if (btnBattle) {
                destroyButton (btnBattle);
                btnBattle = null;
            }
            if (btnAchievements) {
                btnAchievements.removeEventListener (MouseEvent.CLICK, clickListener);
                btnAchievements.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnAchievements.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btnAchievements.destroy ();
                btnAchievements = null;
            }
            if (btnHome) {
                destroyButton (btnHome);
                btnHome = null;
            }

            PopUpManager.instance.topPlayersPopUp.removeEventListener (ScreenEvent.HIDE_SCREEN, hideScreenListener);
            PopUpManager.instance.battleListPopUp.removeEventListener (ScreenEvent.HIDE_SCREEN, hideScreenListener);
            ScreenManager.instance.removeEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
            appUser.removeEventListener (ChangeUserEvent.CHANGE_USER_FRIEND, changeUserFriendListener);

            super.destroy ();
        }

        private function destroyButton (btn:Button):void {
            btn.removeEventListener (MouseEvent.CLICK, clickListener);
            btn.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btn.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            btn.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            mcPlayerPanel = getElement ("mcPlayerPanel");
            btn5Steps = new Button (mcPlayerPanel ["btn5Steps"]);

            mcFriendPanel = getElement ("mcFriendPanel");
            btnWaterBottle = new Button (mcFriendPanel ["btnWaterBottle"]);
            btnTicket = new Button (mcFriendPanel ["btnTicket"]);
            btnBattle = new Button (mcFriendPanel ["btnBattle"]);
            btnHome = new Button (mcFriendPanel ["btnHome"]);
            btnAchievements = new AchievementsButton (mcFriendPanel ["btnAchievements"]);

            mcFriendPanel.visible = false;

            tfName = getElement ("tfName", mcFriendPanel);
            tfLevel = getElement ("tfLevel", mcFriendPanel);

            btn5Steps.addEventListener (MouseEvent.CLICK, clickListener);
            btn5Steps.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btn5Steps.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            btn5Steps.visible = false;

            btnWaterBottle.addEventListener (MouseEvent.CLICK, clickListener);
            btnWaterBottle.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnWaterBottle.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            btnTicket.addEventListener (MouseEvent.CLICK, clickListener);
            btnTicket.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnTicket.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            btnBattle.addEventListener (MouseEvent.CLICK, clickListener);
            btnBattle.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnBattle.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            btnAchievements.addEventListener (MouseEvent.CLICK, clickListener);
            btnAchievements.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnAchievements.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            btnHome.addEventListener (MouseEvent.CLICK, clickListener);
            btnHome.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnHome.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            //Создаём скрины:
            shopWindow = new ShopWindow ();
            dressRoomWindow = new DressRoomWindow ();
            danceMoviesWindow = new DanceMovesWindow ();
            guessMoveGameScreen = new GuessMoveGameScreen();

            shopWindow.addEventListener (ScreenEvent.HIDE_SCREEN, hideScreenListener);
            dressRoomWindow.addEventListener (ScreenEvent.HIDE_SCREEN, hideScreenListener);
            danceMoviesWindow.addEventListener (ScreenEvent.HIDE_SCREEN, hideScreenListener);
            guessMoveGameScreen.addEventListener(ScreenEvent.HIDE_SCREEN, hideScreenListener);

            PopUpManager.instance.topPlayersPopUp.addEventListener (ScreenEvent.HIDE_SCREEN, hideScreenListener);
            PopUpManager.instance.battleListPopUp.addEventListener (ScreenEvent.HIDE_SCREEN, hideScreenListener);
            ScreenManager.instance.addEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
            appUser.addEventListener (ChangeUserEvent.CHANGE_USER_FRIEND, changeUserFriendListener);
            appUser.addEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);

            changeUserFriendListener (null);
            changeUserListener (null);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private static function getTooltipPosition (object:DisplayObject):Point {
            var objectParent:DisplayObjectContainer = object.parent;
            var positionPoint:Point;
            if (objectParent) {
                positionPoint = objectParent.localToGlobal (new Point (object.x, object.y + BUTTON_INDENT_Y_FOR_TOOLTIP));
            }
            return positionPoint;
        }

        private function showScreen (screen:IScreen):void {
            if (screen) {
                screenContainer.open (screen);
            }
            else {
                screenContainer.closeAll ();
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function changeUserFriendListener (event:ChangeUserEvent):void {
            var randomValue:int = Math.random () * 100;
            btnAchievements.setPercents (randomValue);
            btn5Steps.visible = Boolean (appUser.userAwards.indexOf (fiveStepsAwardId) == -1);

            mcFriendPanel.visible = (appUser.currentFriendData != null);
            mcPlayerPanel.visible = (appUser.currentFriendData == null);

            var currentFriendData:FriendData = appUser.currentFriendData;
            if (appUser.currentFriendData) {
                tfName.text = currentFriendData.nickname;
                tfLevel.text = TextsManager.instance.getText ("level_2") + " " + appUser.currentFriendData.level;
                btnBattle.enable = currentFriendData.isOnline;
                appUser.currentFriendData.addEventListener (Event.CHANGE, changeFriendDataListener);
            }
            else {
                tfName.text = "";
                tfLevel.text = "";
            }
        }

        private function changeUserListener (event:ChangeUserEvent):void {
            var numSoftHallTickets:int = 0;
            var userCollections:Vector.<UserCollectionData> = appUser.userCollections;
            for (var i:int = 0; i < userCollections.length; i++) {
                var userCollectionData:UserCollectionData = userCollections [i];
                if (userCollectionData.id == SOFT_HALL) {
                    numSoftHallTickets = userCollectionData.count;
                    break;
                }
            }
            btnTicket.enable = (numSoftHallTickets > 0);

            var userPurchasedConsumable:UserPurchasedConsumable = appUser.getUserPurchaseConsumable (RestoreStaminaConsumable.WATER_BOTTLE);
            btnWaterBottle.enable = (userPurchasedConsumable && userPurchasedConsumable.count > 0);
        }

        private function changeFriendDataListener (event:Event):void {
            if (event.currentTarget == appUser.currentFriendData) {
                btnBattle.enable = appUser.currentFriendData.isOnline;
            }
        }

        private static function hideScreenListener (event:ScreenEvent):void {
            ScreenManager.instance.navigateTo (ScreenManager.HOME_SCREEN);
        }

        private function navigateToListener (event:ScreenManagerEvent):void {
            var battleListPopUp:BattleListPopUp = PopUpManager.instance.battleListPopUp;
            if (battleListPopUp.isShowed) {
                battleListPopUp.hide ();
            }
            var topPlayersPopUp:TopPlayersPopUp = PopUpManager.instance.topPlayersPopUp;
            if (topPlayersPopUp.isShowed) {
                topPlayersPopUp.hide ();
            }
            switch (event.screenId) {
                case (ScreenManager.BATTLE_LIST):
                    if (BreakdanceApp.instance.appUser.testReadyToBattle ()) {
                        battleListPopUp.show ();
                        showScreen (null);
                    }
                    break;
                case (ScreenManager.BATTLE_SCREEN):
                case (ScreenManager.HOME_SCREEN):
                    showScreen (null);
                    break;
                case (ScreenManager.DANCE_MOVES_SCREEN):
                    showScreen (danceMoviesWindow);
                    break;
                case (ScreenManager.DRESS_ROOM_SCREEN):
                    showScreen (dressRoomWindow);
                    break;
                case (ScreenManager.RATING_SCREEN):
                    topPlayersPopUp.show ();
                    showScreen (null);
                    break;
                case (ScreenManager.SHOP_SCREEN):
                    showScreen (shopWindow);
                    break;
                case (ScreenManager.TRAINING_SCREEN):
                    showScreen (guessMoveGameScreen);
                    break;
                default:
                    showScreen (null);
            }
        }

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btn5Steps:
                    PopUpManager.instance.fiveStepsPopUp.show ();
                    break;
                case btnWaterBottle:
                    if (appUser.currentFriendData) {
                        ServerApi.instance.query (ServerApi.GIVE_CONSUMABLES, {recipient_id:appUser.currentFriendData.uid, consumables_id:RestoreStaminaConsumable.WATER_BOTTLE}, onGiveConsumables);
                        TransactionOverlay.instance.show ();
                    }
                    break;
                case btnTicket:
                    if (appUser.currentFriendData) {
                        ServerApi.instance.query (ServerApi.GIVE_COLLECTIONS, {recipient_id:appUser.currentFriendData.uid, collections_id:SOFT_HALL}, onGiveCollections);
                        TransactionOverlay.instance.show ();
                    }
                    break;
                case btnBattle:
                    var currentFriendData:FriendData = appUser.currentFriendData;
                    if (currentFriendData) {
                        if (currentFriendData.isOnline && SocketServerManager.instance.connected) {
                            var battleData:BattleData = new BattleData ();
                            battleData.turns = 3;
                            battleData.bet = 0;
                            battleData.player1 = currentFriendData.asBattlePlayerData ();//Игрок 1 в отсылаемом инвайте всегда противник!
                            battleData.player2 = appUser.asBattlePlayerData ();
                            PopUpManager.instance.sendInvitePopUp.showBattleData (battleData);
                            SocketServerManager.instance.sendInvite (battleData);
                        }
                    }
                    break;
                case btnAchievements:
                    trace ("btnAchievements");
                    PopUpManager.instance.infoPopUp.showMessage (textsManager.getText ("inDevelopingTitle"), textsManager.getText ("inDevelopingText"));
                    var randomValue:int = Math.random () * 140;
                    btnAchievements.setPercents (randomValue);
                    break;
                case btnHome:
                    appUser.currentFriendData = null;
                    break;
            }
        }

        private function onGiveConsumables (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (response.response_code == 1) {
                appUser.onGiveConsumables (response);
                var watterBottleTitle:String = "";
                var waterBottleConsumable:Consumable = ConsumableCollection.instance.getConsumable (RestoreStaminaConsumable.WATER_BOTTLE);
                if (waterBottleConsumable) {
                    watterBottleTitle = waterBottleConsumable.name;
                }
                showGiveGiftPopUp (watterBottleTitle);
            }
        }

        private function onGiveCollections (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (response.response_code == 1) {
                appUser.onGiveCollections (response);
                var collectionTypeName:String = "";
                var collectionType:CollectionType = CollectionTypeCollection.instance.getCollectionType (SOFT_HALL);
                if (collectionType) {
                    collectionTypeName = collectionType.name;
                }
                showGiveGiftPopUp (collectionTypeName);
            }
        }

        private function showGiveGiftPopUp (giftName:String):void {
            var giveItemToFriendsText:String = textsManager.getText ("giveItemToFriends");
            giveItemToFriendsText = giveItemToFriendsText.replace ("#1", giftName);
            var playerName:String = "";
            if (appUser.currentFriendData) {
                playerName = appUser.currentFriendData.nickname;
            }
            giveItemToFriendsText = giveItemToFriendsText.replace ("#1", giftName);
            giveItemToFriendsText = giveItemToFriendsText.replace ("#2", playerName);
            PopUpManager.instance.giftPopUp.showMessage (textsManager.getText ("gift"), giveItemToFriendsText);
        }

        private function rollOverListener (event:MouseEvent):void {
            var object:DisplayObject = DisplayObject (event.currentTarget);
            var message:String;
            switch (event.currentTarget) {
                case btn5Steps:
                    message = TextsManager.instance.getText ("tt5steps");
                    break;
                case btnWaterBottle:
                    message = TextsManager.instance.getText ("ttGiveWaterBottle");
                    break;
                case btnTicket:
                    message = TextsManager.instance.getText ("ttGiveTicket");
                    break;
                case btnBattle:
                    message = TextsManager.instance.getText ("ttFriendBattle");
                    break;
                case btnAchievements:
                    message = TextsManager.instance.getText ("ttFriendAchievements");
                    break;
                case btnHome:
                    message = TextsManager.instance.getText ("ttHome");
                    break;
            }

            if (message) {
                var positionPoint:Point = getTooltipPosition (object);
                BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
            }

        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }

    }
}