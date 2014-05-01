/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.08.13
 * Time: 12:07
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.bucksOffers {

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;

    import com.hogargames.errors.SingletonError;

    public class BucksOffersCollection {

        private var _listAsObject:Object;
        private var _list:Vector.<BucksOffer>;

        private static var _instance:BucksOffersCollection;

        public function BucksOffersCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }

            _listAsObject = {};
            _list = new Vector.<BucksOffer> ();
        }

        static public function get instance ():BucksOffersCollection {
            if (!_instance) {
                _instance = new BucksOffersCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init ():Boolean {
            var award:BucksOffer;

            var table:StaticTable = StaticData.instance.getTable ("offer");

            for (var i:int = 0; i < table.rows.length; i++) {
                award = new BucksOffer (table.rows[i]);
                _list.push (award);
                _listAsObject[award.id] = award;
            }

            return true;
        }

        public function get list ():Vector.<BucksOffer> {
            return _list;
        }

        public function getAward (id:String):BucksOffer {
            var award:BucksOffer = _listAsObject [id];
            if (award) {
                return award;
            }
            else {
                throw new Error ('BucksOffer "' + id + '" not found.');
            }
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}