/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 19.11.13
 * Time: 22:11
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socket {

    import fl.controls.Button;
    import fl.controls.TextArea;
    import fl.controls.TextInput;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.external.ExternalInterface;
    import flash.utils.Timer;

    [SWF(width="550", height="400", frameRate="30", backgroundColor="#ffffff")]
    public class TestSocketIOMain2 extends Sprite {

        private var tfLog:TextArea;

        private var tfServer:TextInput;
        private var tfPort:TextInput;
        private var btnConnect:Button;

        private var tfName:TextInput;
        private var btnSetViewerId:Button;
        private var btnGetOnlineUsers:Button;

        private var tfMessage:TextInput;
        private var tfRecipientName:TextInput;
        private var btnSend:Button;
        private var btnSendAll:Button;

        private var readyTimer:Timer;

        public function TestSocketIOMain2 () {

            var mc:MovieClip = new mcPanel2 ();

            tfLog = mc.tfLog;

            tfServer = mc.tfServer;
            tfPort = mc.tfPort;
            btnConnect = mc.btnConnect;

            tfName = mc.tfName;
            btnSetViewerId = mc.btnSetViewerId;
            btnGetOnlineUsers = mc.btnGetOnlineUsers;

            tfMessage = mc.tfMessage;
            tfRecipientName = mc.tfRecipientName;
            btnSend = mc.btnSend;
            btnSendAll = mc.btnSendAll;

            addChild (mc);

            tfServer.text = "http://5.178.82.70";
            tfPort.text = "8889";
            tfName.text = "Hogar";

            btnConnect.addEventListener (MouseEvent.CLICK, clickListener);
            btnSetViewerId.addEventListener (MouseEvent.CLICK, clickListener);
            btnGetOnlineUsers.addEventListener (MouseEvent.CLICK, clickListener);
            btnSend.addEventListener (MouseEvent.CLICK, clickListener);
            btnSendAll.addEventListener (MouseEvent.CLICK, clickListener);

            if (ExternalInterface.available) {
                initCallbackFunctions ();
            }
            else {
                log ("ExternalInterface не доступен.");
                readyTimer = new Timer (100);
                readyTimer.addEventListener (TimerEvent.TIMER, timerHandler);
                readyTimer.start ();
            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function connectToSocket ():void {
            var serverUrl:String = tfServer.text;
            var port:String = tfPort.text;
            var url:String = serverUrl + ":" + port;
            if (ExternalInterface.available) {
                log ("Даём команду js на соединение с " + url);
                var returnValue:String = ExternalInterface.call ("connect", url);
                log ("return: " + returnValue);
//                ExternalInterface.call ("socketApp.init", url);
            }
        }

        private function setViewerId ():void {
            var name:String = tfName.text;
            log ("Посылаем JS метод setViewerId (" + name + ")");
//            ExternalInterface.call ("setViewerId", name);
            var returnValue:String = ExternalInterface.call ("socketApp.init", name);
            log ("return: " + returnValue);
        }

        private function getOnlineUsers ():void {
            log ("Посылаем JS метод getOnlineUsers ()");
//            ExternalInterface.call ("getOnlineUsers");
            var returnValue:String = ExternalInterface.call ("socketApp.init");
            log ("return: " + returnValue);
        }

        private function sendMessage ():void {
            var recipientName:String = tfRecipientName.text;
            var message:String = tfMessage.text;
            log ("Посылаем JS метод sendMessage (" + recipientName + "; '" + message + "')");
//            ExternalInterface.call ("sendMessage", recipientName, message);
            var returnValue:String = ExternalInterface.call ("socketApp.sendMessage", recipientName, message);
            log ("return: " + returnValue);
        }

        private function sendMessageToAll ():void {
            var message:String = tfMessage.text;
            log ("Посылаем JS метод broadcast ('" + message + "')");
//            ExternalInterface.call ("broadcast", message);
            var returnValue:String = ExternalInterface.call ("socketApp.broadcast", message);
            log ("return: " + returnValue);
        }

        private function log (message:String):void {
            tfLog.appendText (message + "\n");
        }

/////////////////////////////////////////////
//JS CALLBACK:
/////////////////////////////////////////////

        private function initCallbackFunctions ():void {
            log ("ExternalInterface доступен.");

            ExternalInterface.addCallback ('onWelcome', onWelcome);
            ExternalInterface.addCallback ('onSetViewerId', onSetViewerId);
            ExternalInterface.addCallback ('onGetViewersOnline', onGetViewersOnline);
            ExternalInterface.addCallback ('onMessage', onMessage);
            ExternalInterface.addCallback ('onPrivateMessage', onPrivateMessage);
        }

        private function onWelcome (data:String):void {
            log ("Получаем от JS 'welcome':");
            log (data);
        }

        private function onSetViewerId (data:String):void {
            log ("Получаем от JS 'onSetViewerId':");
            log (data);
        }

        private function onGetViewersOnline (data:String):void {
            log ("Получаем от JS 'onGetViewersOnline':");
            log (data);
        }

        private function onMessage (data:String):void {
            log ("Получаем от JS 'onMessage':");
            log (data);
        }

        private function onPrivateMessage (data:String):void {
            log ("Получаем от JS 'onPrivateMessage':");
            log (data);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function timerHandler (event:TimerEvent):void {
            if (ExternalInterface.available) {
                initCallbackFunctions ();
                readyTimer.removeEventListener (TimerEvent.TIMER, timerHandler);
                readyTimer.stop ();
            }
            else {
                log (readyTimer.currentCount + ". ExternalInterface не доступен.");
            }
        }

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case (btnConnect):
                    connectToSocket ();
                    break;
                case (btnSetViewerId):
                    setViewerId ();
                    break;
                case (btnGetOnlineUsers):
                    getOnlineUsers ();
                    break;
                case (btnSend):
                    sendMessage ();
                    break;
                case (btnSendAll):
                    sendMessageToAll ();
                    break;
            }
      	}
    }
}
