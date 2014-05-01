/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.07.13
 * Time: 0:51
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.events {

    import breakdance.data.shop.ShopItem;

    import flash.events.Event;

    public class SelectShopItemEvent extends Event {

        private var _shopItem:ShopItem;

        public static const SELECT_SHOP_ITEM:String = "select shop item";

        public function SelectShopItemEvent (shopItem:ShopItem, type:String = SELECT_SHOP_ITEM, bubbles:Boolean = false, cancelable:Boolean = true) {
            this.shopItem = shopItem;
            super (type, bubbles, cancelable)
        }

        public function get shopItem ():ShopItem {
            return _shopItem;
        }

        public function set shopItem (value:ShopItem):void {
            _shopItem = value;
        }

    }
}
