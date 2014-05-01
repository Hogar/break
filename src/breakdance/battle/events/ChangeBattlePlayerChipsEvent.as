/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.03.14
 * Time: 9:48
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.events {

    import flash.events.Event;

    public class ChangeBattlePlayerChipsEvent extends Event {

        private var _previousChips:int;
        private var _currentChips:int;

        public static const CHANGE_CHIPS:String = "change chips";

        public function ChangeBattlePlayerChipsEvent (previousChips:int = 0, currentChips:int = 0) {
            super (CHANGE_CHIPS);
            this.previousChips = previousChips;
            this.currentChips = currentChips;
        }

        public function get previousChips ():int {
            return _previousChips;
        }

        public function set previousChips (value:int):void {
            _previousChips = value;
        }

        public function get currentChips ():int {
            return _currentChips;
        }

        public function set currentChips (value:int):void {
            _currentChips = value;
        }
    }
}
