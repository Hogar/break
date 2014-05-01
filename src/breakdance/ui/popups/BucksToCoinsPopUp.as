/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.12.13
 * Time: 3:22
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.BreakdanceApp;
    import breakdance.core.server.ServerApi;
    import breakdance.core.staticData.StaticData;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.Button;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.basePopUps.TitleClosingPopUp;
    import breakdance.user.AppUser;

    import com.hogargames.utils.NumericalUtilities;
    import com.hogargames.utils.TextFieldUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    public class BucksToCoinsPopUp extends TitleClosingPopUp {

        private var appUser:AppUser;

        private var mcSlider:Sprite;
        private var mcSliderZone:Sprite;
        private var mcSliderHotSpot:Sprite;
        private var mcProgressBar:MovieClip;

        private var bucksToCoinsPrice:int;

        private var tfBucks:TextField;
        private var tfCoins:TextField;

        private var btnMinus:Button;
        private var btnPlus:Button;
        private var btnChange:ButtonWithText;

        private var _sliderIsDrag:Boolean = false;

        private var currentDeal:int = 0;//ставка текущей сделки (в баксах).

        public function BucksToCoinsPopUp () {
            bucksToCoinsPrice = parseInt (StaticData.instance.getSetting ("bucks_to_coins"));

            appUser = BreakdanceApp.instance.appUser;

            super (Template.createSymbol (Template.BUCKS_TO_COINS_POP_UP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            super.setTexts ();
            tfTitle.text = textsManager.getText ("bucksToCoins");
            btnChange.text = textsManager.getText ("change");
        }

        override public function show ():void {
            super.show ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            //Инициализируем графические элементы:
            mcSlider = Sprite (getElement ("mcSlider"));
            mcSlider.buttonMode = true;
            mcSlider.useHandCursor = true;
            mcSliderZone = Sprite (getElement ("mcSliderZone"));
            mcSliderHotSpot = Sprite (getElement ("mcSliderHotSpot"));
            mcProgressBar = getElement ("mcProgressBar");

            tfBucks = getElement ("tfBucks");
            tfCoins = getElement ("tfCoins");

            TextFieldUtilities.setBold (tfBucks);
            TextFieldUtilities.setBold (tfCoins);

            btnMinus = new Button (mc ["btnMinus"]);
            btnPlus = new Button (mc ["btnPlus"]);
            btnChange = new ButtonWithText (mc ["btnChange"]);

            //Устанавливаем слушатели:
            mcSlider.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);
            addEventListener (MouseEvent.MOUSE_UP, mouseUpListener);
            mcSliderHotSpot.addEventListener (MouseEvent.CLICK, clickListener_hotSpot);

            btnMinus.addEventListener (MouseEvent.CLICK, clickListener);
            btnPlus.addEventListener (MouseEvent.CLICK, clickListener);
            btnChange.addEventListener (MouseEvent.CLICK, clickListener);

            setDeal (0);
            updateSlider ();

            textsManager.addTextContainer (this);
        }

        private function startSliderDrag ():void {
            trace ("startSliderDrag");
            _sliderIsDrag = true;
            addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveListener);
            var rect:Rectangle = new Rectangle (mcSliderZone.x, mcSliderZone.y, mcSliderZone.width, 0);
            mcSlider.startDrag (false, rect);
        }

        private function stopSliderDrag ():void {
            if (_sliderIsDrag) {
                trace ("stopSliderDrag");
                mcSlider.stopDrag ();
                removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveListener);
                var percent:Number = (mcSlider.x - mcSliderZone.x) / mcSliderZone.width;
                setDealByPercent (percent);
                updateSlider ();
                _sliderIsDrag = false;
            }
        }

        //Обновление данных по позиции слайдера.
        private function setDealByPercent (percent:Number):void {
            percent = NumericalUtilities.correctValue (percent, 0, 1);
            mcProgressBar.gotoAndStop (Math.max (1, Math.round (percent * 100)));
            var maxValue:Number = getMaxValue ();
            setDeal (Math.round (maxValue * percent));
        }

        //Установка текущей ставки.
        private function setDeal (value:int):void {
            var maxValue:Number = getMaxValue ();
            currentDeal = NumericalUtilities.correctValue (value, 0, maxValue);
            testButtons ();

            tfBucks.text = String (currentDeal);
            tfCoins.text = String (currentDeal * bucksToCoinsPrice);
        }

        //Позиционирование слайдера по выбраной ставке.
        private function updateSlider ():void {
            var maxValue:Number = getMaxValue ();
            var percent:Number;
            if (maxValue == 0) {
                percent = 0;
            }
            else {
                percent = Math.min (1, currentDeal / maxValue);
            }
            mcSlider.x = mcSliderZone.x + mcSliderZone.width * percent;
            if (maxValue > 0) {
                mcProgressBar.gotoAndStop (Math.max (1, Math.round ((currentDeal / maxValue) * 100)));
            }
            else {
                mcProgressBar.gotoAndStop (1);
            }
        }

        //Проверка активности кнопок в зависимости от выбраной ставки.
        private function testButtons ():void {
            var maxValue:Number = getMaxValue ();
            btnMinus.enable = true;
            btnPlus.enable = true;
            if (currentDeal == 0) {
                btnMinus.enable = false;
                btnChange.enable = false;
            }
            else {
                btnChange.enable = true;
            }
            if (currentDeal == maxValue) {
                btnPlus.enable = false;
            }
        }

        //Получение максимальной возможной ставки.
        private function getMaxValue ():int {
            var maxValue:Number = appUser.bucks;
            return maxValue;
        }

/////////////////////////////////////////////
//LISTEBERS:
/////////////////////////////////////////////

        private function mouseDownListener (event:MouseEvent):void {
            var maxValue:Number = getMaxValue ();
            if (maxValue > 0) {
                startSliderDrag ();
            }
        }

        private function mouseUpListener (event:MouseEvent):void {
            stopSliderDrag ();
        }

        private function mouseMoveListener (event:MouseEvent):void {
            var percent:Number = ((mcSlider.x - mcSliderZone.x) / mcSliderZone.width);
            setDealByPercent (percent);
        }

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case (btnPlus):
                    setDeal (currentDeal + 1);
                    updateSlider ();
                    break;
                case (btnMinus):
                    setDeal (currentDeal - 1);
                    updateSlider ();
                    break;
                case (btnChange):
                    ServerApi.instance.query (ServerApi.SELL_BUCKS, {bucks:currentDeal}, onResponse);
                    break;

            }
        }

        private function onResponse (response:Object):void {
            appUser.onResponseWithUpdateUserData (response);
            setDeal (currentDeal);
            updateSlider ();
        }

        private function clickListener_hotSpot (event:MouseEvent):void {
            var percent:Number = (event.localX / mcSliderHotSpot.width);
            setDealByPercent (percent);
            updateSlider ();
        }

    }
}
