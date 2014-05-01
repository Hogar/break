/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 13.11.13
 * Time: 18:01
 * To change this template use File | Settings | File Templates.
 */
package breakdance.events {

    import flash.events.Event;

    public class BreakDanceAppEvent extends Event {

        public static const END_CHARACTER_MOVING:String = "end character moving";
        public static const CREATE_SCREEN_SHOT:String = "create screen shot";

        public function BreakDanceAppEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = true) {
            super (type, bubbles, cancelable);
        }
    }
}
