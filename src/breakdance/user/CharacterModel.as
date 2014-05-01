/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 14.07.13
 * Time: 1:33
 * To change this template use File | Settings | File Templates.
 */
package breakdance.user {

    public class CharacterModel {

        private var _body:UserPurchasedItem;
        private var _head:UserPurchasedItem;
        private var _hands:UserPurchasedItem;
        private var _legs:UserPurchasedItem;
        private var _shoes:UserPurchasedItem;
        private var _music:UserPurchasedItem;
        private var _cover:UserPurchasedItem;
        private var _other:UserPurchasedItem;

        public function CharacterModel () {

        }

        public function get body ():UserPurchasedItem {
            return _body;
        }

        public function set body (value:UserPurchasedItem):void {
            _body = value;
        }

        public function get head ():UserPurchasedItem {
            return _head;
        }

        public function set head (value:UserPurchasedItem):void {
            _head = value;
        }

        public function get hands ():UserPurchasedItem {
            return _hands;
        }

        public function set hands (value:UserPurchasedItem):void {
            _hands = value;
        }

        public function get legs ():UserPurchasedItem {
            return _legs;
        }

        public function set legs (value:UserPurchasedItem):void {
            _legs = value;
        }

        public function get shoes ():UserPurchasedItem {
            return _shoes;
        }

        public function set shoes (value:UserPurchasedItem):void {
            _shoes = value;
        }

        public function get music ():UserPurchasedItem {
            return _music;
        }

        public function set music (value:UserPurchasedItem):void {
            _music = value;
        }

        public function get cover ():UserPurchasedItem {
            return _cover;
        }

        public function set cover (value:UserPurchasedItem):void {
            _cover = value;
        }

        public function get other ():UserPurchasedItem {
            return _other;
        }

        public function set other (value:UserPurchasedItem):void {
            _other = value;
        }

        public function clone ():CharacterModel {
            var cloneModel:CharacterModel = new CharacterModel ();
            cloneModel._body = _body;
            cloneModel._body = _body;
            cloneModel._head = _head;
            cloneModel._hands = _hands;
            cloneModel._legs = _legs;
            cloneModel._shoes = _shoes;
            cloneModel._music = _music;
            cloneModel._cover = _cover;
            cloneModel._other = _other;
            return cloneModel;
        }

    }
}
