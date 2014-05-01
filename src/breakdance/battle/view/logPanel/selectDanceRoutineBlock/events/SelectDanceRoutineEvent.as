/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 25.09.13
 * Time: 15:28
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.selectDanceRoutineBlock.events {

    import flash.events.Event;

    public class SelectDanceRoutineEvent extends Event {

        public static const UPDATE_DANCE_ROUTINE:String = "update dance routine";
        public static const COMPLETE_DANCE_ROUTINE:String = "complete dance routine";
        public static const SHOW_RESTORE_STAMINA_POP_UP:String = "show restore stamina pop up";
        public static const GO:String = "go";

        public function SelectDanceRoutineEvent (type:String = COMPLETE_DANCE_ROUTINE, bubbles:Boolean = false, cancelable:Boolean = true) {
            super (type, bubbles, cancelable);
        }
    }
}
