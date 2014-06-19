/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.11.13
 * Time: 15:29
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socketServer {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalConstants;
    import breakdance.battle.BattleManager;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.data.BattleData;
    import breakdance.battle.data.BattlePlayerData;
    import breakdance.battle.model.UserBattleResultInfo;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.TextsManager;
    import breakdance.socketServer.events.CancelBattleEvent;
    import breakdance.socketServer.events.GetOnlineUsersEvent;
    import breakdance.socketServer.events.ReceiveAddingStaminaEvent;
    import breakdance.socketServer.events.ReceiveBattleResultEvent;
    import breakdance.socketServer.events.ReceiveChatMessageEvent;
    import breakdance.socketServer.events.ReceiveDanceRoutineEvent;
    import breakdance.socketServer.events.ReceiveMarkedDataEvent;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.popups.battleListPopUp.BattleListPopUp;
    import breakdance.ui.popups.infoPopUp.IInfoPopUp;
    import breakdance.ui.popups.pvpLogPanel.PvpLogPanelPopUp;
    import breakdance.ui.popups.pvpLogPanel.RequestType;
    import breakdance.user.AppUser;
    import breakdance.user.FriendData;
    import breakdance.user.UserLevel;
    import breakdance.user.UserLevelCollection;
    import breakdance.user.events.ChangeUserEvent;

    import com.hogargames.debug.Tracer;
    import com.hogargames.errors.SingletonError;
    import com.hogargames.utils.StringUtilities;

    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.XMLSocket;

    public class SocketServerManager extends EventDispatcher {

        private var xmlSocket:XMLSocket;

        private var currentUserDivision:int = 0;

        private var appUser:AppUser;
        private var textsManager:TextsManager = TextsManager.instance;

        private static var _instance:SocketServerManager;

        private static const CHAT_MESSAGE:String = "chat message";

        public function SocketServerManager (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
            appUser = BreakdanceApp.instance.appUser;
            appUser.addEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public static function get instance ():SocketServerManager {
            if (!_instance) {
                _instance = new SocketServerManager (new SingletonKey ());
            }
            return _instance;
        }

        public function connect ():void {
            xmlSocket = new XMLSocket ();
            xmlSocket.addEventListener (Event.CONNECT, connectListener);
            xmlSocket.addEventListener (Event.CLOSE, closeListener);
            xmlSocket.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
            xmlSocket.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
            xmlSocket.addEventListener (DataEvent.DATA, dataListener);
            xmlSocket.connect (GlobalConstants.SOCKET_SERVER_URL, GlobalConstants.SOCKET_SERVER_PORT);
        }


        public function get connected ():Boolean {
            return (xmlSocket && xmlSocket.connected);
        }

        public function sendInvite (battleData:BattleData):void {
            var opponentId:String = battleData.opponentId;
            if (opponentId) {
                var shortLog:String = "<b>Отправили инвайт игроку <font color='#ff0000'>" + opponentId + "</font></b>";
                var fullLog:String = battleData.toString ();
                PopUpManager.instance.pvpLogPanelPopUp.addLog (shortLog, fullLog, RequestType.SEND);
                sendMessageTo (battleData.opponentId, PvPBattleActionType.INVITE_SEND, JSON.stringify (battleData.asData ()));
            }
            else {
                trace ("Невозможно отправить приглашение, т.к. неизвестен противник.");
            }
        }

        public function acceptInvite (battleData:BattleData):void {
            var opponentId:String = battleData.opponentId;
            if (battleData) {
                if (opponentId) {
                    var shortLog:String = "<b>Отправили согласие на инвайт игроку <font color='#ff0000'>" + opponentId + "</font></b>";
                    var fullLog:String = battleData.toString ();
                    PopUpManager.instance.pvpLogPanelPopUp.addLog (shortLog, fullLog, RequestType.SEND);
                    sendMessageTo (opponentId, PvPBattleActionType.INVITE_ACCEPT, JSON.stringify (battleData.asData ()));
                    BattleManager.instance.createPvPBattle (battleData);
                }
                else {
                    trace ("Невозможно согласится на приглашение, т.к. неизвестен противник.");
                }
            }
        }

        public function cancelBattle (recipientId:String):void {
            var shortLog:String = "<b>Отменили бой с игроком <font color='#ff0000'>" + recipientId + "</font></b>";
            var fullLog:String = "";
            PopUpManager.instance.pvpLogPanelPopUp.addLog (shortLog, fullLog, RequestType.SEND);
            sendMessageTo (recipientId, PvPBattleActionType.CANCEL_BATTLE, "null");
        }

        public function endBattle (recipientId:String, userBattleResultInfo:UserBattleResultInfo):void {
            var message:String = JSON.stringify (userBattleResultInfo.asData ());
            var shortLog:String = "<b>Отправили результат боя игроку <font color='#ff0000'>" + recipientId + "</font></b>";
            var fullLog:String = message;
            PopUpManager.instance.pvpLogPanelPopUp.addLog (shortLog, fullLog, RequestType.SEND);
            sendMessageTo (recipientId, PvPBattleActionType.END_BATTLE, message);
        }

        public function sendAddStamina (addingStamina:int, recipientId:String, noLessStamina:Boolean = false, staminaConsumableId:String = ""):void {
            var data:Object = {addingStamina:addingStamina, noLessStamina:noLessStamina, staminaConsumableId:staminaConsumableId};
            var message:String = JSON.stringify (data);
            var shortLog:String = "<b>Отправили инфу о энергетике игроку <font color='#ff0000'>" + recipientId + "</font></b>";
            var fullLog:String = message;
            PopUpManager.instance.pvpLogPanelPopUp.addLog (shortLog, fullLog, RequestType.SEND);

            sendMessageTo (recipientId, PvPBattleActionType.ADD_STAMINA, message);
        }

        public function sendDanceRoutine (recipientId:String, danceRoutine:Vector.<BattleDanceMoveData>, marker:String = null):void {
            var shortLog:String = "<b>Отправили связку игроку <font color='#ff0000'>" + recipientId + "</font></b>";
            var fullLog:String = danceRoutine.toString ();
            PopUpManager.instance.pvpLogPanelPopUp.addLog (shortLog, fullLog, RequestType.SEND);

            var danceRoutineArr:Array = [];
            for (var i:int = 0; i < danceRoutine.length; i++) {
                danceRoutineArr.push (danceRoutine [i].asData ());
            }
            sendMessageTo (recipientId, PvPBattleActionType.DANCE_ROUTINE, JSON.stringify (danceRoutineArr), marker);
        }

        public function sendAdditionalDanceRoutine (recipientId:String, danceRoutine:Vector.<BattleDanceMoveData>, marker:String = null):void {
            var shortLog:String = "<b>Отправили связку игроку <font color='#ff0000'>" + recipientId + "</font></b>";
            var fullLog:String = danceRoutine.toString ();
            PopUpManager.instance.pvpLogPanelPopUp.addLog (shortLog, fullLog, RequestType.SEND);

            var danceRoutineArr:Array = [];
            for (var i:int = 0; i < danceRoutine.length; i++) {
                danceRoutineArr.push (danceRoutine [i].asData ());
            }
            sendMessageTo (recipientId, PvPBattleActionType.ADDITIONAL_DANCE_ROUTINE, JSON.stringify (danceRoutineArr), marker);
        }

        public function sendChallenge (battleData:BattleData):void {
            if (battleData && xmlSocket) {
                var shortLog:String = "<b>Отправили вызов.</b>";
                var fullLog:String = battleData.toString ();
                PopUpManager.instance.pvpLogPanelPopUp.addLog (shortLog, fullLog, RequestType.SEND);				
				var message:String = '{"method": "addChallenge", "data":' + JSON.stringify (battleData.asData ()) + '}';				
              //  var message:String = '{"method": "addChallenge", "data": {}}';
                Tracer.log ("[SocketServerManager] Отправили вызов: " + message);
                xmlSocket.send (message);
            }
        }

        public function cancelChallenge ():void {
            if (xmlSocket && xmlSocket.connected) {
                var shortLog:String = "<b>Отменили вызов.</b>";
                var fullLog:String = "";
                PopUpManager.instance.pvpLogPanelPopUp.addLog (shortLog, fullLog, RequestType.SEND);
                var message:String = '{"method": "removeChallenge", "data": "" }';
                Tracer.log ("[SocketServerManager] Отменили вызов: " + message);
                xmlSocket.send (message);
            }
        }

        public function getChallenges ():void {
            if (xmlSocket && xmlSocket.connected) {
                var message:String = '{"method": "getChallenges", "data": {} }';
                Tracer.log ("[SocketServerManager] Запрашиваем список вызовов: " + message);
                xmlSocket.send (message);
            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function destroySocket ():void {
            if (xmlSocket != null) {
                xmlSocket.removeEventListener (Event.CONNECT, connectListener);
                xmlSocket.removeEventListener (Event.CLOSE, closeListener);
                xmlSocket.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
                xmlSocket.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
                xmlSocket.removeEventListener (DataEvent.DATA, dataListener);
                try {
                    xmlSocket.close ();
                }
                catch (error:Error) {
                    //
                }
            }
            xmlSocket = null;
        }

        /**
         * @param recipientId Получатель.
         * @param type Тип сообщения (для боя).
         * @param message Данные.
         * @param marker Униальный маркер сообщения, принятый задаваемый на клиенте. ПвП сервер посылает информацию о том, что сообщение с указанным маркером дошло.
         */
        private function sendMessageTo (recipientId:String, type:String, message:String, marker:String = null):void {
            if (xmlSocket && xmlSocket.connected) {
                var sendingMessage:String = '{"method":"sendMessage","data":{';
                if (marker) {
                    sendingMessage += '"marker":"' + marker + '",';
                }
                sendingMessage += '"viewerID":"' + recipientId + '","type":"' + type + '","senderID":"' + appUser.uid + '","message":' + message + '}}';
                Tracer.log ("[SocketServerManager] Отправили сообщение: " + message);
                xmlSocket.send (sendingMessage);
            }
            else {
                outputDisconnect ();
            }
        }

        /**
         * @param message Сообщение чата.
         * @param name Имя отправителя.
         */
        public function broadcast (message:String):void {
            if (xmlSocket && xmlSocket.connected) {
                var sendingMessage:String = '{"method":"broadcast","data":{';
                sendingMessage += '"message":"' + escape (message) + '","name":"' + appUser.nickname + '","uid":"' + appUser.uid + '","type":"' + CHAT_MESSAGE + '"}}';
                Tracer.log ("[SocketServerManager] Отправили сообщение: " + message);
                Tracer.log ("[SocketServerManager] Отправили запрос: " + sendingMessage);
                xmlSocket.send (sendingMessage);
            }
            else {
                outputDisconnect ();
            }
        }

        private function outputDisconnect ():void {
            var title:String = textsManager.getText ("socketServerConnectionErrorTitle");
            var message:String = textsManager.getText ("socketServerNoConnectionText");
            PopUpManager.instance.infoPopUp.showMessage (title, message);
        }

        private function getCurrentUserDivision ():int {
            var userLevel:int = appUser.level;
            var levelData:UserLevel = UserLevelCollection.instance.getUserLevel (userLevel);
            var useDivisionsInPvp:Boolean = StringUtilities.parseToBoolean (StaticData.instance.getSetting ("use_divisions_in_pvp"));
            var division:int = 1;
            if (useDivisionsInPvp) {
                if (levelData) {
                    division = levelData.division;
                }
            }
            return division;
        }

        private function setDivision ():void {
            if (xmlSocket && xmlSocket.connected) {
                var message:String = '{"method": "setViewerCategory", "data":{"viewerCategory": "' + currentUserDivision + '"}}';
                Tracer.log ("[SocketServerManager] Устанавливаем дивизион: " + message);
                xmlSocket.send (message);
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function connectListener (event:Event):void {
            Tracer.log ("[SocketServerManager] Соединение установлено.");
            if (xmlSocket && xmlSocket.connected) {
                //Задаём свой id:
                var message:String = '{"method":"setViewerID","data":{"viewerID":"' + appUser.uid + '"}}';
                xmlSocket.send (message);
                message = '{"method":"getViewersOnline","data":{}}';
                xmlSocket.send (message);
                currentUserDivision = getCurrentUserDivision ();
                setDivision ();
            }
            else {
                outputDisconnect ();
            }
            dispatchEvent (new Event (Event.CONNECT));
        }

        private function closeListener (event:Event):void {
            Tracer.log ("[SocketServerManager] Соединение разорвано.");
            if (xmlSocket) {
                Tracer.log ("[SocketServerManager] Подключаемся заново.");
                xmlSocket.connect (GlobalConstants.SOCKET_SERVER_URL, GlobalConstants.SOCKET_SERVER_PORT);
            }
            var title:String = textsManager.getText ("socketServerCloseTitle");
            var message:String = textsManager.getText ("socketServerCloseText");
            PopUpManager.instance.infoPopUp.showMessage (title, message);
            dispatchEvent (new Event (Event.CLOSE));
        }

        private function ioErrorListener (event:IOErrorEvent):void {
            Tracer.log ("[SocketServerManager] Io error: " + event.target);
            destroySocket ();
            var title:String = textsManager.getText ("socketServerConnectionErrorTitle");
            var message:String = textsManager.getText ("socketServerConnectionErrorText");
            PopUpManager.instance.infoPopUp.showMessage (title, message);
            dispatchEvent (new Event (Event.CLOSE));
        }

        private function securityErrorListener (event:SecurityErrorEvent):void {
            Tracer.log ("[SocketServerManager] Security error: " + event.target);
            destroySocket ();
            var title:String = textsManager.getText ("socketServerConnectionErrorTitle");
            var message:String = textsManager.getText ("socketServerConnectionErrorText");
            PopUpManager.instance.infoPopUp.showMessage (title, message);
            dispatchEvent (new Event (Event.CLOSE));
        }

        private function dataListener (event:DataEvent):void {
            if (xmlSocket) {
                var receivedData:String = unescape (event.data);
//                Tracer.log ("[SocketServerManager] Получили сообщение: " + receivedData);
                try {
                    var data:Object = JSON.parse (receivedData);
                }
                catch (error:Error) {
                    Tracer.log ("[SocketServerManager] Полученое сообщение не json: " + message);
                    return;
                }

                var shortLog:String = "";
                var fullLog:String = receivedData;
                var errorMessage:String;
                var doCancelInvite:Boolean = false;
                var pvpLogPanelPopUp:PvpLogPanelPopUp = PopUpManager.instance.pvpLogPanelPopUp;

                var senderId:String;
                var i:int;
                var battleDanceMoveData:BattleDanceMoveData;
                var battleData:BattleData;

                /////////////////////////////////////////////
                //ПОДТВЕРЖДЕНИЕ МАРКИРОВАННОГО СООБЩЕНИЯ:
                /////////////////////////////////////////////
                if (data.hasOwnProperty ("marker")) {
                    var marker:String = data.marker;
                    dispatchEvent (new ReceiveMarkedDataEvent (marker));
                }
                /////////////////////////////////////////////
                //ОБРАБОТКА ОШИБОК:
                /////////////////////////////////////////////
                if (data.hasOwnProperty ("error")) {
                    if (data.hasOwnProperty ("code")) {
                        var errorPopUp:IInfoPopUp = PopUpManager.instance.errorPopUp;
                        var popUpTitle:String = textsManager.getText ("socketServerErrorTitle");
                        var popUpMessage:String;
                        if (data.code == "3") {
                            popUpMessage = textsManager.getText ("socketServerError3");
                        }
                        else if (data.code == "13") {
                            popUpMessage = textsManager.getText ("socketServerError13");
                        }
                        else if (data.code == "14") {
                            popUpMessage = textsManager.getText ("socketServerError14");
                        }
                        else if (data.code == "23") {
//                            popUpMessage = textsManager.getUiText ("socketServerError23");
                        }
                        else if (data.code == "55") {
                            popUpMessage = textsManager.getText ("socketServerError55");
                        }
                        else if (data.code == "402") {
                            popUpMessage = textsManager.getText ("socketServerError402");
                            destroySocket ();
                        }
                        else if (data.code == "403") {
                            popUpMessage = textsManager.getText ("socketServerError403");
                            destroySocket ();
                        }
                        else {
                            popUpTitle = textsManager.getText ("socketServerErrorTitle");
                            popUpMessage = receivedData;
                        }
                        if (popUpMessage) {
                            errorPopUp.showMessage (popUpTitle, popUpMessage);
                        }
                    }
                }
                /////////////////////////////////////////////
                //СООБЩЕНИЕ ОТ ИГРОКА:
                /////////////////////////////////////////////
                else if (data.hasOwnProperty ("senderID")) {
                    senderId = data.senderID;
                    if (senderId == appUser.uid) {
                        //Ответ на собственные сообщения.
                    }
                    if (data.hasOwnProperty ("type")) {
                        var message:Object;
                        if (data.hasOwnProperty ("message")) {
                            message = data.message;
                        }
                        switch (data.type) {
                            case PvPBattleActionType.INVITE_ACCEPT:
                                shortLog = "<b>Получили подтверждение инвайта</b>";
                                if (senderId) {
                                    shortLog += "<b> от игрока <font color='#ff0000'>" + senderId + "</font></b>";
                                }
                                if (!BattleManager.instance.hasBattle) {
                                    if (appUser.testReadyToBattle (false)) {
                                        battleData = new BattleData ();
                                        if (message) {
                                            battleData.init (message);
                                            BattleManager.instance.createPvPBattle (battleData);
                                        }
                                        else {
                                            errorMessage = "Получены данные с пустым полем <b>message</b>.";
                                            doCancelInvite = true;
                                        }
                                    }
                                    else {
                                        errorMessage = "Игрок не готов к бою.";
                                    }
                                }
                                else {
                                    errorMessage = "Игрок уже в бою.";
                                }
                                break;
                            case PvPBattleActionType.INVITE_SEND:
                                shortLog = "<b>Получили инвайт</b>";
                                if (senderId) {
                                    shortLog += "<b> от игрока <font color='#ff0000'>" + senderId + "</font></b>";
                                }
                                if (!BattleManager.instance.hasBattle) {
                                    if (appUser.testReadyToBattle (false)) {
                                        battleData = new BattleData ();
                                        if (message) {
                                            battleData.init (message);
                                            var playerAsBattlePlayerData:BattlePlayerData = appUser.asBattlePlayerData ();
                                            if (battleData.player1 == null) {
                                                battleData.player1 = playerAsBattlePlayerData;
                                            }
                                            else if (battleData.player2 == null) {
                                                battleData.player2 = playerAsBattlePlayerData;
                                            }
                                            PopUpManager.instance.acceptInvitePopUp.showBattleData (battleData);
                                        }
                                        else {
                                            errorMessage = "Получены данные с пустым полем <b>message</b>.";
                                            doCancelInvite = true;
                                        }
                                    }
                                    else {
                                        errorMessage = "Игрок не готов к бою.";
                                        doCancelInvite = true;
                                    }
                                }
                                else {
                                    errorMessage = "Игрок уже в бою.";
                                    doCancelInvite = true;
                                }
                                break;
                            case PvPBattleActionType.DANCE_ROUTINE:
                                shortLog = "<b>Получили связку</b>";
                                if (senderId) {
                                    shortLog += "<b> от игрока <font color='#ff0000'>" + senderId + "</font></b>";
                                }
                                if (BattleManager.instance.hasBattle) {
                                    if (message) {
                                        var danceRoutine:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
                                        for (i = 0; i < message.length; i++) {
                                            battleDanceMoveData = new BattleDanceMoveData ();
                                            battleDanceMoveData.init (message [i]);
                                            danceRoutine.push (battleDanceMoveData);
                                        }
                                        dispatchEvent (new ReceiveDanceRoutineEvent (ReceiveDanceRoutineEvent.RECEIVE_DANCE_ROUTINE, danceRoutine, senderId));
                                    }
                                }
                                else {
                                    errorMessage = "Нету ни одной созданной битвы.";
                                }
                                break;
                            case PvPBattleActionType.ADDITIONAL_DANCE_ROUTINE:
                                shortLog = "<b>Получили связку для доп. рауда</b>";
                                if (senderId) {
                                    shortLog += "<b> от игрока <font color='#ff0000'>" + senderId + "</font></b>";
                                }
                                if (BattleManager.instance.hasBattle) {
                                    if (message) {
                                        var additionalDanceRoutine:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
                                        for (i = 0; i < message.length; i++) {
                                            battleDanceMoveData = new BattleDanceMoveData ();
                                            battleDanceMoveData.init (message [i]);
                                            additionalDanceRoutine.push (battleDanceMoveData);
                                        }
                                        dispatchEvent (new ReceiveDanceRoutineEvent (ReceiveDanceRoutineEvent.RECEIVE_ADDITIONAL_DANCE_ROUTINE, additionalDanceRoutine, senderId));
                                    }
                                }
                                else {
                                    errorMessage = "Нету ни одной созданной битвы.";
                                }
                                break;
                            case PvPBattleActionType.ADD_STAMINA:
                                shortLog = "<b>Получили инфу об энергетике</b>";
                                if (senderId) {
                                    shortLog += "<b> от игрока <font color='#ff0000'>" + senderId + "</font></b>";
                                }
                                if (BattleManager.instance.hasBattle) {
                                    if (message) {
                                        dispatchEvent (new ReceiveAddingStaminaEvent (message.addingStamina, senderId, message.noLessStamina, message.staminaConsumableId));
                                    }
                                }
                                else {
                                    errorMessage = "Нету ни одной созданной битвы.";
                                }
                                break;
                            case PvPBattleActionType.CANCEL_BATTLE:
                                shortLog = "<b>Получили отмену боя</b>";
                                if (senderId) {
                                    shortLog += "<b> от игрока <font color='#ff0000'>" + senderId + "</font></b>";
                                }
                                dispatchEvent (new CancelBattleEvent (CancelBattleEvent.OPPONENT_CANCEL_BATTLE, senderId));
                                break;
                            case PvPBattleActionType.END_BATTLE:
                                shortLog = "<b>Получили результат боя</b>";
                                if (senderId) {
                                    shortLog += "<b> от игрока <font color='#ff0000'>" + senderId + "</font></b>";
                                }
                                var userBattleResultInfo:UserBattleResultInfo = new UserBattleResultInfo ();
                                userBattleResultInfo.init (message);
                                dispatchEvent (new ReceiveBattleResultEvent (userBattleResultInfo, senderId));
                                break;
                        }
                        pvpLogPanelPopUp.addLog (shortLog, fullLog, RequestType.RECEIVE);
                    }
                    if (doCancelInvite) {
                        if (senderId) {
                            cancelBattle (senderId);
                        }
                    }
                    pvpLogPanelPopUp.showStopListening ();
                }
                /////////////////////////////////////////////
                //BROADCAST (СПИСОК ИГРОКОВ ОНЛАЙН):
                /////////////////////////////////////////////
                else if (data.hasOwnProperty ("viewersOnline")) {
                    var viewersOnline:Array = data.viewersOnline;
                    var userFriends:Vector.<FriendData> = appUser.userAppFriends;
                    for (i = 0; i < userFriends.length; i++) {
                        var friendData:FriendData = userFriends [i];
                        friendData.isOnline = (viewersOnline.indexOf (friendData.uid) != -1);
                    }
                    dispatchEvent (new GetOnlineUsersEvent (GetOnlineUsersEvent.GET_ONLINE_USERS, viewersOnline));
                }
                /////////////////////////////////////////////
                //СПИСОК ВЫЗОВОВ:
                /////////////////////////////////////////////
                else if (data.hasOwnProperty ("activeChallenges")) {
                    var activeChallenges:Object = data.activeChallenges;
                    var battles:Vector.<BattleData> = new Vector.<BattleData> ();
//                    Tracer.log ("***Вызовы:");
                    for (var playerId:String in activeChallenges) {
//                        Tracer.log ("***От игрока " + playerId + " есть вызов " + activeChallenges [playerId]);
                        var challengeData:Object = activeChallenges [playerId];
                        battleData = new BattleData ();
                        battleData.init (challengeData);
                        if (playerId != appUser.uid) {
                            battles.push (battleData);
                        }
                    }
                    var battleListPopUp:BattleListPopUp = PopUpManager.instance.battleListPopUp;
                    if (battleListPopUp.isShowed) {
//                        Tracer.log ("***Показали полученный сисок.");
                        battleListPopUp.init (battles);
                    }
                    else {
//                        Tracer.log ("***Но полученный сисок не показали, т.к. окно не открыто.");
                    }
//                    Tracer.log ("***");
                }
                /////////////////////////////////////////////
                //BROADCAST (ЧАТ):
                /////////////////////////////////////////////
                else if (data.hasOwnProperty ("type")) {
                    if ( data.type == CHAT_MESSAGE) {
                        dispatchEvent (new ReceiveChatMessageEvent (unescape (String (data.message)), unescape (String (data.name)), data.uid));
                    }
                }
            }
        }

        private function changeUserListener (event:ChangeUserEvent):void {
            var division:int = currentUserDivision = getCurrentUserDivision ();
            if (currentUserDivision != division) {
                currentUserDivision = division;
                if (xmlSocket && xmlSocket.connected) {
                    setDivision ();
                }
            }
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}