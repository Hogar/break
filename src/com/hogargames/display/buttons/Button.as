/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 05.09.11
 * Time: 22:09
 */
package com.hogargames.display.buttons {

    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.MovieClipUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
     * Базовая кнопка.
     */
    public class Button extends GraphicStorage {

        private var _selected:Boolean = false;
        private var _enable:Boolean = true;

        public const UP:String = "up";
        public const OVER:String = "over";
        public const DOWN:String = "down";
        public const DISABLE:String = "disable";
        public const SELECT:String = "select";

        public function Button (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Установка скина <code>Button.SELECT</code> (переход в кадр).
         * @see #SELECT
         */
        public function get selected ():Boolean {
            return _selected;
        }

        public function set selected (value:Boolean):void {
            if (value == _selected || !enable) {
                return;
            }
            if (value) {
                setSkin (SELECT);
            }
            else {
                setSkin (UP);
            }
            _selected = value;
        }

        /**
         * Включение/выключение кнопки. При выключении установка скина <code>Button.DISABLE</code> (переход в кадр).
         * @see #DISABLE
         */
        public function get enable ():Boolean {
            return _enable;
        }

        public function set enable (value:Boolean):void {
            if (value == _enable) {
                return;
            }
            if (!value) {
                selected = false;
                setSkin (DISABLE);
            }
            else {
                setSkin (UP);
            }
            _enable = value;
            mouseEnabled = value;
            mouseChildren = value;
        }

        /**
         * @inheritDoc
         */
        override public function destroy ():void {
            hit.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            hit.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            hit.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);
            hit.removeEventListener (MouseEvent.MOUSE_UP, mouseUpListener);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        /**
         * @inheritDoc
         */
        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            hit = Sprite (getElement ("hit"));

            hit.buttonMode = true;
            hit.useHandCursor = true;

            hit.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            hit.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            hit.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);
            hit.addEventListener (MouseEvent.MOUSE_UP, mouseUpListener);

            setSkin (UP);
        }

        protected function setSkin (id:String):void {
            MovieClipUtilities.gotoAndStop (mc, id);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        /**
         * @private
         */
        protected function rollOverListener (event:MouseEvent):void {
            if (!selected && enable) {
                setSkin (OVER);
            }
        }

        /**
         * @private
         */
        protected function rollOutListener (event:MouseEvent):void {
            if (!selected && enable) {
                setSkin (UP);
            }
        }

        /**
         * @private
         */
        protected function mouseDownListener (event:MouseEvent):void {
            if (!selected && enable) {
                setSkin (DOWN);
            }
        }

        /**
         * @private
         */
        protected function mouseUpListener (event:MouseEvent):void {
            if (!selected && enable) {
                setSkin (OVER);
            }
        }

    }
}
