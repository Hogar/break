package breakdance.ui.popups.achievementPopUp 
{
	/**
	 * ...
	 * @author gray_crow
	 */
	import breakdance.ui.commons.AbstractList;
    import com.hogargames.display.scrolls.BasicScrollWithTweenLite;
    import com.hogargames.display.scrolls.MotionType;
	import breakdance.data.achievements.AchievementCollection;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class AchievementsList extends AbstractList {

        private var achievementsListItems:Vector.<AchievementsListItem> = new Vector.<AchievementsListItem> ();

        private static const NUM_VISIBLE_ITEMS:int = 5;
        private static const STEP:int = 69;
        private static const WIDTH:int = 540;

        public function AchievementsList (mc:MovieClip) {
           //создаём скролл-бар:
            var mcScrollBar:Sprite = getElement ("mcScrollBar", mc);
            var mcScrollBase:Sprite = getElement ("mcScrollBase", mc);
            var scroll:BasicScrollWithTweenLite = new BasicScrollWithTweenLite ();
            scroll.x = mcScrollBase.x;
            scroll.y = mcScrollBase.y;
            scroll.setExternalScrollBar (mcScrollBar, true);
            scroll.setExternalScrollBase (mcScrollBase, true);
            scroll.baseAlpha = 0;
            addChild (scroll);

            super (mc, NUM_VISIBLE_ITEMS, STEP, WIDTH, NUM_VISIBLE_ITEMS * STEP, scroll);
            motionType = MotionType.Y;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function init (achievementList:Vector.<AchievementData>):void {
            clear ();
            //add scroll elements:			
            var listIdAchievement:Vector.<String> = AchievementCollection.instance.listId;
			  for (var i:int = 0; i < listIdAchievement.length; i++) {
                var achievementsListItem:AchievementsListItem = new AchievementsListItem ();
                achievementsListItem.y = i * STEP;
        		achievementsListItem.achievementsData = achievementList[i];
                container.addChild (achievementsListItem);
                achievementsListItems.push (achievementsListItem);
			}

            //set scroll params:
            this.numItems = listIdAchievement.length;

            moveTo (0);
        }

        override public function clear ():void {
            for (var i:int = 0; i < achievementsListItems.length; i++) {
                var achievementsListItem:AchievementsListItem = achievementsListItems [i];
                if (container.contains (achievementsListItem)) {
                    container.removeChild (achievementsListItem);
                }
                achievementsListItem.destroy ();
            }
            achievementsListItems = new Vector.<AchievementsListItem> ();
        }
    }
}
