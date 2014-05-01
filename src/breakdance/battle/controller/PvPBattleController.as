/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.09.13
 * Time: 16:24
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.controller {

    import breakdance.BreakdanceApp;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.model.BattlePlayer;
    import breakdance.battle.model.BattleResultType;
    import breakdance.battle.model.BattleUtils;
    import breakdance.battle.model.UserBattleResultInfo;
    import breakdance.core.server.ServerApi;
    import breakdance.core.texts.TextsManager;
    import breakdance.socketServer.SocketServerManager;
    import breakdance.socketServer.events.CancelBattleEvent;
    import breakdance.socketServer.events.GetOnlineUsersEvent;
    import breakdance.socketServer.events.ReceiveAddingStaminaEvent;
    import breakdance.socketServer.events.ReceiveBattleResultEvent;
    import breakdance.socketServer.events.ReceiveDanceRoutineEvent;
    import breakdance.socketServer.events.ReceiveMarkedDataEvent;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.popups.infoPopUp.IInfoPopUp;
    import breakdance.user.AppUser;

    import com.hogargames.debug.Tracer;

    /**
     * Контроллер для ведения боя PvP.
     */
    public class PvPBattleController extends BattleController {

        private var appUser:AppUser;
        private var socketServerManager:SocketServerManager;

        private var sendingDanceRoutineStorage:Object = {};//Хранилище отправляемых связок.
        private var sendingAdditionalDanceRoutineStorage:Object = {};//Хранилище отправляемых связок для доп.тура.
        // Связка добавляется в модель только после того, как получено сообщение со специальным маркером о получении связки сервером.

        public function PvPBattleController () {
            appUser = BreakdanceApp.instance.appUser;
            socketServerManager = SocketServerManager.instance;
            socketServerManager.addEventListener (ReceiveBattleResultEvent.RECEIVE_BATTLE_RESULT, receiveBattleResultListener);
            socketServerManager.addEventListener (ReceiveMarkedDataEvent.RECEIVE_MARKED_DATA, receiveMarkedDataListener);
            socketServerManager.addEventListener (ReceiveDanceRoutineEvent.RECEIVE_DANCE_ROUTINE, receiveDanceRoutineListener);
            socketServerManager.addEventListener (ReceiveDanceRoutineEvent.RECEIVE_ADDITIONAL_DANCE_ROUTINE, receiveAdditionalDanceRoutineListener);
            socketServerManager.addEventListener (ReceiveAddingStaminaEvent.RECEIVE_ADDING_STAMINA, receiveAddingStaminaEventListener);
            socketServerManager.addEventListener (CancelBattleEvent.OPPONENT_CANCEL_BATTLE, opponentCancelBattleListener);
            socketServerManager.addEventListener (GetOnlineUsersEvent.GET_ONLINE_USERS, getOnlineUsersListener);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        //Оппонент отменил битву.
        public function opponentCancelBattle ():void {
            if (battle) {
                battle.autoWin ();
            }
        }

        override public function timeIsUp ():void {
            //
        }

        /**
         * @inheritDoc
         */
        override public function addDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>, uid:String):void {
            if (appUser.uid == uid) {//Если связку добавляет текущий игрок, то мы отправяем эту связку второму игроку.
                if (battle) {
                    var marker:String = appUser.uid + "_" + new Date ().getTime ();
                    sendingDanceRoutineStorage [marker] = danceRoutine;
                    var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, BreakdanceApp.instance.appUser.uid);
                    socketServerManager.sendDanceRoutine (opponent.uid, danceRoutine, marker);
                }
            }
            else {
                super.addDanceRoutine (danceRoutine, uid);
            }
        }

        /**
         * @inheritDoc
         */
        override public function addAdditionalDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>, uid:String):void {
            if (appUser.uid == uid) {//Если связку добавляет текущий игрок, то мы отправяем эту связку второму игроку.
                if (battle) {
                    var marker:String = appUser.uid + "_" + new Date ().getTime ();
                    sendingAdditionalDanceRoutineStorage [marker] = danceRoutine;
                    var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, BreakdanceApp.instance.appUser.uid);
                    socketServerManager.sendAdditionalDanceRoutine (opponent.uid, danceRoutine, marker);
                }
            }
            else {
                super.addAdditionalDanceRoutine (danceRoutine, uid);
            }
        }

        override public function addStamina (addingStamina:int, uid:String, noLessStamina:Boolean = false, staminaConsumableId:String = ""):void {
            if (appUser.uid == uid) {//Если стамину добавляет текущий игрок, то мы отправяем второму игроку инфу об этом.
                if (battle) {
                    var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, BreakdanceApp.instance.appUser.uid);
                    socketServerManager.sendAddStamina (addingStamina, opponent.uid, noLessStamina, staminaConsumableId);
                }
            }
            super.addStamina (addingStamina, uid, noLessStamina, staminaConsumableId);
        }

        /**
         * @inheritDoc
         */
        override public function get type ():String {
            return ControllerType.PVP;
        }

        override public function destroy ():void {
            socketServerManager.removeEventListener (ReceiveBattleResultEvent.RECEIVE_BATTLE_RESULT, receiveBattleResultListener);
            socketServerManager.removeEventListener (ReceiveMarkedDataEvent.RECEIVE_MARKED_DATA, receiveMarkedDataListener);
            socketServerManager.removeEventListener (ReceiveDanceRoutineEvent.RECEIVE_DANCE_ROUTINE, receiveDanceRoutineListener);
            socketServerManager.removeEventListener (ReceiveDanceRoutineEvent.RECEIVE_ADDITIONAL_DANCE_ROUTINE, receiveAdditionalDanceRoutineListener);
            socketServerManager.removeEventListener (ReceiveAddingStaminaEvent.RECEIVE_ADDING_STAMINA, receiveAddingStaminaEventListener);
            socketServerManager.removeEventListener (CancelBattleEvent.OPPONENT_CANCEL_BATTLE, opponentCancelBattleListener);
            socketServerManager.removeEventListener (GetOnlineUsersEvent.GET_ONLINE_USERS, getOnlineUsersListener);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function receiveBattleResultListener (event:ReceiveBattleResultEvent):void {
            var textsManager:TextsManager = TextsManager.instance;
            if (battle) {
                var userBattleResultInfo:UserBattleResultInfo = battle.userBattleResultInfo;
                var opponentBattleResultInfo:UserBattleResultInfo;
                var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, appUser.uid);
                if (opponent.uid == event.uid) {
                    opponentBattleResultInfo = event.userBattleResultInfo;
                }
                var errorMessage:String;
                var userBattleResultInfoAsString:String = "null";
                if (userBattleResultInfo) {
                    userBattleResultInfoAsString = JSON.stringify (userBattleResultInfo.asData ());
                }
                var opponentBattleResultInfoAsString:String = "null";
                if (opponentBattleResultInfo) {
                    opponentBattleResultInfoAsString = JSON.stringify (opponentBattleResultInfo.asData ());
                }
                Tracer.log ("userBattleResultInfo = " + userBattleResultInfoAsString + "; opponentBattleResultInfo = " + opponentBattleResultInfoAsString);
                if (opponentBattleResultInfo) {
                    if (
                        (opponentBattleResultInfo.battleResult == BattleResultType.WIN) ||
                        (opponentBattleResultInfo.battleResult == BattleResultType.OPPONENT_SURRENDER)
                    )
                    {
                        ServerApi.instance.query (ServerApi.USER_GET, {}, onUserGet);
                    }
                    if (userBattleResultInfo) {
                        if (
                                (
                                        (userBattleResultInfo.battleResult == BattleResultType.WIN) ||
                                        (userBattleResultInfo.battleResult == BattleResultType.OPPONENT_SURRENDER)
                                )
                                        &&
                                (
                                        (opponentBattleResultInfo.battleResult == BattleResultType.WIN) ||
                                        (opponentBattleResultInfo.battleResult == BattleResultType.OPPONENT_SURRENDER)
                                        )
                                ) {
                            errorMessage = textsManager.getText ("asynchronousBattleResultWin");
                        }
                        else if (
                                (
                                        (userBattleResultInfo.battleResult == BattleResultType.LOSE) ||
                                        (userBattleResultInfo.battleResult == BattleResultType.SURRENDER)
                                        )
                                        &&
                                (
                                        (opponentBattleResultInfo.battleResult == BattleResultType.LOSE) ||
                                        (opponentBattleResultInfo.battleResult == BattleResultType.SURRENDER)
                                        )
                                ) {
                            errorMessage = textsManager.getText ("asynchronousBattleResultLose");
                        }
                        else if (
                                (userBattleResultInfo.battleResult == BattleResultType.TIE) &&
                                (opponentBattleResultInfo.battleResult != BattleResultType.TIE)
                                ) {
                            errorMessage = textsManager.getText ("asynchronousBattleResultTie");
                        }
                        else if (
                                (userBattleResultInfo.battleResult != BattleResultType.TIE) &&
                                (opponentBattleResultInfo.battleResult == BattleResultType.TIE)
                                ) {
                            errorMessage = textsManager.getText ("asynchronousBattleResultOpponentTie");
                        }
                        else if (
                                (opponentBattleResultInfo.battleResult != BattleResultType.SURRENDER)
                                        &&
                                (
                                        (userBattleResultInfo.userPoints != opponentBattleResultInfo.opponentPoints) ||
                                        (userBattleResultInfo.opponentPoints != opponentBattleResultInfo.userPoints)
                                        )

                                ) {
                            errorMessage = textsManager.getText ("asynchronousBattleResultPoints");
                            errorMessage = errorMessage.replace ("#1", userBattleResultInfo.userPoints);
                            errorMessage = errorMessage.replace ("#2", userBattleResultInfo.opponentPoints);
                            errorMessage = errorMessage.replace ("#3", opponentBattleResultInfo.opponentPoints);
                            errorMessage = errorMessage.replace ("#4", opponentBattleResultInfo.userPoints);
                        }
                        else {
                            Tracer.log ("Результат боя расчитан синхронно!");
                        }
                        if (errorMessage) {
                            var errorPopUp:IInfoPopUp = PopUpManager.instance.errorPopUp;
                            var messageTitle:String = textsManager.getText ("asynchronousBattleResultTitle");
                            errorPopUp.showMessage (messageTitle, errorMessage);
                        }
                    }
                }
            }
        }

        private function onUserGet (response:Object):void {
            BreakdanceApp.instance.appUser.init (response);
        }

        private function receiveMarkedDataListener (event:ReceiveMarkedDataEvent):void {
            if (battle) {
                var marker:String = event.marker;
                var danceRoutine:Vector.<BattleDanceMoveData> = sendingDanceRoutineStorage [marker];
                Tracer.log ("Получили промаркерованный ответ. Маркер = '" + marker + "'; " +
                            "sendingDanceRoutineStorage [marker] = " + sendingDanceRoutineStorage [marker] + "; sendingAdditionalDanceRoutineStorage [marker]"
                );
                if (danceRoutine) {
                    Tracer.log ("Получили промаркерованный ответ и добавили свою связку.");
                    super.addDanceRoutine (danceRoutine, appUser.uid);
                    sendingDanceRoutineStorage [marker] = null;
                }
                danceRoutine = sendingAdditionalDanceRoutineStorage [marker];
                if (danceRoutine) {
                    Tracer.log ("Получили промаркерованный ответ и добавили свою связку для доп. тура.");
                    super.addAdditionalDanceRoutine (danceRoutine, appUser.uid);
                    sendingAdditionalDanceRoutineStorage [marker] = null;
                }
            }
        }

        private function receiveDanceRoutineListener (event:ReceiveDanceRoutineEvent):void {
            if (battle) {
                var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, BreakdanceApp.instance.appUser.uid);
                if (opponent && (opponent.uid == event.uid)) {
                    super.addDanceRoutine (event.danceRoutine, opponent.uid);
                }
                else {
                    Tracer.log ("Попытка добавить связку оппонента, который не в бою. (opponent.uid (" + opponent.uid + ") != event.uid (" + event.uid + "))");
                }
            }
        }

        private function receiveAdditionalDanceRoutineListener (event:ReceiveDanceRoutineEvent):void {
            if (battle) {
                var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, BreakdanceApp.instance.appUser.uid);
                if (opponent && (opponent.uid == event.uid)) {
                    super.addAdditionalDanceRoutine (event.danceRoutine, opponent.uid);
                }
                else {
                    Tracer.log ("Попытка добавить связку доп.тура оппонента, который не в бою. (opponent.uid (" + opponent.uid + ") != event.uid (" + event.uid + "))");
                }
            }
        }

        private function receiveAddingStaminaEventListener (event:ReceiveAddingStaminaEvent):void {
            if (battle) {
                var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, BreakdanceApp.instance.appUser.uid);
                if (opponent && (opponent.uid == event.uid)) {
                    super.addStamina (event.addingStamina, opponent.uid, event.noLessStamina, event.staminaConsumableId);
                }
                else {
                    Tracer.log ("Попытка добавить выносливость оппонента, который не в бою. (opponent.uid (" + opponent.uid + ") != event.uid (" + event.uid + "))");
                }
            }
        }

        private function opponentCancelBattleListener (event:CancelBattleEvent):void {
            if (battle) {
                var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, BreakdanceApp.instance.appUser.uid);
                if (opponent && (opponent.uid == event.uid)) {
                    Tracer.log ("[PvPBattleController] Получили отмену боя от противника. Автопобеда!");
                    battle.autoWin ();
                }
            }
        }

        private function getOnlineUsersListener (event:GetOnlineUsersEvent):void {
            if (battle) {
                var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, BreakdanceApp.instance.appUser.uid);
                if (opponent && (event.onlineUsers.indexOf (opponent.uid) == -1)) {
                    Tracer.log ("[PvPBattleController] Противник ушёл оффлайн. Автопобеда!");
                    battle.autoWin ();
                }
            }
        }

    }
}
