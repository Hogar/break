/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.08.13
 * Time: 12:41
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.events {

    import breakdance.user.UserPurchasedItem;

    import flash.events.Event;

    public class SelectUserPurchaseItemEvent extends Event {

            private var _userPurchasedItem:UserPurchasedItem;

            public static const SELECT_USER_PURCHASE_ITEM:String = "select user purchase item";

            public function SelectUserPurchaseItemEvent (userPurchaseItem:UserPurchasedItem, type:String = SELECT_USER_PURCHASE_ITEM, bubbles:Boolean = false, cancelable:Boolean = true) {
                this.userPurchasedItem = userPurchaseItem;
                super (type, bubbles, cancelable)
            }

            public function get userPurchasedItem ():UserPurchasedItem {
                return _userPurchasedItem;
            }

            public function set userPurchasedItem (value:UserPurchasedItem):void {
                _userPurchasedItem = value;
            }

        }
    }
