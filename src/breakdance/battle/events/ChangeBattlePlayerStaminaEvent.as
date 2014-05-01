/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 24.01.14
 * Time: 13:50
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.events {

    import flash.events.Event;

    public class ChangeBattlePlayerStaminaEvent extends Event {

        private var _previousStamina:int;
        private var _currentStamina:int;

        public static const CHANGE_STAMINA:String = "change stamina";

        public function ChangeBattlePlayerStaminaEvent (previousStamina:int = 0, currentStamina:int = 0) {
            super (CHANGE_STAMINA);
            this.previousStamina = previousStamina;
            this.currentStamina = currentStamina;
        }

        public function get previousStamina ():int {
            return _previousStamina;
        }

        public function set previousStamina (value:int):void {
            _previousStamina = value;
        }

        public function get currentStamina ():int {
            return _currentStamina;
        }

        public function set currentStamina (value:int):void {
            _currentStamina = value;
        }
    }
}
