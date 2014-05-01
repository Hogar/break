/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.09.13
 * Time: 8:42
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view {

    import breakdance.BreakdanceApp;
    import breakdance.battle.controller.IBattleController;
    import breakdance.battle.events.ChangeBattlePlayerChipsEvent;
    import breakdance.battle.events.ChangeBattlePlayerStaminaEvent;
    import breakdance.battle.events.ProcessBattleDanceMoveEvent;
    import breakdance.battle.model.BattleDanceMove;
    import breakdance.battle.view.logPanel.UserBattleLogPanel;
    import breakdance.core.server.ServerApi;
    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;

    /**
     * Элемент, управляющий отображением данных игрока батла, для пользователя игры.
     */
    public class UserBattlePlayerView extends BattlePlayerView {

        private var payerLogPanel:UserBattleLogPanel;

        private var _controller:IBattleController;//Ссылка на контроллер боя.

        public function UserBattlePlayerView (infoTemplate:Sprite, mcAvatarContainer:MovieClip, tfPlayerName:TextField, logTemplate:MovieClip, roundsIndicatorContainer:MovieClip) {
            super (infoTemplate, mcAvatarContainer, tfPlayerName, logTemplate, roundsIndicatorContainer);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get controller ():IBattleController {
            return _controller;
        }

        public function set controller (value:IBattleController):void {
            _controller = value;
            payerLogPanel.controller = _controller;
        }


/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function createLogPanel (logTemplate:MovieClip):void {
            payerLogPanel = new UserBattleLogPanel (logTemplate);
            logPanel = payerLogPanel;
        }

        override protected function setStamina (stamina:int, maxStamina:int):void {
            BreakdanceApp.instance.appDispatcher.dispatchEvent (new ChangeBattlePlayerStaminaEvent (stamina, stamina));
            super.setStamina (stamina, maxStamina);
        }

        override protected function changeBattlePlayerChipsListener (event:ChangeBattlePlayerChipsEvent):void {
            super.changeBattlePlayerChipsListener (event);
            var chips:int = event.currentChips - event.previousChips;
            if (chips < 0) {
                ServerApi.instance.query (ServerApi.TAKE_CHIPS, {}, onTakeChips);
            }
        }

        private function onTakeChips (response:Object):void {
            BreakdanceApp.instance.appUser.onResponseWithUpdateUserData (response);
        }

        override protected function changeBattlePlayerStaminaListener (event:ChangeBattlePlayerStaminaEvent):void {
            super.changeBattlePlayerStaminaListener (event);
            var stamina:int = event.previousStamina - event.currentStamina;
            if (stamina > 0) {
                ServerApi.instance.query (ServerApi.TAKE_STAMINA, {stamina: stamina}, onTakeStamina);
            }
        }

        private function onTakeStamina (response:Object):void {
            BreakdanceApp.instance.appUser.onResponseWithUpdateUserData (response);
        }

    }
}
