package breakdance.ui.commons.tooltip 
{
	/**
	 * ...
	 * @author gray_crow
	 */

    import breakdance.GlobalConstants;
    import breakdance.template.Template;
	import flash.utils.Timer;

    import com.greensock.TweenLite;
    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.NumericalUtilities;

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.text.TextField;
	import flash.events.TimerEvent;
	import com.hogargames.debug.Tracer;

    public class Tooltip2 extends GraphicStorage {

        private var tf:TextField;
        private var mcCenter:MovieClip;       
        private var _isShowed:Boolean = false;

        private var topPartStartPositionX:int;
        private var centerPartStartPositionX:int;
        private var tfStartWidth:int;

        private var positionX:Number;
        private var positionY:Number;
		
        private var orientation:String = TooltipOrientation.BOTTOM;

        private static const SHOW_TWEEN_TIME:Number = .3;
        private static const SHOW_DELAY:Number = .5;
        private static const TEXT_INDENT:int = 4;
        private static const START_TF_WIDTH:int = 180;


        public function Tooltip2 () {
            super (Template.createSymbol(Template.TOOLTIP2));
            mouseEnabled = false;
            mouseChildren = false;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function showTextAndPosition (msg:String, positionPoint:Point = null, noAnimation:Boolean = false, orientation:String = TooltipOrientation.BOTTOM, timeHide:Number =0):void {
            this.orientation = orientation;      
            setPosition (positionPoint);
            setText (msg);
            if (msg != '') {				
                show (noAnimation);				
				if (timeHide > 0) {
					TweenLite.killTweensOf (mc.tf);
					TweenLite.to (mc.tf, timeHide, {onComplete:onCompleteHide});
				}
			}
            else {
				hide ();
            }
        }
		public function onCompleteHide():void {
			hide();
		}

        public function setText (msg:String):void {
            var tfWidth:int = 0;
            var tfHeight:int = 0;
            if (msg) {
                tf.width = START_TF_WIDTH;
                tf.htmlText = msg;
                tf.width = Math.floor (tf.textWidth + 6);
                tf.height = Math.floor (tf.textHeight + 6);
                tfWidth = tf.width;
                tfHeight = tf.height;
            }
            else {
                tf.text = "";
            }          
            mcCenter.width = Math.ceil (tfWidth + TEXT_INDENT * 2);
            mcCenter.height = Math.ceil (tfHeight + TEXT_INDENT * 2);
            
            if (orientation == TooltipOrientation.TOP) {
                mc.y = - (mcCenter.y + mcCenter.height);
            }
            else if (orientation == TooltipOrientation.BOTTOM) {
                mc.y = 0;
            }
        }

        public function setPosition (positionPoint:Point = null):void {
            if (positionPoint) {
                positionX = positionPoint.x;
                positionY = positionPoint.y;
            }
            else {
                positionX = NaN;
                positionY = NaN;
            }
        }

        public function show (noAnimation:Boolean = false):void {
            position ();
            if (!noAnimation) {
                TweenLite.killTweensOf (mc);
                _isShowed = false;
                mc.alpha = 0;
                TweenLite.to (mc, SHOW_TWEEN_TIME, {alpha:1, delay:SHOW_DELAY, onComplete:setShowed});
            }
        }
		
        public function hide ():void {
			Tracer.log('tooltip    hide   '+positionY)
            TweenLite.killTweensOf (mc);
            TweenLite.to (mc, SHOW_TWEEN_TIME, {alpha:0, onComplete:setHide});
            setPosition (null);
        }

        override public function destroy ():void {
            removeEventListener (Event.ENTER_FRAME, enterFrameListener);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            tf = getElement ("tf");
			mcCenter = getElement ("mcCenter");
            
            centerPartStartPositionX = mcCenter.x;
            tfStartWidth = tf.width;

            mc.alpha = 0;

            addEventListener (Event.ENTER_FRAME, enterFrameListener);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setShowed ():void {
            _isShowed = true;
        }

        private function setHide ():void {
            _isShowed = false;
        }

        private function position ():void {
            var point:Point = new Point (mouseX, mouseY);
            var globalPoint:Point = mc.localToGlobal (point);

            var toX:Number = isNaN (positionX) ? globalPoint.x : positionX;
            var toY:Number = isNaN (positionY) ? globalPoint.y : positionY;

            toX = Math.round (NumericalUtilities.correctValue (toX, 0, GlobalConstants.APP_WIDTH - mcCenter.width));
            if (orientation == TooltipOrientation.BOTTOM) {
                toY = Math.round (NumericalUtilities.correctValue (toY, 0, GlobalConstants.APP_HEIGHT - mcCenter.height));
            }
            else if (orientation == TooltipOrientation.TOP) {
                toY = Math.round (NumericalUtilities.correctValue (toY, mcCenter.height, GlobalConstants.APP_HEIGHT));
            }

            this.x = toX;
            this.y = toY;

            var topPartPositionX:Number;
            if (isNaN (positionX)) {
                topPartPositionX = topPartStartPositionX + (globalPoint.x - toX);
            }
            else {
                topPartPositionX = topPartStartPositionX + (positionX - toX);
            }

            topPartPositionX = NumericalUtilities.correctValue (
                topPartPositionX,
                mcCenter.x + TEXT_INDENT,
                mcCenter.x + mcCenter.width - TEXT_INDENT
            );
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        protected function enterFrameListener (event:Event):void {
            if (!_isShowed) {
                position ();
            }
        }
		
    }
}
