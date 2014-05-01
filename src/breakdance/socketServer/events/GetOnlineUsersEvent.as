/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.11.13
 * Time: 19:19
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socketServer.events {

    import flash.events.Event;

    public class GetOnlineUsersEvent extends Event {

        private var _onlineUsers:Array;

        public static const GET_ONLINE_USERS:String = "get online users";

        public function GetOnlineUsersEvent (type:String, onlineUsers:Array) {
            this.onlineUsers = onlineUsers;
            super (type);
        }

        public function get onlineUsers ():Array {
            return _onlineUsers;
        }

        public function set onlineUsers (value:Array):void {
            _onlineUsers = value;
        }
    }
}
