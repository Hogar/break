package breakdance.core.ui.overlay {

    import breakdance.GlobalConstants;

    import flash.display.Sprite;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class BlockerOverlay extends Sprite {

        protected var _priority:int = OverlayManager.DIALOG_BACK_LAYER_PRIORITY;
        protected var _show:int = 0;

        static private var _instance:BlockerOverlay;

        public static function get instance ():BlockerOverlay {
            if (!_instance) {
                _instance = new BlockerOverlay ();
            }
            return _instance;
        }

        public function BlockerOverlay () {
            graphics.beginFill (0x0, 0.3);
            graphics.drawRect (0, 0, GlobalConstants.APP_WIDTH, GlobalConstants.APP_HEIGHT);
            graphics.endFill ();

        }

        public function show ():void {
            _show++;

//            if (_show > 0 && !parent) {
            if (!parent) {
                OverlayManager.instance.addOverlay (this, _priority);
            }
        }

        public function hide ():void {
            _show--;

            if (_show < 0) {
                trace ("AHA!!!");
            }

            if (_show <= 0 && parent) {
                OverlayManager.instance.removeOverlay (this);
            }
        }

    }

}