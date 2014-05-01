/**
 * Created by IntelliJ IDEA.
 * Author Hogar.
 * Date: 14.05.11 (16:27)
 */

package com.hogargames.display {

    import flash.display.Shape;
    import flash.display.Sprite;

    /**
     * Класс, содержащий контейнер (экземпляр <code>Sprite</code>) под маской.
     */
    public class ResizableContainer extends Sprite implements IResizableContainer {

        /**
         * Контейнер, содержащий отображаемые элементы.
         */
        protected var container:Sprite = new Sprite ();
        /**
         * Маска контейнера, размером <code>containerWidth</code> на <code>containerHeight</code>.
         */
        protected var containerMask:Shape = new Shape ();

        private var _containerWidth:Number = 0;
        private var _containerHeight:Number = 0;

        public function ResizableContainer ():void {
            super ();
            addChild (container);
            addChild (containerMask);
            container.mask = containerMask;
        }

        /**
         * Ширина контейнера (ширина области с маской).
         */
        public function get containerWidth ():Number {
            return _containerWidth;
        }

        public function set containerWidth (value:Number):void {
            value = Math.max (0, value);
            _containerWidth = value;
            position ();
        }

        /**
         * Высота контейнера (высота области с маской).
         */
        public function get containerHeight ():Number {
            return _containerHeight;
        }

        public function set containerHeight (value:Number):void {
            value = Math.max (value, 0);
            _containerHeight = value;
            position ();
        }

        /**
         * Перерисовка области маски. Вызывается при изменении размеров.
         */
        protected function position ():void {
            containerMask.graphics.clear ();
            containerMask.graphics.beginFill (0x00ff00);
            containerMask.graphics.drawRect (0, 0, _containerWidth, _containerHeight);
            containerMask.graphics.endFill ();
        }

    }
}
