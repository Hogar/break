package breakdance.core.tasks 
{

    import flash.events.Event;

    /**
	 * ...
	 * @author Alexey Stashin
	 */
	public class TaskEvent extends Event
	{
		public static const TASK_START:String = 'TASK_START';
		public static const TASK_COMPLETE:String = 'TASK_COMPLETE';
		public static const TASK_ERROR:String = 'TASK_ERROR';
		public static const TASK_PROGRESS:String = 'TASK_PROGRESS';
		
		private var _message:String;
		private var _ratio:Number;
		
		public function TaskEvent(type:String, message:String = '', ratio:Number = 0)
		{
			super(type);
			_message = message;
			_ratio = ratio;
		}
		
		public override function clone():Event
		{
			return new TaskEvent(type,message,ratio);
		}
		
		public function get ratio():Number 
		{
			return _ratio;
		}
		
		public function get message():String 
		{
			return _message;
		}
	}

}