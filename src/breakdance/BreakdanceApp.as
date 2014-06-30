package breakdance {

    import breakdance.battle.BattleManager;
    import breakdance.battle.view.BattleScreen;
    import breakdance.core.js.JsApi;
    import breakdance.core.sound.SoundManager;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.tasks.AsyncInitTask;
    import breakdance.core.tasks.SimpleTask;
    import breakdance.core.tasks.TaskEvent;
    import breakdance.core.tasks.TaskStack;
    import breakdance.core.ui.Screen;
    import breakdance.core.ui.overlay.OverlayManager;
    import breakdance.data.awards.AwardCollection;
    import breakdance.data.bucksOffers.BucksOffersCollection;
    import breakdance.data.collections.CollectionTypeCollection;
    import breakdance.data.consumables.ConsumableCollection;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;
    import breakdance.data.news.NewDataCollection;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.data.sounds.SoundsDataCollection;
    import breakdance.data.video.VideoCollection;
	import breakdance.data.achievements.AchievementCollection;
    import breakdance.socketServer.SocketServerManager;
    import breakdance.template.TemplateDefault;
    import breakdance.ui.AppBackground;
    import breakdance.ui.commons.InfoMessage;
    import breakdance.ui.commons.tooltip.Tooltip;
	import breakdance.ui.commons.tooltip.Tooltip2;
    import breakdance.ui.commons.tooltip.TooltipData;
    import breakdance.ui.commons.tooltip.TooltipOrientation;
    import breakdance.ui.panels.bottomPanel.BottomPanel;
    //import breakdance.ui.panels.settingsPanel.SettingsPanel;
    import breakdance.ui.panels.topPanel.TopPanel;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.popups.pvpLogPanel.PvpLogPanelPopUp;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.ui.screenManager.events.ScreenManagerEvent;
    import breakdance.ui.screens.homeScreen.HomeScreen;
    import breakdance.user.AppUser;
    import breakdance.user.UserInfoLoader;
    import breakdance.user.UserLevelCollection;
	import breakdance.data.playerMusic.GroupCollection;

    import com.hogargames.debug.Tracer;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.geom.Point;
    import flash.ui.Keyboard;

    CONFIG::mixpanel {
        import com.mixpanel.Mixpanel;
    }

    public class BreakdanceApp extends Sprite {

        CONFIG::mixpanel {
            public static var mixpanel:Mixpanel;
        }

        public var appDispatcher:EventDispatcher = new EventDispatcher ();

        public var background:AppBackground;
        public var topPanel:TopPanel;
        public var friendsPanel:BottomPanel;
        //public var settingsPanel:SettingsPanel;

        private var homeScreen:HomeScreen;
        private var battleScreen:BattleScreen;

        public var currentScreen:Screen;

        private var tooltip:Tooltip;
		private var tooltipSong:Tooltip2;

        private var infoMessageContainer:Sprite;

        private var _flashVars:Object;

        private var _initTaskStack:TaskStack;

        private var _initCompleteCallback:Function;
        private var _initErrorCallback:Function;
        private var _initProgressCallback:Function;

        private var _appUser:AppUser;
        public var currentFriendAppUser:AppUser;

        private static var _instance:BreakdanceApp;

        public function BreakdanceApp (flashVars:Object) {
            _instance = this;

            _flashVars = flashVars;

            JsApi.instance;

            if (stage) {
                addedToStageListener (null);
            }
            else {
                addEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
            }

            CONFIG::mixpanel {
                mixpanel = new Mixpanel (GlobalConstants.MIX_PANEL_TOKEN);
            }
        }

        public static function get instance ():BreakdanceApp {
            return _instance;
        }


        public function get appUser ():AppUser {
            if (!_appUser) {
                _appUser = new AppUser ();
            }
            return _appUser;
        }

        public function init (initCompleteCallback:Function, initErrorCallback:Function, initProgressCallback:Function):void {
            _initCompleteCallback = initCompleteCallback;
            _initErrorCallback = initErrorCallback;
            _initProgressCallback = initProgressCallback;

            _initTaskStack = new TaskStack ();
            _initTaskStack.addEventListener (TaskEvent.TASK_COMPLETE, onInitComplete);
            _initTaskStack.addEventListener (TaskEvent.TASK_ERROR, onInitError);
            _initTaskStack.addEventListener (TaskEvent.TASK_PROGRESS, onInitProgress);

            // Стартовые задачи
            //_initTaskStack.addTask(new DummyTask());
            _initTaskStack.addTask (new AsyncInitTask (StaticData.instance));
            _initTaskStack.addTask (new AsyncInitTask (TemplateDefault.instance));
            _initTaskStack.addTask (new SimpleTask (DanceMoveTypeCollection.instance.initCategories));
            _initTaskStack.addTask (new SimpleTask (DanceMoveTypeCollection.instance.init));
            _initTaskStack.addTask (new AsyncInitTask (VideoCollection.instance));
            _initTaskStack.addTask (new SimpleTask (UserLevelCollection.instance.init));
            _initTaskStack.addTask (new SimpleTask (ShopItemCollection.instance.init));
            _initTaskStack.addTask (new SimpleTask (AwardCollection.instance.init));
			_initTaskStack.addTask (new SimpleTask (AchievementCollection.instance.init));
            _initTaskStack.addTask (new SimpleTask (SoundsDataCollection.instance.init));
            _initTaskStack.addTask (new SimpleTask (BucksOffersCollection.instance.init));
            _initTaskStack.addTask (new SimpleTask (ConsumableCollection.instance.init));
            _initTaskStack.addTask (new SimpleTask (CollectionTypeCollection.instance.init));
            _initTaskStack.addTask (new SimpleTask (NewDataCollection.instance.init));
			_initTaskStack.addTask (new SimpleTask (GroupCollection.instance.init));
            _initTaskStack.addTask (new AsyncInitTask (new UserInfoLoader ()));

            _initTaskStack.start ();

        }

        public function get flashVars ():Object {
            return _flashVars;
        }

        public function showTooltip (tooltipData:TooltipData, positionPoint:Point = null):void {
            tooltip.showTextAndPosition (tooltipData, positionPoint);
        }

        public function showTooltipMessage (message:String, positionPoint:Point = null, noAnimation:Boolean = false, orientation:String = TooltipOrientation.BOTTOM):void {
            tooltip.showTextAndPosition (new TooltipData (message), positionPoint, noAnimation, orientation);
        }

        public function hideTooltip ():void {
            tooltip.hide ();
        }

	    public function showTooltipMessageSong (message:String, positionPoint:Point = null, noAnimation:Boolean = false, orientation:String = TooltipOrientation.BOTTOM, timeHide:Number = 0):void {			
            tooltipSong.showTextAndPosition (message, positionPoint, noAnimation, orientation, timeHide);			
        }

        public function hideTooltipSong ():void {
            tooltipSong.hide ();
        }
		
        public function showInfoMessage (text:String, positionPoint:Point):void {
            var infoMessage:InfoMessage = new InfoMessage (text);
            infoMessage.x = positionPoint.x;
            infoMessage.y = positionPoint.y;
            infoMessageContainer.addChild (infoMessage);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function onInitComplete (e:TaskEvent):void {
            OverlayManager.instance.init ();

            topPanel = new TopPanel ();
            OverlayManager.instance.addOverlay (topPanel, OverlayManager.UI_PRIORITY);

            friendsPanel = new BottomPanel ();
            OverlayManager.instance.addOverlay (friendsPanel, OverlayManager.UI_PRIORITY);

            //settingsPanel = new SettingsPanel ();
            //OverlayManager.instance.addOverlay (settingsPanel, OverlayManager.SETTINGS_LAYER_PRIORITY);

            background = new AppBackground ();
            addChild (background);

            homeScreen = new HomeScreen ();
            battleScreen = new BattleScreen ();

            tooltip = new Tooltip ();
			tooltipSong = new Tooltip2 ();
			
            OverlayManager.instance.addOverlay (tooltip, OverlayManager.TOOLTIP_LAYER_PRIORITY);
			OverlayManager.instance.addOverlay (tooltipSong, OverlayManager.TOOLTIP_LAYER_PRIORITY_MUSICK);
			
            infoMessageContainer = new Sprite ();
            OverlayManager.instance.addOverlay (infoMessageContainer, OverlayManager.TOOLTIP_LAYER_PRIORITY);

            gotoScreen (homeScreen);

//            SoundManager.instance.playMusic (Template.SND_MAIN_THEME);
            SoundManager.instance.playRadio ();

            if (_initCompleteCallback != null) {
                _initCompleteCallback ();
            }

            ScreenManager.instance.addEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
            BattleManager.instance.setBattleScreen (battleScreen);
            SocketServerManager.instance.connect ();

            if (appUser.hasUnReadNews) {
                PopUpManager.instance.newsPopUp.show ();
            }
		
        }

        private function gotoScreen (screen:Screen):void {
            //if (currentScreen == screen)
            //	return;

            if (currentScreen) {
                currentScreen.onHide ();
                OverlayManager.instance.removeOverlay (currentScreen);
            }

            currentScreen = screen;

            if (currentScreen) {
                OverlayManager.instance.addOverlay (screen, OverlayManager.SCREEN_PRIORITY);
                currentScreen.onShow ();
            }
        }

        private function onInitError (e:TaskEvent):void {
            if (_initErrorCallback != null) {
                _initErrorCallback (e.message);
            }
        }

        private function onInitProgress (e:TaskEvent):void {
            if (_initProgressCallback != null) {
                _initProgressCallback (e.ratio);
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////



        private function addedToStageListener (event:Event):void {
            OverlayManager.instance.init ();
            removeEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
            stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDownListener);
        }

        private function keyDownListener (event:KeyboardEvent):void {
            if (event.ctrlKey) {
                if (event.keyCode == Keyboard.D) {
                    PopUpManager.instance.deleteUserPopUp.show ();
                }
                else if (event.keyCode == Keyboard.B) {
                    PopUpManager.instance.beatStreetShopPopUp.show ();
                }
                else if (event.keyCode == Keyboard.NUMBER_5) {
                    PopUpManager.instance.fiveStepsPopUp.show ();
                }
                else if (event.keyCode == Keyboard.G) {
                    PopUpManager.instance.newsPopUp.show ();
                }

                CONFIG::debug {
                    if (event.keyCode == Keyboard.NUMBER_0) {
                        GlobalVariables.noMasteryPoints = !GlobalVariables.noMasteryPoints;
                        Tracer.log ("noMasteryPoints = " + GlobalVariables.noMasteryPoints)
                    }
                    else if (event.keyCode == Keyboard.SPACE) {
                        var pvpLogPanelPopUp:PvpLogPanelPopUp = PopUpManager.instance.pvpLogPanelPopUp;
                        if (pvpLogPanelPopUp.isShowed) {
                            pvpLogPanelPopUp.hide ();
                        }
                        else {
                            pvpLogPanelPopUp.show ();
                        }
                    }
                }
            }
        }


        private function navigateToListener (event:ScreenManagerEvent):void {
            if (event.screenId == ScreenManager.BATTLE_SCREEN) {
                gotoScreen (battleScreen);
            }
            else {
                gotoScreen (homeScreen);
            }
        }

    }
}
