package breakdance.ui.popups.achievementPopUp 
{
	import breakdance.core.ui.events.ScreenEvent;
	import breakdance.ui.popups.basePopUps.TitleClosingPopUp;
	import breakdance.user.AppUser;
	import breakdance.user.InterfaceUser;
	import flash.text.TextField;
	import breakdance.BreakdanceApp;
	import breakdance.template.Template;
	import com.hogargames.debug.Tracer;
	import flash.events.Event;
	import breakdance.core.server.ServerApi;
	import breakdance.core.ui.overlay.TransactionOverlay;
	import breakdance.GlobalConstants;
	
	/**
	 * ...
	 * @author gray_crow
	 */
	public class AchievementListPopUp extends TitleClosingPopUp {

        private var achievementsList:AchievementsList;

		private var achievementsDataList : Vector.<AchievementData>;
		private var achievementsAsObject : Object;
        private var userApp:InterfaceUser;
		

        private static const FIRST_BATTLE_NUM_ROUNDS:int = 2;
        private static const FIRST_BATTLE_BET:int = 50;

		private var textTitle :String
		
		public function AchievementListPopUp() 
		{            
            super (Template.createSymbol(Template.ACHIEVEMENT_LIST_POPUP));            
			userApp = BreakdanceApp.instance.appUser;
			//maxTopListItems = parseInt (StaticData.instance.getSetting ("max_top_list_items"));
            
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function init (achievements:Vector.<AchievementData>):void {
            achievementsList.init (achievements);
        }		
		
		public function setData(user:InterfaceUser):void {
			userApp = user;
			var title:String = textTitle;
			title = title.replace ("#1", userApp.countAchievementsDone);     						
			tfTitle.text =  title;   
		}

		// вызывает HomeScreen
        override public function show ():void {
            super.show ();
            reinit ();
        }

        override public function setTexts ():void {
			textTitle = textsManager.getText ("achievementTitle");
			textTitle = textTitle.replace ("#2", GlobalConstants.MAXIMUM_ACHIEVEMENTS);     
			var title:String = textTitle;
			if (userApp)
				title = title.replace ("#1", userApp.countAchievementsDone);     
			
            tfTitle.text =  title;   
        }

        override public function destroy ():void {

            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            achievementsList = new AchievementsList (mc ["mcAchievementList"]);
        }

        override protected function onClickCloseButton ():void {
            dispatchEvent (new ScreenEvent (ScreenEvent.HIDE_SCREEN));
            super.onClickCloseButton ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function reinit ():void {
		    achievementsList.clear ();
		    init (userApp.userAchievements);
        }

	}

}