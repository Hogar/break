package breakdance.ui.panels.bottomPanel {

    import breakdance.BreakdanceApp;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.news.NewData;
    import breakdance.data.news.NewDataCollection;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.commons.tooltip.TooltipOrientation;
    import breakdance.ui.panels.bottomPanel.chatPanel.ChatPanel;
    import breakdance.ui.panels.bottomPanel.friendList.FriendsList;
    import breakdance.ui.panels.bottomPanel.mainMenuButtons.AchievementButton;
    import breakdance.ui.panels.bottomPanel.mainMenuButtons.MainMenuButton;
    import breakdance.ui.panels.bottomPanel.mainMenuButtons.ShopButton;
    import breakdance.ui.panels.bottomPanel.settingBlockButton.NewsButton;
    import breakdance.ui.panels.bottomPanel.settingBlockButton.ScreenshotButton;
    import breakdance.ui.panels.settingsPanel.SettingsPanel;
	import breakdance.ui.popups.playerMusicPopUp.PlayerMusicPopUp;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.ui.screenManager.events.ScreenManagerEvent;
    import breakdance.user.AppUser;
    import breakdance.user.FriendData;
    import breakdance.user.events.ChangeUserEvent;

    import com.hogargames.display.GraphicStorage;
    import com.hogargames.display.buttons.Button;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class BottomPanel extends GraphicStorage implements ITextContainer {

        private var btnMainMenu1:MainMenuButton;
        private var btnRating:MainMenuButton;
        private var btnAchievements:AchievementButton;
        private var btnTraining:MainMenuButton;
        private var btnBattle:MainMenuButton;
        private var btnDressingRoom:MainMenuButton;
        private var btnShop:ShopButton;
        private var btnWork:MainMenuButton;
        private var btnLearnMoves:MainMenuButton;

        private var mainMenuButtons:Vector.<MainMenuButton> = new Vector.<MainMenuButton> ();



        //Кнопки переключения режимов (список друзей / чат):
        private var btnTeam:TypeButtonWithText;
        private var btnFriends:TypeButtonWithText;
        private var btnChat:TypeButtonWithText;

        private var mcToggle:MovieClip;

        //Кнопки панели управления:
        private var btnScreenShot:ScreenshotButton;
        private var btnSettings:TypeButton;
        private var btnEditCharacter:TypeButton;
        private var btnNews:NewsButton;

        private var chatPanel:ChatPanel;
        private var friendsList:FriendsList;

        private var appUser:AppUser;
        private var popUpManager:PopUpManager;

        private var tutorialManager:TutorialManager;
        private var textsManager:TextsManager = TextsManager.instance;

        private static const TOGGLE_FRIENDS_FRAME:int = 1;
        private static const TOGGLE_TEAM_FRAME:int = 2;
        private static const TOGGLE_CHAT_FRAME:int = 3;
        private static const TOGGLE_DEFAULT_FRAME:int = TOGGLE_CHAT_FRAME;

        private static const BUTTON_MARGIN_X:int = 40;
        private static const BUTTON_MARGIN_Y:int = 549;

        public function BottomPanel () {
            appUser = BreakdanceApp.instance.appUser;
            popUpManager = PopUpManager.instance;
            tutorialManager = TutorialManager.instance;
            super (Template.createSymbol (Template.BOTTOM_PANEL));
            init (appUser.userAppFriends);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function init (friends:Vector.<FriendData>):void {
            friendsList.init (friends);
        }

        public function setTexts ():void {
            btnTeam.text = textsManager.getText ("team");
            btnFriends.text = textsManager.getText ("friends");
            btnChat.text = textsManager.getText ("chat");
        }

        override public function destroy ():void {
            destroyMainMenuButton (btnMainMenu1);
            destroyMainMenuButton (btnRating);
            destroyMainMenuButton (btnAchievements);
            destroyMainMenuButton (btnTraining);
            destroyMainMenuButton (btnBattle);
            destroyMainMenuButton (btnDressingRoom);
            destroyMainMenuButton (btnShop);
            destroyMainMenuButton (btnWork);
            destroyMainMenuButton (btnLearnMoves);

            btnMainMenu1 = null;
            btnRating = null;
            btnAchievements = null;
            btnTraining = null;
            btnBattle = null;
            btnDressingRoom = null;
            btnShop = null;
            btnWork = null;
            btnLearnMoves = null;

            if (btnTeam) {
                destroyButton (btnTeam);
                btnTeam = null;
            }
            if (btnFriends) {
                destroyButton (btnFriends);
                btnFriends = null;
            }
            if (btnChat) {
                destroyButton (btnChat);
                btnChat = null;
            }

            if (btnScreenShot) {
                destroyButton (btnScreenShot);
                btnScreenShot = null;
            }
            if (btnSettings) {
                destroyButton (btnSettings);
                btnSettings = null;
            }
            if (btnEditCharacter) {
                destroyButton (btnEditCharacter);
                btnEditCharacter = null;
            }
            if (btnNews) {
                destroyButton (btnNews);
                btnNews = null;
            }

            ScreenManager.instance.removeEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);

            textsManager.removeTextContainer (this);
            appUser.removeEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);
            super.destroy ();
        }

        private function initMainMenuButton (button:MainMenuButton):void {
            if (button) {
                button.addEventListener (MouseEvent.CLICK, clickListener_mainMenuButtons);
                button.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                button.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            }
        }

        private function initButton (button:Button):void {
            if (button) {
                button.addEventListener (MouseEvent.CLICK, clickListener);
                button.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                button.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            }
        }

        private function destroyMainMenuButton (button:MainMenuButton):void {
            if (button) {
                button.removeEventListener (MouseEvent.CLICK, clickListener_mainMenuButtons);
                button.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                button.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                button.destroy ();
            }
        }

        private function destroyButton (button:Button):void {
            if (button) {
                button.removeEventListener (MouseEvent.CLICK, clickListener);
                button.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                button.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                button.destroy ();
            }
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            friendsList = new FriendsList (getElement ("mcFriendsList"));

            btnMainMenu1 = new MainMenuButton (mc ["btnMainMenu1"]);
            btnRating = new MainMenuButton (mc ["btnMainMenu2"]);
            btnAchievements = new AchievementButton (mc ["btnMainMenu3"]);
            btnTraining = new MainMenuButton (mc ["btnMainMenu4"]);
            btnBattle = new MainMenuButton (mc ["btnMainMenu5"]);
            btnLearnMoves = new MainMenuButton (mc ["btnMainMenu6"]);
            btnShop = new ShopButton (mc ["btnMainMenu7"]);
            btnDressingRoom = new MainMenuButton (mc ["btnMainMenu8"]);
            btnWork = new MainMenuButton (mc ["btnMainMenu9"]);

            btnTeam = new TypeButtonWithText (mc ["btnTeam"]);
            btnFriends = new TypeButtonWithText (mc ["btnFriends"]);
            btnChat = new TypeButtonWithText (mc ["btnChat"]);
            mcToggle = getElement ("mcToggle");

            chatPanel = new ChatPanel (mc ["mcChatPanel"]);

            btnScreenShot = new ScreenshotButton (mc ["btnScreenShot"]);
            btnSettings = new TypeButton (mc ["btnSettings"]);
            btnEditCharacter = new TypeButton (mc ["btnEditCharacter"]);
            btnNews = new NewsButton (mc ["btnNews"]);

            mcToggle.gotoAndStop (TOGGLE_DEFAULT_FRAME);
            chatPanel.visible = true;
            friendsList.visible = false;

            mainMenuButtons.push (btnMainMenu1);
            mainMenuButtons.push (btnRating);
            mainMenuButtons.push (btnAchievements);
            mainMenuButtons.push (btnTraining);
            mainMenuButtons.push (btnBattle);
            mainMenuButtons.push (btnDressingRoom);
            mainMenuButtons.push (btnShop);
            mainMenuButtons.push (btnWork);
            mainMenuButtons.push (btnLearnMoves);

            initMainMenuButton (btnMainMenu1);
            initMainMenuButton (btnRating);
            initMainMenuButton (btnAchievements);
            initMainMenuButton (btnTraining);
            initMainMenuButton (btnBattle);
            initMainMenuButton (btnDressingRoom);
            initMainMenuButton (btnShop);
            initMainMenuButton (btnWork);
            initMainMenuButton (btnLearnMoves);

            initButton (btnTeam);
            initButton (btnFriends);
            initButton (btnChat);

            initButton (btnScreenShot);
            initButton (btnSettings);
            initButton (btnEditCharacter);
            initButton (btnNews);

            ScreenManager.instance.addEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
            appUser.addEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);

            changeUserListener (null);

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function pushButton (button:MainMenuButton):void {
            for (var i:int = 0; i < mainMenuButtons.length; i++) {
                var currentButton:MainMenuButton = mainMenuButtons [i];
                currentButton.pushed = (currentButton == button);
            }
        }

        private function unPushButtons ():void {
            for (var i:int = 0; i < mainMenuButtons.length; i++) {
                var currentButton:MainMenuButton = mainMenuButtons [i];
                currentButton.pushed = false;
            }
        }

        private function setMainMenuButtonsIconsVisible (enable:Boolean):void {
            for (var i:int = 0; i < mainMenuButtons.length; i++) {
                var currentButton:MainMenuButton = mainMenuButtons [i];
                currentButton.iconVisible = enable;
            }
        }

        private function getTooltipPositionForMainMenuButton (button:Button):Point {
            var buttonMarginX:int = BUTTON_MARGIN_X;
            if (button is MainMenuButton) {
                buttonMarginX = MainMenuButton (button).hitWidth / 2;
            }
            var positionPoint:Point = localToGlobal (new Point (button.x + buttonMarginX, BUTTON_MARGIN_Y));
            return positionPoint;
        }

        private function getTooltipPositionForButton (button:Button, marginY:int = 0):Point {
            var positionPoint:Point = localToGlobal (new Point (button.x + button.width / 2, button.y + marginY));
            return positionPoint;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener_mainMenuButtons (event:MouseEvent):void {
            if (!appUser.installed) {
                return;
            }
            var button:MainMenuButton = MainMenuButton (event.currentTarget);
            var screenId:String;
            switch (button) {
                case btnMainMenu1:
//                    unPushButtons ();
//                    setMainMenuButtonsIconsVisible (true);
                    break;
                case btnRating:
                    screenId = ScreenManager.RATING_SCREEN;
                    break;
                case btnAchievements:
                    //var randomValue:int = Math.random () * 140;
                    btnAchievements.setPercents (BreakdanceApp.instance.appUser.countAchievementsDone);
                    screenId = ScreenManager.ACHIEVEMENTS_SCREEN;
                //    PopUpManager.instance.infoPopUp.showMessage (textsManager.getText ("inDevelopingTitle"), textsManager.getText ("inDevelopingText"));
                    break;
                case btnTraining:
                    screenId = ScreenManager.TRAINING_SCREEN;
                    break;
                case btnBattle:
                    screenId = ScreenManager.BATTLE_LIST;
                    if (tutorialManager.currentStep == TutorialStep.BATTLE_OPEN) {
                        tutorialManager.completeStep (TutorialStep.BATTLE_OPEN);
                    }
                    break;
                case btnDressingRoom:
                    if (tutorialManager.currentStep == TutorialStep.DRESS_ROOM_OPEN) {
                        tutorialManager.completeStep (TutorialStep.DRESS_ROOM_OPEN);
                    }
                    screenId = ScreenManager.DRESS_ROOM_SCREEN;
                    break;
                case btnShop:
                    screenId = ScreenManager.SHOP_SCREEN;
                    if (tutorialManager.currentStep == TutorialStep.SHOP_OPEN) {
                        tutorialManager.completeStep (TutorialStep.SHOP_OPEN);
                    }
                    break;
                case btnWork:
//                    screenId = ScreenManager.WORKS_SCREEN;
                    PopUpManager.instance.infoPopUp.showMessage (textsManager.getText ("inDevelopingTitle"), textsManager.getText ("inDevelopingText"));
                    break;
                case btnLearnMoves:
                    screenId = ScreenManager.DANCE_MOVES_SCREEN;
                    if (tutorialManager.currentStep == TutorialStep.TRAINING_OPEN) {
                        tutorialManager.completeStep (TutorialStep.TRAINING_OPEN);
                    }
                    break;
            }
            if (screenId) {
//                CONFIG::mixpanel {
//                    BreakdanceApp.mixpanel.track(
//                            'bottom menu',
//                            {'click':screenId}
//                    );
//                }
                ScreenManager.instance.navigateTo (screenId);
            }
        }

        private function clickListener (event:MouseEvent):void {
            if (!appUser.installed) {
                if (event.currentTarget != btnSettings) {
                    return;
                }
            }
            switch (event.currentTarget) {
                case btnFriends:
                    mcToggle.gotoAndStop (TOGGLE_FRIENDS_FRAME);
                    chatPanel.visible = false;
                    friendsList.visible = true;
                    break;
                case btnTeam:
                    mcToggle.gotoAndStop (TOGGLE_TEAM_FRAME);
                    trace ("click btnTeam");
                    chatPanel.visible = false;
                    friendsList.visible = true;
                    break;
                case btnChat:
                    mcToggle.gotoAndStop (TOGGLE_CHAT_FRAME);
                    chatPanel.visible = true;
                    friendsList.visible = false;
                    break;
                case btnScreenShot:
                    popUpManager.savePhotoPopUp.show ();
                    break;
                case btnSettings:
					var playerMusicPopUp:PlayerMusicPopUp = PopUpManager.instance.playerMusicPopUp;			
					if (playerMusicPopUp.isShowed) {
						playerMusicPopUp.hide ();
					}
					else {						
						playerMusicPopUp.show()
					}
			/*
                    var settingsPanel:SettingsPanel = BreakdanceApp.instance.settingsPanel;
                    if (settingsPanel.isShowed) {
                        settingsPanel.hide ();
                    }
                    else {
                        settingsPanel.show ();
                    }
					*/
                    break;
                case btnEditCharacter:
                    popUpManager.editCharacterPopUp.show ();
                    break;
                case btnNews:
                    popUpManager.newsPopUp.show ();
                    break;
            }
        }

        private function onInviteFriend (response:JsQueryResult):void {
            //
        }

        private function rollOverListener (event:MouseEvent):void {
            var orientation:String = TooltipOrientation.BOTTOM;
            var tooltipText:String;
            var btn:Button = Button (event.currentTarget);
            var positionPoint:Point = getTooltipPositionForMainMenuButton (btn);
            switch (event.currentTarget) {
                case (btnBattle):
                    tooltipText = textsManager.getText ("ttBattle");
                    break;
                case (btnAchievements):
                    tooltipText = textsManager.getText ("ttAchievements");
                    break;
                case (btnRating):
                    tooltipText = textsManager.getText ("ttRating");
                    break;
                case (btnTraining):
                    tooltipText = textsManager.getText ("ttTraining");
                    break;
                case (btnLearnMoves):
                    tooltipText = textsManager.getText ("ttLearnMoves");
                    break;
                case (btnShop):
                    tooltipText = textsManager.getText ("ttShop");
                    break;
                case (btnDressingRoom):
                    tooltipText = textsManager.getText ("ttDressingRoom");
                    break;
                case (btnWork):
                    tooltipText = textsManager.getText ("ttWork");
                    break;
                case (btnScreenShot):
                    tooltipText = textsManager.getText ("ttScreenShot");
                    positionPoint = getTooltipPositionForButton (btn, btn.height);
                    break;
                case (btnSettings):
                    tooltipText = textsManager.getText ("ttSettings");
                    positionPoint = getTooltipPositionForButton (btn, btn.height);
                    break;
                case (btnEditCharacter):
                    tooltipText = textsManager.getText ("ttEditCharacter");
                    positionPoint = getTooltipPositionForButton (btn, 0);
                    orientation = TooltipOrientation.TOP;
                    break;
                case (btnNews):
                    var newsText:String = textsManager.getText ("ttNews");
                    var newData:NewData = appUser.getUnreadNewData ();
                    if (newData) {
                        newsText += "[" + newData.text + "]";
                    }
                    else {
                        var news:Vector.<NewData> = NewDataCollection.instance.enabledList;
                        if (news.length > 0) {
                            newsText += "[" + news [0].text + "]";
                        }
                    }
                    positionPoint = getTooltipPositionForButton (btn, 0);
                    tooltipText = newsText;
                    orientation = TooltipOrientation.TOP;
                    break;
            }
            if (tooltipText) {
                BreakdanceApp.instance.showTooltipMessage (tooltipText, positionPoint, false, orientation);
            }
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }

        private function navigateToListener (event:ScreenManagerEvent):void {
            var iconsVisible:Boolean = false;
            switch (event.screenId) {
                case (ScreenManager.BATTLE_LIST):
                case (ScreenManager.BATTLE_SCREEN):
                    if (!btnBattle.pushed) {
                        pushButton (btnBattle);
                    }
                    break;
                case (ScreenManager.ACHIEVEMENTS_SCREEN):
                    pushButton (btnAchievements);
                    break;
                case (ScreenManager.HOME_SCREEN):
                    unPushButtons ();
                    iconsVisible = true;
                    break;
                case (ScreenManager.DANCE_MOVES_SCREEN):
                    pushButton (btnLearnMoves);
                    break;
                case (ScreenManager.DRESS_ROOM_SCREEN):
                    pushButton (btnDressingRoom);
                    break;
                case (ScreenManager.RATING_SCREEN):
                    pushButton (btnRating);
                    break;
                case (ScreenManager.SHOP_SCREEN):
                    pushButton (btnShop);
                    break;
                case (ScreenManager.TRAINING_SCREEN):
                    pushButton (btnTraining);
                    break;
                case (ScreenManager.WORKS_SCREEN):
                    pushButton (btnWork);
                    break;
                default:
//                    unPushButtons ();
            }
            setMainMenuButtonsIconsVisible (iconsVisible);
        }

        private function changeUserListener (event:ChangeUserEvent):void {
            var newItems:Vector.<String> = BreakdanceApp.instance.appUser.newItems;
            btnShop.newItemsSelection = (newItems && newItems.length > 0);
			btnAchievements.setPercents (BreakdanceApp.instance.appUser.countAchievementsDone);            
            if (appUser.hasUnReadNews) {
                btnNews.showNews ();
            }
            else {
                btnNews.hideNews ();
            }
        }

    }
}