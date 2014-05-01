/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 02.10.13
 * Time: 8:51
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.roundIndicator {

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;

    public class RoundIndicator extends GraphicStorage {

        private var _selected:Boolean;
        private var _completed:Boolean;

        private static const NORMAL_STATE_FRAME:int = 1;
        private static const SELECT_STATE_FRAME:int = 2;
        private static const UNCOMPLETED_ALPHA:Number = .25;

        public function RoundIndicator (mc:MovieClip) {
            super (mc);
            enable = true;
            completed = false;
            _selected = false;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Выделение раунда, как текущего.
         */
        public function get selected ():Boolean {
            return _selected;
        }

        public function set selected (value:Boolean):void {
            _selected = value;
            if (_selected) {
                mc.gotoAndStop (SELECT_STATE_FRAME);
            }
            else {
                mc.gotoAndStop (NORMAL_STATE_FRAME);
            }
        }

        /**
         * Выделение раунда, как завершённого.
         */
        public function get completed ():Boolean {
            return _completed;
        }

        public function set completed (value:Boolean):void {
            _completed = value;
            alpha = _completed ? 1 : UNCOMPLETED_ALPHA;
        }

        public function get enable ():Boolean {
            return visible;
        }

        public function set enable (value:Boolean):void {
            visible = value;
        }
    }
}
