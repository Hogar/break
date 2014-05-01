package breakdance.core.tasks {

    import breakdance.core.IAsyncInitObject;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class AsyncInitTask extends BaseTask {
        private var _object:IAsyncInitObject;

        public function AsyncInitTask (object:IAsyncInitObject) {
            _object = object;
        }

        override public function start ():void {
            dispatchEvent (new TaskEvent (TaskEvent.TASK_PROGRESS, "", 0));
            _object.init (onComplete, onError, onProgress);
        }

        override public function cancel ():void {
            _object = null;
        }

        private function onError (message:String):void {
            dispatchEvent (new TaskEvent (TaskEvent.TASK_ERROR, message));
        }

        private function onComplete ():void {
            dispatchEvent (new TaskEvent (TaskEvent.TASK_PROGRESS, "", 1.0));
            dispatchEvent (new TaskEvent (TaskEvent.TASK_COMPLETE));
        }

        private function onProgress (ratio:Number, message:String = ""):void {
            dispatchEvent (new TaskEvent (TaskEvent.TASK_PROGRESS, message, ratio));
        }

    }

}