package breakdance.user {

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;

    import com.hogargames.errors.SingletonError;

    public class UserLevelCollection {

        private var _listAsObject:Object;
        private var _list:Vector.<UserLevel>;

        private static var _instance:UserLevelCollection;

        public function UserLevelCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }

            _list = new Vector.<UserLevel> ();
        }


        static public function get instance ():UserLevelCollection {
            if (!_instance) {
                _instance = new UserLevelCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init ():Boolean {
            var level:UserLevel;

            var table:StaticTable = StaticData.instance.getTable ("level");

            _list = new Vector.<UserLevel> ();
            _list.push (new UserLevel (null));//level 0
            _listAsObject = {};

            for (var i:int = 0; i < table.rows.length; i++) {
                level = new UserLevel (table.rows[i]);
                _list.push (level);
                _listAsObject [level.id] = level;
            }

            return true;
        }

        public function get list ():Vector.<UserLevel> {
            return _list;
        }

        public function getUserLevel (id:int):UserLevel {
            return _listAsObject [id];
        }

    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}