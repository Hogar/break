package com.hogargames.app.popups.events {

    import flash.events.Event;

    /**
     * Событие, отправляемое всплывающими окнами.
     */
    public class PopUpEvent extends Event {

        /**
         * Закрытие всплывающего окона.
         */
        public static var CLOSE:String = 'close popUp';
        /**
         * Открытие всплывающего окона.
         */
        public static var OPEN:String = 'open popUp';

        public function PopUpEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = true):void {
            super (type, bubbles, cancelable);
        }

    }

}