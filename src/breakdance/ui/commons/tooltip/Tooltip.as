/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.07.13
 * Time: 7:15
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons.tooltip {

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

    public class Tooltip extends GraphicStorage {

        private var tf:TextField;
        private var tf2:TextField;
        private var mcTop:MovieClip;
        private var mcCenter:MovieClip;
        private var mcBottom:MovieClip;

        private var mcPrice:MovieClip;
        private var mcCoinsIcon:GraphicStorage;
        private var mcBucksIcon:GraphicStorage;

        private var tfPrice:TextField;
        private var tfCoins:TextField;
        private var tfBucks:TextField;

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
        private static const ICON_MARGIN:int = 4;

        public function Tooltip () {
            super (Template.createSymbol(Template.TOOLTIP));
            mouseEnabled = false;
            mouseChildren = false;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function showTextAndPosition (tooltipData:TooltipData, positionPoint:Point = null, noAnimation:Boolean = false, orientation:String = TooltipOrientation.BOTTOM, timeHide:Number =0):void {
            this.orientation = orientation;
            if (orientation == TooltipOrientation.BOTTOM) {
                mcBottom.visible = false;
                mcTop.visible = true;
            }
            else if (orientation == TooltipOrientation.TOP) {
                mcBottom.visible = true;
                mcTop.visible = false;
            }
            setPosition (positionPoint);
            setText (tooltipData);
            if (tooltipData && !tooltipData.isEmpty) {
                show (noAnimation);				
				if (timeHide > 0) {
					Tracer.log('timeHide  ' + timeHide +  '  ' + mc)
					TweenLite.killTweensOf (mc);
					TweenLite.to (mc, timeHide, {onComplete:onCompleteHide});
				}
			}
            else {
                hide ();
            }
        }
		public function onCompleteHide():void {
			Tracer.log('onCompleteHide  ' + onCompleteHide)
			hide();
		}

        public function setText (data:TooltipData):void {
            var tfWidth:int = 0;
            var tfHeight:int = 0;
            var tfWidth2:int = 0;
            var tfHeight2:int = 0;
            var priceHeight:int = 0;
            var hasCoins:Boolean = data.priceCoins != 0;
            var hasBucks:Boolean = data.priceBucks != 0;
            if (data.tooltipText) {
                tf.width = START_TF_WIDTH;
                tf.htmlText = data.tooltipText;
                tf.width = Math.floor (tf.textWidth + 6);
                tf.height = Math.floor (tf.textHeight + 6);
                tfWidth = tf.width;
                tfHeight = tf.height;
            }
            else {
                tf.text = "";
            }
            if (hasCoins || hasBucks) {
                mcPrice.visible = true;
                priceHeight = Math.max (mcCoinsIcon.height + mcCoinsIcon.y, mcBucksIcon.height + mcBucksIcon.y);
                mcPrice.y = tf.y + tfHeight;
                var priceWidth:int = 0;
                if (data.priceText) {
                    tfPrice.visible = true;
                    tfPrice.text = String (data.priceText);
                    tfPrice.width = Math.floor (tfPrice.textWidth + 6);
                    tfPrice.x = priceWidth;
                    priceWidth += tfPrice.width;
                }
                else {
                    tfPrice.text = "";
                    tfPrice.visible = false;
                }
                if (hasCoins) {
                    tfCoins.visible = true;
                    mcCoinsIcon.visible = true;
                    tfCoins.htmlText = "<b>" + String (data.priceCoins) + "</b>";
                    tfCoins.width = Math.floor (tfCoins.textWidth + 6);
                    tfCoins.x = priceWidth;
                    priceWidth += tfCoins.width;
                    mcCoinsIcon.x = priceWidth + ICON_MARGIN;
                    priceWidth += mcCoinsIcon.width + ICON_MARGIN;
                }
                else {
                    tfCoins.text = "";
                    tfCoins.visible = false;
                    mcCoinsIcon.visible = false;
                }

                if (hasBucks) {
                    tfBucks.visible = true;
                    mcBucksIcon.visible = true;
                    tfBucks.htmlText = "<b>" + String (data.priceBucks) + "</b>";
                    tfBucks.width = Math.floor (tfBucks.textWidth + 6);
                    tfBucks.x = priceWidth;
                    priceWidth += tfBucks.width;
                    mcBucksIcon.x = priceWidth + ICON_MARGIN;
                    priceWidth += mcBucksIcon.width + ICON_MARGIN;
                }
                else {
                    tfBucks.text = "";
                    tfBucks.visible = false;
                    mcBucksIcon.visible = false;
                }
            }
            else {
                mcPrice.visible = false;
            }
            if (data.afterPriceTooltipText) {
                tf2.y = tf.y + tfHeight + priceHeight;
                tf2.width = Math.max (START_TF_WIDTH, tfWidth, priceWidth);
                tf2.htmlText = data.afterPriceTooltipText;
                tf2.width = Math.floor (tf2.textWidth + 6);
                tf2.height = Math.floor (tf2.textHeight + 6);
                tfWidth2 = tf2.width;
                tfHeight2 = tf2.height;
            }
            else {
                tf2.text = "";
            }
            mcCenter.width = Math.ceil (Math.max (tfWidth, priceWidth, tfWidth2) + TEXT_INDENT * 2);
            mcCenter.height = Math.ceil (tfHeight + priceHeight + tfHeight2 + TEXT_INDENT * 2);
            mcBottom.y = mcCenter.y + mcCenter.height;

            if (orientation == TooltipOrientation.TOP) {
                mc.y = - (mcBottom.y + mcBottom.height);
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
            tf2 = getElement ("tf2");
            mcTop = getElement ("mcTop");
            mcCenter = getElement ("mcCenter");
            mcBottom = getElement ("mcBottom");

            mcPrice = getElement ("mcPrice");
            mcCoinsIcon = new GraphicStorage (getElement ("mcCoinsIcon", mcPrice));
            tfPrice = getElement ("tfPrice", mcPrice);
            tfCoins = getElement ("tfCoins", mcPrice);
            mcBucksIcon = new GraphicStorage (getElement ("mcBucksIcon", mcPrice));
            tfBucks = getElement ("tfBucks", mcPrice);

            topPartStartPositionX = mcTop.x;
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
                mcCenter.x + mcCenter.width - (TEXT_INDENT + mcTop.width)
            );

            mcTop.x = topPartPositionX;
            mcBottom.x = topPartPositionX;
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
