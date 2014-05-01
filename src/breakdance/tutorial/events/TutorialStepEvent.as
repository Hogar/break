/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.02.14
 * Time: 11:08
 * To change this template use File | Settings | File Templates.
 */
package breakdance.tutorial.events {

    import flash.events.Event;

    public class TutorialStepEvent extends Event {

        private var _completedStep:String;

        public static const COMPLETE_TUTORIAL_STEP:String = "complete tutorial step";
        public static const SET_TUTORIAL_STEP:String = "set tutorial step";

        public function TutorialStepEvent (completedStep:String, type:String = COMPLETE_TUTORIAL_STEP) {
            this.completedStep = completedStep;
            super (type);
        }

        public function get completedStep ():String {
            return _completedStep;
        }

        public function set completedStep (value:String):void {
            _completedStep = value;
        }
    }
}
