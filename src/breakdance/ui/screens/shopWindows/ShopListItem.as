/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.08.13
 * Time: 11:04
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows {

    import breakdance.BreakdanceApp;
    import breakdance.data.shop.ShopItem;
    import breakdance.ui.commons.ItemView;
    import breakdance.user.AppUser;

    import flash.events.MouseEvent;

    public class ShopListItem extends ListItem {

        protected var _shopItem:ShopItem;

        private var itemView:ItemView;

        public function ShopListItem () {
            super ();
            itemView = new ItemView ();
            itemViewContainer.addChild (itemView);
            itemView.x = -ITEM_VIEW_INDENT;
            itemView.y = -ITEM_VIEW_INDENT;

        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get shopItem ():ShopItem {
            return _shopItem;
        }

        public function set shopItem (value:ShopItem):void {
            _shopItem = value;
            var shopItemId:String;
            if (_shopItem) {
                shopItemId = _shopItem.id;
            }
            itemView.showItem (shopItemId);
            testEnabled ();
        }

        override public function destroy ():void {
            itemView.destroy ();
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function testEnabled ():void {
            newItemsSelection = false;
            if (_shopItem) {
                var appUser:AppUser = BreakdanceApp.instance.appUser;
                enable = appUser.itemIsPurchased (_shopItem.id) || appUser.metAdditionConditionsForBuyItem (_shopItem);
                var newItems:Vector.<String> = appUser.newItems;
                if (newItems) {
                    if (newItems.indexOf (_shopItem.id) != -1) {
                        newItemsSelection = true;
                    }
                }
            }
            else {
                enable = false;
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        override protected function rollOverListener (event:MouseEvent):void {
            super.rollOverListener (event);
            showTooltip (_shopItem);
        }

    }
}
