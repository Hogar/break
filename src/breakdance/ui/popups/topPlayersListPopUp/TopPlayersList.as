/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.10.13
 * Time: 19:41
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.topPlayersListPopUp {

    import breakdance.ui.commons.AbstractList;

    import com.hogargames.display.scrolls.BasicScrollWithTweenLite;
    import com.hogargames.display.scrolls.MotionType;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class TopPlayersList extends AbstractList {

        private var battlesListItems:Vector.<TopPlayersListItem> = new Vector.<TopPlayersListItem> ();

        private static const NUM_VISIBLE_ITEMS:int = 5;
        private static const STEP:int = 54;
        private static const WIDTH:int = 485;
        private static const BOTTOM_MARGIN:int = 2;

        public function TopPlayersList (mc:MovieClip) {
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

            super (mc, NUM_VISIBLE_ITEMS, STEP, WIDTH, NUM_VISIBLE_ITEMS * STEP - BOTTOM_MARGIN, scroll);
            motionType = MotionType.Y;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function init (players:Vector.<TopPlayerData>):void {
            clear ();
            //add scroll elements:
            var numShopItems:int = players.length;
            for (var i:int = 0; i < numShopItems; i++) {
                var battlesListItem:TopPlayersListItem = new TopPlayersListItem ();
                battlesListItem.playerData = players [i];
                battlesListItem.y = i * STEP;
                battlesListItem.id = i + 1;
                battlesListItem.addEventListener (MouseEvent.CLICK, clickListener);
                container.addChild (battlesListItem);
                battlesListItems.push (battlesListItem);

            }

            //set scroll params:
            this.numItems = numShopItems;

            moveTo (0);
        }

        override public function clear ():void {
            for (var i:int = 0; i < battlesListItems.length; i++) {
                var battlesListItem:TopPlayersListItem = battlesListItems [i];
                battlesListItem.removeEventListener (MouseEvent.CLICK, clickListener);
                if (container.contains (battlesListItem)) {
                    container.removeChild (battlesListItem);
                }
                battlesListItem.destroy ();
            }
            battlesListItems = new Vector.<TopPlayersListItem> ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var battlesListItem:TopPlayersListItem = TopPlayersListItem (event.currentTarget);
            var playerData:TopPlayerData = battlesListItem.playerData;
            if (playerData) {
                trace ("click on player " + playerData.uid);
            }
        }
    }
}
