/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.07.13
 * Time: 10:39
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.awards {

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;

    import com.hogargames.errors.SingletonError;

    public class AwardCollection {

        private var _listAsObject:Object;
        private var _list:Vector.<Award>;

        private var _dailyAwards:Vector.<String>;

        private static var _instance:AwardCollection;

        public function AwardCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }

            _listAsObject = {};
            _list = new Vector.<Award> ();
            _dailyAwards = new Vector.<String> ();
        }

        static public function get instance ():AwardCollection {
            if (!_instance) {
                _instance = new AwardCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init ():Boolean {
            var award:Award;

            var table:StaticTable = StaticData.instance.getTable ("award");

            for (var i:int = 0; i < table.rows.length; i++) {
                award = new Award (table.rows[i]);
                _list.push (award);
                _listAsObject[award.id] = award;
            }

            table = StaticData.instance.getTable ("daily_award");

            for (i = 0; i < table.rows.length; i++) {
                var awardId:String = table.rows[i].getAsString ("award_id");
                _dailyAwards.push (awardId);
            }

            return true;
        }

        public function get list ():Vector.<Award> {
            return _list;
        }

        public function get dailyAwards ():Vector.<String> {
            return _dailyAwards;
        }

        public function getAward (id:String):Award {
            var award:Award = _listAsObject [id];
            if (award) {
                return award;
            }
            else {
                throw new Error ('Award "' + id + '" not found.');
            }
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}