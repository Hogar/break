/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.03.14
 * Time: 22:11
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socketServer.events {

    import flash.events.Event;

    public class ReceiveAddingStaminaEvent extends Event {

        private var _uid:String;
        private var _addingStamina:int;
        private var _noLessStamina:Boolean = false;
        private var _staminaConsumableId:String = "";

        public static const RECEIVE_ADDING_STAMINA:String = "receive adding stamina";

        public function ReceiveAddingStaminaEvent (addingStamina:int, uid:String, noLessStamina:Boolean, staminaConsumableId:String) {
            this.addingStamina = addingStamina;
            this.uid = uid;
            this.noLessStamina = noLessStamina;
            this.staminaConsumableId = staminaConsumableId;
            super (RECEIVE_ADDING_STAMINA);
        }

        public function get uid ():String {
            return _uid;
        }

        public function set uid (value:String):void {
            _uid = value;
        }

        public function get addingStamina ():int {
            return _addingStamina;
        }

        public function set addingStamina (value:int):void {
            _addingStamina = value;
        }

        public function get noLessStamina ():Boolean {
            return _noLessStamina;
        }

        public function set noLessStamina (value:Boolean):void {
            _noLessStamina = value;
        }

        public function get staminaConsumableId ():String {
            return _staminaConsumableId;
        }

        public function set staminaConsumableId (value:String):void {
            _staminaConsumableId = value;
        }
    }
}
