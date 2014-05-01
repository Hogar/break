/**
 * Created by IntelliJ IDEA.
 * Author Hogar
 * Date: 17.05.11 (0:30)
 */

package com.hogargames.display.scrolls {

    import avmplus.getQualifiedClassName;

    import com.hogargames.display.IResizableContainer;
    import com.hogargames.errors.AbstractClassRealizationError;

    import flash.display.MovieClip;
    import flash.display.Shape;

    /**
     * Абстрактный класс содержащий логику для простого пошагового скроллера под маской.
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
     * @see com.hogargames.display.scrolls.AbstractStepScroll#BTN_NEXT
     * @see com.hogargames.display.scrolls.AbstractStepScroll#BTN_PREVIOUS
     * @see com.hogargames.display.scrolls.AbstractStepScroll#BTN_BEGIN
     * @see com.hogargames.display.scrolls.AbstractStepScroll#BTN_END
     *
     * @example Пример класса реализующего конкретный скроллер:
     *  <listing version="3.0">
     *
     *   import flash.display.MovieClip;
     *   import flash.display.Sprite;
     *
     *   public class ConcreteStepScroll extends AbstractResizableStepScroll {
     *
     *       public static const NUM_VISIBLE_ITEMS:int = 5;
     *       public static const ELEMENT_WIDTH:int = 40;
     *       public static const ELEMENT_HEIGHT:int = 60;
     *
     *       public function ConcreteStepScroll (mc:MovieClip) {
     *           super (mc, NUM_VISIBLE_ITEMS, ELEMENT_WIDTH, ELEMENT_WIDTH ~~ NUM_VISIBLE_ITEMS, ELEMENT_HEIGHT);
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

    public class AbstractResizableStepScroll extends AbstractStepScroll implements IResizableContainer {

        /**
         * Маска для контейнера.
         */
        protected var containerMask:Shape = new Shape ();

        private var _containerWidth:Number = 0;
        private var _containerHeight:Number = 0;

        /**
         * @param mc <code>MovieClip</code> с графикой.
         * @param numVisibleItems Количество видимых элементов.
         * Т.е. максимальное количество элементов, которые должны быть видны.
         * @param step Шаг скроллера (в пикселях).
         * @param width Ширина контейнера (ширина области с маской).
         * @param height Высота контейнера (высота области с маской).
         *
         * @throws com.hogargames.errors.AbstractClassRealizationError
         * Класс является абстрактным классом.
         * Создание экземпляров этого класса не возможно.
         */
        public function AbstractResizableStepScroll (mc:MovieClip, numVisibleItems:int, step:Number, width:Number, height:Number, basicScroll:BasicScroll = null):void {
            this.containerWidth = width;
            this.containerHeight = height;
            super (mc, numVisibleItems, step, basicScroll);

            //protection from the realization of this abstract class:
            if (getQualifiedClassName (this) == getQualifiedClassName (AbstractResizableStepScroll)) {
                throw new AbstractClassRealizationError (getQualifiedClassName (this));
            }
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Ширина контейнера (ширина области с маской).
         */
        public function set containerWidth (value:Number):void {
            value = Math.max (0, value);
            _containerWidth = value;
            position ();
        }

        public function get containerWidth ():Number {
            return _containerWidth;
        }

        /**
         * Высота контейнера (высота области с маской).
         */
        public function set containerHeight (value:Number):void {
            value = Math.max (0, value);
            _containerHeight = value;
            position ();
        }

        public function get containerHeight ():Number {
            return _containerHeight;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        /**
         * @inheritDoc
         */
        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mc.addChild (containerMask);
            container.mask = containerMask;
        }

        /**
         * Перерисовка области маски. Вызывается при изменении размеров.
         */
        protected function position ():void {
            //redraw mask:
            containerMask.graphics.clear ();
            containerMask.graphics.beginFill (0x00ff00);
            containerMask.graphics.drawRect (0, 0, _containerWidth, _containerHeight);
            containerMask.graphics.endFill ();
        }

    }
}
