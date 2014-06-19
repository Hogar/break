package breakdance.ui.popups.achievementPopUp.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author gray_crow
	 */
	public class SelectAchievementEvent extends Event
	{
		
		private var _achievementData:BattleData;

        public static const SELECT_Achievement:String = "select achievement";

        public function SelectAchievementEvent (battleData:BattleData, type:String = SELECT_Achievement, bubbles:Boolean = false, cancelable:Boolean = true) {
            this.battleData = battleData;
            super (type, bubbles, cancelable);
        }

        public function get battleData ():BattleData {
            return _battleData;
        }

        public function set battleData (value:BattleData):void {
            _battleData = value;
        }
    }
}
}