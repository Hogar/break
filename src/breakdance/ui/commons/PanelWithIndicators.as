/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.09.13
 * Time: 11:55
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;

    public class PanelWithIndicators extends GraphicStorage {

        private var _numIndicators:int = 0;
        private var indicators:Vector.<IndicatorCheckBox>;

        public function PanelWithIndicators (mc:MovieClip, numIndicators:int = 5) {
            this._numIndicators = numIndicators;
            super (mc);

            //FOR TEST+++
            setValue (Math.round (Math.random () * numIndicators));
            //FOR TEST---
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function setValue (value:int):void {
            for (var i:int = 0; i < _numIndicators; i++) {
                var indicator:IndicatorCheckBox = indicators [i];
                indicator.selected = (i < value);
            }
        }

        public function get numIndicators ():int {
            return _numIndicators;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            indicators = new Vector.<IndicatorCheckBox> ();
            for (var i:int = 1; i <= _numIndicators; i++) {
                var indicator:IndicatorCheckBox = new IndicatorCheckBox (getElement ("mcIndicator" + i));
                indicators.push (indicator);
            }
        }

    }
}