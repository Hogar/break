/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.07.13
 * Time: 16:55
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.shop {

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;
    import breakdance.core.texts.TextData;

    import com.hogargames.errors.SingletonError;

    public class ShopItemCollection {

        private var _listAsObject:Object;
        private var _list:Vector.<ShopItem>;

        private static var _instance:ShopItemCollection;

        public function ShopItemCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
            _listAsObject = {};
            _list = new Vector.<ShopItem> ();
        }

        static public function get instance ():ShopItemCollection {
            if (!_instance) {
                _instance = new ShopItemCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init ():Boolean {
            var shopItem:ShopItem;
            var textData:TextData;

            var table:StaticTable = StaticData.instance.getTable ("item");

            for (var i:int = 0; i < table.rows.length; i++) {
                shopItem = new ShopItem (table.rows[i]);
                _list.push (shopItem);
                _listAsObject[shopItem.id] = shopItem;
            }

            //Добавляем тексты для уже созданных предметов магазина:
            table = StaticData.instance.getTable ("item_title");
            for (i = 0; i < table.rows.length; i++) {
                textData = new TextData (table.rows[i]);
                shopItem = ShopItem (_listAsObject[textData.id]);
                if (shopItem) {
                    shopItem.textData = textData;
                }
            }

            return true;
        }

        public function get list ():Vector.<ShopItem> {
            return _list;
        }

        public function getShopItem (id:String):ShopItem {
            var shopItem:ShopItem = _listAsObject [id];
            if (shopItem) {
                return shopItem;
            }
            else {
                var message:String = 'ShopItem "' + id + '" not found.';
//                trace (message);
                return null;
//                throw new Error (message);
            }
        }

        public function getShopItemsByCategory (categoryId:String):Vector.<ShopItem> {
            var shopItemList:Vector.<ShopItem> = new Vector.<ShopItem> ();
            for (var i:int = 0; i < list.length; i++) {
                var shopItem:ShopItem = list [i];
                if (shopItem.category == categoryId) {
                    shopItemList.push (shopItem);
                }
            }
            return shopItemList;
        }

        public function getRandomShopItemOfCategory (categoryId:String):ShopItem {
            var shopItemList:Vector.<ShopItem> = getShopItemsByCategory (categoryId);
            if (shopItemList.length > 0) {
                return shopItemList [Math.round (Math.random () * (shopItemList.length - 1))];
            }
            else {
                return null;
            }
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}