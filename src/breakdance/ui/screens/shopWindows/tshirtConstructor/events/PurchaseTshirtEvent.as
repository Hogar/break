/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.08.13
 * Time: 11:27
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.tshirtConstructor.events {

    import flash.events.Event;

    public class PurchaseTshirtEvent extends Event {

        public static const PURCHASE:String = "purchase";
        public static const PURCHASE_AND_DRESS:String = "purchase and dress";

        public function PurchaseTshirtEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = true) {
            super (type, bubbles, cancelable);
        }

    }
}

