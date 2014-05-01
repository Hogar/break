/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 28.07.13
 * Time: 8:38
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import breakdance.ui.commons.buttons.Button;

    import com.greensock.TweenLite;
    import com.hogargames.display.scrolls.AbstractResizableStepScroll;
    import com.hogargames.display.scrolls.BasicScroll;
    import com.hogargames.display.scrolls.MotionType;

    import flash.display.InteractiveObject;
    import flash.display.MovieClip;

    public class AbstractList extends AbstractResizableStepScroll {

        private static const TWEEN_TIME:Number = .3;

        public function AbstractList (mc:MovieClip, numVisibleItems:int, step:Number, width:Number, height:Number, basicScroll:BasicScroll = null) {
            super (mc, numVisibleItems, step, width, height, basicScroll);
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

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
    }
}
