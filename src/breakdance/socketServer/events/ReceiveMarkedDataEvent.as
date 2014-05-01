/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.12.13
 * Time: 4:14
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socketServer.events {

    import flash.events.Event;

    public class ReceiveMarkedDataEvent extends Event {

        private var _marker:String;

        public static const RECEIVE_MARKED_DATA:String = "receive marked data";

        public function ReceiveMarkedDataEvent (marker:String) {
            this.marker = marker;
            super (RECEIVE_MARKED_DATA)
        }

        public function get marker ():String {
            return _marker;
        }

        public function set marker (value:String):void {
            _marker = value;
        }
    }
}
