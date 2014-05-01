/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 16.10.13
 * Time: 9:59
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.battle.data.BattleData;
    import breakdance.battle.data.BattlePlayerData;
    import breakdance.socketServer.SocketServerManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.BattlePlayerAvatarContainer;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;

    import flash.display.MovieClip;
    import flash.text.TextField;

    public class InvitePopUp extends TwoTextButtonsPopUp {

        protected var _battleData:BattleData;

        private var tfPlayerName1:TextField;
        private var tfPlayerName2:TextField;
        private var mcStaminaBarPlayer1:MovieClip;
        private var mcStaminaBarPlayer2:MovieClip;
        private var tfStaminaPlayer1:TextField;
        private var tfStaminaPlayer2:TextField;
        private var tfTurnsTitle:TextField;
        private var tfTurns:TextField;
        private var tfBetTitle:TextField;
        private var tfBet:TextField;

        private var avatarContainer1:BattlePlayerAvatarContainer;
        private var avatarContainer2:BattlePlayerAvatarContainer;

        public function InvitePopUp () {
            super (Template.createSymbol (Template.INVITE_BATTLE_POPUP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            tf.htmlText = textsManager.getText ("vs");
            tfTitle.htmlText = textsManager.getText ("acceptInvitation");
            tfTurnsTitle.htmlText = textsManager.getText ("turns");
            tfBetTitle.htmlText = textsManager.getText ("bet");
            btn1.text = textsManager.getText ("accept");
            btn2.text = textsManager.getText ("reject");
        }

        public function showBattleData (battleData:BattleData):void {
            if (battleData) {
                tfTurns.htmlText = "<b>" + String (battleData.turns) + "</b>";
                tfBet.htmlText = "<b>" + String (battleData.bet) + "</b>";
                setBattlePlayerData1 (battleData.player1);
                setBattlePlayerData2 (battleData.player2);
            }
            _battleData = battleData;
            show ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            tfPlayerName1 = getElement ("tfPlayerName1");
            tfPlayerName2 = getElement ("tfPlayerName2");
            mcStaminaBarPlayer1 = getElement ("mcStaminaBarPlayer1");
            mcStaminaBarPlayer2 = getElement ("mcStaminaBarPlayer2");
            avatarContainer1 = new BattlePlayerAvatarContainer (mc ["mcAvatarContainer1"]);
            avatarContainer2 = new BattlePlayerAvatarContainer (mc ["mcAvatarContainer2"]);
            tfStaminaPlayer1 = getElement ("tf", mcStaminaBarPlayer1);
            tfStaminaPlayer2 = getElement ("tf", mcStaminaBarPlayer2);
            tfTurnsTitle = getElement ("tfTurnsTitle");
            tfTurns = getElement ("tfTurns");
            tfBetTitle = getElement ("tfBetTitle");
            tfBet = getElement ("tfBet");
        }

        override protected function onClickSecondButton ():void {
            cancelBattle ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setBattlePlayerData1 (battlePlayerData:BattlePlayerData):void {
            if (battlePlayerData) {
                avatarContainer1.visible = true;
                avatarContainer1.initByPlayerData (battlePlayerData);
                tfPlayerName1.text = battlePlayerData.nickname;
                tfStaminaPlayer1.text = battlePlayerData.stamina + "/" + battlePlayerData.maxStamina;
                var percent:int = battlePlayerData.stamina / battlePlayerData.maxStamina * 100;
                mcStaminaBarPlayer1.gotoAndStop (percent);
            }
            else {
                avatarContainer1.visible = false;
                tfPlayerName1.text = "";
                tfStaminaPlayer1.text = "";
                mcStaminaBarPlayer1.gotoAndStop (1);
            }
        }

        private function setBattlePlayerData2 (battlePlayerData:BattlePlayerData):void {
            if (battlePlayerData) {
                avatarContainer2.visible = true;
                avatarContainer2.initByPlayerData (battlePlayerData);
                tfPlayerName2.text = battlePlayerData.nickname;
                tfStaminaPlayer2.text = battlePlayerData.stamina + "/" + battlePlayerData.maxStamina;
                var percent:int = battlePlayerData.stamina / battlePlayerData.maxStamina * 100;
                mcStaminaBarPlayer2.gotoAndStop (percent);
            }
            else {
                avatarContainer2.visible = false;
                tfPlayerName2.text = "";
                tfStaminaPlayer2.text = "";
                mcStaminaBarPlayer2.gotoAndStop (0);
            }
        }

        protected function cancelBattle ():void {
            if (_battleData) {
                var opponentId:String = _battleData.opponentId;
                if (opponentId) {
                    SocketServerManager.instance.cancelBattle (opponentId);
                }
                _battleData = null;
            }
            hide ();
        }

    }
}