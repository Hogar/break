package breakdance.core.js {

    import com.hogargames.debug.Tracer;

    import flash.external.ExternalInterface;

    public class JsQuery {
        public function JsQuery (type:String, callBack:Function, params:Array) {
            _type = type;
            _callBack = callBack;
            if (params != null) {
                _params = params;
            }
        }

        private var _type:String;
        private var _callBack:Function;
        private var _params:Array = [];

        public function go ():void {
            Tracer.log ('-----------------------------------');
            if (ExternalInterface.available) {
                callQuery ();
            }
            else {
                tmpFakeData ();
            }
        }

        private function callBack (data:String):void {
            Tracer.log ('JS QUERY RESULT: ' + data);

            var result:JsQueryResult = new JsQueryResult ();

            result.parseJsonData (data);

            if (_callBack != null) {
                _callBack (result);
            }
        }

        private function callQuery ():void {
            JsApi.instance.addEventListener (JsApiEvent.JS_CALL_BACK, onJsCallBack);

            var paramsStr:String = '';
            for each(var param:* in _params) {
                if (paramsStr != '')
                    paramsStr += ',';
                paramsStr += "'" + param + "'";
            }
            Tracer.log ('JS API QUERY: ' + _type + '(' + paramsStr + ')');
            //trace('JS API Query: '+_type+'('+paramsStr+')');

            switch (_params.length) {
                default:
                case 0:
                    ExternalInterface.call (_type);
                    break;

                case 1:
                    ExternalInterface.call (_type, _params[0]);
                    break;

                case 2:
                    ExternalInterface.call (_type, _params[0], _params[1]);
                    break;

                case 3:
                    ExternalInterface.call (_type, _params[0], _params[1], _params[2]);
                    break;

                case 4:
                    ExternalInterface.call (_type, _params[0], _params[1], _params[2], _params[3]);
                    break;

                case 5:
                    ExternalInterface.call (_type, _params[0], _params[1], _params[2], _params[3], _params[4]);
                    break;
                case 6:
                    ExternalInterface.call (_type, _params[0], _params[1], _params[2], _params[3], _params[4], _params[5]);
                    break;
                case 7:
                    ExternalInterface.call (_type, _params[0], _params[1], _params[2], _params[3], _params[4], _params[5], _params[6]);
                    break;
            }
        }

        private function onJsCallBack (e:JsApiEvent):void {
            JsApi.instance.removeEventListener (JsApiEvent.JS_CALL_BACK, onJsCallBack);
            callBack (e.data);
        }

        private function tmpFakeData ():void {
            var paramsStr:String = '';
            for each (var param:* in _params) {
                if (paramsStr != '')
                    paramsStr += ',';
                paramsStr += "'" + param + "'";
            }
            //trace('JS API Query: '+_type+'('+paramsStr+')');

            var data:*;
            switch (_type) {
                /*				case JsApi.WRITE_WALL:
                 data = '{"write":1}';
                 break;
                 */
            }

            if (data == null) {
                Tracer.log ('JS UNDEFINED METHOD');
            }
            callBack (data);
        }
    }
}