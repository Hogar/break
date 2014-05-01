/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.08.13
 * Time: 12:09
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.bucksOffers {

    import breakdance.core.staticData.StaticTableRow;

    public class BucksOffer {

            private var _id:String;
            private var _cost:int;
            private var _bucks:int;
            private var _bonus:int;

            public function BucksOffer (row:StaticTableRow) {
                _id = row.getAsString ("id");
                _cost = row.getAsInt ("cost");
                _bucks = row.getAsInt ("bucks");
                _bonus = row.getAsInt ("bonus");
            }

            public function get id ():String {
                return _id;
            }

            public function get cost ():int {
                return _cost;
            }

            public function get bucks ():int {
                return _bucks;
            }

            public function get bonus ():int {
                return _bonus;
            }
        }
    }
