/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 29.10.13
 * Time: 20:03
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.pvpLogPanel {

    import breakdance.ui.commons.AbstractList;
    import breakdance.ui.popups.pvpLogPanel.events.SelectPvpLogItemEvent;

    import com.hogargames.display.scrolls.BasicScrollWithTweenLite;
    import com.hogargames.display.scrolls.MotionType;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class PvpLogList extends AbstractList {

        private var logItems:Vector.<PvpLogListItem> = new Vector.<PvpLogListItem> ();

        private static const NUM_VISIBLE_ITEMS:int = 7;
        private static const STEP:int = 40;
        private static const WIDTH:int = 280;

        public function PvpLogList (mc:MovieClip) {
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

        public function init (logs:Vector.<LogData>):void {
            clear ();
            //add scroll elements:
            var numShopItems:int = logs.length;
            for (var i:int = 0; i < numShopItems; i++) {
                var pvpLogListItem:PvpLogListItem = new PvpLogListItem ();
                pvpLogListItem.id = i + 1;
                pvpLogListItem.logData = logs [i];
                pvpLogListItem.y = i * STEP;
                pvpLogListItem.addEventListener (MouseEvent.CLICK, clickListener);
                container.addChild (pvpLogListItem);
                logItems.push (pvpLogListItem);
            }

            //set scroll params:
            this.numItems = numShopItems;

            moveTo (getMaxMovingIndex ());
        }

        override public function clear ():void {
            for (var i:int = 0; i < logItems.length; i++) {
                var pvpLogListItem:PvpLogListItem = logItems [i];
                pvpLogListItem.removeEventListener (MouseEvent.CLICK, clickListener);
                if (container.contains (pvpLogListItem)) {
                    container.removeChild (pvpLogListItem);
                }
                pvpLogListItem.destroy ();
            }
            logItems = new Vector.<PvpLogListItem> ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var pvpLogListItem:PvpLogListItem = PvpLogListItem (event.currentTarget);
            var logData:LogData = pvpLogListItem.logData;
            for (var i:int = 0 ; i < logItems.length; i++) {
                logItems [i].selected = (logItems [i] == pvpLogListItem);
            }
            if (logData) {
                dispatchEvent (new SelectPvpLogItemEvent (logData));
            }
        }
    }
}
