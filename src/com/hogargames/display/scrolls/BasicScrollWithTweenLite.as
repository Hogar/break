package com.hogargames.display.scrolls {

    import com.greensock.TweenLite;
    import com.hogargames.utils.NumericalUtilities;

    import flash.display.DisplayObject;

    /**
     * Нарисованный скроллер с добавлением анимации <code>TweenLite</code>,
     * предоставляет методы для прокрутки объектов и
     * замены графики отдельных элементов скроллера.
     */
    public class BasicScrollWithTweenLite extends BasicScroll {

        private const OBJECTS_TWEEN_SPEED:Number = .7;
        private const SCROLL_TWEEN_SPEED:Number = .5;

        public function BasicScrollWithTweenLite (objs:* = null):void {
            super (objs);
        }

        /**
         * @inheritDoc
         */
        override protected function moveObject (obj:DisplayObject, position:Number):void {
            TweenLite.killTweensOf (obj);
            if (motionType == MotionType.X) {
                TweenLite.to (obj, OBJECTS_TWEEN_SPEED, { x: position });
            }
            else if (motionType == MotionType.Y) {
                TweenLite.to (obj, OBJECTS_TWEEN_SPEED, { y: position });
            }
        }

        /**
         * @inheritDoc
         */
        override public function setPositionAt (percent:Number = 0):void {
            percent = NumericalUtilities.correctValue (percent);
            moveObjects (percent);
            var amountToScroll:Number = baseHeight - barHeight;
            var toY:Number = percent * amountToScroll;
            TweenLite.killTweensOf (scrollBar);
            TweenLite.to (scrollBar, SCROLL_TWEEN_SPEED, { y: toY });
        }
    }

}