/**
 * Created by Hogar on 28.03.14.
 */
package breakdance.ui.popups {

    import breakdance.GlobalConstants;
    import breakdance.core.ui.overlay.OverlayManager;
    import breakdance.ui.popups.infoPopUp.InfoPopUpWithCharacter2;

    import com.greensock.TweenLite;

    public class GiftPopUp extends InfoPopUpWithCharacter2 {

        public function GiftPopUp () {

        }

        override public function show ():void {
            trace ("show ErrorPopUp");
            OverlayManager.instance.addOverlay (this, OverlayManager.GIFT_LAYER_PRIORITY);
            if (mc && useShowAnimation) {
                TweenLite.killTweensOf (mc);
                mc.y = mcY - GlobalConstants.APP_HEIGHT / 2;
                TweenLite.to (mc, TWEEN_TIME, {y:mcY});
            }
        }
    }
}
