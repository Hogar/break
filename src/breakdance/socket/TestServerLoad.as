/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.11.13
 * Time: 20:13
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socket {

    import fl.controls.Button;
    import fl.controls.CheckBox;
    import fl.controls.NumericStepper;
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
    import flash.utils.Dictionary;

    [SWF(width="550", height="400", frameRate="30", backgroundColor="#ffffff")]
    public class TestServerLoad extends Sprite {

        private var tfLog:TextArea;
        private var tfResult:TextArea;

        private var cbxBroadcast:CheckBox;
        private var tfBroadcast:TextInput;
        private var cbxGetUsers:CheckBox;

        private var tfServer:TextInput;
        private var tfPort:TextInput;
        private var tfName:TextInput;
        private var numericStepper:NumericStepper;
        private var btnConnect:Button;

        private var maxCount:int = 0;
        private var clientNames:Dictionary = new Dictionary ();
        private var currentConnectionCount:int;

        public function TestServerLoad () {

            var mc:MovieClip = new mcPanel3 ();

            tfLog = mc.tfLog;
            tfResult = mc.tfResult;

            cbxBroadcast = mc.cbxBroadcast;
            tfBroadcast = mc.tfBroadcast;
            cbxGetUsers = mc.cbxGetUsers;

            tfServer = mc.tfServer;
            tfPort = mc.tfPort;
            tfName = mc.tfName;
            btnConnect = mc.btnConnect;

            numericStepper = mc.numericStepper;

            addChild (mc);

            tfServer.text = "5.178.82.70";
            tfPort.text = "8889";
            tfName.text = "Client";
            numericStepper.maximum = 1000000;

            btnConnect.addEventListener (MouseEvent.CLICK, clickListener);
        }

        /////////////////////////////////////////////
        //PRIVATE:
        /////////////////////////////////////////////

        private function connectToSocketServer ():void {
            var serverUrl:String = tfServer.text;
            var port:int = parseInt (tfPort.text);
            count++;
            var clientName:String = tfName.text + "_" + count;
            log (clientName + " соединяется с сокет-сервером: " + serverUrl + ":" + port);
            var xmlSocket:XMLSocket = new XMLSocket ();
            xmlSocket.addEventListener (Event.CONNECT, connectListener);
            xmlSocket.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
            xmlSocket.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
            xmlSocket.addEventListener (DataEvent.DATA, dataListener);
            clientNames [xmlSocket] = clientName;
            xmlSocket.connect (serverUrl, port);
            btnConnect.enabled = false;
        }

        private function setViewerId (xmlSocket:XMLSocket):void {
            var clientName:String = getClientName (xmlSocket);
            var message:String = '{"method":"setViewerID","data":{"viewerID":"' + clientName + '"}}';
            send (xmlSocket, message);
        }

        private function getOnlineUsers (xmlSocket:XMLSocket):void {
            var message:String = '{"method":"getViewersOnline","data":{}}';
            send (xmlSocket, message);
        }

        private function sendBroadcast (xmlSocket:XMLSocket):void {
            var message:String = escape (tfBroadcast.text);
            message = '{"method":"broadcast","data":{"message": "' + message + '"}}';
            send (xmlSocket, message);
        }

        private function log (message:String):void {
            tfLog.appendText (message + "\n");
        }

        private function getClientName (xmlSocket:XMLSocket):String {
            var clientName:String = clientNames [xmlSocket];
            if (clientName == null) {
                clientName = "Client_X";
            }
            return clientName;
        }

        private function send (xmlSocket:XMLSocket, message:String):void {
            var clientName:String = getClientName (xmlSocket);
            log (clientName + ' посылает :' + message);
            xmlSocket.send (message);
        }

        /////////////////////////////////////////////
        //LISTENERS:
        /////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case (btnConnect):
                    tfLog.text = "";
                    maxCount = numericStepper.value;
                    currentConnectionCount = 0;
                    count = 0;
                    connectToSocketServer ();
                    break;
            }
        }

        private var count:int = 1;

        private function connectListener (event:Event):void {
            var xmlSocket:XMLSocket = XMLSocket (event.currentTarget);
            var clientName:String = clientNames [xmlSocket];
            log (clientName + " соединён.");
            currentConnectionCount++;
            tfResult.text = currentConnectionCount + "/" + maxCount;
            setViewerId (xmlSocket);
            if (cbxBroadcast.selected) {
                sendBroadcast (xmlSocket);
            }
            if (cbxGetUsers.selected) {
                getOnlineUsers (xmlSocket);
            }
            if (count < maxCount) {
                connectToSocketServer ();
            }
            else {
                btnConnect.enabled = true;
            }
        }

        private function ioErrorListener (event:IOErrorEvent):void {
            var xmlSocket:XMLSocket = XMLSocket (event.currentTarget);
            var clientName:String = clientNames [xmlSocket];
            log (clientName + ". Io error: " + event.target);
            btnConnect.enabled = true;
        }

        private function securityErrorListener (event:SecurityErrorEvent):void {
            var xmlSocket:XMLSocket = XMLSocket (event.currentTarget);
            var clientName:String = clientNames [xmlSocket];
            log (clientName + ". Security error: " + event.target);
            btnConnect.enabled = true;
        }

        private function dataListener (event:DataEvent):void {
            var xmlSocket:XMLSocket = XMLSocket (event.currentTarget);
            var clientName:String = clientNames [xmlSocket];
            var message:String = unescape (event.data);
            log (clientName + " получает сообщение: " + message);
        }
    }
}
