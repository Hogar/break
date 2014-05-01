/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.02.14
 * Time: 6:41
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.GlobalConstants;
    import breakdance.core.ui.overlay.OverlayManager;
    import breakdance.ui.popups.infoPopUp.InfoPopUpWithCharacter;

    import com.greensock.TweenLite;

    public class ErrorPopUp extends InfoPopUpWithCharacter {

        public function ErrorPopUp () {

        }

        override public function show ():void {
            trace ("show ErrorPopUp");
            OverlayManager.instance.addOverlay (this, OverlayManager.ERROR_LAYER_PRIORITY);
            if (mc && useShowAnimation) {
                TweenLite.killTweensOf (mc);
                mc.y = mcY - GlobalConstants.APP_HEIGHT / 2;
                TweenLite.to (mc, TWEEN_TIME, {y:mcY});
            }
        }

    }
}
