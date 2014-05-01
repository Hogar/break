/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.10.13
 * Time: 21:12
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.topPlayersListPopUp {

    import breakdance.IInitialPlayerData;
    import breakdance.IPlayerData;
    import breakdance.battle.data.PlayerItemData;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.user.UserLevelCollection;

    public class TopPlayerData implements IPlayerData, IInitialPlayerData {

        private var _uid:String = "";
        private var _name:String = "";
        private var _nickname:String = "";
        private var _level:int;
        public var points:int;

        private var _hairId:int;
        private var _faceId:int;

        private var _head:PlayerItemData = new PlayerItemData ();
        private var _hands:PlayerItemData = new PlayerItemData ();
        private var _body:PlayerItemData = new PlayerItemData ();
        private var _legs:PlayerItemData = new PlayerItemData ();
        private var _shoes:PlayerItemData = new PlayerItemData ();
        private var _music:PlayerItemData = new PlayerItemData ();
        private var _cover:PlayerItemData = new PlayerItemData ();
        private var _other:PlayerItemData = new PlayerItemData ();

        private var _guessMoveGameRecord:int;

        public function TopPlayerData () {

        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public static function createFakeBattlePlayer ():TopPlayerData {
            var fakePlayerData:TopPlayerData = new TopPlayerData ();
            fakePlayerData._uid = String (Math.ceil (Math.random () * 99999));
            fakePlayerData._name = "Test " + Math.ceil (Math.random () * 100) + " testov";
            fakePlayerData._nickname = "Nick " + Math.ceil (Math.random () * 100);
            fakePlayerData._level = Math.ceil (1 + Math.random () * UserLevelCollection.instance.list.length);
            fakePlayerData._faceId = Math.ceil (Math.random () * 5.99 + 0.01);
            fakePlayerData._hairId = Math.ceil (Math.random () * 5.99 + 0.01);
            fakePlayerData.points = Math.ceil (Math.random () * 100000);

            fakePlayerData._head = new PlayerItemData (createFakeShopItemId (ShopItemCategory.HEAD));
            fakePlayerData._hands = new PlayerItemData (createFakeShopItemId (ShopItemCategory.HANDS));
            fakePlayerData._body = new PlayerItemData (createFakeShopItemId (ShopItemCategory.BODY));
            fakePlayerData._legs = new PlayerItemData (createFakeShopItemId (ShopItemCategory.LEGS));
            fakePlayerData._shoes = new PlayerItemData (createFakeShopItemId (ShopItemCategory.SHOES));
            fakePlayerData._music = new PlayerItemData (createFakeShopItemId (ShopItemCategory.MUSIC));
            fakePlayerData._cover = new PlayerItemData (createFakeShopItemId (ShopItemCategory.COVER));
            fakePlayerData._other = new PlayerItemData (createFakeShopItemId (ShopItemCategory.OTHER));

            return fakePlayerData;
        }


        public function get uid ():String {
            return _uid;
        }

        public function set uid (value:String):void {
            _uid = value;
        }

        public function get name ():String {
            return _name;
        }

        public function set name (value:String):void {
            _name = value;
        }

        public function get nickname ():String {
            return _nickname;
        }

        public function set nickname (value:String):void {
            _nickname = unescape (value);
        }

        public function get level ():int {
            return _level;
        }

        public function set level (value:int):void {
            _level = value;
        }

        public function get hairId ():int {
            return _hairId;
        }

        public function set hairId (value:int):void {
            _hairId = value;
        }

        public function get faceId ():int {
            return _faceId;
        }

        public function set faceId (value:int):void {
            _faceId = value;
        }

        public function get head ():PlayerItemData {
            return _head;
        }

        public function set head (value:PlayerItemData):void {
            _head = value;
        }

        public function get hands ():PlayerItemData {
            return _hands;
        }

        public function set hands (value:PlayerItemData):void {
            _hands = value;
        }

        public function get body ():PlayerItemData {
            return _body;
        }

        public function set body (value:PlayerItemData):void {
            _body = value;
        }

        public function get legs ():PlayerItemData {
            return _legs;
        }

        public function set legs (value:PlayerItemData):void {
            _legs = value;
        }

        public function get shoes ():PlayerItemData {
            return _shoes;
        }

        public function set shoes (value:PlayerItemData):void {
            _shoes = value;
        }

        public function get music ():PlayerItemData {
            return _music;
        }

        public function set music (value:PlayerItemData):void {
            _music = value;
        }

        public function get cover ():PlayerItemData {
            return _cover;
        }

        public function set cover (value:PlayerItemData):void {
            _cover = value;
        }

        public function get other ():PlayerItemData {
            return _other;
        }

        public function set other (value:PlayerItemData):void {
            _other = value;
        }

        public function get guessMoveGameRecord ():int {
            return _guessMoveGameRecord;
        }

        public function set guessMoveGameRecord (value:int):void {
            _guessMoveGameRecord = value;
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private static function createFakeShopItemId (category:String):String {
            if (Math.random () > .5) {
                return "";
            }
            var randomShopItem:ShopItem = ShopItemCollection.instance.getRandomShopItemOfCategory (category);
            if (randomShopItem) {
                return randomShopItem.id;
            }
            else {
                return "";
            }
        }
    }
}
