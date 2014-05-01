/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.03.14
 * Time: 16:46
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.newsPopUp {

    import breakdance.BreakdanceApp;
    import breakdance.data.news.NewData;
    import breakdance.ui.commons.buttons.Button;
    import breakdance.ui.popups.newsPopUp.events.SelectNewDataEvent;

    import com.greensock.TweenLite;
    import com.hogargames.display.scrolls.AbstractResizableStepScroll;
    import com.hogargames.display.scrolls.MotionType;

    import flash.display.InteractiveObject;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class NewsList extends AbstractResizableStepScroll {

        private var items:Vector.<NewsListItem> = new Vector.<NewsListItem> ();

        private static const NUM_VISIBLE_ITEMS:int = 5;
        private static const STEP:int = 66;
        private static const HEIGHT:int = 66;
        private static const TWEEN_TIME:Number = .3;
        private static const TOOLTIP_X:int = 33;
        private static const TOOLTIP_Y:int = 66;

        public function NewsList (mc:MovieClip) {
            super (mc, NUM_VISIBLE_ITEMS, STEP, NUM_VISIBLE_ITEMS * STEP, HEIGHT);
            motionType = MotionType.X;
        }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

        public function init (news:Vector.<NewData>):void {
            clear ();
            //add scroll elements:
            var numFriends:int = news.length;
            items = new Vector.<NewsListItem> ();
            var totalItems:int = numFriends;
            if ((totalItems % NUM_VISIBLE_ITEMS != 0) || (numFriends == 0)) {
                totalItems = (Math.floor (numFriends / NUM_VISIBLE_ITEMS) + 1) * NUM_VISIBLE_ITEMS;
            }
            for (var i:int = 0; i < totalItems; i++) {
                var newsListItem:NewsListItem = new NewsListItem ();
                if (i < numFriends) {
                    newsListItem.newData = news [i];
                    newsListItem.addEventListener (MouseEvent.CLICK, clickListener);
                    newsListItem.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                    newsListItem.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                }
                newsListItem.x = STEP * i;
                container.addChild (newsListItem);
                items.push (newsListItem);
            }

            //set scroll params:
            this.numItems = totalItems;
            moveTo (0);
        }

        public function selectNew (newData:NewData, withDispatch:Boolean = true):void {
            for (var i:int = 0; i < items.length; i++) {
                var newsListItem:NewsListItem = items [i];
                if (newsListItem.newData == newData) {
                    selectItem (newsListItem, withDispatch);
                }
            }
        }

        override public function clear ():void {
            for (var i:int = 0; i < items.length; i++) {
                var newsListItem:NewsListItem = items [i];
                newsListItem.removeEventListener (MouseEvent.CLICK, clickListener);
                newsListItem.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                newsListItem.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                if (container.contains (newsListItem)) {
                    container.removeChild (newsListItem);
                }
                newsListItem.destroy ();
            }
        }

        override public function destroy ():void {
            clear ();
            super.destroy ();
        }

//////////////////////////////////
//PROTECTED:
//////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            //создаём кнопки:
            btnNext = new Button (getElement (BTN_NEXT));
            btnPrevious = new Button (getElement (BTN_PREVIOUS));
            if (btnBegin) {
                btnBegin = new Button (getElement (BTN_BEGIN));
            }
            if (btnEnd) {
                btnEnd = new Button (getElement (BTN_END));
            }
        }

        override protected function move (targetCoordinate:Number):void {
            if (motionType == MotionType.X) {
                TweenLite.to (container, TWEEN_TIME, {x: targetCoordinate});
            }
            else if (motionType == MotionType.Y) {
                TweenLite.to (container, TWEEN_TIME, {y: targetCoordinate});
            }
        }

        override protected function activateButton (btn:InteractiveObject):void {
            if (btn != null) {
                Button (btn).enable = true;
            }
        }

        override protected function deactivateButton (btn:InteractiveObject):void {
            if (btn != null) {
                Button (btn).enable = false;
            }
        }

//////////////////////////////////
//PRIVATE:
//////////////////////////////////

        private function selectItem (newsListItem:NewsListItem, withDispatch:Boolean = true):void {
            if (newsListItem.newData) {
                for (var i:int = 0; i < items.length; i++) {
                    var _newsListItem:NewsListItem = items [i];
                    _newsListItem.selected = (_newsListItem == newsListItem);
                }
                if (withDispatch) {
                    dispatchEvent (new SelectNewDataEvent (SelectNewDataEvent.SELECT_NEW_DATA, newsListItem.newData));
                }
            }
        }

//////////////////////////////////
//LISTENERS:
//////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var newsListItem:NewsListItem = NewsListItem (event.currentTarget);
            selectItem (newsListItem);
        }

        private function rollOverListener (event:MouseEvent):void {
            var _newsListItem:NewsListItem = NewsListItem (event.currentTarget);
            var positionPoint:Point = _newsListItem.localToGlobal (new Point (TOOLTIP_X, TOOLTIP_Y));
            var message:String = "";
            if (_newsListItem.newData) {
                var newData:NewData = _newsListItem.newData;
                message = "";
//                message += newData.dateAsString + "\n";
//                message += '<p align="center">' + TextsManager.instance.getText ("ttLine") + "<br></p>";
                message += newData.text;
            }
            BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }

        /**
         * @private
         */
        override protected function clickListener_btnNext (event:MouseEvent):void {
            moveTo (currentMovingIndex + NUM_VISIBLE_ITEMS);
        }

        /**
         * @private
         */
        override protected function clickListener_btnPrevious (event:MouseEvent):void {
            moveTo (currentMovingIndex - NUM_VISIBLE_ITEMS);
        }
    }
}
