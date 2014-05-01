/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.03.14
 * Time: 16:13
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.restoreStaminaPopUp.events {

    import flash.events.Event;

    public class StaminaConsumableEvent extends Event {

        public static const BUY_STAMINA_CONSUMABLE:String = "buy stamina consumable";
        public static const USE_STAMINA_CONSUMABLE:String = "use stamina consumable";

        public function StaminaConsumableEvent (type:String) {
            super (type);
        }
    }
}
