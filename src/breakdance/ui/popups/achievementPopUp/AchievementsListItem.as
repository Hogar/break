package breakdance.ui.popups.achievementPopUp 
{
	import breakdance.core.texts.ITextContainer;
	import breakdance.core.texts.TextsManager;
	import breakdance.data.achievements.Achievement;
	import breakdance.ui.commons.ProgressText;
	import com.hogargames.display.GraphicStorage;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import breakdance.template.Template;
	import breakdance.data.achievements.AchievementCollection;
	import breakdance.data.awards.AwardCollection;
	/**
	 * ...
	 * @author gray_crow
	 */
	public class AchievementsListItem extends GraphicStorage implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var tfName				:TextField;
        private var tfTask				:TextField;
        private var tfAwardCaption		:TextField;
        private var tfAwardCurrency		:TextField;
        private var progressText		:ProgressText;
        private var listStars			:Array;
		private var mcCurrency			:MovieClip;
		
        private var _achievementsData   :AchievementData;
		
		private const MAX_COUNT_STARS:  int = 5;

        public function AchievementsListItem () {
            super (Template.createSymbol (Template.ACHIEVEMENT_LIST_ITEM));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get achievementsData ():AchievementData {
            return _achievementsData;
        }

        public function set achievementsData (value:AchievementData):void {
	      _achievementsData = value;
            setTexts ();          
        }

       
        public function setTexts ():void {
            if (_achievementsData) {
                
				tfAwardCaption.text = textsManager.getText ("achAward");
				tfName.text = String (_achievementsData.name);
                tfTask.text = String (_achievementsData.caption);
				
				var achievement:Achievement = AchievementCollection.instance.getAchievement(_achievementsData.id)
				// показывать нагду следующего уровня дотижения
				var idAward: String = achievement.getAwards(_achievementsData.currentPhase);
				
				var buks: int = AwardCollection.instance.getAward(idAward).bucks;
				var coins: int = AwardCollection.instance.getAward(idAward).coins;
				if (buks != 0) {					
					tfAwardCurrency.text = String(buks);   
					mcCurrency.gotoAndStop(2);
				}
				if (coins != 0) {					
					tfAwardCurrency.text = String(coins);   
					mcCurrency.gotoAndStop(1);
				}
				progressText.changeFilling(_achievementsData.currentCountAch, achievement.nextMaxValue(_achievementsData.currentPhase));
            
                tfAwardCaption.width = tfAwardCaption.textWidth + 4;				
				tfName.width = tfName.textWidth + 4;
				tfTask.width = tfTask.textWidth + 4;
				tfAwardCurrency.width = tfAwardCurrency.textWidth + 4;
				
				for (var i: int = 0; i < listStars.length; i++ ) {					
					if (i < achievement.countLevel) {
						if (i<_achievementsData.currentPhase) 
							listStars[i].gotoAndStop(3);
						else	
							listStars[i].gotoAndStop(2);
					}
					else 
					  listStars[i].gotoAndStop(1);
				}
            }
            else {
                tfName.text = "";
                tfTask.text = "";
                tfAwardCurrency.text = "";
                progressText.changeFilling();
				mcCurrency.gotoAndStop(2);
            }
        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);     
			while (listStars.length > 0) {
				listStars.pop();
			}
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

			progressText = new ProgressText (mc ["mcProgressText"]);
            tfName = getElement ("tfName");
            tfTask = getElement ("tfTask");
            tfAwardCaption = getElement ("tfAwardCaption");
            tfAwardCurrency = getElement ("tfAward1");
			mcCurrency = getElement ("mcCurrency");
            listStars = new Array();
			for (var i: int = 0; i < MAX_COUNT_STARS; i++ ) {
				listStars.push(getElement ("star"+i))
			}
            textsManager.addTextContainer (this);
        }

    }
}
