/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 29.01.14
 * Time: 21:12
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.dailyAwardPopUp {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.awards.Award;

    import com.greensock.TweenLite;
    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.TextFieldUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;

    public class Day extends GraphicStorage implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var _day:int = 1;
        private var _selected:Boolean;

        private var tfTitle:TextField;
        private var mcIcon:MovieClip;
        private var mcCurrency:Sprite;
        private var tfCoins:TextField;
        private var tfBucks:TextField;
        private var mcCoinsIcon:GraphicStorage;
        private var mcBucksIcon:GraphicStorage;

        private var tfCoinsX:Number;
        private var tfCoinsY:Number;

        private var tfBucksX:Number;
        private var tfBucksY:Number;

        private static const WIDTH:int = 90;
        private static const DISABLE_ALPHA:Number = .3;
        private static const TWEEN_TIME:Number = .3;
        private static const TO_SCALE:Number = 1.2;
        private static const EXTRA_DELAY_COUNT:int = 2;
        private static const NORMAL_TEXT_COLOR:uint = 0x000000;
        private static const SELECTED_TEXT_COLOR:uint = 0xEFC10B;

        public function Day (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get day ():int {
            return _day;
        }

        public function set day (value:int):void {
            _day = value;
            mcIcon.gotoAndStop (_day);
            setTexts ();
        }

        public function get selected ():Boolean {
            return _selected;
        }

        public function showSelected (delayCount:int = 0, isCurrentDay:Boolean = false):void {
            tfTitle.textColor = NORMAL_TEXT_COLOR;
            _selected = true;
            mcIcon.alpha = DISABLE_ALPHA;
            TweenLite.to (tfTitle, 0, {removeTint:true});
            mcCurrency.alpha = DISABLE_ALPHA;
            mcCurrency.scaleX = 1;
            mcCurrency.scaleY = 1;
            TweenLite.killTweensOf (mcIcon);
            TweenLite.killTweensOf (mcCurrency);
            var delay:Number = (delayCount + EXTRA_DELAY_COUNT) * TWEEN_TIME / 2;
            TweenLite.to (mcIcon, TWEEN_TIME, {alpha: 1, delay: delay});
            if (isCurrentDay) {
                TweenLite.to (mcCurrency, TWEEN_TIME, {alpha: 1, delay: delay, onComplete: onShowCurrency});
                TweenLite.to (tfTitle, TWEEN_TIME, {delay: delay, colorTransform:{tint:SELECTED_TEXT_COLOR}});
                TweenLite.to (tfBucks, TWEEN_TIME, {scaleX: TO_SCALE, scaleY: TO_SCALE, x:tfBucksX, y:tfBucksY - 3, delay: delay});
                TweenLite.to (tfCoins, TWEEN_TIME, {scaleX: TO_SCALE, scaleY: TO_SCALE, x:tfCoinsX, y:tfCoinsY - 3, delay: delay});
            }
        }

        private function onShowCurrency ():void {
            TweenLite.to (tfTitle, TWEEN_TIME, {removeTint:true});
            TweenLite.to (tfBucks, TWEEN_TIME, {scaleX: 1, scaleY: 1, x:tfBucksX, y:tfBucksY});
            TweenLite.to (tfCoins, TWEEN_TIME, {scaleX: 1, scaleY: 1, x:tfCoinsX, y:tfCoinsY});
        }

        public function hideSelected ():void {
            _selected = false;
            TweenLite.to (tfTitle, 0, {removeTint:true});
            tfTitle.textColor = NORMAL_TEXT_COLOR;
            TweenLite.killTweensOf (mcIcon);
            TweenLite.killTweensOf (mcCurrency);
            mcIcon.alpha = DISABLE_ALPHA;
            mcCurrency.alpha = DISABLE_ALPHA;
        }

        public function setAward (award:Award):void {
            if (award) {
                mcCurrency.visible = true;
                var positionX:int = 0;
                if (award.coins > 0) {
                    mcCoinsIcon.visible = true;
                    tfCoins.visible = true;
                    positionX += mcCoinsIcon.width;
                    tfCoins.text = String (award.coins);
                    tfCoins.width = Math.ceil (tfCoins.textWidth + 4);
                    tfCoins.x = positionX;
                    positionX += tfCoins.width;
                }
                else {
                    mcCoinsIcon.visible = false;
                    tfCoins.visible = false;
                }
                if (award.bucks > 0) {
                    mcBucksIcon.x = positionX;
                    mcBucksIcon.visible = true;
                    tfBucks.visible = true;
                    positionX += mcBucksIcon.width;
                    tfBucks.text = String (award.bucks);
                    tfBucks.width = Math.ceil (tfBucks.textWidth + 4);
                    tfBucks.x = positionX;
                    positionX += tfBucks.width;
                }
                else {
                    mcBucksIcon.visible = false;
                    tfBucks.visible = false;
                }
                mcCurrency.x = (WIDTH - positionX) / 2;
            }
            else {
                mcCurrency.visible = false;
            }
            tfCoinsX = tfCoins.x;
            tfCoinsY = tfCoins.y;
            tfBucksX = tfBucks.x;
            tfBucksY = tfBucks.y;
        }

        public function setTexts ():void {
            tfTitle.text = textsManager.getText ("day") + " " + _day;
        }


        override public function destroy ():void {
            textsManager.removeTextContainer (this);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            tfTitle = getElement ("tfTitle");
            mcIcon = getElement ("mcIcon");
            mcCurrency = getElement ("mcCurrency");
            mcCoinsIcon = new GraphicStorage (getElement ("mcCoinsIcon", mcCurrency));
            tfCoins = getElement ("tfCoins", mcCurrency);
            mcBucksIcon = new GraphicStorage (getElement ("mcBucksIcon", mcCurrency));
            tfBucks = getElement ("tfBucks", mcCurrency);

            TextFieldUtilities.setBold (tfCoins);
            TextFieldUtilities.setBold (tfBucks);

            textsManager.addTextContainer (this);
        }
    }
}
