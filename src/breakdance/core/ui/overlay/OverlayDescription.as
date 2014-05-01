package breakdance.core.ui.overlay
{

    import flash.display.DisplayObject;

    internal class OverlayDescription
	{
		public var object:DisplayObject;
		public var priority:uint;
		
		public function OverlayDescription(aObject:DisplayObject, aPriority:uint)
		{
			object = aObject;
			priority = aPriority;
		}
	}
}