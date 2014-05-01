package breakdance.core.ui.overlay {

    import breakdance.template.Template;

    import com.greensock.TweenLite;

    import flash.display.MovieClip;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class TransactionOverlay extends BlockerOverlay {

        private var mc:MovieClip;

        static private var _instance:TransactionOverlay;
        static private const TWEEN_TIME:Number = .3;

        public static function get instance ():TransactionOverlay {
            if (!_instance) {
                _instance = new TransactionOverlay ();
            }
            return _instance;
        }

        override public function show ():void {
            super.show ();
            mc.gotoAndPlay (1);
            TweenLite.killTweensOf (mc);
            mc.alpha = 0;
            TweenLite.to (mc, TWEEN_TIME, {alpha: 1});
        }

        override public function hide ():void {
            _show--;
            TweenLite.killTweensOf (mc);
            mc.alpha = 1;
            TweenLite.to (mc, TWEEN_TIME, {alpha: 0, onComplete: onHide});
        }

        private function onHide ():void {
//            if (_show <= 0 && parent) {
            if (parent) {
                OverlayManager.instance.removeOverlay (this);
            }
        }

        public function TransactionOverlay () {
            _priority = OverlayManager.TRANSACTION_LAYER_PRIORITY;
            mc = Template.createSymbol (Template.LOADING_SCREEN);
            addChild (mc);
        }
    }

}