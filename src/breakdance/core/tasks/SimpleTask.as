package breakdance.core.tasks 
{
	
	/**
	 * ...
	 * @author Alexey Stashin
	 */
	public class SimpleTask extends BaseTask 
	{
		private var _taskFunc:Function;
		
		public function SimpleTask(taskFunc:Function) 
		{
			_taskFunc = taskFunc;
		}
		
		override public function start():void
		{
			if(_taskFunc())
				dispatchEvent( new TaskEvent(TaskEvent.TASK_COMPLETE) );
			else
				dispatchEvent( new TaskEvent(TaskEvent.TASK_ERROR,'Something wrong '+_taskFunc) );
		}
		
		override public function cancel():void
		{
			_taskFunc = null;
		}
		
	}

}