/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.07.13
 * Time: 9:40
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.basePopUps {

    import breakdance.GlobalConstants;
    import breakdance.core.ui.overlay.OverlayManager;

    import com.greensock.TweenLite;
    import com.hogargames.app.popups.events.PopUpEvent;
    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;

    public class BasePopUp extends GraphicStorage {

        protected var useShowAnimation:Boolean = true;

        protected var mcY:int;
        protected static const TWEEN_TIME:Number = 0.2;

        public function BasePopUp (mc:MovieClip) {
            super (mc);
        }

        public function show ():void {
            OverlayManager.instance.addOverlay (this, OverlayManager.DIALOG_LAYER_PRIORITY);
            if (mc && useShowAnimation) {
                TweenLite.killTweensOf (mc);
                mc.y = mcY - GlobalConstants.APP_HEIGHT / 2;
                TweenLite.to (mc, TWEEN_TIME, {y:mcY});
            }
        }

        public function get isShowed ():Boolean {
            return (stage != null);
        }

        public function hide ():void {
            OverlayManager.instance.removeOverlay (this);
            dispatchEvent (new PopUpEvent (PopUpEvent.CLOSE));
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcY = mc.y;
        }

    }
}
