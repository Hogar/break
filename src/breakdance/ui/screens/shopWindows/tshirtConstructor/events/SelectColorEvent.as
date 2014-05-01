/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.08.13
 * Time: 11:14
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.tshirtConstructor.events {

    import flash.events.Event;

    public class SelectColorEvent extends Event {

        private var _color:String;

        public static const SELECT_COLOR:String = "select color";

        public function SelectColorEvent (color:String, type:String = SELECT_COLOR, bubbles:Boolean = false, cancelable:Boolean = true) {
            this.color = color;
            super (type, bubbles, cancelable);
        }

        public function get color ():String {
            return _color;
        }

        public function set color (value:String):void {
            _color = value;
        }
    }
}
