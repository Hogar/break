/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.11.13
 * Time: 20:56
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.server.bitmapSender.events {

    import flash.events.Event;

    public class BitmapSenderEvent extends Event {

        public static const UPLOADING_COMPLETE:String = "uploading complete";
        public static const LOADING_COMPLETE:String = "loading complete";

        public function BitmapSenderEvent (type:String, bubbles:Boolean = true, cancelable:Boolean = true):void {
            super (type, bubbles, cancelable);
        }
    }
}
