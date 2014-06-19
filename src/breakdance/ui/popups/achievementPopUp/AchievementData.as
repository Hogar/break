package breakdance.ui.popups.achievementPopUp 
{
	/**
	 * Состояние достижение конкретного юзера
	 * @author gray_crow
	 */
	
	import breakdance.core.texts.TextsManager;
	import breakdance.data.achievements.Achievement;
	import breakdance.data.achievements.AchievementCollection;
	import breakdance.core.server.ServerTime;
	
	public class AchievementData 
	{
		private var textsManager:TextsManager = TextsManager.instance;
		
		private var _id	 : String;
		private var _name	 : String;
		private var _caption : String;	
		private var _currentCountAch : int;		
		private var _currentPhase : int;
		
		private var _achievement : Achievement;
		private var _modifyDate : Date;
		private var _createDate : Date;
		
		
		//"user_achievement_list":[{"user_id":"5781649","achievement_id":"winner","modify_date":"2014-05-20 18:31:15","create_date":"2014-05-20 18:31:15","phase":"1","points":"6"}]
		public function AchievementData(id:String) 
		{
			_id = id;
			_currentCountAch = 0;
			_currentPhase = 0;
			_modifyDate = null;
			_createDate = null;
			_name = AchievementCollection.instance.getAchievement(_id).textDataTitle;			
			_caption = AchievementCollection.instance.getAchievement(_id).getTextDataCaption(0);						
		}

		public function init(resp: Object):void
		{
			_currentPhase = (resp.phase -1);
			_currentCountAch = resp.points;
			_createDate = ServerTime.instance.parseDateStr(resp.create_date);
			_modifyDate = ServerTime.instance.parseDateStr(resp.modify_date);			
			_caption = AchievementCollection.instance.getAchievement(_id).getTextDataCaption(_currentPhase);			
		}
		
		
		public function get id():String {
			return _id;
		}
				
		public function get name():String {
			return _name;
		}
		
		public function get modifyDate():Date {
			return _modifyDate;
		}
				
		public function get caption():String {
			if (_currentCountAch < AchievementCollection.instance.getAchievement(_id).maxValue)			
				return _caption.replace ("#1",AchievementCollection.instance.getAchievement(_id).nextMaxValue(_currentPhase));           
			else 	
				return 'Вы собрали максимумм с этой награды'			
		}
				
		public function get currentCountAch():int {
			return _currentCountAch;
		}
		
		public function get currentPhase():int {
			return _currentPhase;
		}			
		
		//возвращает кол-во часов прошедших между настоящей датой и последней модификации ачивки
		// нужно посмотреть на день(дату дня)
		public function get fitIntoNextDay():int {
			if (_modifyDate == null) return -1;				
			return -((_modifyDate.time - ServerTime.instance.time) / 3600 / 1000);
		}
		
	
	}

}
