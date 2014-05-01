/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.03.14
 * Time: 21:07
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.events {

    import flash.events.Event;

    public class UseStaminaConsumableEvent extends Event {

        private var _addingStamina:int;
        private var _staminaConsumableId:String;

        public static const USE_STAMINA_CONSUMABLE:String = "use stamina consumable";

        public function UseStaminaConsumableEvent (addingStamina:int, staminaConsumableId:String) {
            this.addingStamina = addingStamina;
            this.staminaConsumableId = staminaConsumableId;
            super (USE_STAMINA_CONSUMABLE);
        }

        public function get staminaConsumableId ():String {
            return _staminaConsumableId;
        }

        public function set staminaConsumableId (value:String):void {
            _staminaConsumableId = value;
        }

        public function get addingStamina ():int {
            return _addingStamina;
        }

        public function set addingStamina (value:int):void {
            _addingStamina = value;
        }
    }
}
