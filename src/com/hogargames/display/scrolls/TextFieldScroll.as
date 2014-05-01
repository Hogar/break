/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.03.14
 * Time: 17:31
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.display.scrolls {

    import com.hogargames.display.buttons.Button;
    import com.hogargames.display.scrolls.events.ScrollEvent;
    import com.hogargames.utils.NumericalUtilities;

    import flash.display.DisplayObject;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    import flash.text.TextField;

    /**
     * Нарисованный скроллер, предоставляет методы для прокрутки текстового поля и
     * замены графики отдельных элементов скроллера.
     *
     * @example Пример использования скроллера
     * (<code>tf:TextField</code> - заранее созданное текстовое поле):
     *  <listing version="3.0">
     *  var scroll:Scroll = new Scroll (tf);
     *  addChild (scroll);
     *  </listing>
     */
    public class TextFieldScroll extends BasicScrollGraphic {

        /**
         * Текстовое поля для прокрутки.
         */
        protected var tf:TextField;

        private var _useAutoHide:Boolean = true;
        private var _useMouseWheel:Boolean = true;

        private var isDrag:Boolean = false;

        private static const MOVE_EVENT:ScrollEvent = new ScrollEvent (ScrollEvent.MOVE);

        /**
         * @param tf Текстовое поле для прокрутки.
         * @param enableButtons Включение кнопок.
         */
        public function TextFieldScroll (tf:TextField = null, enableButtons:Boolean = true):void {
            super (enableButtons);
            setTextField (tf);
            draw ();
            addEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////


        /**
         * Параметр, указывающий, скрывать ли скроллер, если поле не может прокручиваться.
         * Значение по умолчанию <code>true</code>.
         */
        public function get useAutoHide ():Boolean {
            return _useAutoHide;
        }

        public function set useAutoHide (value:Boolean):void {
            _useAutoHide = value;
            update ();
        }

        /**
         * Параметр, указывающий, проводить ли прокрутку колесом мыши.
         * Значение по умолчанию <code>true</code>.
         */
        public function set useMouseWheel (value:Boolean):void {
            if (_useMouseWheel == value) {
                return;
            }
            _useMouseWheel = value;
            deactivateMouseWheel ();
            activateMouseWheel ();
        }

        public function get useMouseWheel ():Boolean {
            return _useMouseWheel;
        }

        /**
         * Установка объектов для скроллирования.
         *
         * @param objects Объект DisplayObject или массив объектов DisplayObject для прокрутки.
         */
        public function setTextField (textField:TextField):void {
            if (tf) {
                tf.removeEventListener (Event.SCROLL, scrollListener);
                tf.removeEventListener (Event.CHANGE,changeListener);
            }
            tf = textField;
            if (tf) {
                tf.addEventListener (Event.SCROLL, scrollListener);
                tf.addEventListener (Event.CHANGE, changeListener);
            }
            activateMouseWheel ();
            update ();
        }

        /**
         * Установка позиции скроллера в процентах.
         *
         * @param percent Позиция в процентах (0.1 = 10%).
         */
        public function setPositionAt (percent:Number = 0):void {
            percent = NumericalUtilities.correctValue (percent);
            mouseUpListener (null);
            setTextFieldPosition (percent);
        }

        public function update ():void {
            moveScrollBar (getPercentByTf ());

            //test buttons and auto_hide:
            setButtonEnable (topButton, true);
            setButtonEnable (bottomButton, true);
            scrollContainer.visible = true;
            var maxPosition:int;
            var currentPosition:int;
            if (tf) {
                currentPosition = Math.max (0, tf.scrollV - 1);
                maxPosition = Math.max (0, tf.maxScrollV - 1);
            }
            if ((maxPosition == 0) || (tf.scrollV == 0)) {
                setButtonEnable (topButton, false);
                setButtonEnable (bottomButton, false);
                if (useAutoHide) {
                    scrollContainer.visible = false;
                }
            }
            else if (currentPosition == 0) {
                setButtonEnable (topButton, false);
            }
            else if (currentPosition == maxPosition) {
                setButtonEnable (bottomButton, false);
            }
        }

        public function destroy ():void {
            setTextField (null);
            removeFromStageListener (null);
            removeEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        /**
         * Прокрутка (перемещение) текстового поля.
         *
         * @param percent Позиция в процентах (0.1 = 10%).
         */
        protected function setTextFieldPosition (percent:Number):void {
            percent = NumericalUtilities.correctValue (percent);
            if (tf) {
                tf.scrollV = percent * tf.maxScrollV;
            }
            dispatchEvent (MOVE_EVENT);
        }

        /**
         * Прокрутка (перемещение) на один шаг вперед.
         */
        protected function nextStep ():void {
            doStep (true);
        }

        /**
         * Прокрутка (перемещение) на один шаг назад.
         */
        protected function previousStep ():void {
            doStep (false);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function doStep (forward:Boolean):void {
            if (tf) {
                if (forward) {
                    tf.scrollV++;
                }
                else {
                    tf.scrollV--;
                }
                update ();
            }
        }

        private function setButtonEnable (button:DisplayObject, value:Boolean):void {
            switch (button) {
                case topButton:
                    setButtonEnableForExternalButton (button, externalTopButton, value);
                    break;
                case bottomButton:
                    setButtonEnableForExternalButton (button, externalBottomButton, value);
                    break;
            }
        }

        private function setButtonEnableForExternalButton (button:DisplayObject, externalButton:DisplayObject, value:Boolean):void {
            if (!enableButtons) {
                button.visible = false;
                return;
            }
            if (externalButton) {
                if (externalButton is Button) {
                    button.visible = true;
                    var aButton:Button = Button (externalButton);
                    aButton.enable = value;
                    return;
                }
            }
            button.visible = value;
        }

        private function getPercentByTf ():Number {
            var percent:Number = 0;
            if (tf) {
                var maxPosition:int = tf.maxScrollV - 1;
                var currentPosition:int = Math.max (0, tf.scrollV - 1);
                if (maxPosition > 0) {
                    percent = currentPosition / maxPosition;
                }
            }
            return percent;
        }

        private function activateMouseWheel ():void {
            if (useMouseWheel) {
                addEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
            }
        }

        private function deactivateMouseWheel ():void {
            if (hasEventListener (MouseEvent.MOUSE_WHEEL)) {
                removeEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function addedToStageListener (event:Event):void {
            addEventListener (Event.REMOVED_FROM_STAGE, removeFromStageListener);
            scrollBar.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);
            scrollBar.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            scrollBar.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            topButton.addEventListener (MouseEvent.CLICK, clickListener);
            bottomButton.addEventListener (MouseEvent.CLICK, clickListener);
        }

        private function removeFromStageListener (event:Event):void {
            removeEventListener (Event.REMOVED_FROM_STAGE, removeFromStageListener);
            scrollBar.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);
            scrollBar.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            scrollBar.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            topButton.addEventListener (MouseEvent.CLICK, clickListener);
            bottomButton.addEventListener (MouseEvent.CLICK, clickListener);
        }

        private function mouseDownListener (event:MouseEvent):void {
            var rectangle:Rectangle = new Rectangle (0, 0, 0, baseHeight - barHeight);
            scrollBar.startDrag (false, rectangle);
            isDrag = true;
            stage.addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveListener);
            stage.addEventListener (MouseEvent.MOUSE_UP, mouseUpListener);
        }

        private function mouseWheelListener (event:MouseEvent):void {
            if (event.delta < 0) {
                nextStep ();
            }
            else {
                previousStep ();
            }
        }

        private function rollOverListener (event:MouseEvent):void {
            //
        }

        private function rollOutListener (event:MouseEvent):void {
            if (!isDrag) {
                scrollBar.filters = [];
            }
        }

        private function mouseMoveListener (event:MouseEvent):void {
            setTextFieldPosition (getPercentByScrollPosition ());
        }

        private function mouseUpListener (event:MouseEvent):void {
            scrollBar.filters = [];
            isDrag = false;
            scrollBar.stopDrag ();
            update ();
            stage.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveListener);
            stage.removeEventListener (MouseEvent.MOUSE_UP, mouseUpListener);
        }

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case topButton:
                    previousStep ();
                    break;
                case bottomButton:
                    nextStep ();
                    break;
            }
        }

        private function changeListener (event:Event):void {
            if (tf) {
                if (!isDrag) {
                    update ();
                    dispatchEvent (MOVE_EVENT);
                }
            }
        }

        private function scrollListener (event:Event):void {
            if (tf) {
                if (!isDrag) {
                    update ();
                    dispatchEvent (MOVE_EVENT);
                }
            }
        }

    }
}