/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 03.07.13
 * Time: 19:42
 * To change this template use File | Settings | File Templates.
 */
package breakdance.user {

    import breakdance.IInitialPlayerData;
    import breakdance.IPlayerData;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.data.BattlePlayerData;
    import breakdance.battle.data.PlayerItemData;
	import breakdance.ui.popups.achievementPopUp.AchievementData;
	import breakdance.data.achievements.AchievementCollection;
	import breakdance.GlobalConstants;
	
    import flash.events.Event;
    import flash.events.EventDispatcher;

    public class FriendData extends EventDispatcher implements IPlayerData, IInitialPlayerData,InterfaceUser {

        private var _uid:String;
        private var _shortName:String;
        private var _name:String;
        private var _nickname:String = "";
        private var _level:int;
        private var _avatarUrl:String;
        private var _isOnline:Boolean = false;
        private var _guessMoveGameRecord:int;

        private var _hairId:int;
        private var _faceId:int;

        private var _head:PlayerItemData = new PlayerItemData ();
        private var _hands:PlayerItemData = new PlayerItemData ();
        private var _body:PlayerItemData = new PlayerItemData ();
        private var _legs:PlayerItemData = new PlayerItemData ();
        private var _shoes:PlayerItemData = new PlayerItemData ();
        private var _music:PlayerItemData = new PlayerItemData ();
        private var _cover:PlayerItemData = new PlayerItemData ();
        private var _other:PlayerItemData = new PlayerItemData ();
		
		private var _userAchievements:Vector.<AchievementData> = new Vector.<AchievementData>;//Список полученных игроком одноразовых наград.		
		private var _countAchievementsDone: int;
		
        public function FriendData () {

        }

        public function get uid ():String {
            return _uid;
        }

        public function set uid (value:String):void {
            _uid = value;
        }

        public function get name ():String {
            return _name;
        }

        public function set name (value:String):void {
            _name = value;
        }

        public function get shortName ():String {
            return _shortName;
        }

        public function set shortName (value:String):void {
            _shortName = value;
        }

        public function get nickname ():String {
            return _nickname;
        }

        public function set nickname (value:String):void {
            if (!value) {
                value = "";
            }
            _nickname = unescape (value);
        }

        public function get level ():int {
            return _level;
        }

        public function set level (value:int):void {
            _level = value;
        }

        public function get avatarUrl ():String {
            return _avatarUrl;
        }

        public function set avatarUrl (value:String):void {
            _avatarUrl = value;
            if (_avatarUrl) {
                _avatarUrl = _avatarUrl.replace (".me", ".com");
            }
        }

        public function get hairId ():int {
            return _hairId;
        }

        public function set hairId (value:int):void {
            _hairId = value;
        }

        public function get faceId ():int {
            return _faceId;
        }

        public function set faceId (value:int):void {
            _faceId = value;
        }

        public function get head ():PlayerItemData {
            return _head;
        }

        public function set head (value:PlayerItemData):void {
            _head = value;
        }

        public function get hands ():PlayerItemData {
            return _hands;
        }

        public function set hands (value:PlayerItemData):void {
            _hands = value;
        }

        public function get body ():PlayerItemData {
            return _body;
        }

        public function set body (value:PlayerItemData):void {
            _body = value;
        }

        public function get legs ():PlayerItemData {
            return _legs;
        }

        public function set legs (value:PlayerItemData):void {
            _legs = value;
        }

        public function get shoes ():PlayerItemData {
            return _shoes;
        }

        public function set shoes (value:PlayerItemData):void {
            _shoes = value;
        }

        public function get music ():PlayerItemData {
            return _music;
        }

        public function set music (value:PlayerItemData):void {
            _music = value;
        }

        public function get cover ():PlayerItemData {
            return _cover;
        }

        public function set cover (value:PlayerItemData):void {
            _cover = value;
        }

        public function get other ():PlayerItemData {
            return _other;
        }

        public function set other (value:PlayerItemData):void {
            _other = value;
        }

        public function get isOnline ():Boolean {
            return _isOnline;
        }

        public function set isOnline (value:Boolean):void {
            _isOnline = value;
            dispatchEvent (new Event (Event.CHANGE));
        }

        public function get guessMoveGameRecord ():int {
            return _guessMoveGameRecord;
        }

        public function set guessMoveGameRecord (value:int):void {
            _guessMoveGameRecord = value;
        }
		
        public function get userAchievements ():Vector.<AchievementData> {
            return _userAchievements;
        }
				
        public function get countAchievementsDone ():int {
            return _countAchievementsDone;
        }

		/**
         * Представление данных об игроке в бою.
         * Вмажно! Метод импользуется для отображения персонажа в окне вызова, но не даёт подные данные о текущем состоянии друга (нет stamina, chips и т.д.).
         * @return Данные об игроке в бою.
         *
         * @see breakdance.battle.data.BattlePlayerData
         */
        public function asBattlePlayerData ():BattlePlayerData {
            var battlePlayerData:BattlePlayerData = new BattlePlayerData ();
            battlePlayerData.name = name;
            battlePlayerData.nickname = nickname;
            battlePlayerData.uid = uid;
            battlePlayerData.level = level;
            battlePlayerData.hairId = hairId;
            battlePlayerData.faceId = faceId;

            var bodyData:PlayerItemData = new PlayerItemData ();
            if (body) {
                bodyData.itemId = body.itemId;
                bodyData.color = body.color;
            }
            battlePlayerData.body = bodyData;

            var headData:PlayerItemData = new PlayerItemData ();
            if (head) {
                headData.itemId = head.itemId;
                headData.color = head.color;
            }
            battlePlayerData.head = headData;

            var handsData:PlayerItemData = new PlayerItemData ();
            if (hands) {
                handsData.itemId = hands.itemId;
                handsData.color = hands.color;
            }
            battlePlayerData.hands = handsData;

            var legsData:PlayerItemData = new PlayerItemData ();
            if (legs) {
                legsData.itemId = legs.itemId;
                legsData.color = legs.color;
            }
            battlePlayerData.legs = legsData;

            var shoesData:PlayerItemData = new PlayerItemData ();
            if (shoes) {
                shoesData.itemId = shoes.itemId;
                shoesData.color = shoes.color;
            }
            battlePlayerData.shoes = shoesData;

            var musicData:PlayerItemData = new PlayerItemData ();
            if (music) {
                musicData.itemId = music.itemId;
                musicData.color = music.color;
            }
            battlePlayerData.shoes = shoesData;

            var coverData:PlayerItemData = new PlayerItemData ();
            if (cover) {
                coverData.itemId = cover.itemId;
                coverData.color = cover.color;
            }
            battlePlayerData.cover = coverData;

            var otherData:PlayerItemData = new PlayerItemData ();
            if (other) {
                otherData.itemId = other.itemId;
                otherData.color = other.color;
            }
            battlePlayerData.other = otherData;

            battlePlayerData.availableMoves = new Vector.<BattleDanceMoveData> ();
            return battlePlayerData;
        }

        override public function toString ():String  {
            var str:String;
            str = "FriendData:[";
            str += "uid = " + uid + "; ";
            str += "name = " + name + "; ";
            str += "shortName = " + shortName + "; ";
            str += "nickname = " + nickname + "; ";
            str += "level = " + level + "; ";
            str += "avatarUrl = " + avatarUrl + "; ";
            str += "isOnline = " + isOnline + "; ";
            str += "guessMoveGameRecord = " + guessMoveGameRecord + "; ";
            str += "hairId = " + hairId + "; ";
            str += "faceId = " + faceId + "; ";
            str += "head = " + head + "; ";
            str += "hands = " + hands + "; ";
            str += "body = " + body + "; ";
            str += "legs = " + legs + "; ";
            str += "shoes = " + shoes + "; ";
            str += "music = " + music + "; ";
            str += "cover = " + cover + "; ";
            str += "other = " + other + "; ";
            str += "avatarUrl = " + avatarUrl;
            str += "]";
            return str;
        }
		
		
		public function createAchievements(data:Object):void {
			if (_userAchievements.length == 0) initAchievementsList();
			parseAchievementsList (data);
		}
		
			// инициализируем пустой список ачивок 
		private function initAchievementsList ():void {
			var listIdAchievement:Vector.<String> = AchievementCollection.instance.listId;   // список id ачивок
            _userAchievements = new Vector.<AchievementData> ();
			for (var i:int = 0; i < listIdAchievement.length; i++) {							
				var achievementData : AchievementData = new AchievementData(listIdAchievement[i]);  // созданияе поля для данной ачивке
				_userAchievements.push (achievementData);				
			}        			
        }				
	
		private function parseAchievementsList (data:Object):void {
			
            if (data) {
		        if (data.hasOwnProperty ("user_achievement_list")) {
					_countAchievementsDone = 0;
					var userAchievementsList:Object = data.user_achievement_list; 
                    for (var i:int = 0; i < _userAchievements.length; i++) {							
						for (var j:int = 0; j < userAchievementsList.length; j++) {						
							var achievementObject:Object = userAchievementsList [j];
							if (achievementObject.hasOwnProperty ("achievement_id") && achievementObject.achievement_id == _userAchievements[i].id ) {							
								_userAchievements[i].init(achievementObject);			// инит поля для данной ачивке user_achievement_list			
								_countAchievementsDone += _userAchievements[i].currentPhase;					
//								_userAchievementsPhase[_userAchievements[i].id] = _userAchievements[i].currentPhase;
								trace('FriendData : parseAchievementsList   :   ' + achievementObject.achievement_id);
							}													
						}
					}						
					_countAchievementsDone = Math.round (_countAchievementsDone / GlobalConstants.MAXIMUM_ACHIEVEMENTS *100);					
                }
            }		
			
        }		


    }
}
