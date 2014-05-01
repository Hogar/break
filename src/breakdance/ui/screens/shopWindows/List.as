/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.08.13
 * Time: 11:21
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows {

    import breakdance.ui.commons.AbstractList;

    import com.hogargames.display.scrolls.BasicScrollWithTweenLite;
    import com.hogargames.display.scrolls.MotionType;

    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class List extends AbstractList {

        protected static const NUM_VISIBLE_ITEMS:int = 3;
        protected static const NUM_COLUMNS:int = 3;
        protected static const STEP:int = 75;
        protected static const WIDTH:int = 225;
        protected static const HEIGHT:int = 273;

        public function List (mc:MovieClip) {

            //создаём скролл-бар:
            var mcScrollBar:Sprite = getElement ("mcScrollBar", mc);
            var mcScrollBase:Sprite = getElement ("mcScrollBase", mc);
            var scroll:BasicScrollWithTweenLite = new BasicScrollWithTweenLite ();
            scroll.x = mcScrollBase.x;
            scroll.y = mcScrollBase.y;
            scroll.setExternalScrollBar (mcScrollBar, true);
            scroll.setExternalScrollBase (mcScrollBase, true);
            addChild (scroll);

            super (mc, NUM_VISIBLE_ITEMS, STEP, WIDTH, HEIGHT, scroll);
            motionType = MotionType.Y;
        }

        public function lockMouseWheel ():void {
            useMouseWheel = false;
        }

        public function unLockMouseWheel ():void {
            useMouseWheel = true;
        }

    }
}
