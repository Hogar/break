/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.02.14
 * Time: 11:39
 * To change this template use File | Settings | File Templates.
 */
package breakdance.tutorial.events {

    import flash.events.Event;

    public class TutorialEvent extends Event {

        public static const START_TUTORIAL:String = "start tutorial";
        public static const FINISH_TUTORIAL:String = "finish tutorial";

        public function TutorialEvent (type:String) {
            super (type);
        }
    }
}
