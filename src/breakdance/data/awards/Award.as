/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.07.13
 * Time: 10:36
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.awards {

    import breakdance.core.staticData.StaticTableRow;

    public class Award {

        private var _id:String;
        private var _coins:int;
        private var _bucks:int;
        private var _energy:int;
        private var _chips:int;
        private var _stamina:int;
        private var _itemId:String;

        public function Award (row:StaticTableRow) {
            _id = row.getAsString ("id");
            _coins = row.getAsInt ("coins");
            _bucks = row.getAsInt ("bucks");
            _energy = row.getAsInt ("energy");
            _chips = row.getAsInt ("chips");
            _stamina = row.getAsInt ("stamina");
            _itemId = row.getAsString ("item_id", false, "");
        }

        public function get id ():String {
            return _id;
        }

        public function get coins ():int {
            return _coins;
        }

        public function get bucks ():int {
            return _bucks;
        }

        public function get energy ():int {
            return _energy;
        }

        public function get chips ():int {
            return _chips;
        }

        public function get stamina ():int {
            return _stamina;
        }

        public function get itemId ():String {
            return _itemId;
        }

        public function toString ():String {
            var str:String = "[ShopItem:[" +
                             "id = " + id + "; " +
                             "coins = " + coins + "; " +
                             "bucks = " + bucks + "; " +
                             "energy = " + energy + "; " +
                             "chips = " + chips + "; " +
                             "stamina = " + stamina + "; " +
                             "itemId = " + itemId +
                             "]]";
            return str;
        }
    }
}
