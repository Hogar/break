/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 16.10.13
 * Time: 15:40
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.sounds {

    import breakdance.core.staticData.StaticTableRow;

    public class SoundData {

        private var _id:String;
        private var _volume:Number;

        public function SoundData (row:StaticTableRow) {
            _id = row.getAsString ("id");
            _volume = row.getAsNumber ("volume");
        }

        public function get id ():String {
            return _id;
        }

        public function get volume ():Number {
            return _volume;
        }

    }
}
