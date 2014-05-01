/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 24.03.14
 * Time: 11:21
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socketServer.events {

    import flash.events.Event;

    public class ReceiveChatMessageEvent extends Event {

        private var _message:String;
        private var _authorName:String;
        private var _uid:String;

        public static const RECEIVE_CHAT_MESSAGE:String = "receive chat message";

        public function ReceiveChatMessageEvent (message:String, authorName:String, uid:String):void {
            this.message = message;
            this.authorName = authorName;
            this.uid = uid;
            super (RECEIVE_CHAT_MESSAGE);
        }

        public function get message ():String {
            return _message;
        }

        public function set message (value:String):void {
            _message = value;
        }

        public function get authorName ():String {
            return _authorName;
        }

        public function set authorName (value:String):void {
            _authorName = value;
        }

        public function get uid ():String {
            return _uid;
        }

        public function set uid (value:String):void {
            _uid = value;
        }
    }
}
