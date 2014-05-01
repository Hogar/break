/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.07.13
 * Time: 23:05
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.battleListPopUp {

    import breakdance.BreakdanceApp;
    import breakdance.battle.BattleManager;
    import breakdance.battle.ai.BattlePlayerGenerator;
    import breakdance.battle.data.BattleData;
    import breakdance.battle.data.BattlePlayerData;
    import breakdance.core.ui.events.ScreenEvent;
    import breakdance.socketServer.SocketServerManager;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.commons.AvatarContainer;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.popups.basePopUps.TitleClosingPopUp;
    import breakdance.ui.popups.battleListPopUp.events.SelectBattleEvent;
    import breakdance.user.AppUser;

    import com.hogargames.debug.Tracer;

    import flash.events.Event;

    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class BattleListPopUp extends TitleClosingPopUp {

        private var battleList:BattlesList;

        private var avatarContainer:AvatarContainer;
        private var tfName:TextField;
        private var tfLevel:TextField;
        private var tfTurnsTitle:TextField;
        private var tfBetTitle:TextField;

        private var btnReadyToBattle:ButtonWithText;
        private var battleSettingsPanel:BattleSettingsPanel;
        private var localBattleData:BattleData;//Данные о локальной битве (АИ).
        private var tutorialManager:TutorialManager;

        private var appUser:AppUser;

        private static const FIRST_BATTLE_NUM_ROUNDS:int = 2;
        private static const FIRST_BATTLE_BET:int = 50;

        public function BattleListPopUp () {
            tutorialManager = TutorialManager.instance;
            appUser = BreakdanceApp.instance.appUser;
            super (Template.createSymbol(Template.BATTLE_LIST_POPUP));
            Tracer.log ("BattleListPopUp. connected = " + SocketServerManager.instance.connected);
            if (SocketServerManager.instance.connected) {
                sendChallenge ();
            }
            else {
                SocketServerManager.instance.addEventListener (Event.CONNECT, connectListener)
            }
        }

        private function connectListener (event:Event):void {
            Tracer.log ("connectListener");
            sendChallenge ();
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function init (battles:Vector.<BattleData>, withClear:Boolean = false):void {
//            Tracer.log ("Инициализируем список битв. length = " + battles.length);
//            var i:int = 0;
//            for (i = 0; i < battles.length; i++) {
//                trace (battles [i].toString ());
//            }
//            battles.sort (sortBattles);
//            for (i = 0; i < battles.length; i++) {
//                trace (battles [i].toString ());
//            }
            battleList.init (battles, localBattleData, withClear);
        }

        override public function show ():void {
            super.show ();
            if (tutorialManager.currentStep == TutorialStep.BATTLE_SELECT) {
                localBattleData = new BattleData ();
                localBattleData.bet = FIRST_BATTLE_BET;
                localBattleData.turns = FIRST_BATTLE_NUM_ROUNDS;
                localBattleData.player1 = BattlePlayerGenerator.createBattleOpponentForFirstBattle ();
            }
            else {
                localBattleData = new BattleData ();
//                localBattleData.bet = Math.ceil (Math.random () * 2) * 50;
                localBattleData.bet = 0;
                localBattleData.turns = 1 + Math.round (Math.random () * 2);
                localBattleData.player1 = BattlePlayerGenerator.createFakeBattleOpponentForAppUser ();
                var userNoAppFriendsUids:Vector.<String> = appUser.userNoAppFriendsUids;
                if (userNoAppFriendsUids.length > 0) {
                    localBattleData.player1.name = userNoAppFriendsUids [Math.round (Math.random () * (userNoAppFriendsUids.length - 1))];
                    localBattleData.player1.nickname = userNoAppFriendsUids [Math.round (Math.random () * (userNoAppFriendsUids.length - 1))];
                }
                else {
                    localBattleData.player1.name = textsManager.getText ("aiBattlePlayerDefaultName");
                    localBattleData.player1.nickname = textsManager.getText ("aiBattlePlayerDefaultName");
                }
            }

            var battlePlayerData:BattlePlayerData;

            battlePlayerData = appUser.asBattlePlayerData ();

            btnReadyToBattle.selected = true;
            battleSettingsPanel.enabled = false;

            avatarContainer.initByPlayerData (battlePlayerData);

            init (new Vector.<BattleData> (), true);

//            sendChallenge ();
            SocketServerManager.instance.getChallenges ();

            battleSettingsPanel.bet = appUser.lastBet;
            battleSettingsPanel.turns = appUser.lastTurns;
        }

        override public function hide ():void {
//            cancelChallenge ();
            super.hide ();
        }

        override public function setTexts ():void {
            tfTitle.text = textsManager.getText ("battles");
            tfName.text = appUser.nickname;
            tfLevel.text = appUser.level + " " + textsManager.getText ("level");
            tfTurnsTitle.text = textsManager.getText ("turns");
            tfBetTitle.text = textsManager.getText ("bet");
            btnReadyToBattle.text = textsManager.getText ("readyToBattle");
        }

        override public function destroy ():void {
            if (btnReadyToBattle) {
                btnReadyToBattle.addEventListener (MouseEvent.CLICK, clickListener);
                btnReadyToBattle.destroy ();
                btnReadyToBattle = null;
            }
            if (avatarContainer) {
                avatarContainer.destroy ();
                avatarContainer = null;
            }
            if (battleSettingsPanel) {
                battleSettingsPanel.destroy ();
                battleSettingsPanel = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            battleList = new BattlesList (mc ["mcBattleList"]);
            battleList.addEventListener (SelectBattleEvent.SELECT_BATTLE, selectBattleListener);
            avatarContainer = new AvatarContainer (mc ["mcAvatarContainer"]);

            tfName = getElement ("tfName");
            tfLevel = getElement ("tfLevel");
            tfTurnsTitle = getElement ("tfTurnsTitle");
            tfBetTitle = getElement ("tfBetTitle");

            btnReadyToBattle = new ButtonWithText (mc ["btnReadyToBattle"], false);

            battleSettingsPanel = new BattleSettingsPanel (mc ["mcBattleSettingsPanel"]);
            battleSettingsPanel.setDefault ();

            btnReadyToBattle.addEventListener (MouseEvent.CLICK, clickListener);
        }

        override protected function onClickCloseButton ():void {
            dispatchEvent (new ScreenEvent (ScreenEvent.HIDE_SCREEN));
            super.onClickCloseButton ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private static function sortBattles (battle1:BattleData, battle2:BattleData):Number {
            if (battle1.bet > battle2.bet) {
                return -1;
            }
            else if (battle1.bet < battle2.bet) {
                return 1;
            }
            else {
                var player1:BattlePlayerData = battle1.player1;
                var player2:BattlePlayerData = battle2.player1;
                if (player1 && player2) {
                    if (player1.nickname > player2.nickname) {
                        trace (player1.nickname + " > " + player2.nickname);
                        return 1;
                    }
                    else if (player1.nickname < player2.nickname) {
                        trace (player1.nickname + " < " + player2.nickname);
                        return -1;
                    }
                    else {
                        return 0;
                    }
                }
                else {
                    return 0;
                }
            }
        }

        private function sendChallenge ():void {
            Tracer.log ("sendChallenge");
            var battleData:BattleData = new BattleData ();
            battleData.bet = battleSettingsPanel.bet;
            battleData.turns = battleSettingsPanel.turns;
            battleData.player1 = appUser.asBattlePlayerData ();
            SocketServerManager.instance.sendChallenge (battleData);
        }

        private function cancelChallenge ():void {
            SocketServerManager.instance.cancelChallenge ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            btnReadyToBattle.selected = !btnReadyToBattle.selected;
            battleSettingsPanel.enabled = !btnReadyToBattle.selected;
            if (btnReadyToBattle.selected) {
                appUser.lastBet = battleSettingsPanel.bet;
                appUser.lastTurns = battleSettingsPanel.turns;
                appUser.saveUserSettings ();
                sendChallenge ();
            }
            else {
                cancelChallenge ();
            }
        }

        private function selectBattleListener (event:SelectBattleEvent):void {
            var battleData:BattleData = event.battleData;
            battleData.player2 = appUser.asBattlePlayerData ();//Игрок 1 в отсылаемом инвайте всегда противник!
            if (battleData) {
                if (battleData == localBattleData) {
                    if (tutorialManager.currentStep == TutorialStep.BATTLE_SELECT) {
                        tutorialManager.completeStep (TutorialStep.BATTLE_SELECT);
                    }
                    BattleManager.instance.createLocalBattle (battleData);
                }
                else {
                    PopUpManager.instance.sendInvitePopUp.showBattleData (battleData);
                    PopUpManager.instance.sendInvitePopUp.show ();
                    SocketServerManager.instance.sendInvite (battleData);
                }
            }
//            hide ();
        }

    }
}
