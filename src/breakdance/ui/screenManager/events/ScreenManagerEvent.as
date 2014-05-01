/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.12.13
 * Time: 18:38
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screenManager.events {

    import flash.events.Event;

    public class ScreenManagerEvent extends Event {

        private var _screenId:String;

        public static const NAVIGATE_TO:String = "navigate to";
        public static const REINIT:String = "reinit";

        public function ScreenManagerEvent (screenId:String, type:String = NAVIGATE_TO) {
            this.screenId = screenId;
            super (type);
        }

        public function get screenId ():String {
            return _screenId;
        }

        public function set screenId (value:String):void {
            _screenId = value;
        }
    }
}
