package breakdance.data.achievements 
{
	/**
	 * ...
	 * @author gray_crow
	 */

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;
	import breakdance.core.texts.TextData;
	import breakdance.data.achievements.Achievement;

    import com.hogargames.errors.SingletonError;
	import breakdance.data.achievements.NameAchievements;
	
    public class AchievementCollection {

        private var _listAsObject:Object;
        private var _list:Vector.<Achievement>;
		private var _listId:Vector.<String>;     // список ачивок, которые мы будем показывать (т.е. те что ещё не задействованы - не показываем)

         private static var _instance:AchievementCollection;

        public function AchievementCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }

            _listAsObject = {};
            _list = new Vector.<Achievement> ();
			_listId = new Vector.<String>;
         }

        static public function get instance ():AchievementCollection {
            if (!_instance) {
                _instance = new AchievementCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init ():Boolean {
            var achievement:Achievement;
			var textData:TextData;

            var table:StaticTable = StaticData.instance.getTable ("achievement");

            for (var i:int = 0; i < table.rows.length; i++) {
                achievement = new Achievement (table.rows[i]);
                _list.push (achievement);
                _listAsObject[achievement.id] = achievement;
				if (achievement.id != NameAchievements.ACH_HUNKY && achievement.id !=  NameAchievements.ACH_EXPERIENCED ){
					_listId.push(achievement.id);
				}					
            }

            //Добавляем тексты для уже созданных коллекций:
            table = StaticData.instance.getTable ("achievements_title");		
			
			
			var objTitle:Object = new Object();  // по ключу ачивки TextData;
			var objCaption:Object = new Object();  // по ключу ачивки Vector.<TextData>();
			for (i = 0; i < table.rows.length; i++) {
				
				for (var j: int = 0; j < _listId.length; j++) {
					
					var strId :String = table.rows[i].getId();
					if (strId == 'name_' + _listId[j]) {
						objTitle[_listId[j]] =  new TextData (table.rows[i]);	
					}											
					if ('caption_' + _listId[j] == strId.substr(0,strId.length-1)) {
						for (var k: int = 1; k < Achievement.MAX_COUNT_LEVEL + 1; k++) {
							if ('caption_' + _listId[j] + k == strId) {
								if (objCaption[_listId[j]] == undefined)
								   objCaption[_listId[j]] = new  Vector.<TextData>();
								objCaption[_listId[j]].push(new TextData (table.rows[i]));	
								break;
							}	
						}	
						break;
					}																
				}			
			}
			
			for (j = 0; j < _listId.length; j++) {
				_listAsObject[_listId[j]].textData(objTitle[_listId[j]]);
				_listAsObject[_listId[j]].textCaption(objCaption[_listId[j]]);	
			}	
        
            return true;
        }

        public function get list ():Vector.<Achievement> {
            return _list;
        }

		// список id ачивок 
        public function get listId ():Vector.<String> {
            return _listId;
        }
		
        public function getAchievement(id:String):Achievement {
            var achievement:Achievement = _listAsObject [id];
            if (achievement) {
                return achievement;
            }
            else {
                throw new Error ('Achievement "' + id + '" not found.');
            }
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}
