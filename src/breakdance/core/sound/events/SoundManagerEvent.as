/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.04.13
 * Time: 0:32
 * To change this template use File | Settings | File Templates.
 */
package breakdance.core.sound.events {

    import flash.events.Event;

    public class SoundManagerEvent extends Event {

        public static const CHANGE_SOUND_CONTROLLER:String = "change sound state";
        public static const CHANGE_MUSIC_CONTROLLER:String = "change music state";
		public static const CHANGE_MUSICSONG_CONTROLLER:String = "change musicsong state";

        public function SoundManagerEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super (type, bubbles, cancelable);
        }
    }
}
