package breakdance.core.js
{

    import flash.events.Event;

    public class JsApiEvent extends Event
	{
		static public const JS_CALL_BACK : String = 'JS_CALL_BACK';

		private var _data : String;

		public function JsApiEvent ( data:String ) {
			_data = data;
			super( JsApiEvent.JS_CALL_BACK, false, false );
		}

		public function get data () : String {
			return _data;
		}
	}
}