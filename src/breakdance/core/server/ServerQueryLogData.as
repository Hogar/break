/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 30.10.13
 * Time: 7:32
 * To change this template use File | Settings | File Templates.
 */
package breakdance.core.server {

    import flash.events.Event;
    import flash.events.EventDispatcher;

    public class ServerQueryLogData extends EventDispatcher {

        public var timestamp:int = -1;
        public var requestTime:Date;
        public var request:String;
        public var answerTime:Date;
        private var _answer:String;
        private var _errorMessage:String;

        private var _repeats:Vector.<ServerQueryLogData> = new Vector.<ServerQueryLogData> ();

        public function ServerQueryLogData () {

        }

        public function get answer ():String {
            return _answer;
        }

        public function set answer (value:String):void {
            _answer = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function get errorMessage ():String {
            return _errorMessage;
        }

        public function set errorMessage (value:String):void {
            _errorMessage = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        /**
         * Добавление повтора серверного запроса.
         * @param repeatServerQueryLog
         */
        public function addRepeat (repeatServerQueryLog:ServerQueryLogData):void {
            if (repeatServerQueryLog) {
                _repeats.push (repeatServerQueryLog);
                dispatchEvent (new Event (Event.CHANGE));
            }
        }

        /**
         * Список повторы запроса.
         */
        public function get repeats ():Vector.<ServerQueryLogData> {
            return _repeats;
        }
    }
}
