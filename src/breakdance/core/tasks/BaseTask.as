package breakdance.core.tasks 
{

    import flash.events.EventDispatcher;

    /**
	 * ...
	 * @author Alexey Stashin
	 */
	public class BaseTask extends EventDispatcher
	{
		
		public function BaseTask() 
		{
		}
		
		public function destroy():void
		{
			cancel();
		}
		
		public function start():void
		{
		}
		
		public function cancel():void
		{
		}
		
	}

}