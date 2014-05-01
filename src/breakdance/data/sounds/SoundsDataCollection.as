/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 16.10.13
 * Time: 15:40
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.sounds {

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;

    import com.hogargames.errors.SingletonError;

    public class SoundsDataCollection {

        private var _listAsObject:Object;
        private var _list:Vector.<SoundData>;

        private static var _instance:SoundsDataCollection;

        public function SoundsDataCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }

            _listAsObject = {};
            _list = new Vector.<SoundData> ();
        }

        static public function get instance ():SoundsDataCollection {
            if (!_instance) {
                _instance = new SoundsDataCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init ():Boolean {
            var soundData:SoundData;

            var table:StaticTable = StaticData.instance.getTable ("sound");

            for (var i:int = 0; i < table.rows.length; i++) {
                soundData = new SoundData (table.rows[i]);
                _list.push (soundData);
                _listAsObject[soundData.id] = soundData;
            }

            return true;
        }

        public function get list ():Vector.<SoundData> {
            return _list;
        }

        public function getSoundData (id:String):SoundData {
            var soundData:SoundData = _listAsObject [id];
            if (soundData) {
                return soundData;
            }
            else {
                throw new Error ('SoundData "' + id + '" not found.');
            }
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}