/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.09.13
 * Time: 12:58
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.selectDanceRoutineBlock.selectDanceMoveBlock.events {

    import breakdance.battle.data.BattleDanceMoveData;

    import flash.events.Event;

    public class SelectDanceMoveEvent extends Event {

        private var _battleDanceMoveData:BattleDanceMoveData;

        public static const SELECT_DANCE_MOVE:String = "select dance move";

        public function SelectDanceMoveEvent (battleDanceMoveData:BattleDanceMoveData, type:String = SELECT_DANCE_MOVE, bubbles:Boolean = false, cancelable:Boolean = true) {
            this.battleDanceMoveData = battleDanceMoveData;
            super (type, bubbles, cancelable);
        }

        public function get battleDanceMoveData ():BattleDanceMoveData {
            return _battleDanceMoveData;
        }

        public function set battleDanceMoveData (value:BattleDanceMoveData):void {
            _battleDanceMoveData = value;
        }
    }
}
