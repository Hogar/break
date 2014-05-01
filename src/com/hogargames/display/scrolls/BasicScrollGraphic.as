/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.03.14
 * Time: 4:21
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.display.scrolls {

    import com.hogargames.display.scrolls.events.ScrollEvent;
    import com.hogargames.utils.NumericalUtilities;
    import com.hogargames.utils.ResizeUtilities;

    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.Sprite;

    /**
     * Нарисованный скроллер, предоставляет методы для прокрутки объектов и
     * замены графики отдельных элементов скроллера. Без логики.
     *
     * @example Пример использования скроллера
     * (<code>objectForScrolling</code> - заранее созданный объект для прокрутки):
     *  <listing version="3.0">
     *  var scroll:Scroll = new Scroll ();
     *  addChild (scroll);
     *  scroll.movingArea = 300;
     *  scroll.setObjects (objectForScrolling);
     *  </listing>
     */
    public class BasicScrollGraphic extends Sprite {

        /**
         * Нарисованный бегунок скроллера.
         */
        protected var scrollBar:Sprite = new Sprite ();

        /**
         * Нарисованная подложка скроллера.
         */
        protected var scrollBase:Sprite = new Sprite ();

        /**
         * Нарисованная верхняя кнопка.
         */
        protected var topButton:Sprite = new Sprite ();

        /**
         * Нарисованная нижняя кнопка.
         */
        protected var bottomButton:Sprite = new Sprite ();

        /**
         * Графика для бегунка скроллера.
         */
        protected var externalScrollBar:DisplayObject;

        /**
         * Графика для подложки скроллера.
         */
        protected var externalScrollBase:DisplayObject;

        /**
         * Графика верхней кнопки.
         */
        protected var externalTopButton:DisplayObject;

        /**
         * Графика нижней кнопки.
         */
        protected var externalBottomButton:DisplayObject;

        /**
         * Маска для бегунка скроллера.
         */
        protected var scrollBarMask:Shape = new Shape ();

        /**
         * Маска для подложки скроллера.
         */
        protected var scrollBaseMask:Shape = new Shape ();

        /**
         * Маска для верхней кнопки.
         */
        protected var topButtonMask:Shape = new Shape ();

        /**
         * Маска для нижней кнопки.
         */
        protected var bottomButtonMask:Shape = new Shape ();

        /**
         * Контейнер для элементов (кнопки, полузунок, подложка).
         */
        protected var scrollContainer:Sprite = new Sprite ();

        private var _barWidth:Number = 10;
        private var _barHeight:Number = 60;
        private var _barColor:uint = 0x777777;
        private var _barAlpha:Number = 1;

        private var _baseWidth:Number = 10;
        private var _baseHeight:Number = 200;
        private var _baseColor:uint = 0x999999;
        private var _baseAlpha:Number = 1;

        private var _buttonHeight:Number = 10;
        private var _buttonWidth:Number = 10;
        private var _buttonMargin:Number = 0;
        private var _buttonColor:uint = 0x999999;
        private var _buttonAlpha:Number = 1;
        private var _buttonArrowColor:uint = 0x333333;
        private var _buttonArrowAlpha:Number = 1;

        private var _enableButtons:Boolean = true;

        private static const REPOSITION_EVENT:ScrollEvent = new ScrollEvent (ScrollEvent.REPOSITION);

        /**
         * @param enableButtons Включение кнопок.
         */
        public function BasicScrollGraphic (enableButtons:Boolean = false):void {
            scrollContainer = new Sprite ();
            addChild (scrollContainer);
            scrollContainer.addChild (scrollBase);
            scrollContainer.addChild (scrollBar);
            scrollContainer.addChild (topButton);
            scrollContainer.addChild (bottomButton);
            topButton.buttonMode = true;
            topButton.useHandCursor = true;
            bottomButton.buttonMode = true;
            bottomButton.useHandCursor = true;
            scrollBar.buttonMode = true;
            scrollBar.useHandCursor = true;
            this.enableButtons = enableButtons;
            draw ();
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Подключение графики для бегунка скроллера.
         *
         * @param obj Графика для бегунка скроллера.
         * @param setNewSizes Установка размеров по размеру подключаемой графики.
         */
        public function setExternalScrollBar (obj:DisplayObject = null, setNewSizes:Boolean = false):void {
            while (scrollBar.numChildren > 0) {
                scrollBar.removeChildAt (0);
            }
            externalScrollBar = obj;
            if ((externalScrollBar != null) && setNewSizes) {
                _barWidth = externalScrollBar.width;
                _barHeight = externalScrollBar.height;
            }
            if (obj != null) {
                scrollBar.addChild (externalScrollBar);
                scrollBar.addChild (scrollBarMask);
                externalScrollBar.mask = scrollBarMask;
            }
            draw ();
        }

        /**
         * Подключение графики для подложки скроллера.
         *
         * @param obj Графика для подложки скроллера.
         * @param setNewSizes Установка размеров по размеру подключаемой графики.
         */
        public function setExternalScrollBase (obj:DisplayObject = null, setNewSizes:Boolean = false):void {
            while (scrollBase.numChildren > 0) {
                scrollBase.removeChildAt (0);
            }
            externalScrollBase = obj;
            if ((externalScrollBase != null) && setNewSizes) {
                _baseWidth = externalScrollBase.width;
                _baseHeight = externalScrollBase.height;
            }
            if (obj != null) {
                scrollBase.addChild (externalScrollBase);
                scrollBase.addChild (scrollBaseMask);
                externalScrollBase.mask = scrollBaseMask;
            }
            draw ();
        }

        /**
         * Подключение графики для верхней кнопки.
         *
         * @param obj Графика для верхней кнопки.
         * @param setNewSizes Установка размеров кнопок по размеру подключаемой графики.
         */
        public function setExternalTopButton (obj:DisplayObject = null, setNewSizes:Boolean = false):void {
            while (topButton.numChildren > 0) {
                topButton.removeChildAt (0);
            }
            externalTopButton = obj;
            if ((externalTopButton != null) && setNewSizes) {
                _buttonWidth = externalTopButton.width;
                _buttonHeight = externalTopButton.height;
            }
            if (obj != null) {
                topButton.addChild (externalTopButton);
                topButton.addChild (topButtonMask);
                externalTopButton.mask = topButtonMask;
            }
            draw ();
        }

        /**
         * Подключение графики для нижней кнопки.
         *
         * @param obj Графика для нижней кнопки.
         * @param setNewSizes Установка размеров кнопок по размеру подключаемой графики.
         */
        public function setExternalBottomButton (obj:DisplayObject = null, setNewSizes:Boolean = false):void {
            while (bottomButton.numChildren > 0) {
                bottomButton.removeChildAt (0);
            }
            externalBottomButton = obj;
            if ((externalBottomButton != null) && setNewSizes) {
                _buttonWidth = externalBottomButton.width;
                _buttonHeight = externalBottomButton.height;
            }
            if (obj != null) {
                bottomButton.addChild (externalBottomButton);
                bottomButton.addChild (bottomButtonMask);
                externalBottomButton.mask = bottomButtonMask;
            }
            draw ();
        }

        /**
         * Высота бегунка скроллера.
         */
        public function set barHeight (value:Number):void {
            value = NumericalUtilities.correctValue (value, 1, (baseHeight - 1));
            _barHeight = value;
            draw ();
            moveScrollBar (getPercentByScrollPosition ());
        }

        public function get barHeight ():Number {
            return _barHeight;
        }

        /**
         * Ширина бегунка скроллера.
         */
        public function set barWidth (value:Number):void {
            value = Math.max (value, 1);
            _barWidth = value;
            draw ();
        }

        public function get barWidth ():Number {
            return Math.max (_barWidth, _baseWidth);
        }

        /**
         * Высота подложки скроллера.
         */
        public function get baseHeight ():Number {
            return _baseHeight;
        }

        public function set baseHeight (value:Number):void {
            value = Math.max (value, (barHeight + 1));
            _baseHeight = value;
            draw ();
            moveScrollBar (getPercentByScrollPosition ());
        }

        /**
         * Ширина подложки скроллера.
         */
        public function get baseWidth ():Number {
            return _baseWidth;
        }

        public function set baseWidth (value:Number):void {
            value = Math.max (value, 1);
            _baseWidth = value;
            draw ();
        }

        /**
         * Цвет бегунка скроллера.
         */
        public function get barColor ():uint {
            return _barColor;
        }

        public function set barColor (value:uint):void {
            _barColor = value;
            draw ();
        }

        /**
         * Цвет подложки скроллера.
         */
        public function get baseColor ():uint {
            return _baseColor;
        }

        public function set baseColor (value:uint):void {
            _baseColor = value;
            draw ();
        }

        /**
         * Прозрачность бегунка скроллера.
         */
        public function get barAlpha ():Number {
            return _barAlpha;
        }

        public function set barAlpha (value:Number):void {
            value = NumericalUtilities.correctValue (value);
            _barAlpha = value;
            draw ();
        }

        /**
         * Прозрачность подложки скроллера.
         */
        public function get baseAlpha ():Number {
            return _baseAlpha;
        }

        public function set baseAlpha (value:Number):void {
            value = NumericalUtilities.correctValue (value);
            _baseAlpha = value;
            draw ();
        }

        /**
         * Ширина кнопки.
         */
        public function get buttonWidth ():Number {
            return _buttonWidth;
        }

        public function set buttonWidth (value:Number):void {
            value = Math.max (value, 1);
            _buttonWidth = value;
            draw ();
        }

        /**
         * Высота кнопки.
         */
        public function get buttonHeight ():Number {
            return _buttonHeight;
        }

        public function set buttonHeight (value:Number):void {
            value = Math.max (value, 1);
            _buttonHeight = value;
            draw ();
        }

        /**
         * Отступ от кнопок.
         */
        public function get buttonMargin ():Number {
            return _buttonMargin;
        }

        public function set buttonMargin (value:Number):void {
            value = Math.max (value, 0);
            _buttonMargin = value;
            draw ();
        }

        /**
         * Цвет кнопкок.
         */
        public function get buttonColor ():uint {
            return _buttonColor;
        }

        public function set buttonColor (value:uint):void {
            _buttonColor = value;
        }

        /**
         * Цвет стрелки кнопок.
         */
        public function get buttonArrowColor ():uint {
            return _buttonArrowColor;
        }

        public function set buttonArrowColor (value:uint):void {
            _buttonArrowColor = value;
        }

        /**
         * Прозрачность кнопок.
         */
        public function get buttonAlpha ():Number {
            return _buttonAlpha;
        }

        public function set buttonAlpha (value:Number):void {
            _buttonAlpha = value;
        }

        /**
         * Прозрачность стрелки у кнопок.
         */
        public function get buttonArrowAlpha ():Number {
            return _buttonArrowAlpha;
        }

        public function set buttonArrowAlpha (value:Number):void {
            _buttonArrowAlpha = value;
        }

        /**
         * Отображение кнопок.
         */
        public function get enableButtons ():Boolean {
            return _enableButtons;
        }

        public function set enableButtons (value:Boolean):void {
            _enableButtons = value;
            topButton.visible = value;
            bottomButton.visible = value;
        }


        /**
         * Общая высота кноки (с отступом).
         */
        public function get totalButtonHeight ():Number {
            return _buttonHeight + _buttonMargin;
        }

        /**
         * Ширина.
         */
        public function get totalWidth ():Number {
            return Math.max (_barWidth, _baseWidth, _buttonWidth);
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        /**
         * Прокрутка (перемещение) бегунка скролла.
         *
         * @param percent Позиция в процентах (0.1 = 10%).
         */
        protected function moveScrollBar (percent:Number):void {
            percent = NumericalUtilities.correctValue (percent);
            var amountToScroll:Number = baseHeight - barHeight;
            scrollBar.y = percent * amountToScroll;
        }

        protected function getPercentByScrollPosition ():Number {
            var amountToScroll:Number = baseHeight - barHeight;
            var percent:Number = scrollBar.y / amountToScroll;
            return percent;
        }

        protected function draw ():void {
            //бегунок скроллера
            scrollBase.graphics.clear ();
            scrollBaseMask.graphics.clear ();
            var barX:Number = (barWidth - baseWidth) / 2;
            if (externalScrollBase) {
                ResizeUtilities.resizeObj (externalScrollBase, baseWidth, baseHeight, ResizeUtilities.MODE_FILLING);
                externalScrollBase.x = (baseWidth - externalScrollBase.width) / 2 + barX;
                externalScrollBase.y = (baseHeight - externalScrollBase.height) / 2;
                externalScrollBase.alpha = baseAlpha;
                scrollBaseMask.graphics.beginFill (0x00ff00, 1);
                scrollBaseMask.graphics.drawRect (barX, 0, baseWidth, baseHeight);
                scrollBaseMask.graphics.endFill ();
            }
            else {
                scrollBase.graphics.beginFill (baseColor, baseAlpha);
                scrollBase.graphics.drawRect (barX, 0, baseWidth, baseHeight);
                scrollBase.graphics.endFill ();
            }

            //подложка скроллера
            scrollBar.graphics.clear ();
            scrollBarMask.graphics.clear ();
            if (externalScrollBar != null) {
                ResizeUtilities.resizeObj (externalScrollBar, barWidth, barHeight, ResizeUtilities.MODE_FILLING);
                externalScrollBar.x = (barWidth - externalScrollBar.width) / 2;
                externalScrollBar.y = (barHeight - externalScrollBar.height) / 2;
                externalScrollBar.alpha = barAlpha;
                scrollBarMask.graphics.beginFill (0x00ff00, 1);
                scrollBarMask.graphics.drawRect (0, 0, barWidth, barHeight);
                scrollBarMask.graphics.endFill ();
            }
            else {
                scrollBar.graphics.beginFill (barColor, barAlpha);
                scrollBar.graphics.drawRect (0, 0, barWidth, barHeight);
                scrollBar.graphics.endFill ();
            }

            //кнопки
            var buttonX:Number;
            var buttonY:Number;
            var arrowToX:Number;
            var arrowToY:Number;
            var minSide:int = Math.min (buttonWidth, buttonHeight);
            var arrowMargin:int = Math.floor (minSide / 6);
            var marginX:Number = (buttonWidth - minSide) / 2;
            var marginY:Number = (buttonHeight - minSide) / 2;

            //верхняя кнопка
            topButton.graphics.clear ();
            topButtonMask.graphics.clear ();
            buttonX = (barWidth - buttonWidth) / 2;
            buttonY = - (buttonHeight + buttonMargin);
            if (externalTopButton) {
                ResizeUtilities.resizeObj (externalTopButton, buttonWidth, buttonHeight, ResizeUtilities.MODE_FILLING);
                externalTopButton.x = (buttonWidth - externalTopButton.width) / 2  + (Math.max (barWidth, baseWidth) - buttonWidth) / 2;
                externalTopButton.y = (buttonHeight - externalTopButton.height) / 2  + buttonY;
                externalTopButton.alpha = buttonAlpha;
                topButtonMask.graphics.beginFill (0x00ff00, 1);
                topButtonMask.graphics.drawRect (buttonX, buttonY, buttonWidth, buttonHeight);
                topButtonMask.graphics.endFill ();
            }
            else {
                topButton.graphics.beginFill (buttonColor, buttonAlpha);
                topButton.graphics.drawRect (buttonX, buttonY, buttonWidth, buttonHeight);
                if (arrowMargin > 0) {
                    arrowToX = buttonX + marginX;
                    arrowToY = buttonY + marginY;
                    topButton.graphics.beginFill (buttonArrowColor, buttonArrowAlpha);
                    topButton.graphics.moveTo (arrowToX + arrowMargin, arrowToY + minSide - arrowMargin);
                    topButton.graphics.lineTo (arrowToX + minSide / 2, arrowToY + arrowMargin);
                    topButton.graphics.lineTo (arrowToX + minSide - arrowMargin, arrowToY + minSide - arrowMargin);
                    topButton.graphics.lineTo (arrowToX + arrowMargin, arrowToY + minSide - arrowMargin);
                }
                topButton.graphics.endFill ();
            }

            //нижняя кнопка
            bottomButton.graphics.clear ();
            bottomButtonMask.graphics.clear ();
            buttonX = (barWidth - buttonWidth) / 2;
            buttonY = baseHeight + buttonMargin;
            if (externalBottomButton) {
                ResizeUtilities.resizeObj (externalBottomButton, buttonWidth, buttonHeight, ResizeUtilities.MODE_FILLING);
                externalBottomButton.x = (buttonWidth - externalBottomButton.width) / 2  + (Math.max (barWidth, baseWidth) - buttonWidth) / 2;
                externalBottomButton.y = (buttonHeight - externalBottomButton.height) / 2  + buttonY;
                externalBottomButton.alpha = buttonAlpha;
                bottomButtonMask.graphics.beginFill (0x00ff00, 1);
                bottomButtonMask.graphics.drawRect (buttonX, buttonY, buttonWidth, buttonHeight);
                bottomButtonMask.graphics.endFill ();
            }
            else {
                bottomButton.graphics.beginFill (buttonColor, buttonAlpha);
                bottomButton.graphics.drawRect (buttonX, buttonY, buttonWidth, buttonHeight);
                if (arrowMargin > 0) {
                    arrowToX = buttonX + marginX;
                    arrowToY = buttonY + marginY;
                    bottomButton.graphics.beginFill (buttonArrowColor, buttonArrowAlpha);
                    bottomButton.graphics.moveTo (arrowToX + arrowMargin, arrowToY + arrowMargin);
                    bottomButton.graphics.lineTo (arrowToX + minSide / 2, arrowToY + minSide - arrowMargin);
                    bottomButton.graphics.lineTo (arrowToX + minSide - arrowMargin, arrowToY + arrowMargin);
                    bottomButton.graphics.lineTo (arrowToX + arrowMargin, arrowToY + arrowMargin);
                }
                bottomButton.graphics.endFill ();
            }

            dispatchEvent (REPOSITION_EVENT);
        }

    }
}