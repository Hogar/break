/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 25.06.13
 * Time: 17:34
 * To change this template use File | Settings | File Templates.
 */
package breakdance.core.ui.events {

    import flash.events.Event;

    public class ScreenEvent extends Event {

        public static const SHOW_SCREEN:String = "show screen";
        public static const HIDE_SCREEN:String = "hide screen";

        public function ScreenEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = true) {
            super (type, bubbles, cancelable);
        }
    }
}
