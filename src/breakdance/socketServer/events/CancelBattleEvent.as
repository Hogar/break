/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.11.13
 * Time: 5:36
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socketServer.events {

    import flash.events.Event;

    public class CancelBattleEvent extends Event {

        private var _uid:String;

        public static const OPPONENT_CANCEL_BATTLE:String = "opponent cancel battle";

        public function CancelBattleEvent (type:String, uid:String) {
            this.uid = uid;
            super (type)
        }

        public function get uid ():String {
            return _uid;
        }

        public function set uid (value:String):void {
            _uid = value;
        }
    }
}
