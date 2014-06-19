package breakdance.data.playerMusic 
{
	import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;
	import breakdance.core.texts.TextData;	
    import com.hogargames.errors.SingletonError;
	import com.hogargames.debug.Tracer;
	
	/**
	 * ...
	 * @author gray_crow
	 */
	public class GroupCollection 
	{		
		private var _listAsObject:Object;
        private var _list:Vector.<GroupData>;		 

         private static var _instance:GroupCollection;

        public function GroupCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }

            _listAsObject = {};
            _list = new Vector.<GroupData> ();			
         }

        static public function get instance ():GroupCollection {
            if (!_instance) {
                _instance = new GroupCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init ():Boolean {
            var group:GroupData;
			var textData:TextData;

		    var table:StaticTable = StaticData.instance.getTable ("group_music");

            for (var i:int = 0; i < table.rows.length; i++) {
                group = new GroupData (table.rows[i]);
                _list.push (group);
                _listAsObject[group.id] = group;
		    }

            return true;
        }

        public function get list ():Vector.<GroupData> {
            return _list;
        }
	
        public function getGroup(id:int):GroupData {
            var group:GroupData = _listAsObject [id];
            if (group) {
                return group;
            }
            else {
                throw new Error ('Group "' + id + '" not found.');
            }
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}
