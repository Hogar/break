/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 06.07.13
 * Time: 16:06
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows {

    import breakdance.BreakdanceApp;
    import breakdance.data.shop.ShopItem;
    import breakdance.ui.screens.shopWindows.events.SelectShopItemEvent;

    import com.hogargames.utils.NumericalUtilities;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class ShopList extends List {

        private var _selectedShopItem:ShopItem;

        private var shopListItems:Vector.<ShopListItem> = new Vector.<ShopListItem> ();

        public function ShopList (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function init (shopItems:Vector.<ShopItem>, currentDressingItemId:String):void {
            clear ();
            //add scroll elements:
            var numShopItems:int = shopItems.length;
            var itemForSelect:ShopItem;//Элемент списка для выделения текущей одетой одежды.
            var itemForSelectPosition:int;//Позиция элемента списка для выделения текущей одетой одежды (для автоматической перемотки).
            for (var i:int = 0; i < numShopItems; i++) {
                var shopShopListItem:ShopListItem = createNewItem ();
                var currentShopIem:ShopItem = shopItems [i];
                shopShopListItem.shopItem = currentShopIem;
                var curRow:int = Math.floor (i / NUM_COLUMNS);
                var curColumn:int = i - curRow * NUM_COLUMNS;
                if (currentShopIem.id == currentDressingItemId) {
                    itemForSelect = currentShopIem;
                    itemForSelectPosition = curRow + 1;
                }
                shopShopListItem.x = curColumn * STEP;
                shopShopListItem.y = curRow * STEP;
                shopShopListItem.addEventListener (MouseEvent.CLICK, clickListener);
                container.addChild (shopShopListItem);
                shopListItems.push (shopShopListItem);

            }

            //set scroll params:
            this.numItems = curRow + 1;

            if (itemForSelect) {
                setSelectedItem (itemForSelect);
                var movingIndex:int = NumericalUtilities.correctValue (
                        itemForSelectPosition - numVisibleItems, 0, getMaxMovingIndex ());
                moveTo (movingIndex);
            }
            else {
                setSelectedItem (null);
                moveTo (0);
            }
        }

        protected function createNewItem ():ShopListItem {
            return new ShopListItem ();
        }

        override public function clear ():void {
            for (var i:int = 0; i < shopListItems.length; i++) {
                var shopShopListItem:ShopListItem = shopListItems [i];
                shopShopListItem.removeEventListener (MouseEvent.CLICK, clickListener);
                if (container.contains (shopShopListItem)) {
                    container.removeChild (shopShopListItem);
                }
                shopShopListItem.destroy ();
            }
            shopListItems = new Vector.<ShopListItem> ();
            _selectedShopItem = null;
        }

        public function get selectedShopItem ():ShopItem {
            return _selectedShopItem;
        }

        //Выделение ближайшего доступного предмета:
        public function selectFirstAvailableItem ():void {
            for (var i:int = 0; i < shopListItems.length; i++) {
                if (shopListItems [i].enable) {
                    var shopItem:ShopItem = shopListItems [i].shopItem;
                    if (shopItem) {
                        setSelectedItem (shopItem);
                        return;
                    }
                }
            }
        }

        override public function destroy ():void {
            clear ();
            super.destroy ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setSelectedItem (shopItem:ShopItem):void {
            _selectedShopItem = shopItem;
            for (var i:int = 0; i < shopListItems.length; i++) {
                var currentShopShopListItem:ShopListItem = shopListItems [i];
                currentShopShopListItem.selected = (shopItem && (currentShopShopListItem.shopItem == shopItem));
            }
            if (_selectedShopItem) {
                BreakdanceApp.instance.appUser.character.fitting (_selectedShopItem);
            }
            dispatchEvent (new SelectShopItemEvent (_selectedShopItem));
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var shopShopListItem:ShopListItem = ShopListItem (event.currentTarget);
            if (shopShopListItem && shopShopListItem.enable) {
                setSelectedItem (shopShopListItem.shopItem);
            }
        }
    }
}
