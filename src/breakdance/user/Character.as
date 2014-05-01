/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 14.07.13
 * Time: 1:16
 * To change this template use File | Settings | File Templates.
 */
package breakdance.user {

    import breakdance.core.server.ServerApi;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;

    import flash.events.Event;
    import flash.events.EventDispatcher;

    public class Character extends EventDispatcher {

        private var _hairId:int;
        private var _faceId:int;
        private var dressingModel:CharacterModel;
        private var fittingModel:CharacterModel;
        private var _mode:String;

        public function Character () {
            dressingModel = new CharacterModel ();
            fittingModel = new CharacterModel ();
            _mode = CharacterMode.DRESSING
        }

        public function get hairId ():int {
            return _hairId;
        }

        public function set hairId (value:int):void {
            _hairId = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function get faceId ():int {
            return _faceId;
        }

        public function set faceId (value:int):void {
            _faceId = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function get mode ():String {
            return _mode;
        }

        public function set mode (value:String):void {
            _mode = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function startFitting ():void {
            fittingModel = dressingModel.clone ();
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function get body ():UserPurchasedItem {
            if (_mode == CharacterMode.FITTING) {
                return fittingModel.body;
            }
            else {
                return dressingModel.body;
            }
        }

        public function get head ():UserPurchasedItem {
            if (_mode == CharacterMode.FITTING) {
                return fittingModel.head;
            }
            else {
                return dressingModel.head;
            }
        }

        public function get hands ():UserPurchasedItem {
            if (_mode == CharacterMode.FITTING) {
                return fittingModel.hands;
            }
            else {
                return dressingModel.hands;
            }
        }

        public function get legs ():UserPurchasedItem {
            if (_mode == CharacterMode.FITTING) {
                return fittingModel.legs;
            }
            else {
                return dressingModel.legs;
            }
        }

        public function get shoes ():UserPurchasedItem {
            if (_mode == CharacterMode.FITTING) {
                return fittingModel.shoes;
            }
            else {
                return dressingModel.shoes;
            }
        }

        public function get music ():UserPurchasedItem {
            if (_mode == CharacterMode.FITTING) {
                return fittingModel.music;
            }
            else {
                return dressingModel.music;
            }
        }

        public function get cover ():UserPurchasedItem {
            if (_mode == CharacterMode.FITTING) {
                return fittingModel.cover;
            }
            else {
                return dressingModel.cover;
            }
        }

        public function get other ():UserPurchasedItem {
            if (_mode == CharacterMode.FITTING) {
                return fittingModel.other;
            }
            else {
                return dressingModel.other;
            }
        }

        /**
         * Одевание одежды.
         * @param userPurchaseItem
         */
        public function dressing (userPurchaseItem:UserPurchasedItem):void {
            if (userPurchaseItem) {
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (userPurchaseItem.itemId);
                var category:String = shopItem.category;
                switch (category) {
                    case ShopItemCategory.T_SHIRTS:
                    case ShopItemCategory.BODY:
                        dressingBody (userPurchaseItem);
                        break;
                    case ShopItemCategory.HEAD:
                        dressingHead (userPurchaseItem);
                        break;
                    case ShopItemCategory.HANDS:
                        dressingHands (userPurchaseItem);
                        break;
                    case ShopItemCategory.LEGS:
                        dressingLegs (userPurchaseItem);
                        break;
                    case ShopItemCategory.SHOES:
                        dressingShoes (userPurchaseItem);
                        break;
                    case ShopItemCategory.MUSIC:
                        dressingMusic (userPurchaseItem);
                        break;
                    case ShopItemCategory.COVER:
                        dressingCover (userPurchaseItem);
                        break;
                    case ShopItemCategory.OTHER:
                        dressingOther (userPurchaseItem);
                        break;
                }
            }
        }

        /**
         * Одевание (установка) одежды без диспетчеризации события изменения.
         * @param userPurchaseItem
         */
        public function setItem (slotId:String, userPurchaseItem:UserPurchasedItem):void {
            switch (slotId) {
                case ShopItemCategory.T_SHIRTS:
                case ShopItemCategory.BODY:
                    dressingModel.body = userPurchaseItem;
                    break;
                case ShopItemCategory.HEAD:
                    dressingModel.head = userPurchaseItem;
                    break;
                case ShopItemCategory.HANDS:
                    dressingModel.hands = userPurchaseItem;
                    break;
                case ShopItemCategory.LEGS:
                    dressingModel.legs = userPurchaseItem;
                    break;
                case ShopItemCategory.SHOES:
                    dressingModel.shoes = userPurchaseItem;
                    break;
                case ShopItemCategory.MUSIC:
                    dressingModel.music = userPurchaseItem;
                    break;
                case ShopItemCategory.COVER:
                    dressingModel.cover = userPurchaseItem;
                    break;
            }
            dispatchEvent (new Event (Event.CHANGE));
        }

        /**
         * Снятие одежды.
         * @param userPurchaseItem
         * @param withClearFittingModel
         */
        public function undressing (userPurchaseItem:UserPurchasedItem, withClearFittingModel:Boolean = true):void {
            if (userPurchaseItem) {
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (userPurchaseItem.itemId);
                var category:String = shopItem.category;
                const EMPTY_ITEM:UserPurchasedItem = null;
                switch (category) {
                    case ShopItemCategory.T_SHIRTS:
                    case ShopItemCategory.BODY:
                        if (dressingModel.body == userPurchaseItem) {
                            dressingBody (EMPTY_ITEM);
                            if (withClearFittingModel) {
                                fittingBody (EMPTY_ITEM);
                            }
                        }
                        break;
                    case ShopItemCategory.HEAD:
                        if (dressingModel.head == userPurchaseItem) {
                            dressingHead (EMPTY_ITEM);
                            if (withClearFittingModel) {
                                fittingHead (EMPTY_ITEM);
                            }
                        }
                        break;
                    case ShopItemCategory.HANDS:
                        if (dressingModel.hands == userPurchaseItem) {
                            dressingHands (EMPTY_ITEM);
                            if (withClearFittingModel) {
                                fittingHands (EMPTY_ITEM);
                            }
                        }
                        break;
                    case ShopItemCategory.LEGS:
                        if (dressingModel.legs == userPurchaseItem) {
                            dressingLegs (EMPTY_ITEM);
                            if (withClearFittingModel) {
                                fittingLegs (EMPTY_ITEM);
                            }
                        }
                        break;
                    case ShopItemCategory.SHOES:
                        if (dressingModel.shoes == userPurchaseItem) {
                            dressingShoes (EMPTY_ITEM);
                            if (withClearFittingModel) {
                                fittingShoes (EMPTY_ITEM);
                            }
                        }
                        break;
                    case ShopItemCategory.MUSIC:
                        if (dressingModel.music == userPurchaseItem) {
                            dressingMusic (EMPTY_ITEM);
                            if (withClearFittingModel) {
                                fittingMusic (EMPTY_ITEM);
                            }
                        }
                        break;
                    case ShopItemCategory.COVER:
                        if (dressingModel.cover == userPurchaseItem) {
                            dressingCover (EMPTY_ITEM);
                            if (withClearFittingModel) {
                                fittingCover (EMPTY_ITEM);
                            }
                        }
                        break;
                    case ShopItemCategory.OTHER:
                        if (dressingModel.other == userPurchaseItem) {
                            dressingOther (EMPTY_ITEM);
                            if (withClearFittingModel) {
                                fittingOther (EMPTY_ITEM);
                            }
                        }
                        break;
                }
            }
        }

        public function hasDressedItem (userPurchaseItem:UserPurchasedItem):Boolean {
            return (
                    dressingModel.body == userPurchaseItem ||
                    dressingModel.head == userPurchaseItem ||
                    dressingModel.hands == userPurchaseItem ||
                    dressingModel.legs == userPurchaseItem ||
                    dressingModel.shoes == userPurchaseItem ||
                    dressingModel.music == userPurchaseItem ||
                    dressingModel.cover == userPurchaseItem ||
                    dressingModel.other == userPurchaseItem
            );
        }

        /**
         * Примерка купленой одежды.
         * @param userPurchaseItem
         */
        public function fittingPurchasedItem (userPurchaseItem:UserPurchasedItem):void {
            if (userPurchaseItem) {
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (userPurchaseItem.itemId);
                var category:String = shopItem.category;
                switch (category) {
                    case ShopItemCategory.T_SHIRTS:
                    case ShopItemCategory.BODY:
                        fittingBody (userPurchaseItem);
                        break;
                    case ShopItemCategory.HEAD:
                        fittingHead (userPurchaseItem);
                        break;
                    case ShopItemCategory.HANDS:
                        fittingHands (userPurchaseItem);
                        break;
                    case ShopItemCategory.LEGS:
                        fittingLegs (userPurchaseItem);
                        break;
                    case ShopItemCategory.SHOES:
                        fittingShoes (userPurchaseItem);
                        break;
                    case ShopItemCategory.MUSIC:
                        fittingMusic (userPurchaseItem);
                        break;
                    case ShopItemCategory.COVER:
                        fittingCover (userPurchaseItem);
                        break;
                    case ShopItemCategory.OTHER:
                        fittingOther (userPurchaseItem);
                        break;
                }
            }
        }

        /**
         * Примерка не купленой одежды.
         * @param userPurchaseItem
         */
        public function fitting (shopItem:ShopItem):void {
            if (shopItem) {
                var userPurchaseItem:UserPurchasedItem = new UserPurchasedItem ();
                userPurchaseItem.color = "";
                userPurchaseItem.itemId = shopItem.id;
                userPurchaseItem.id = -1;
                fittingPurchasedItem (userPurchaseItem);
            }
        }

        public function dressingBody (value:UserPurchasedItem):void {
            dressingModel.body = value;
            dispatchEvent (new Event (Event.CHANGE));
            save (ShopItemCategory.BODY, value);
        }

        public function dressingHead (value:UserPurchasedItem):void {
            dressingModel.head = value;
            dispatchEvent (new Event (Event.CHANGE));
            save (ShopItemCategory.HEAD, value);
        }

        public function dressingHands (value:UserPurchasedItem):void {
            dressingModel.hands = value;
            dispatchEvent (new Event (Event.CHANGE));
            save (ShopItemCategory.HANDS, value);
        }

        public function dressingLegs (value:UserPurchasedItem):void {
            dressingModel.legs = value;
            dispatchEvent (new Event (Event.CHANGE));
            save (ShopItemCategory.LEGS, value);
        }

        public function dressingShoes (value:UserPurchasedItem):void {
            dressingModel.shoes = value;
            dispatchEvent (new Event (Event.CHANGE));
            save (ShopItemCategory.SHOES, value);
        }

        public function dressingMusic (value:UserPurchasedItem):void {
            dressingModel.music = value;
            dispatchEvent (new Event (Event.CHANGE));
            save (ShopItemCategory.MUSIC, value);
        }

        public function dressingCover (value:UserPurchasedItem):void {
            dressingModel.cover = value;
            dispatchEvent (new Event (Event.CHANGE));
            save (ShopItemCategory.COVER, value);
        }

        public function dressingOther (value:UserPurchasedItem):void {
            dressingModel.other = value;
            dispatchEvent (new Event (Event.CHANGE));
            save (ShopItemCategory.OTHER, value);
        }

        public function fittingBody (value:UserPurchasedItem):void {
            fittingModel.body = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function fittingHead (value:UserPurchasedItem):void {
            fittingModel.head = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function fittingHands (value:UserPurchasedItem):void {
            fittingModel.hands = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function fittingLegs (value:UserPurchasedItem):void {
            fittingModel.legs = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function fittingShoes (value:UserPurchasedItem):void {
            fittingModel.shoes = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function fittingMusic (value:UserPurchasedItem):void {
            fittingModel.music = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function fittingCover (value:UserPurchasedItem):void {
            fittingModel.cover = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function fittingOther (value:UserPurchasedItem):void {
            fittingModel.other = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        private function save (slotId:String, userPurchaseItem:UserPurchasedItem):void {
            var userItemId:String = "";
            if (userPurchaseItem) {
                userItemId = String (userPurchaseItem.id);
            }
            ServerApi.instance.query (ServerApi.SAVE_EQUIP_SLOT, {slot_id:slotId, user_item_id:userItemId}, onComplete);
            TransactionOverlay.instance.show ();
        }

        private function onComplete (response:Object):void {
            TransactionOverlay.instance.hide ();
//            Tracer.log ("**********onEquipSlot***********:");
//            Tracer.traceObject (response);
//            Tracer.log ("********************************:");
        }

    }
}
