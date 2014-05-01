/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 28.07.13
 * Time: 8:46
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.battleListPopUp.events {

    import breakdance.battle.data.BattleData;

    import flash.events.Event;

    public class SelectBattleEvent extends Event {

        private var _battleData:BattleData;

        public static const SELECT_BATTLE:String = "select battle";

        public function SelectBattleEvent (battleData:BattleData, type:String = SELECT_BATTLE, bubbles:Boolean = false, cancelable:Boolean = true) {
            this.battleData = battleData;
            super (type, bubbles, cancelable);
        }

        public function get battleData ():BattleData {
            return _battleData;
        }

        public function set battleData (value:BattleData):void {
            _battleData = value;
        }
    }
}
