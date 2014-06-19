package breakdance.ui.popups 
{
	/**
	 * ...
	 * @author gray_crow
	 */
    import breakdance.BreakdanceApp;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.server.ServerApi;
	import breakdance.data.achievements.Achievement;
    import breakdance.data.awards.Award;
    import breakdance.data.awards.AwardCollection;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.data.shop.ShopItemConditionType;
    import breakdance.template.Template;
    import breakdance.ui.commons.ItemView;
    import breakdance.ui.popups.basePopUps.OneTextButtonPopUp;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.ui.screenManager.events.ScreenManagerEvent;
    import breakdance.user.UserLevel;
    import breakdance.user.UserLevelCollection;
	import breakdance.data.achievements.AchievementCollection;
	
    import flash.display.Sprite;
    import flash.text.TextField;
	import breakdance.ui.popups.achievementPopUp.AchievementData;

    public class TakeAchievementPopUp extends OneTextButtonPopUp {
        private var mcUnlockedItem:Sprite;
        private var tfUnlock:TextField;
        private var mcItem:Sprite;
        private var item:ItemView;

        private var tfCaption:TextField;
        private var mcBucks:Sprite;
        private var tfBucks:TextField;
        private var mcCoins:Sprite;
        private var tfCoins:TextField;
        private var tfText:TextField;
		private var listStars:Array;

        private var currentLevel:int = 0;

        private var _achievementData:AchievementData;
        private var delayShow:Boolean = false;
		

        public function TakeAchievementPopUp () {
            super (Template.createSymbol (Template.TAKE_ACHIEVEMENT_POP_UP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
            if (ScreenManager.instance.currentScreenId == ScreenManager.BATTLE_SCREEN) {
                delayShow = true;
            }
            else {
                super.show ();
            }
        }

        override public function setTexts ():void {
            super.setTexts ();
			
			tfTitle.htmlText = textsManager.getText ("achievementTitleMessage")  
            btn1.text = textsManager.getText ("close");
			tf.y = 160;
			//tf.y = (tf.height > 35)? 140:160;

	/*				
            var txtNewDivision:String = textsManager.getText ("newDivision");
                txtNewDivision = txtNewDivision.replace ("#1", levelData.maxMoves);
                txtNewDivision = txtNewDivision.replace ("#2", levelData.maxStamina);
                tfText.htmlText = txtNewDivision;
			*/	            
        }

		public function setAchievements (achData: AchievementData):void {
			
			_achievementData = achData;
			var achievement:Achievement = AchievementCollection.instance.getAchievement(achData.id);	
			tf.htmlText = achData.name;
			tfCaption.htmlText = achData.caption;
			if (achData.caption.length > 31) {
				tfCaption.y = 225
			}else {
				tfCaption.y = 234
			}
			if (achievement) {
                var awardData:Award = AwardCollection.instance.getAward (achievement.getAwards(achData.currentPhase));
                if (awardData) {
                    if (awardData.coins != 0) {
                        mcCoins.visible = true;
                        tfCoins.htmlText = "<b>" + String (awardData.coins) + "</b>";
                    }
                    else {
                        mcCoins.visible = false;
                    }
                    if (awardData.bucks != 0) {
                        mcBucks.visible = true;
                        tfBucks.htmlText = "<b>" + String (awardData.bucks) + "</b>";
                    }
                    else {
                        mcBucks.visible = false;
                    }
				}	
				if (achData.currentCountAch < achievement.maxValue )			
					tfTitle.htmlText = textsManager.getText ("achievementNextMessage"); 
				else
					tfTitle.htmlText = textsManager.getText ("achievementEndMessage"); 
				
				for (var i: int = 0; i < listStars.length; i++ ) {					
					if (i < achievement.countLevel) {
						if (i<achData.currentPhase) 
							listStars[i].gotoAndStop(3);
						else	
							listStars[i].gotoAndStop(2);
					}
					else 
					  listStars[i].gotoAndStop(1);
				}
            }
            else {
                mcBucks.visible = false;
                mcCoins.visible = false;
            }

            setTexts ();
        }

        override public function destroy ():void {
            item.destroy ();
            ScreenManager.instance.removeEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            
            mcBucks = getElement ("mcBucks");
            tfBucks = getElement ("tfBucks", mcBucks);
            mcCoins = getElement ("mcCoins");
            tfCoins = getElement ("tfCoins", mcCoins);
            tfText = getElement ("tfText");
			tfCaption = getElement ("tfCaption");
			
			listStars = new Array();
			for (var i: int = 0; i < 5; i++ ) {
				listStars.push(getElement ("star"+i))
			}

            ScreenManager.instance.addEventListener (ScreenManagerEvent.NAVIGATE_TO, navigateToListener);
        }

        override protected function onClickFirstButton ():void {
            hide ();
        }

        private function onWriteWall (response:JsQueryResult):void {
            //
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function onAddUserNewsResponse (response:Object):void {
            //
        }

        private function navigateToListener (event:ScreenManagerEvent):void {
            if (delayShow) {
                super.show ();
                delayShow = false;
            }
        }

    }
}
