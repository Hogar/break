/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.09.13
 * Time: 3:54
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;

    public class IndicatorCheckBox extends GraphicStorage {

        private var _selected:Boolean;

        public static const DESELECT_FRAME:int = 1;
        public static const SELECT_FRAME:int = 2;

        public function IndicatorCheckBox (mc:MovieClip) {
            super (mc);
        }

        public function get selected ():Boolean {
            return _selected;
        }

        public function set selected (value:Boolean):void {
            _selected = value;
            if (_selected) {
                mc.gotoAndStop (SELECT_FRAME);
            }
            else {
                mc.gotoAndStop (DESELECT_FRAME);
            }
        }
    }
}
