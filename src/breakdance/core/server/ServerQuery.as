package breakdance.core.server {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalConstants;
    import breakdance.core.texts.TextsManager;
    import breakdance.ui.popups.PopUpManager;

    import com.adobe.crypto.MD5;
    import com.hogargames.debug.Tracer;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class ServerQuery {

        private var _method:String;
        private var _params:Object;

        private var _completeCallback:Function;
        private var _errorCallback:Function;
        private var _showErrorPopUp:Boolean;

        private var _serverQueryLog:ServerQueryLogData;

        private var _loader:URLLoader;

        private static const NICKNAME:String = 'nickname';

        public function ServerQuery (method:String, params:Object, completeCallback:Function, errorCallback:Function, serverQueryLog:ServerQueryLogData, showErrorPopUp:Boolean = true) {
            _method = method;
            _params = params ? params : {};

            _completeCallback = completeCallback;
            _errorCallback = errorCallback;
            _showErrorPopUp = showErrorPopUp;

            this._serverQueryLog = serverQueryLog;

            init ();
        }

        private function init ():void {
            //_params.method = _method;
            _params.viewer_id = BreakdanceApp.instance.appUser.uid;
            _params.auth_key = BreakdanceApp.instance.appUser.authKey;

            var serverUrl:String = GlobalConstants.SERVER_API_URL;
            CONFIG::debug {
                serverUrl = GlobalConstants.SERVER_API_DEV_URL;
            }
            var request:URLRequest = new URLRequest (serverUrl + _method);
            request.data = paramsToString (_params);

            Tracer.log ('-----------------------------------');
            Tracer.log ("SERVER QUERY: " + request.url + '?' + request.data);
            if (_serverQueryLog) {
                _serverQueryLog.requestTime = new Date ();
                _serverQueryLog.request = request.url + '?' + request.data;
            }

            _loader = new URLLoader ();
            _loader.addEventListener (Event.COMPLETE, onComplete);
            _loader.addEventListener (IOErrorEvent.IO_ERROR, onIOError);
            _loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            _loader.load (request);
        }

        public function destroy ():void {
            if (_loader) {
                _loader.removeEventListener (Event.COMPLETE, onComplete);
                _loader.removeEventListener (IOErrorEvent.IO_ERROR, onIOError);
                _loader.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
                _loader.close ();
                _loader = null;
            }

            _completeCallback = null;
            _errorCallback = null;

            _params = null;
        }

        private function onIOError (e:IOErrorEvent):void {
            Tracer.log ('SERVER QUERY ERROR: ' + e.text);

            if (_serverQueryLog) {
                _serverQueryLog.errorMessage = "Ошибка отправки.";
            }

            if (_errorCallback != null) {
                _errorCallback (e.text);
            }
            destroy ();
        }

        private function onSecurityError (e:SecurityErrorEvent):void {
            Tracer.log ('SERVER QUERY ERROR: ' + e.text);

            if (_serverQueryLog) {
                _serverQueryLog.errorMessage = "Ошибка безопастности.";
            }

            if (_errorCallback != null) {
                _errorCallback (e.text);
            }
            destroy ();
        }

        private function onComplete (e:Event):void {
            Tracer.log ('SERVER QUERY ANSWER: ' + e.target.data);

            if (_serverQueryLog) {
                _serverQueryLog.answerTime = new Date ();
                _serverQueryLog.answer = e.target.data;
            }

            var data:Object;
            try {
                data = JSON.parse (e.target.data);
            }
            catch (error:Error) {
                var xml:XML;
                try {
                    xml = XML (e.target.data);
                }
                catch (error:Error) {
                    xml = new XML ();
                }
                var errorMessage:String = "Invalid JSON";
                if (xml) {
                    if (xml.hasOwnProperty ("body")) {
                        var body:XML = XML (xml.body);
                        if (body.hasOwnProperty ("h3")) {
                            errorMessage = body.h3 [0];
                        }
                    }
                }
                data = {response_code:ServerQueryError.INVALID_JSON_ERROR, error:errorMessage};
            }

            if (_completeCallback != null) {
                if (data) {
                    if (data.hasOwnProperty ("response_code") && data.hasOwnProperty ("error")) {
                        var requestAsText:String = "";
                        if (_serverQueryLog) {
                            requestAsText = _serverQueryLog.request;
                        }
                        if (data.response_code != 1) {
                            CONFIG::debug {
                                trace ("");
                                //
                            }
                            var message:String = "";
                            var textManager:TextsManager = TextsManager.instance;
                            if (data.response_code == 2) {
                                message += textManager.getText ("error2text") + '\n';
                                CONFIG::mixpanel {
                                    BreakdanceApp.mixpanel.track(
                                            'error',
                                            {'method':_method,'type':"2",'request':requestAsText,'errorMessage':errorMessage}
                                    );
                                }
                            }
                            else if (data.response_code == 3) {
                                message += textManager.getText ("error3text") + '\n';
                                CONFIG::mixpanel {
                                    BreakdanceApp.mixpanel.track(
                                            'error',
                                            {'method':_method,'type':"3"}
                                    );
                                }
                            }
                            else if (data.response_code == 4) {
                                message += textManager.getText ("error4text") + '\n';
                                CONFIG::mixpanel {
                                    BreakdanceApp.mixpanel.track(
                                            'error',
                                            {'method':_method,'type':"4"}
                                    );
                                }
                            }
                            else if (data.response_code == 21) {
                                message += textManager.getText ("error21text") + '\n';
                                CONFIG::mixpanel {
                                    var date:Date = new Date ();
                                    BreakdanceApp.mixpanel.track(
                                            'error',
                                            {'method':_method,'type':"21",'timezoneOffset':date.timezoneOffset}
                                    );
                                }
                            }
                            else if (data.response_code == 31) {
                                message += "error31text";
                                CONFIG::mixpanel {
                                    BreakdanceApp.mixpanel.track(
                                            'error',
                                            {'method':_method,'type':"31",'request':requestAsText,'errorMessage':errorMessage}
                                    );
                                }
                            }
                            message += 'Request: "' + _method + '"\n';
                            message += 'Response code: "' + data.response_code + '"\n';
                            message += 'Error: "' + data.error + '"\n';
                            var title:String = TextsManager.instance.getText ("errorTitle");
                            if (_serverQueryLog) {
                                _serverQueryLog.errorMessage = "response_code = " + data.response_code;
                            }
                            if (_showErrorPopUp) {
                                PopUpManager.instance.errorPopUp.showMessage (title, message);
                            }
                        }
                    }
                }
                _completeCallback (data);
            }
            destroy ();
        }

        private static function paramsToString (params:Object):String {
            //сортируем параметры по алфавиту:
            var paramsAsArray:Array = [];
            for (var key:String in params) {
                paramsAsArray.push (key);
            }
            paramsAsArray.sort ();

            //формируем строку запроса и строку для перевода в md5:
            var str:String = '';
            var dataStr:String = '';
            for (var i:int = 0; i < paramsAsArray.length; i++) {
                key = paramsAsArray [i];
                if (str != '') {
                    str += '&';
                }
                str += key + '=' + escape (params [key]);
                if (key != NICKNAME) {
                    dataStr += key + params [key];
                }
            }
//            var ts:String = String (new Date ().getTime ());
            var ts:String = String (ServerTime.instance.time);
            var dataStrToMD5:String = MD5.hash (GlobalConstants.SECRET_KEY + ts + dataStr);
            var access_key:String = MD5.hash (GlobalConstants.SECRET_KEY + dataStrToMD5);
            str += '&' + "ts=" + ts;
            str += '&' + "access_key=" + access_key;
            return str;
        }

    }

}