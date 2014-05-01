package breakdance.core 
{
	
	/**
	 * ...
	 * @author Alexey Stashin
	 */
	public interface IAsyncInitObject 
	{
		function init (completeCallback:Function, errorCallback:Function, progressCallback:Function):void;
	}
	
}