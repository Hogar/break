package breakdance.core.tasks
{

    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;

    public class JsQueryTask extends BaseTask
	{
		private var _method:String;
		private var _params:Array;
		private var _responseCallback:Function;
		
		public function JsQueryTask(method:String, params:Array, responseCallback:Function)
		{
			_method = method;
			_params = params;
			_responseCallback = responseCallback;
		}
		
		override public function start():void
		{
			JsApi.instance.query(_method, onComplete, _params);
		}
		
		override public function cancel():void
		{
			_responseCallback = null;
		}
		
		private function onError(message:String):void 
		{
			dispatchEvent( new TaskEvent(TaskEvent.TASK_ERROR,message) );
		}
		
		private function onComplete(response:JsQueryResult):void 
		{
			_responseCallback(response);
			_responseCallback = null;
			
			dispatchEvent( new TaskEvent(TaskEvent.TASK_PROGRESS,"",1.0) );
			dispatchEvent( new TaskEvent(TaskEvent.TASK_COMPLETE) );
		}
	}
}