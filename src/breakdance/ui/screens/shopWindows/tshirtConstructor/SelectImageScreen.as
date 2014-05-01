/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.08.13
 * Time: 1:22
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.tshirtConstructor {

    import breakdance.BreakdanceApp;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.ui.screens.shopWindows.events.SelectShopItemEvent;
    import breakdance.ui.screens.shopWindows.tshirtConstructor.events.SelectImageEvent;

    import com.hogargames.app.screens.IScreen;
    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;

    public class SelectImageScreen extends GraphicStorage implements IScreen {

        private var shopList:TshirtList;

        public function SelectImageScreen (mc:MovieClip) {
            super (mc);

        }

        public function onShow ():void {
            var items:Vector.<ShopItem> = ShopItemCollection.instance.getShopItemsByCategory (ShopItemCategory.T_SHIRTS);
            shopList.init (items, null);
//            shopList.selectFirstAvailableItem ();
        }

        public function get selectedItem ():ShopItem {
            return shopList.selectedShopItem;
        }

        public function onHide ():void {
            shopList.clear ();
            BreakdanceApp.instance.hideTooltip ();
        }

        override protected function initGraphicElements ():void {
            shopList = new TshirtList (getElement ("mcImagesList"));
            shopList.addEventListener (SelectShopItemEvent.SELECT_SHOP_ITEM, selectShopItemListener);
        }

        private function selectShopItemListener (event:SelectShopItemEvent):void {
            var shopItem:ShopItem = event.shopItem;
            if (shopItem) {
                dispatchEvent (new SelectImageEvent (shopItem.id));
            }
        }

    }
}
