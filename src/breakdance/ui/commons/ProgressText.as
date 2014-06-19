package breakdance.ui.commons 
{
	import com.hogargames.display.GraphicStorage;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.hogargames.utils.NumericalUtilities;
	/**
	 * ...
	 * @author gray_crow
	 */
	public class ProgressText  extends GraphicStorage {
	
		private var _current : int;
		private var _max : int;
		
		private var tf:TextField;
        private var mcProgress:MovieClip;
		
		
        private static const ELEMENT_WIDTH:int = 184;
        private static const TEXT_INDENT:int = 4;
        private static const PERCENT_INDENT:int = 3;
		
		public function ProgressText (mc:MovieClip) {
            super (mc);
        }
		
	
/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

		public function changeFilling (current:int=0, max: int=1):void {
			_current = current
			_max = max;
			
			tf.htmlText = _current+'/'+_max;
            tf.width =  Math.ceil (tf.textWidth + 4);
            tf.x = ELEMENT_WIDTH / 2 - Math.floor (tf.width / 2) - TEXT_INDENT;
         //  tfPercent.x = tf.x + tf.width - PERCENT_INDENT;
			
            var value: int = NumericalUtilities.correctValue (int(_current*100/_max), 1, 100);
			mcProgress.gotoAndStop (value);
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            tf = getElement ("tfText");
            mcProgress = getElement ("mcProgress");

            changeFilling ();

        }

    }		

}
