/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 12.03.12
 * Time: 7:22
 * To change this template use File | Settings | File Templates.
 */
package breakdance.core.sound.events {

    import flash.events.Event;

    public class SoundControllerEvent extends Event {

        private var _volume:Number = 1;

        public static const SET_VOLUME:String = "set volume";
        public static const MUTE:String = "mute";
        public static const UNMUTE:String = "unmute";
        public static const ENABLE:String = "enable";
        public static const DISABLE:String = "disable";
        public static const PAUSE:String = "pause";
        public static const RESUME:String = "resume";

        public function SoundControllerEvent (type:String, volume:Number = 1, bubbles:Boolean = false, cancelable:Boolean = true) {
            this.volume = volume;
            super (type, bubbles, cancelable);
        }

        public function get volume ():Number {
            return _volume;
        }

        public function set volume (value:Number):void {
            _volume = value;
        }
    }
}
