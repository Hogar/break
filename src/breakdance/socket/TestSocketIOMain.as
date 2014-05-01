/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.11.13
 * Time: 23:02
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socket {

    import com.adobe.serialization.json.JSON;
    import com.hogargames.debug.ITracerOutput;
    import com.hogargames.debug.Tracer;
    import com.hogargames.utils.StringUtilities;

    import fl.controls.Button;
    import fl.controls.ComboBox;
    import fl.controls.TextArea;
    import fl.controls.TextInput;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.errors.IOError;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;
    import flash.system.Security;

    [SWF(width="550", height="400", frameRate="30", backgroundColor="#ffffff")]
    public class TestSocketIOMain extends Sprite implements ITracerOutput {

        private var tfMessage:TextInput;
        private var tfServer:TextInput;
        private var tfPort:TextInput;
        private var tfLog:TextArea;
        private var btnConnect:Button;
        private var btnSend:Button;
        private var cbxType:ComboBox;

        private var socketIOTransportFactory:ISocketIOTransportFactory = new SocketIOTransportFactory ();
        private var ioSocket:ISocketIOTransport;

        private var socket:Socket;

        private static const TYPE_SOCKET:String = "socket";
        private static const TYPE_IO_SOCKET:String = "io_socket";

        public function TestSocketIOMain () {
            var mc:MovieClip = new mcPanel ();
            tfMessage = mc.tfMessage;
            tfServer = mc.tfServer;
            tfPort = mc.tfPort;
            tfLog = mc.tfLog;
            btnConnect = mc.btnConnect;
            btnSend = mc.btnSend;
            cbxType = mc.cbxType;
            addChild (mc);

            tfServer.text = "5.178.82.70";
            tfPort.text = "8889";
//            tfServer.text = "1v1battle.eu01.aws.af.cm";
//            tfPort.text = "80";

            btnConnect.addEventListener (MouseEvent.CLICK, clickListener);
            btnSend.addEventListener (MouseEvent.CLICK, clickListener);

            Tracer.addTracerOutput (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function connectToSocket ():void {
            tfLog.text = "";
            var type:String = cbxType.selectedItem.data;
            trace ("type = " + type);
            switch (type) {
                case (TYPE_IO_SOCKET):
                    ioSocket = socketIOTransportFactory.createSocketIOTransport (XhrPollingTransport.TRANSPORT_TYPE, tfServer.text + ":" + tfPort.text + "/socket.io", this);
                    ioSocket.addEventListener (SocketIOEvent.CONNECT, onSocketConnected);
                    ioSocket.addEventListener (SocketIOEvent.DISCONNECT, onSocketDisconnected);
                    ioSocket.addEventListener (SocketIOEvent.MESSAGE, onSocketMessage);
                    ioSocket.addEventListener (SocketIOErrorEvent.CONNECTION_FAULT, onSocketConnectionFault);
                    ioSocket.addEventListener (SocketIOErrorEvent.SECURITY_FAULT, onSocketSecurityFault);
                    ioSocket.connect ();
                    btnConnect.enabled = false;
                    log ("Соединяемся с io_socket сервером...");
                    break;
                case (TYPE_SOCKET):
                    socket = new Socket ();
                    socket.addEventListener (Event.CONNECT, connectListener);
                    socket.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
                    socket.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
                    socket.addEventListener (ProgressEvent.SOCKET_DATA, socketDataListener);
                    Security.loadPolicyFile ("http://1v1battle.eu01.aws.af.cm/crossdomain.xml");
                    socket.connect (tfServer.text, parseInt (tfPort.text));
                    btnConnect.enabled = false;
                    log ("Соединяемся с socket сервером...");
                    break;
            }
        }

        private function sendMessage (message:String):void {
            var type:String = cbxType.selectedItem.data;
            switch (type) {
                case (TYPE_IO_SOCKET):
                    if (ioSocket) {
                        log ("IO_SOCKET. отправили сообщение: " + message);
                        if (StringUtilities.isNotValueString (message)) {
                            var obj:Object = {type: "setViewerId", data: "Hogar2"};
                            ioSocket.send (obj);
                        }
                        else {
                            ioSocket.send (message);
                        }
                    }
                    break;
                case (TYPE_SOCKET):
                    if (socket) {
                        try {
                            log ("SOCKET. отправили сообщение: " + message);
                            socket.writeUTFBytes (message);
                            socket.flush ();
                        }
                        catch (error:IOError) {
                            log ("SOCKET. SEND ERROR. " + error);
                        }
                    }
                    break;
            }
        }

        public function log (message:String):ITracerOutput {
            tfLog.appendText (message + "\n");
            return this;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        /////////////////////////////////////////////
        //IO_SOCKET:
        /////////////////////////////////////////////

        private function onSocketConnectionFault (event:SocketIOErrorEvent):void {
            log ("IO_SOCKET. Fault: " + event.type + ":" + event.text);
            ioSocket = null;
            socket = null;
            btnConnect.enabled = true;
        }

        private function onSocketSecurityFault (event:SocketIOErrorEvent):void {
            log (event.type + ":" + event.text);
            ioSocket = null;
            socket = null;
            btnConnect.enabled = true;
        }

        private function onSocketMessage (event:SocketIOEvent):void {
            if (event.message is String) {
                log ("IO_SOCKET. Получили сообщение: " + String (event.message));
            }
            else {
                log ("IO_SOCKET. Получили Json сообщение: " + com.adobe.serialization.json.JSON.encode (event.message));
            }
        }

        private function onSocketConnected (event:SocketIOEvent):void {
            log ("IO_SOCKET. Connected: " + event.target);
        }

        private function onSocketDisconnected (event:SocketIOEvent):void {
            log ("IO_SOCKET. Disconnected: " + event.target);
        }

        /////////////////////////////////////////////
        //SOCKET:
        /////////////////////////////////////////////

        private function connectListener (event:Event):void {
            log ("SOCKET. Connected: " + event.target);
        }

        private function ioErrorListener (event:IOErrorEvent):void {
            log ("SOCKET. Io error: " + event.target);
            ioSocket = null;
            socket = null;
            btnConnect.enabled = true;
        }

        private function securityErrorListener (event:SecurityErrorEvent):void {
            log ("SOCKET. security error: " + event.target);
            ioSocket = null;
            socket = null;
            btnConnect.enabled = true;
        }

        private function socketDataListener (event:ProgressEvent):void {
            log ("socketDataListener...");
            if (socket) {
                var message:String = socket.readUTFBytes (socket.bytesAvailable);
                log ("SOCKET. Получили сообщение: " + message);
            }
        }

        /////////////////////////////////////////////
        //OTHER:
        /////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case (btnConnect):
                    connectToSocket ();
                    break;
                case (btnSend):
                    sendMessage (tfMessage.text);
                    break;
            }
      	}
    }
}
