/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 01.08.13
 * Time: 17:55
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import breakdance.template.Template;

    import com.greensock.TweenLite;
    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.MovieClipUtilities;
    import com.hogargames.utils.StringUtilities;

    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class ItemView extends GraphicStorage {

        private var items:Vector.<String>;
        private var currentItemIndex:int = 0;
        private var timer:Timer = new Timer (SHOW_TIME * 1000);

        private static const TWEEN_TIME:Number = .3;
        private static const SHOW_TIME:Number = 2;

        public function ItemView () {
            super (Template.createSymbol (Template.MC_ITEM));
            hideItem ();
        }

        public function showItem (id:String):void {
            stopItemsShowing ();
            if (!StringUtilities.isNotValueString (id)) {
                mc.visible = MovieClipUtilities.gotoAndStop (mc, id);
            }
            else {
                mc.visible = false;
            }
            mc.visible = true;
        }

        public function hideItem ():void {
            stopItemsShowing ();
            mc.visible = false;
        }

        public function startItemsShowing (items:Vector.<String>):void {
            if (items.length == 0) {
                hideItem ();
            }
            else if (items.length == 1) {
                showItem (items [0]);
            }
            else {
                this.items = items;
                currentItemIndex = 0;
                showNextItem ();
                timer.reset ();
                timer.start ();
            }
        }

        public function stopItemsShowing ():void {
            items = null;
            TweenLite.killTweensOf (mc);
            timer.stop ();
        }

        override public function destroy ():void {
            timer.stop ();
            timer.removeEventListener (TimerEvent.TIMER, timerListener);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            timer.addEventListener (TimerEvent.TIMER, timerListener);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function showNextItem ():void {
            if (items) {
                var shopItemId:String = items [currentItemIndex];
                TweenLite.killTweensOf (mc);
                mc.alpha = 0;
                mc.visible = MovieClipUtilities.gotoAndStop (mc, shopItemId);
                TweenLite.to (mc, TWEEN_TIME, {alpha:1});
                currentItemIndex++;
                if (currentItemIndex > items.length - 1) {
                    currentItemIndex = 0;
                }
                TweenLite.delayedCall (SHOW_TIME, hideCurrentItems);
            }
        }

        private function hideCurrentItems ():void {
            TweenLite.killTweensOf (mc);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function timerListener (event:TimerEvent):void {
            showNextItem ();
        }
    }
}
