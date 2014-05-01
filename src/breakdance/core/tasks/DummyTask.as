package breakdance.core.tasks
{

    import com.greensock.TweenLite;

    public class DummyTask extends BaseTask
	{
		private var count:int=0;
		private var maxCount:int = 3;
		
		public function DummyTask()
		{
			super();
		}
		
		override public function start():void
		{
			dispatchEvent( new TaskEvent(TaskEvent.TASK_PROGRESS,"",0) );
			
			TweenLite.delayedCall(1.0,onProgress);
		}
		
		private function onProgress():void
		{
			count++;
			if(count>=maxCount)
			{
				dispatchEvent( new TaskEvent(TaskEvent.TASK_PROGRESS,"",1.0) );
				dispatchEvent( new TaskEvent(TaskEvent.TASK_COMPLETE) );
			}
			else
			{
				dispatchEvent( new TaskEvent(TaskEvent.TASK_PROGRESS,"",count/(1.0*maxCount)) );
				TweenLite.delayedCall(1.0,onProgress);
			}
		}
	}
}