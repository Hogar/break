/**
 * @author Hogar
 **/
package com.hogargames.display.scrolls {

    import com.hogargames.display.GraphicStorage;
    import com.hogargames.display.scrolls.events.ScrollEvent;
    import com.hogargames.errors.AbstractClassRealizationError;
    import com.hogargames.utils.NumericalUtilities;

    import flash.display.InteractiveObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.getQualifiedClassName;

    /**
     * Абстрактный класс содержащий логику для простого пошагового скроллера.
     *
     * <p>Для реализации конкретного класса можно воспользоваться классами с расширенной функциональностью,
     * которые наследуются от <code>AbstractStepScroll</code>, например <code>AbstractResizableStepScroll</code>.</p>
     *
     * <p>Для реализации конкретного класса необходимо:</p>
     * <ul>
     *  <li>Реализовать функцию добавления элементов в визуальный контейнер (переменная <code>container</code>),
     *  присвоив общее количество элементов переменной <code>numItems</code>;</li>
     *  <li>При создании экземпляра конкретного класса необходимо,
     *  чтобы <code>MovieClip</code>, который используется в качестве параметра конструктора,
     *  содержал кнопки (потомки, являющиеся экземплярами класса <code>InteractiveObject</code>) с такими же названиями,
     *  как константы <code>AbstractStepScroll.BTN_NEXT</code> и <code>AbstractStepScroll.BTN_PREVIOUS</code>.
     *  Также возможно, но не обязательно, присутствие кнопок, чьи имена совпадают
     *  с константами <code>AbstractStepScroll.BTN_BEGIN</code> и <code>AbstractStepScroll.BTN_END</code>.</li>
     * </ul>
     *
     * @see #numItems
     * @see com.hogargames.display.scrolls.AbstractResizableStepScroll
     * @see #BTN_NEXT
     * @see #BTN_PREVIOUS
     * @see #BTN_BEGIN
     * @see #BTN_END
     *
     * @example Пример класса реализующего конкретный скроллер:
     *  <listing version="3.0">
     *
     *   import flash.display.MovieClip;
     *   import flash.display.Shape;
     *   import flash.display.Sprite;
     *
     *   public class ConcreteStepScroll extends AbstractStepScroll {
     *
     *       private var containerMask:Shape = new Shape ();
     *
     *       public static const NUM_VISIBLE_ITEMS:int = 5;
     *       public static const ELEMENT_WIDTH:int = 40;
     *       public static const ELEMENT_HEIGHT:int = 60;
     *
     *       public function ConcreteStepScroll (mc:MovieClip) {
     *           super (mc, NUM_VISIBLE_ITEMS, ELEMENT_WIDTH);
     *       }
     *
     *       public function init (numItems:int):void {
     *           clear ();
     *           //add scroll elements:
     *           for (var i:int = 0; i &lt; numItems; i++) {
     *               var scrollElement:Sprite = new Sprite ();
     *               scrollElement.graphics.beginFill (0x00ff00);
     *               scrollElement.graphics.drawRect (i + 1, i + 1, ELEMENT_WIDTH - 2 ~~ (i + 1), ELEMENT_HEIGHT - 2 ~~ (i + 1));
     *               scrollElement.graphics.endFill ();
     *               scrollElement.x = i ~~ ELEMENT_WIDTH;
     *               container.addChild (scrollElement);
     *           }
     *
     *           //set scroll params:
     *           this.numItems = numItems;
     *           moveTo (0);
     *       }
     *
     *       override public function parseGraphicMc (mc:MovieClip):void {
     *           super.parseGraphicMc (mc);
     *
     *           //add mask:
     *           containerMask.graphics.beginFill (0);
     *           containerMask.graphics.drawRect (0, 0, ELEMENT_WIDTH ~~ NUM_VISIBLE_ITEMS, ELEMENT_HEIGHT);
     *           container.mask = containerMask;
     *           mc.addChild (containerMask);
     *       }
     *
     *   }
     *  </listing>
     *
     * @example Пример использования конкретного скроллера:
     *  <listing version="3.0">
     *   import com.hogargames.display.ui.scrolls.AbstractStepScroll;
     *   import flash.display.MovieClip;
     *   import flash.display.Sprite;
     *
     *   var mc:MovieClip = new MovieClip ();
     *
     *   //create buttons:
     *   var btnNext:Sprite = new Sprite ();
     *   btnNext.graphics.beginFill (0x777777);
     *   btnNext.graphics.drawRect (10, 110, 40, 40);
     *   btnNext.graphics.endFill ();
     *   btnNext.name = AbstractStepScroll.BTN_NEXT;
     *   btnNext.buttonMode = btnNext.useHandCursor = true;
     *   var btnPrevious:Sprite = new Sprite ();
     *   btnPrevious.graphics.beginFill (0x777777);
     *   btnPrevious.graphics.drawRect (60, 110, 40, 40);
     *   btnPrevious.graphics.endFill ();
     *   btnPrevious.buttonMode = btnPrevious.useHandCursor = true;
     *   btnPrevious.name = AbstractStepScroll.BTN_PREVIOUS;
     *
     *   mc.addChild (btnNext);
     *   mc.addChild (btnPrevious);
     *
     *   var concreteStepScroll:ConcreteStepScroll = new ConcreteStepScroll (mc);
     *   addChild (concreteStepScroll);
     *   concreteStepScroll.init (15);
     *  </listing>
     */

    public class AbstractStepScroll extends GraphicStorage {

        /**
         * Контейнер для размещения элементов скроллера. В процессе скроллинга меняет свои координаты.
         */
        protected var container:Sprite = new Sprite ();
        /**
         * Кнопка вперед. При нажатии увеличивает текущую позицию (в шагах) скроллера на 1.
         */
        protected var btnNext:InteractiveObject;
        /**
         * Кнопка назад. При нажатии уменьшает текущую позицию (в шагах) скроллера на 1.
         */
        protected var btnPrevious:InteractiveObject;
        /**
         * Кнопка конец. При нажатии устанвливает текущую позицию скроллера (в шагах) в максимально возможную позицию.
         */
        protected var btnEnd:InteractiveObject;
        /**
         * Кнопка начало. При нажатии устанвливает текущую позицию скроллера (в шагах) в 0.
         */
        protected var btnBegin:InteractiveObject;

        private var _currentMovingIndex:int;
        private var _numVisibleItems:int;
        private var _numItems:int;
        private var _motionType:String = MotionType.X;
        private var _step:Number = 0;
        private var _basicScroll:BasicScroll = null;

        /**
         * Название кнопки вперед, для поиска элемента в мувиклипе.
         */
        public static const BTN_NEXT:String = "btnNext";
        /**
         * Название кнопки назад, для поиска элемента в мувиклипе.
         */
        public static const BTN_PREVIOUS:String = "btnPrevious";
        /**
         * Название кнопки конец, для поиска элемента в мувиклипе.
         */
        public static const BTN_BEGIN:String = "btnBegin";
        /**
         * Название кнопки начало, для поиска элемента в мувиклипе.
         */
        public static const BTN_END:String = "btnEnd";

        /**
         * @param mc <code>MovieClip</code> с графикой.
         * @param numVisibleItems Количество отображаемых элементов.
         * @param step Шаг скроллера (в пикселях).
         *
         * @throws com.hogargames.errors.AbstractClassRealizationError
         * Класс является абстрактным классом.
         * Создание экземпляров этого класса не возможно.
         */
        public function AbstractStepScroll (mc:MovieClip, numVisibleItems:int, step:Number, basicScroll:BasicScroll = null):void {
            this.numVisibleItems = numVisibleItems;
            this.step = step;
            this.basicScroll = basicScroll;
            super (mc);
            useMouseWheel = true;

            testButtons ();

            //protection from the realization of this abstract class:
            if (getQualifiedClassName (this) == getQualifiedClassName (AbstractStepScroll)) {
                throw new AbstractClassRealizationError (getQualifiedClassName (this));
            }
        }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

        /**
         * Установка текущей позиции (в шагах), перемещение контейнера в соответвующую координату,
         * проверка кнопок на предмет активации/деактивации.
         *
         * @see #currentMovingIndex
         * @see #move()
         * @see #testButtons()
         */
        public function moveTo (movingIndex:int):void {
            currentMovingIndex = movingIndex;
            move (getTargetCoordinate ());
            testButtons ();
        }

        /**
         * Очистка всех элементов контейнера.
         */
        public function clear ():void {
            while (container.numChildren > 0) {
                container.removeChildAt (0);
            }
        }

        /**
         * @inheritDoc
         */
        override public function destroy ():void {
            useMouseWheel = false;
            if (btnNext) {
                btnNext.removeEventListener (MouseEvent.CLICK, clickListener_btnNext);
            }
            if (btnPrevious) {
                btnPrevious.removeEventListener (MouseEvent.CLICK, clickListener_btnPrevious);
            }
            if (btnEnd) {
                btnEnd.removeEventListener (MouseEvent.CLICK, clickListener_btnEnd);
            }
            if (btnBegin) {
                btnBegin.removeEventListener (MouseEvent.CLICK, clickListener_btnBegin);
            }
            super.destroy ();
        }

        public function get basicScroll ():BasicScroll {
            return _basicScroll;
        }

        public function set basicScroll (value:BasicScroll):void {
            if (basicScroll) {
                if (contains (basicScroll)) {
                    removeChild (basicScroll);
                }
                basicScroll.destroy ();
            }
            _basicScroll = value;
            if (value) {
                addChild (basicScroll);
                basicScroll.setObjects (container);
                basicScroll.step = step;
                basicScroll.useMouseWheel = false;
                basicScroll.addEventListener (ScrollEvent.MOVE, scrollMoveListener);
            }
        }

//////////////////////////////////
//PROTECTED:
//////////////////////////////////

        /**
         * @inheritDoc
         */
        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            //init graphic:
            btnNext = InteractiveObject (getElement (BTN_NEXT));
            btnPrevious = InteractiveObject (getElement (BTN_PREVIOUS));
            btnEnd = mc [BTN_END];
            btnBegin = mc [BTN_BEGIN];

            //add listeners:
            btnNext.addEventListener (MouseEvent.CLICK, clickListener_btnNext);
            btnPrevious.addEventListener (MouseEvent.CLICK, clickListener_btnPrevious);
            if (btnEnd) {
                btnEnd.addEventListener (MouseEvent.CLICK, clickListener_btnEnd);
            }
            if (btnBegin) {
                btnBegin.addEventListener (MouseEvent.CLICK, clickListener_btnBegin);
            }

            mc.addChild (container);
        }

        /**
         * Количество отображаемых элементов.
         */
        protected function get numVisibleItems ():int {
            return _numVisibleItems;
        }

        protected function set numVisibleItems (value:int):void {
            value = Math.max (0, value);
            _numVisibleItems = value;
            updateBasicScrollParams ();
        }

        /**
         * Количество всех элементов скроллера.
         */
        protected function get numItems ():int {
            return _numItems;
        }

        protected function set numItems (value:int):void {
            value = Math.max (0, value);
            _numItems = value;
            updateBasicScrollParams ();
        }

        /**
         * Шаг скроллера (в пикселях).
         */
        protected function get step ():Number {
            return _step;
        }

        protected function set step (value:Number):void {
            value = Math.max (0, value);
            _step = value;
            if (basicScroll) {
                basicScroll.step = step;
            }
            updateBasicScrollParams ();
        }

        /**
         * Текущая позиция скроллера (в шагах).
         */
        protected function get currentMovingIndex ():int {
            return _currentMovingIndex;
        }

        protected function set currentMovingIndex (value:int):void {
            value = NumericalUtilities.correctValue (value, 0, getMaxMovingIndex ());
            _currentMovingIndex = value;
            if (basicScroll) {
                basicScroll.setPositionAt (value / getMaxMovingIndex ());
            }
        }

        /**
         * Предельная позиция скроллера (в шагах).
         */
        protected function getMaxMovingIndex ():int {
            var maxIndex:int = numItems - numVisibleItems;
            maxIndex = Math.max (0, maxIndex);
            return maxIndex;
        }

        /**
         * Параметр, указывающий, реагировать ли на прокрутку колеса мыши также, как и на нажатие кнопок.
         */
        protected function set useMouseWheel (value:Boolean):void {
            if (value) {
                if (!container.hasEventListener (MouseEvent.MOUSE_WHEEL)) {
                    container.addEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
                    btnNext.addEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
                    btnPrevious.addEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
                }
            }
            else {
                container.removeEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
                btnNext.removeEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
                btnPrevious.removeEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
            }
        }

        protected function get useMouseWheel ():Boolean {
            if (container.hasEventListener (MouseEvent.MOUSE_WHEEL)) {
                return true;
            }
            else {
                return false;
            }
        }

        /**
         * Тип движения контейнера (по <code>x</code> или по <code>y</code>).
         * Значение по умолчанию <code>MotionType.X</code>.
         *
         * @see com.hogargames.display.scrolls.MotionType
         */
        protected function get motionType ():String {
            return _motionType;
        }

        protected function set motionType (value:String):void {
            _motionType = value;
        }

        /**
         * Активация кнопки. Делает кнопку активной (видимой).
         */
        protected function activateButton (btn:InteractiveObject):void {
            if (btn != null) {
                btn.visible = true;
            }
        }

        /**
         * Деактивация кнопки. Делает кнопку неактивной (невидимой).
         */
        protected function deactivateButton (btn:InteractiveObject):void {
            if (btn != null) {
                btn.visible = false;
            }
        }

        /**
         * Получение координаты (в пикселях), в которую необходимо переместить контейнер,
         * на основании текущей позиции (в шагах) - <code>currentMovingIndex</code>.
         *
         * @see #currentMovingIndex
         */
        protected function getTargetCoordinate ():Number {
            return (-currentMovingIndex * step);
        }

        /**
         * Перемещение контейнера в указанную координату на основании <code>motionType</code> (по <code>x</code> или <code>y</code>).
         *
         * @see #motionType
         */
        protected function move (targetCoordinate:Number):void {
            if (_motionType == MotionType.X) {
                container.x = targetCoordinate;
            }
            else if (_motionType == MotionType.Y) {
                container.y = targetCoordinate;
            }
        }

        /**
         * Получение позиции (в шагах) по координате.
         */
        protected function getMovingIndexByCoordinate (coordinate:Number):int {
            var movingIndex:int = getMaxMovingIndex () - (numItems - Math.floor (coordinate / step) - 1);
            movingIndex = NumericalUtilities.correctValue (movingIndex, 0, getMaxMovingIndex ());
            return movingIndex;
        }

        /**
         * Проверка кнопок на предмет активации/деактивации.
         * Например, если скроллер максимально прокручен вперед, кнопка <code>btnNext</code> деактивируется.
         */
        protected function testButtons ():void {
            activateButton (btnNext);
            activateButton (btnPrevious);
            activateButton (btnEnd);
            activateButton (btnBegin);

            if (numItems <= numVisibleItems) {
                deactivateButton (btnNext);
                deactivateButton (btnPrevious);
                deactivateButton (btnEnd);
                deactivateButton (btnBegin);
                return;
            }
            else {
                if (currentMovingIndex == getMaxMovingIndex ()) {
                    deactivateButton (btnNext);
                    deactivateButton (btnEnd);
                }
                else {
                    activateButton (btnNext);
                    activateButton (btnEnd);
                }
                if (currentMovingIndex == 0) {
                    deactivateButton (btnPrevious);
                    deactivateButton (btnBegin);
                }
                else {
                    activateButton (btnPrevious);
                    activateButton (btnBegin);
                }
            }
        }

//////////////////////////////////
//PRIVATE:
//////////////////////////////////

        private function updateBasicScrollParams ():void {
            if (basicScroll) {
                basicScroll.movingArea = Math.max (0, numItems - numVisibleItems) * step;
            }
        }

//////////////////////////////////
//LISTENERS:
//////////////////////////////////

        /**
         * @private
         */
        protected function clickListener_btnPrevious (event:MouseEvent):void {
            moveTo (currentMovingIndex - 1);
        }

        /**
         * @private
         */
        protected function clickListener_btnNext (event:MouseEvent):void {
            moveTo (currentMovingIndex + 1);
        }

        /**
         * @private
         */
        protected function clickListener_btnEnd (event:MouseEvent):void {
            moveTo (getMaxMovingIndex ());
        }

        /**
         * @private
         */
        protected function clickListener_btnBegin (event:MouseEvent):void {
            moveTo (0);
        }

        /**
         * @private
         */
        protected function mouseWheelListener (event:MouseEvent):void {
            if (event.delta > 0) {
                moveTo (currentMovingIndex - 1);
            }
            else {
                moveTo (currentMovingIndex + 1);
            }
        }

        private function scrollMoveListener (event:Event):void {
            _currentMovingIndex = NumericalUtilities.correctValue (basicScroll.currentMovingIndex, 0, getMaxMovingIndex ());
            testButtons ();
        }

    }
}