package breakdance.core.tasks {

    import breakdance.core.server.ServerApi;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class ServerQueryTask extends BaseTask {
        private var _method:String;
        private var _params:Object;
        private var _responseCallback:Function;

        public function ServerQueryTask (method:String, params:Object, responseCallback:Function) {
            _method = method;
            _params = params;
            _responseCallback = responseCallback;
        }

        override public function start ():void {
            ServerApi.instance.query (_method, _params, onComplete, onError);
        }

        override public function cancel ():void {
            _responseCallback = null;
        }

        private function onError (message:String):void {
            dispatchEvent (new TaskEvent (TaskEvent.TASK_ERROR, message));
        }

        private function onComplete (response:Object):void {
            _responseCallback (response);
            _responseCallback = null;

            dispatchEvent (new TaskEvent (TaskEvent.TASK_PROGRESS, "", 1.0));
            dispatchEvent (new TaskEvent (TaskEvent.TASK_COMPLETE));
        }

    }

}