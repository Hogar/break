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
    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.XMLSocket;

    [SWF(width="550", height="400", frameRate="30", backgroundColor="#ffffff")]
    public class TestSocketIOMain3 extends Sprite {

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

        private var xmlSocket:XMLSocket;

        public function TestSocketIOMain3 () {

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

            tfServer.text = "5.178.82.70";
            tfPort.text = "8889";
            tfName.text = "Hogar";

            btnConnect.addEventListener (MouseEvent.CLICK, clickListener);
            btnSetViewerId.addEventListener (MouseEvent.CLICK, clickListener);
            btnGetOnlineUsers.addEventListener (MouseEvent.CLICK, clickListener);
            btnSend.addEventListener (MouseEvent.CLICK, clickListener);
            btnSendAll.addEventListener (MouseEvent.CLICK, clickListener);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function connectToSocket ():void {
            var serverUrl:String = tfServer.text;
            var port:int = parseInt (tfPort.text);
            var url:String = serverUrl + ":" + port;
            log ("Соединяемся с сокетом " + url);
            xmlSocket = new XMLSocket ();
            xmlSocket.addEventListener (Event.CONNECT, connectListener);
            xmlSocket.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
            xmlSocket.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
            xmlSocket.addEventListener (DataEvent.DATA, dataListener);
            xmlSocket.connect (serverUrl, port);
            btnConnect.enabled = false;
        }

        private function setViewerId ():void {
            var name:String = tfName.text;
            var message:String = '{"method":"setViewerID","data":{"viewerID":"' + name + '"}}';
            send(message);
        }

        private function getOnlineUsers ():void {
            log ("Посылаем метод getOnlineUsers ()");
            var message:String = '{"method":"getViewersOnline","data":{}}';
            send (message);
        }

        private function sendMessage ():void {
            var recipientName:String = tfRecipientName.text;
            var message:String = escape (tfMessage.text);
            message = '{"method":"sendMessage","data":{"viewerID":"' + recipientName + '","message":"' + message + '"}}';
            send (message);
        }

        private function sendMessageToAll ():void {
            var message:String = escape (tfMessage.text);
            message = '{"method":"broadcast","data":{"message": "' + message + '"}}';
            send (message);
        }

        private function log (message:String):void {
            tfLog.appendText (message + "\n");
        }

        private function send (message:String):void {
            log ('Посылаем :' + message);
            xmlSocket.send (message);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

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

        private var count:int = 1;

        private function connectListener (event:Event):void {
            log ("SOCKET. Connected: " + event.target);
        }

        private function ioErrorListener (event:IOErrorEvent):void {
            log ("SOCKET. Io error: " + event.target);
            xmlSocket = null;
            btnConnect.enabled = true;
        }

        private function securityErrorListener (event:SecurityErrorEvent):void {
            log ("SOCKET. security error: " + event.target);
            xmlSocket = null;
            btnConnect.enabled = true;
        }

        private function dataListener (event:DataEvent):void {
            log ("socketDataListener.");
            if (xmlSocket) {
                var message:String = unescape (event.data);
                log ("SOCKET. Получили сообщение: " + message);
            }
        }
    }
}
