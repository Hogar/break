package breakdance.core.server {

    import com.adobe.utils.DateUtil;
    import com.hogargames.errors.SingletonError;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class ServerTime {
        // локальное время синхронизации
        private var _startServerTime:Date;
        private var _startLocalTime:Date;

        private var _timeZoneStr:String = "-00:00";

        static private var _instance:ServerTime;

        public function ServerTime (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }

            _startLocalTime = new Date ();
            _startServerTime = _startLocalTime;
        }

        static public function get instance ():ServerTime {
            if (!_instance) {
                _instance = new ServerTime (new SingletonKey ());
            }
            return _instance;
        }

        public function synchronize (dateStr:String):void {
            _startLocalTime = new Date ();
            _startServerTime = parseDateStr (dateStr);
        }

        /**
         * Get current server's time
         */
        public function get time ():Number {
            if (_startLocalTime && _startServerTime) {
                // Получаем разницу в миллисекундах между локальным стартовым временем и локальным текущим,
                // прибавляем эту разницу к серверному стартовому времени
                var now:Date = new Date ();
                var delta:int = (now.time - _startLocalTime.time );
                var currentServerMilliseconds:Number = _startServerTime.time + delta;

                return currentServerMilliseconds;
            }
            else {
                return 0;
            }
        }
	

		// день (номер в месяце) чисто твоего раёна
		public function get date ():Number {
			
			var localDate: Date = new Date(_startServerTime.time + delta);    // дожен совпасть с текущим        
			return localDate.date;
		}
        
        /**
         * Get current server's time
         */
        public function get delta ():Number {
            if (_startLocalTime && _startServerTime) {
                // Получаем разницу в миллисекундах между локальным стартовым временем и локальным текущим,
                // прибавляем эту разницу к серверному стартовому времени
                var delta:Number = (_startServerTime.time - _startLocalTime.time);
                return delta;
            }
            else {
                return 0;
            }
        }

        public function parseDateStr (dateStr:String):Date {
            var tempArr:Array = dateStr.split (" ");
            if (tempArr.length < 2) {
                return null;
            }

            if (tempArr.length == 3) {
                _timeZoneStr = tempArr[2];
            }

            var tempStr:String = tempArr[0] + "T" + tempArr[1] + _timeZoneStr;

            return DateUtil.parseW3CDTF (tempStr);
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}