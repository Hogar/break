package breakdance.user 
{
	import breakdance.battle.data.PlayerItemData;
	import breakdance.ui.popups.achievementPopUp.AchievementData;
	/**
	 * ...
	 * @author gray_crow
	 */
	public interface InterfaceUser 
	{
	
		function get uid ():String;
		
        function get name ():String;
		
		function get nickname ():String;
		
        function get level ():int;
		
        function get userAchievements ():Vector.<AchievementData> ;
        
		function get countAchievementsDone ():int;
        
	}
	
}