/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 28.08.12
 * Time: 13:31
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.display.scrolls.events {

    import flash.events.Event;

    /**
     * Событие скролла.
     */
    public class ScrollEvent extends Event {

        /**
         * Движение скролла.
         */
        public static const MOVE:String = "move";
        public static const REPOSITION:String = "reposition";

        public function ScrollEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super (type, bubbles, cancelable)
        }
    }
}
