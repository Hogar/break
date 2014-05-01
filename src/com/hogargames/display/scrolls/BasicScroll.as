package com.hogargames.display.scrolls {

    import com.hogargames.display.buttons.Button;
    import com.hogargames.display.scrolls.events.ScrollEvent;
    import com.hogargames.utils.NumericalUtilities;

    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    /**
     * Нарисованный скроллер, предоставляет методы для прокрутки объектов и
     * замены графики отдельных элементов скроллера.
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
    public class BasicScroll extends BasicScrollGraphic {

        /**
         * Массив объектов <code>DisplayObject</code> для прокрутки.
         */
        protected var objects:Array/*of DisplayObjects*/ = new Array ()/*of DisplayObjects*/;
        /**
         * Массив <code>int</code> начальных позиций объектов для прокрутки.
         */
        protected var objectsStartPositions:Array/*of int*/ = new Array/*of int*/;

        private var _step:Number = 25;
        private var _movingArea:Number = 100;
        private var _motionType:String = MotionType.Y;

        private var _useScrollInvert:Boolean = true;
        private var _useAutoHide:Boolean = true;
        private var _useMouseWheel:Boolean = true;

        private var isDrag:Boolean = false;
        private var _currentMovingIndex:int = 0;

        private static const MOVE_EVENT:ScrollEvent = new ScrollEvent (ScrollEvent.MOVE);

/////////////////////////////////////////////
//CONSTRUCTOR:
/////////////////////////////////////////////

        /**
         * @param objects Объект DisplayObject или массив объектов DisplayObject для прокрутки.
         * @param enableButtons Включение кнопок.
         */
        public function BasicScroll (objects:* = null, enableButtons:Boolean = false):void {
            super (enableButtons);
            setObjects (objects);
            draw ();
            addEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Установка объектов для скроллирования.
         *
         * @param objects Объект DisplayObject или массив объектов DisplayObject для прокрутки.
         */
        public function setObjects (objects:*):void {
            deactivateMouseWheel ();
            if (objects == null) {
                objects = [];
            }
            if (objects is DisplayObject) {
                objects = [objects];
            }
            objectsStartPositions = new Array ()/*of int*/;
            for (var i:int = 0; i < objects.length; i++) {
                if (_motionType == MotionType.X) {
                    objectsStartPositions.push (DisplayObject (objects[i]).x);
                }
                else if (_motionType == MotionType.Y) {
                    objectsStartPositions.push (DisplayObject (objects[i]).y);
                }
            }
            this.objects = objects;
            _currentMovingIndex = 0;
            scrollBar.y = 0;
            testButtons ();
            activateMouseWheel ();
        }

        /**
         * Установка позиции скроллера в процентах.
         *
         * @param percent Позиция в процентах (0.1 = 10%).
         */
        public function setPositionAt (percent:Number = 0):void {
            percent = NumericalUtilities.correctValue (percent);
            moveObjects (percent);
            moveScrollBar (percent);
        }

        /**
         * Тип движения объектов для прокрутки (по <code>x</code> или по <code>y</code>).
         * Значение по умолчанию <code>MotionType.Y</code>.
         *
         * @see com.hogargames.display.scrolls.MotionType
         */
        public function get motionType ():String {
            return _motionType;
        }

        public function set motionType (motionType:String):void {
            _motionType = motionType;
        }

        /**
         * Одиночный шаг скроллера (в пикселях).
         */
        public function get step ():Number {
            return _step;
        }

        public function set step (value:Number):void {
            value = Math.max (value, 1);
            _step = value;
        }

        /**
         * Размер области прокрутки объектов для прокрутки.
         */
        public function get movingArea ():Number {
            if (useScrollInvert) {
                return -_movingArea;
            }
            else {
                return _movingArea;
            }
        }

        public function set movingArea (value:Number):void {
            _movingArea = value;
            //correct objs:
            moveObjects (getPercentByScrollPosition ());
            useAutoHide = useAutoHide;
        }

        /**
         * Параметр, указывающий, инвертировать ли значения <code>movingArea</code>.
         * Значение по умолчанию <code>true</code>.
         */
        public function get useScrollInvert ():Boolean {
            return _useScrollInvert;
        }

        public function set useScrollInvert (value:Boolean):void {
            _useScrollInvert = value;
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

        public function get currentMovingIndex ():int {
            return _currentMovingIndex;
        }

        public function get maxMovingIndex ():int {
            var maxPosition:int = 0;
            if (step > 0) {
                maxPosition = Math.abs (Math.round (movingArea / step));
            }
            return maxPosition;
        }

        /**
         * Параметр, указывающий, скрывать ли скроллер при <code>movingArea == 0</code>.
         * Значение по умолчанию <code>true</code>.
         */
        public function get useAutoHide ():Boolean {
            return _useAutoHide;
        }

        public function set useAutoHide (value:Boolean):void {
            scrollContainer.visible = !(movingArea == 0);
            _useAutoHide = value;
        }

        public function destroy ():void {
            removeFromStageListener (null);
            removeEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
        }

        /**
         * Прокрутка (перемещение) всех объектов для прокрутки.
         *
         * @param percent Позиция в процентах (0.1 = 10%).
         */
        protected function moveObjects (percent:Number):void {
            percent = NumericalUtilities.correctValue (percent);
            for (var i:int = 0; i < objects.length; i++) {
                var obj:DisplayObject = objects [i];
                var startPosition:int = objectsStartPositions [i];
                var newPosition:int = Math.round (percent * movingArea + startPosition);
                if ((percent != 0) && (percent != 1)) {
                    newPosition = correctPosition (newPosition);
                }
                _currentMovingIndex = Math.abs (Math.round ((newPosition - startPosition) / step));
                moveObject (obj, newPosition);
            }
            dispatchEvent (MOVE_EVENT);
        }

        /**
         * Прокрутка (перемещение) объекта.
         *
         * @param object Объект для прокрутки.
         * @param position Позиция объекта.
         */
        protected function moveObject (object:DisplayObject, position:Number):void {
            if (motionType == MotionType.X) {
                object.x = position;
            }
            else if (motionType == MotionType.Y) {
                object.y = position;
            }
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

        private function correctPosition (position:Number):Number {
            var prePosition:Number = position;
            var modulo:Number = position % step;
            if (Math.abs (modulo) < (step / 2)) {
                position -= modulo;
            }
            else {
                position -= modulo;
                if (prePosition >= 0) {
                    position += step;
                }
                else {
                    position -= step;
                }
            }
            return position;
        }

        private function doStep (forward:Boolean):void {
            var percent:Number = getPercentByScrollPosition ();
            var addPercent:Number = step / movingArea;
            if (movingArea > 0) {
                addPercent = -addPercent;
            }
            if (forward) {
                percent -= addPercent;
            }
            else {
                percent += addPercent;
            }
            setPositionAt (percent);
            testButtons ();
        }

        private function testButtons ():void {
            setButtonEnable (topButton, true);
            setButtonEnable (bottomButton, true);
            if (_currentMovingIndex == 0) {
                setButtonEnable (topButton, false);
            }
            else if (_currentMovingIndex == maxMovingIndex) {
                setButtonEnable (bottomButton, false);
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
                    var aButton:Button = Button (externalTopButton);
                    aButton.enable = value;
                    return;
                }
            }
            button.visible = value;
        }

        private function activateMouseWheel ():void {
            if (useMouseWheel) {
                for (var i:int = 0; i < objects.length; i++) {
                    var obj:DisplayObject = objects [i];
                    //trace ("add wheel listener");
                    obj.addEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
                }
                addEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
            }
        }

        private function deactivateMouseWheel ():void {
            for (var i:int = 0; i < objects.length; i++) {
                var obj:DisplayObject = objects [i];
                if (obj.hasEventListener (MouseEvent.MOUSE_WHEEL)) {
                    obj.removeEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
                }
            }
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
            moveObjects (getPercentByScrollPosition ());
        }

        private function mouseUpListener (event:MouseEvent):void {
            scrollBar.filters = [];
            isDrag = false;
            scrollBar.stopDrag ();
            testButtons ();
            setPositionAt (_currentMovingIndex / maxMovingIndex);
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

    }
}