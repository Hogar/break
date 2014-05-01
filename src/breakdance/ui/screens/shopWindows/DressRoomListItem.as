/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.08.13
 * Time: 11:35
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows {

    import breakdance.core.texts.TextsManager;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.ui.commons.ItemView;
    import breakdance.ui.commons.TshirtView;
    import breakdance.ui.commons.tooltip.TooltipData;
    import breakdance.user.UserPurchasedItem;

    import com.hogargames.utils.StringUtilities;

    import flash.events.MouseEvent;

    public class DressRoomListItem extends ListItem {

        private var _userPurchasedItem:UserPurchasedItem;

        private var itemView:ItemView;
        private var tshirtView:TshirtView;

        private static const TSHIRT_SCALE:Number = .63;
        private static const TSHIRT_INDENT_X:Number = 10;
        private static const TSHIRT_INDENT_Y:Number = -3;

        public function DressRoomListItem () {
            super ();
            itemView = new ItemView ();
            tshirtView = new TshirtView ();
            itemViewContainer.addChild (itemView);
            itemViewContainer.addChild (tshirtView);
            itemView.x = -ITEM_VIEW_INDENT;
            itemView.y = -ITEM_VIEW_INDENT;
            tshirtView.x = -ITEM_VIEW_INDENT + TSHIRT_INDENT_X;
            tshirtView.y = -ITEM_VIEW_INDENT + TSHIRT_INDENT_Y;
            tshirtView.scaleX = tshirtView.scaleY = TSHIRT_SCALE;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get userPurchasedItem ():UserPurchasedItem {
            return _userPurchasedItem;
        }

        public function set userPurchasedItem (value:UserPurchasedItem):void {
            _userPurchasedItem = value;
            var shopItemId:String;
            if (_userPurchasedItem) {
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (_userPurchasedItem.itemId);
                if (shopItem.category == ShopItemCategory.T_SHIRTS) {
                    tshirtView.visible = true;
                    itemView.visible = false;
                    tshirtView.id = _userPurchasedItem.itemId;
                    tshirtView.color = _userPurchasedItem.color;
                }
                shopItemId = _userPurchasedItem.itemId;
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
            enable = true;
        }

        override protected function getTooltipData (shopItem:ShopItem):TooltipData {
            if (shopItem) {
                var tooltipText:String = null;
                var priceCoins:int = Math.floor (shopItem.coins / 2);
                var priceBucks:int =  Math.floor (shopItem.bucks / 2);
                var priceText:String;
                var afterPriceText:String = null;
                var bonusText:String = getBonusText (shopItem);
                if (!StringUtilities.isNotValueString (bonusText)) {
                    tooltipText = bonusText;
                }
                if ((priceCoins > 0) || (priceBucks > 0)) {
                    priceText = TextsManager.instance.getText ("ttSellPrice");
                }
            }
            return new TooltipData (tooltipText, priceCoins, priceBucks, priceText, afterPriceText);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        override protected function rollOverListener (event:MouseEvent):void {
            super.rollOverListener (event);
            if (_userPurchasedItem) {
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (_userPurchasedItem.itemId);
                showTooltip (shopItem);
            }
        }

    }
}
