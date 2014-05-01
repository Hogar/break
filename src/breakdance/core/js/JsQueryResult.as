package breakdance.core.js {

    import com.hogargames.debug.Tracer;

    /**
     * Implements server query result
     */
    public class JsQueryResult {
        public function JsQueryResult () {
        }

        public var answer:String;

        private var _success:Boolean = false;
        private var _totalKeys:int = -1;
        private var _data:Object = {};
        private var _tmp:String;

        /**
         * If the request was successfully processed by the server
         */
        public function get success ():Boolean {
            return _success;
        }

        /**
         * Return total fields in data object
         */
        public function get totalKeys ():uint {
            if (_totalKeys == -1) {
                _totalKeys = 0;
                for (_tmp in data) {
                    _totalKeys++;
                }
            }
            return _totalKeys;
        }

        /**
         * Parsed data
         */
        public function get data ():Object {
            return _data;
        }

        public function destroyObject ():void {
            _data = null;
        }

        /**
         * Parse server answer in JSON format, init success state
         */
        internal function parseJsonData (json:String):void {
            answer = json;
            try {
                _data = JSON.parse (json);
                _success = true;
            }
            catch (error:Error) {
                Tracer.log ("PARSE JSON ERROR: " + error.message);
            }
        }
    }
}