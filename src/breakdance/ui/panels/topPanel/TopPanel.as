package breakdance.ui.panels.topPanel {

    import breakdance.BreakdanceApp;
    import breakdance.battle.BattleManager;
    import breakdance.battle.events.ChangeBattlePlayerStaminaEvent;
    import breakdance.core.Utils;
    import breakdance.core.server.ServerApi;
    import breakdance.core.server.ServerQuery;
    import breakdance.core.server.ServerTime;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.consumables.ConsumableBonusType;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.Button;
    import breakdance.ui.commons.tooltip.TooltipData;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.ui.screenManager.events.ScreenManagerEvent;
    import breakdance.user.AppUser;
    import breakdance.user.UserLevel;
    import breakdance.user.UserLevelCollection;
    import breakdance.user.events.ChangeUserEvent;

    import com.hogargames.display.GraphicStorage;
    import com.hogargames.display.animation.TextFieldCountAnimation;
    import com.hogargames.utils.StringUtilities;
    import com.hogargames.utils.TextFieldUtilities;

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.utils.Timer;

    public class TopPanel extends GraphicStorage implements ITextContainer {

        private var appDispatcher:EventDispatcher;
        private var screenManager:ScreenManager;
        private var battleManager:BattleManager;
        private var popUpManager:PopUpManager;
        private var textsManager:TextsManager = TextsManager.instance;
        private var appUser:AppUser;

        private var tfLevel:TextField;
        private var tfExp:TextField;
        private var tfCoins:TextField;
        private var tfBucks:TextField;
        private var tfСhipsTitle:TextField;
        private var tfСhips:TextField;
        private var tfEnergyTitle:TextField;
        private var tfEnergy:TextField;
        private var tfEnergyMax:TextField;
        private var tfEnergyTime:TextField;
        private var tfStaminaTime:TextField;
        private var tfStaminaTitle:TextField;
        private var tfStamina:TextField;
        private var tfStaminaMax:TextField;

        private var btnAddСhips:Button;
        private var btnAddCoins:Button;
        private var btnAddBucks:Button;
        private var btnAddStamina:Button;
        private var btnBeatStreetShop:Button;

        private var mcLevelProgressBar:MovieClip;
        private var mcEnergyProgressBar:MovieClip;
        private var mcStaminaProgressBar:MovieClip;
        private var mcLevelProgressBarArea:Sprite;
        private var mcNoLessStaminaIcon:Sprite;

        //переменные для анимации счётчиков:
        private var coinsAnimation:TextFieldCountAnimation;
        private var bucksAnimation:TextFieldCountAnimation;

        private var updateTimer:Timer;
        private var updating:Boolean;

        private var showNoLessStaminaTime:Boolean = false;

        private var bucksToChips:int;

        private static const TEXT_INDENT:int = 4;
        private static const NO_LESS_STAMINA_ICON_WIDTH:int = 18;
        private static const NO_LESS_STAMINA_ICON_HEIGHT:int = 46;

        public function TopPanel () {
            bucksToChips = parseInt (StaticData.instance.getSetting ("bucks_to_chips"));
            appDispatcher = BreakdanceApp.instance.appDispatcher;
            screenManager = ScreenManager.instance;
            battleManager = BattleManager.instance;
            popUpManager = PopUpManager.instance;
            appUser = BreakdanceApp.instance.appUser;
            updateTimer = new Timer (500);
            super (Template.createSymbol (Template.TOP_PANEL));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function setTexts ():void {
            tfLevel.text = appUser.level + " " + textsManager.getText("level");
            tfСhipsTitle.htmlText = textsManager.getText("chips");
            tfEnergyTitle.htmlText = textsManager.getText("energy");
            tfEnergyTitle.width = tfEnergyTitle.textWidth + TEXT_INDENT;
            tfEnergy.x = tfEnergyTitle.x + tfEnergyTitle.width;
            tfStaminaTitle.htmlText = textsManager.getText("stamina");
            tfStaminaTitle.width = tfStaminaTitle.textWidth + TEXT_INDENT;
            tfStamina.x = tfStaminaTitle.x + tfStaminaTitle.width;
        }

        override public function destroy ():void {
            destroyButton (btnAddСhips);
            destroyButton (btnAddCoins);
            destroyButton (btnAddBucks);
            destroyButton (btnAddStamina);
            destroyButton (btnBeatStreetShop);

            btnAddСhips = null;
            btnAddCoins = null;
            btnAddBucks = null;
            btnAddStamina = null;
            btnBeatStreetShop = null;

            updateTimer.removeEventListener (TimerEvent.TIMER, timerListener);
            updateTimer.stop ();

            appUser.removeEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);
            screenManager.removeEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
            appDispatcher.removeEventListener (ChangeBattlePlayerStaminaEvent.CHANGE_STAMINA, changeStaminaListener);

            textsManager.removeTextContainer (this);

            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            tfLevel = getElement ('tfLevel');
            tfExp = getElement ('tfExp');
            tfCoins = getElement ('tfCoins');
            tfBucks = getElement ('tfBucks');
            tfСhipsTitle = getElement ('tfСhipsTitle');
            tfСhips = getElement ('tfСhips');
            tfEnergyTitle = getElement ('tfEnergyTitle');
            tfEnergy = getElement ('tfEnergy');
            tfEnergyMax = getElement ('tfEnergyMax');
            tfEnergyTime = getElement ('tfEnergyTime');
            tfStaminaTime = getElement ('tfStaminaTime');
            tfStaminaTitle = getElement ('tfStaminaTitle');
            tfStamina = getElement ('tfStamina');
            tfStaminaMax = getElement ('tfStaminaMax');
            mcNoLessStaminaIcon = getElement ('mcNoLessStaminaIcon');

            coinsAnimation = new TextFieldCountAnimation (tfCoins);
            bucksAnimation = new TextFieldCountAnimation (tfBucks);

            TextFieldUtilities.setBold (tfLevel);
            TextFieldUtilities.setBold (tfСhipsTitle);
            TextFieldUtilities.setBold (tfEnergyTitle);
            TextFieldUtilities.setBold (tfStaminaTitle);
            TextFieldUtilities.setBold (tfCoins);
            TextFieldUtilities.setBold (tfBucks);
            TextFieldUtilities.setBold (tfСhips);
            TextFieldUtilities.setBold (tfEnergy);
            TextFieldUtilities.setBold (tfStamina);

            mcLevelProgressBar = getElement ('mcLevelProgressBar');
            mcEnergyProgressBar = getElement ('mcEnergyProgressBar');
            mcStaminaProgressBar = getElement ('mcStaminaProgressBar');
            mcLevelProgressBarArea = getElement ('mcLevelProgressBarArea');

            btnAddСhips = new Button (mc ["btnAddСhips"]);
            btnAddCoins = new Button (mc ["btnAddCoins"]);
            btnAddBucks = new Button (mc ["btnAddBucks"]);
            btnAddStamina = new Button (mc ["btnAddStamina"]);
            btnBeatStreetShop = new Button (mc ["btnBeatStreetShop"]);

            initButton (btnAddСhips);
            initButton (btnAddCoins);
            initButton (btnAddBucks);
            initButton (btnAddStamina);
            initButton (btnBeatStreetShop);

            mcLevelProgressBarArea.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            mcLevelProgressBarArea.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            mcNoLessStaminaIcon.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            mcNoLessStaminaIcon.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            update ();

            updateTimer.addEventListener (TimerEvent.TIMER, timerListener);
            updateTimer.start ();

            appUser.addEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);

            tfCoins.text = "0";
            tfBucks.text = "0";

            screenManager.addEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
            appDispatcher.addEventListener (ChangeBattlePlayerStaminaEvent.CHANGE_STAMINA, changeStaminaListener);

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function initButton (btn:Button):void {
            if (btn) {
                btn.addEventListener (MouseEvent.CLICK, clickListener);
                btn.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btn.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            }
        }

        private function destroyButton (btn:Button):void {
            if (btn) {
                btn.removeEventListener (MouseEvent.CLICK, clickListener);
                btn.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btn.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btn.destroy ();
            }
        }

        private function getTooltipPositionByObj (obj:DisplayObject):Point {
            var positionPoint:Point = localToGlobal (new Point (obj.x + obj.width / 2, obj.y + obj.height));
            return positionPoint;
        }

        private function setEnergyTime (time:Number):void {
            if (time > 0) {
                tfEnergyTime.visible = true;
                tfEnergyTime.text = Utils.timeToString (time);
            }
            else {
                tfEnergyTime.visible = false;
            }
        }

        private function setStaminaTime (time:Number):void {
            if (time > 0) {
                tfStaminaTime.visible = true;
                tfStaminaTime.text = Utils.timeToString (time);
            }
            else {
                tfStaminaTime.visible = false;
            }
        }

        private function setBonusTime (bonus:int, time:Number):void {
            var tfDailyBonusText:String = textsManager.getText ("dailyBonus");
            tfDailyBonusText = tfDailyBonusText.replace ("#1", bonus);
            tfDailyBonusText = tfDailyBonusText.replace ("#2", Utils.timeToString (time));
            var suffix:String = "";
            if (textsManager.currentLanguage == TextsManager.RU) {
                suffix = StringUtilities.getRussianSuffix1 (bonus);
            }
            if (textsManager.currentLanguage == TextsManager.EN) {
                suffix = StringUtilities.getEnglishSuffixForNumber (bonus);
            }
        }

        private function onUserGet (response:Object):void {
            updating = false;
            appUser.init (response);
        }

        private function getEnergyTimeLeft ():int {
            var timeLeft:int;
            if (appUser.energyUpdateDate && ServerTime.instance.time) {
                timeLeft = appUser.energyUpdateDate.time - ServerTime.instance.time;
            }
            return timeLeft;
        }

        private function getStaminaTimeLeft ():int {
            var timeLeft:int;
            if (appUser.staminaUpdateDate && ServerTime.instance.time) {
                timeLeft = appUser.staminaUpdateDate.time - ServerTime.instance.time;
            }
            return timeLeft;
        }

        private function update ():void {
            if (appUser.installed) {
                var curLevelEnergy:int = 0;
                var currentLevel:UserLevel = UserLevelCollection.instance.getUserLevel (appUser.level);
                var curLevelWins:int = 0;
                if (currentLevel) {
                    curLevelEnergy = currentLevel.energyRequired;
                    curLevelWins = currentLevel.winsRequired;
                }
                var nextLevelEnergy:int = 0;
                var nextLevelWins:int = 0;
                var nextLevel:UserLevel = UserLevelCollection.instance.getUserLevel (appUser.level + 1);
                if (nextLevel) {
                    nextLevelEnergy = nextLevel.energyRequired;
                    nextLevelWins = nextLevel.winsRequired;
                }
                var energySpent:int = Math.max (0, appUser.energySpent - curLevelEnergy);
                energySpent = Math.max (0, appUser.energySpent);
                var energyRequired:int = nextLevelEnergy - curLevelEnergy;
                energyRequired = nextLevelEnergy;
                var energyPercent:int = 0;
                if (energyRequired > 0) {
                    energyPercent = Math.max (Math.min (100, Math.floor ((energySpent / energyRequired) * 100)));
//                    trace ("energyPercent = (energySpent (" + energySpent + ") / energyRequired (" + energyRequired + ") * 100) = " + energyPercent);
                }
                var winsPercent:int = 0;
                var wins:int = Math.max (0, appUser.wins - curLevelWins);
                var winsRequired:int = (nextLevelWins - curLevelWins);
                if (winsRequired > 0) {
                    winsPercent = Math.min (100, Math.floor ((wins / winsRequired) * 100));
//                    trace ("winsPercent = (wins (" + wins + ") / winsRequired (" + winsRequired + ") * 100) = " + winsPercent);
                }
                var percent:int = Math.min (energyPercent, winsPercent);
//                trace ("percent = Math.min (energyPercent (" + energyPercent + "), winsPercent (" + winsPercent + ")) = " + percent);
                tfExp.text = percent + " %";
                mcLevelProgressBar.gotoAndStop (percent);

                var delay:int = (coinsAnimation.currentValue != appUser.coins) ? coinsAnimation.numAnimationFrames : 0;
                coinsAnimation.setValue (appUser.coins);
                bucksAnimation.setValue (appUser.bucks, delay);
                tfСhips.htmlText = String (appUser.chips);

                tfEnergy.htmlText = String (appUser.energy);
                tfEnergyMax.htmlText = String (appUser.energyMax);
                if (appUser.energyMax > 0) {
                    mcEnergyProgressBar.gotoAndStop (Math.floor (100.0 * appUser.energy / appUser.energyMax) + 1);
                }
                else {
                    mcEnergyProgressBar.gotoAndStop (0);
                }

                if (battleManager.hasBattle) {
                    setStaminaTime (0);
                }
                else {
                    tfStamina.htmlText = String (appUser.stamina);
                    if (appUser.staminaMax > 0) {
                        mcStaminaProgressBar.gotoAndStop (Math.floor (100.0 * appUser.stamina / appUser.staminaMax) + 1);
                    }
                    else {
                        mcStaminaProgressBar.gotoAndStop (0);
                    }
                    if (appUser.stamina == appUser.staminaMax) {
                        setStaminaTime (0);
                    }
                    else {
                        var staminaTimeLeft:int = getStaminaTimeLeft ();
                        setStaminaTime (staminaTimeLeft);
                    }
                }

                tfStaminaMax.htmlText = String (appUser.staminaMax);

                if (appUser.energy == appUser.energyMax) {
                    setEnergyTime (0);
                }
                else {
                    var energyTimeLeft:int = getEnergyTimeLeft ();
                    setEnergyTime (energyTimeLeft);
                }
                mcNoLessStaminaIcon.visible = appUser.getConsumableBonusTimeLeft (ConsumableBonusType.NO_LOSS_STAMINA) > 0;
            }
            else {
                coinsAnimation.setValue (0);
                bucksAnimation.setValue (0);
                tfExp.text = "0";
                mcLevelProgressBar.gotoAndStop (1);
                tfСhips.text = "0";
                tfEnergy.text = "0";
                tfEnergyMax.text = "0";
                mcEnergyProgressBar.gotoAndStop (1);
                tfStamina.text = "0";
                tfStaminaMax.text = "0";
                mcStaminaProgressBar.gotoAndStop (1);
                tfExp.text = "";
                setEnergyTime (0);
                setStaminaTime (0);
                mcNoLessStaminaIcon.visible = false;
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function changeUserListener (event:ChangeUserEvent):void {
            update ();
        }

        private function timerListener (event:TimerEvent):void {
            if (showNoLessStaminaTime) {
                var positionPoint:Point = localToGlobal (new Point (mcNoLessStaminaIcon.x + NO_LESS_STAMINA_ICON_WIDTH / 2, mcNoLessStaminaIcon.y + NO_LESS_STAMINA_ICON_HEIGHT));
                BreakdanceApp.instance.showTooltipMessage (Utils.timeToString (appUser.getConsumableBonusTimeLeft (ConsumableBonusType.NO_LOSS_STAMINA)), positionPoint, true);
            }
            if (updating) {
                return;
            }
            else {
                if (appUser.energy == appUser.energyMax) {
                    setEnergyTime (0);
                }
                else {
                    var energyTimeLeft:int = getEnergyTimeLeft ();
                    if (energyTimeLeft < 0) {
                        setEnergyTime (0);
                        updating = true;
                        ServerApi.instance.query (ServerApi.USER_GET, {}, onUserGet);
                    }
                    else {
                        setEnergyTime (energyTimeLeft);
                    }
                }
                if (battleManager.hasBattle) {
                    setStaminaTime (0);
                }
                else {
                    if (appUser.stamina >= appUser.staminaMax) {
                        setStaminaTime (0);
                    }
                    else {
                        var staminaTimeLeft:int = getStaminaTimeLeft ();
                        if (staminaTimeLeft < 0) {
                            setStaminaTime (0);
                            updating = true;
                            ServerApi.instance.query (ServerApi.USER_GET, {}, onUserGet);
                        }
                        else {
                            setStaminaTime (staminaTimeLeft);
                        }
                    }
                }
            }
        }

        private function clickListener (event:MouseEvent):void {
            if (!appUser.installed) {
                return;
            }
            switch (event.currentTarget) {
                case (btnAddСhips):
                    if (appUser.bucks >= bucksToChips) {
                        TransactionOverlay.instance.show ();
                        ServerApi.instance.query (ServerApi.BUY_CHIPS, {bucks:bucksToChips}, onBuyChips);
                    }
                    else {
                        popUpManager.bucksOffersPopUp.show ();
                    }
                    break;
                case (btnAddCoins):
                    popUpManager.bucksToCoinsPopUp.show ();
                    break;
                case (btnAddBucks):
                    popUpManager.bucksOffersPopUp.show ();
                    break;
                case (btnAddStamina):
                    popUpManager.restoreStaminaPopUp.show ();
                    break;
                case (btnBeatStreetShop):
                    popUpManager.beatStreetShopPopUp.show ();
                    break;
            }
        }

        private function onBuyChips (response:Object):void {
            TransactionOverlay.instance.hide ();
            appUser.onResponseWithUpdateUserData (response);
        }

        private function rollOverListener (event:MouseEvent):void {
            var tooltipText:String;
            var positionPoint:Point = getTooltipPositionByObj (DisplayObject (event.currentTarget));
            switch (event.currentTarget) {
                case (mcLevelProgressBarArea):
                    tooltipText = "";
                    var curLevelEnergy:int = 0;
                    var curLevelWins:int = 0;
                    var currentLevel:UserLevel = UserLevelCollection.instance.getUserLevel (appUser.level);
                    if (currentLevel) {
                        curLevelEnergy = currentLevel.energyRequired;
                        curLevelWins = currentLevel.winsRequired;
                    }
                    var nextLevelEnergy:int = 0;
                    var nextLevelWins:int = 0;
                    var nextLevel:UserLevel = UserLevelCollection.instance.getUserLevel (appUser.level + 1);
                    if (nextLevel) {
                        nextLevelEnergy = nextLevel.energyRequired;
                        nextLevelWins = nextLevel.winsRequired;
                    }
                    var energySpent:int = appUser.energySpent;
                    var winsRequired:int = nextLevelWins;
                    if (winsRequired > 0) {
                        tooltipText += textsManager.getText ("wins2") + " " + appUser.wins + "/" + winsRequired;
                    }
                    if (nextLevelEnergy > 0) {
                        if (!StringUtilities.isNotValueString (tooltipText)) {
                            tooltipText += "\n";
                        }
                        tooltipText += textsManager.getText ("energy") + " " + energySpent + "/" + nextLevelEnergy;
                    }
                    break;
                case (btnAddСhips):
                    var addChipsText:String = textsManager.getText ("ttAddChips");
                    BreakdanceApp.instance.showTooltip (new TooltipData (addChipsText, 0, bucksToChips, null, null), positionPoint);
                    break;
                case (btnAddCoins):
                    tooltipText = textsManager.getText ("ttAddCoins");
                    break;
                case (btnAddBucks):
                    tooltipText = textsManager.getText ("ttAddBucks");
                    break;
                case (btnAddStamina):
                    tooltipText = textsManager.getText ("ttAddStamina");
                    break;
                case (btnBeatStreetShop):
                    tooltipText = textsManager.getText ("ttBeatStreetShop");
                    break;
                case (mcNoLessStaminaIcon):
                    tooltipText = Utils.timeToString (appUser.getConsumableBonusTimeLeft (ConsumableBonusType.NO_LOSS_STAMINA));
                    showNoLessStaminaTime = true;
                    break;
            }
            if (tooltipText) {
                BreakdanceApp.instance.showTooltipMessage (tooltipText, positionPoint);
            }
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
            showNoLessStaminaTime = false;
        }

        private function navigateToListener (event:ScreenManagerEvent):void {
            update ();
        }

        private function changeStaminaListener (event:ChangeBattlePlayerStaminaEvent):void {
            var currentStamina:int = event.currentStamina;
            tfStamina.htmlText = String (currentStamina);
            if (appUser.staminaMax > 0) {
                mcStaminaProgressBar.gotoAndStop (Math.floor (100.0 * currentStamina / appUser.staminaMax) + 1);
            }
            else {
                mcStaminaProgressBar.gotoAndStop (0);
            }
        }

    }
}