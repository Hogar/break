package com.hogargames.display.buttons 
{
	/**
	 * ...
	 * @author gray_crow
	 */
    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.MovieClipUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
     * Базовая кнопка.
     */
    public class ButtonPressed extends GraphicStorage {

        private var _selected:Boolean = false;
        private var _enable:Boolean = true;
		private var _state : String = "";

        public const UP:String = "up";
        public const OVER:String = "over";
        public const DOWN:String = "down";        
		
		public const PRESS:String = "press";
        public const PRESS_OVER:String = "press_over";
		public const PRESS_DOWN:String = "press_down";
		
		public const DISABLE:String = "disable";

        public function ButtonPressed (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////


		public function get pressed ():Boolean {
			return (_state == PRESS || _state == PRESS_OVER || _state == PRESS_DOWN);			
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
			_state = id;
            MovieClipUtilities.gotoAndStop (mc, id);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        /**
         * @private
         */
        protected function rollOverListener (event:MouseEvent):void {
            if (enable) {
				if (_state == UP )  setSkin (OVER);
				if(_state == PRESS )  setSkin (PRESS_OVER);
            }
        }

        /**
         * @private
         */
        protected function rollOutListener (event:MouseEvent):void {
            if (enable) {
				if (_state == OVER || _state == DOWN)  setSkin (UP);
				if(_state == PRESS_OVER || _state == PRESS_DOWN)  setSkin (PRESS);                
            }
        }

        /**
         * @private
         */
        protected function mouseDownListener (event:MouseEvent):void {
            if (enable) {
				if (_state == UP || _state == OVER)  setSkin (DOWN);
				if(_state == PRESS || _state == PRESS_OVER)  setSkin (PRESS_DOWN);                
            }
        }

        /**
         * @private
         */
        protected function mouseUpListener (event:MouseEvent):void {
            if (enable) {
                if (_state == DOWN)  setSkin (PRESS_OVER);
				if(_state == PRESS_DOWN)  setSkin (OVER);   
            }
        }

    }
}
