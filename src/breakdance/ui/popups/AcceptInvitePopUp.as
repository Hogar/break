/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 06.09.13
 * Time: 15:39
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.BreakdanceApp;
    import breakdance.battle.data.BattleData;
    import breakdance.battle.data.BattlePlayerData;
    import breakdance.socketServer.SocketServerManager;
    import breakdance.socketServer.events.CancelBattleEvent;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;

    public class AcceptInvitePopUp extends InvitePopUp {

        private var invites:Vector.<BattleData> = new Vector.<BattleData> ();

        public function AcceptInvitePopUp () {

        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
            if (TutorialManager.instance.currentStep == null) {
                super.show ();
            }
            else {
                trace ("Битву мы не показали!");
            }
        }

        override public function destroy ():void {
            SocketServerManager.instance.removeEventListener (CancelBattleEvent.OPPONENT_CANCEL_BATTLE, opponentCancelBattleListener);
        }

        override public function showBattleData (battleData:BattleData):void {
            invites.push (battleData);
            if (!isShowed) {
                showNextInvite ();
            }
        }

        public function clearInvites ():void {
            invites = new Vector.<BattleData> ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function onClickFirstButton ():void {
            if (_battleData) {
                _battleData.player1 = BreakdanceApp.instance.appUser.asBattlePlayerData ();//Игрок 2 в ответе на инвайт всегда противник!
                SocketServerManager.instance.acceptInvite (_battleData);
            }
            hide ();
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            SocketServerManager.instance.addEventListener (CancelBattleEvent.OPPONENT_CANCEL_BATTLE, opponentCancelBattleListener);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function showNextInvite ():void {
            if (invites.length > 0) {
                var battleData:BattleData = invites.shift ();
                super.showBattleData (battleData);
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function opponentCancelBattleListener (event:CancelBattleEvent):void {
            if (_battleData) {
                var opponentData:BattlePlayerData = _battleData.player2;//Игрок 2 в ответе на инвайт всегда противник!
                if (opponentData) {
                    if (opponentData.uid == event.uid) {
                        hide ();
                    }
                }
            }
        }

    }
}