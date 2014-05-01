/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 14.03.14
 * Time: 4:29
 * To change this template use File | Settings | File Templates.
 */
package breakdance.events {

    import flash.events.Event;

    public class LoadingStepEvent extends Event {

        private var _message:String;

        public static const START_LOADING_STEP:String = "start loading step";

        public function LoadingStepEvent (type:String, message:String) {
            this._message = message;
            super (type);
        }

        public function get message ():String {
            return _message;
        }

        public function set message (value:String):void {
            _message = value;
        }
    }
}
