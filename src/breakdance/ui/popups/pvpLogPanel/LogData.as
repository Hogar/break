/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 29.10.13
 * Time: 20:07
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.pvpLogPanel {

    import breakdance.core.server.ServerQueryLogData;

    import flash.events.EventDispatcher;

    public class LogData extends EventDispatcher{

        public var shortMessage:String;
        public var fullMessage:String;
        public var errorMessage:String;
        public var serverQueryLog:ServerQueryLogData;
        public var requestType:String;
        private var _time:Date;//Время создания лога.

        public function LogData () {
            _time = new Date ();
        }

        /**
         * Время создания лога.
         */
        public function get time ():String {
            return _time.toLocaleTimeString ();
        }
    }
}
