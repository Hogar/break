/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.03.14
 * Time: 10:55
 * To change this template use File | Settings | File Templates.
 */
package breakdance.user.events {

    import flash.events.Event;

    public class GetCollectionItemEvent extends Event {

        private var _collectionTypeId:String;
        private var _amount:int;

        public static const GET_COLLECTION_ITEM:String = "get collection item";

        public function GetCollectionItemEvent (collectionTypeId:String, amount:int) {
            this.collectionTypeId = collectionTypeId;
            this.amount = amount;
            super (GET_COLLECTION_ITEM);
        }

        public function get amount ():int {
            return _amount;
        }

        public function set amount (value:int):void {
            _amount = value;
        }

        public function get collectionTypeId ():String {
            return _collectionTypeId;
        }

        public function set collectionTypeId (value:String):void {
            _collectionTypeId = value;
        }
    }
}
