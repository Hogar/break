/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 11.03.12
 * Time: 14:55
 * To change this template use File | Settings | File Templates.
 */
package breakdance.core.sound {

    import breakdance.core.sound.events.SoundControllerEvent;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.utils.Dictionary;
	import com.hogargames.debug.Tracer;

    public class SoundController extends EventDispatcher {

        private var _volume:Number = 1;
        private var _mute:Boolean = false;
        private var _enable:Boolean = true;
        private var _pause:Boolean = true;

        //sound objects:
        private var sounds:Vector.<Sound> = new Vector.<Sound> ();
        private var soundBySoundChannelDict:Dictionary = new Dictionary ();
        private var loopsDict:Dictionary = new Dictionary ();
        private var volumeCoefficientsDict:Dictionary = new Dictionary ();
        private var soundTransformsDict:Dictionary = new Dictionary ();
        private var soundChannelsDict:Dictionary = new Dictionary ();
        private var positionDict:Dictionary = new Dictionary ();

        public function SoundController () {

        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Уменьшает громкость всех звуков до нуля.
         */
        public function get volume ():Number {
            if (mute) {
                return 0;
            }
            return _volume;
        }

        public function set volume (value:Number):void {
            var oldVolume:Number = _volume;
            if (_volume < 0) {
                _volume = 0;
            }
            else if (_volume > 1) {
                _volume = 1;
            }
            dispatchEvent (new SoundControllerEvent (SoundControllerEvent.SET_VOLUME, _volume));
            if (oldVolume != _volume && enable && !mute) {
                for (var i:int = 0; i < sounds.length; i++) {
                    setSoundVolume (sounds [i], _volume);
                }
            }
        }

        public function get mute ():Boolean {
            return _mute;
        }

        public function set mute (value:Boolean):void {
            _mute = value;
            var i:int;
            if (value) {
                for (i = 0; i < sounds.length; i++) {
                    setSoundVolume (sounds [i], 0);
                }
                dispatchEvent (new SoundControllerEvent (SoundControllerEvent.MUTE, _volume));
            }
            else {
                for (i = 0; i < sounds.length; i++) {
                    setSoundVolume (sounds [i], volume);
                }
                dispatchEvent (new SoundControllerEvent (SoundControllerEvent.UNMUTE, _volume));
            }
        }

        /**
         * Останавливает воспроизведение и удаляет все текущие звуки, блокирует работату метода <code>play()</code>.
         */
        public function get enable ():Boolean {
            return _enable;
        }

        public function set enable (value:Boolean):void {
            _enable = value;
            if (value) {
                dispatchEvent (new SoundControllerEvent (SoundControllerEvent.ENABLE, _volume));
            }
            else {
                clear ();
                dispatchEvent (new SoundControllerEvent (SoundControllerEvent.DISABLE, _volume));
            }
        }

        public function get pause ():Boolean {
            return _pause;
        }

        public function set pause (value:Boolean):void {
            _pause = value;
            var i:int;
            if (value) {
                for (i = 0; i < sounds.length; i++) {
                    pauseSound (sounds [i]);
                }
                dispatchEvent (new SoundControllerEvent (SoundControllerEvent.PAUSE, _volume));
            }
            else {
                for (i = 0; i < sounds.length; i++) {
                    resumeSound (sounds [i]);
                }
                dispatchEvent (new SoundControllerEvent (SoundControllerEvent.RESUME, _volume));
            }
        }

        public function play (sound:Sound, loop:int = 0, volumeCoefficient:Number = 1):void {
			Tracer.log('---------------------------play '+enable)
            if (!enable || (sound == null)) {
                return;
            }

            loop = Math.max (loop, -1);
            volumeCoefficient = Math.max (0, volumeCoefficient);

            sound.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);

            sounds.push (sound);
            loopsDict [sound] = loop;
            volumeCoefficientsDict [sound] = volumeCoefficient;			
			
			pause = false;			 ////
            playSound (sound);
        }

        public function playFromTheBeginning ():void {
            for (var i:int = 0; i < sounds.length; i++) {
                playSound (sounds [i]);
            }
        }

        /**
         * Останавливает воспроизведение и удаляет все текущие звуки.
         */
        public function clear ():void {
            for (var i:int = 0; i < sounds.length; i++) {
                destroySound (sounds [i]);
            }
            sounds = new Vector.<Sound> ();
        }

        public function destroy ():void {
            clear ();
            sounds = null;
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function playSound (sound:Sound, position:Number = 0):void {
            //destroy old sound channel:
            destroySoundChannel (sound);
            var soundChannel:SoundChannel;
            try {
                //create new sound channel, play sound:
                soundChannel = sound.play (position);				
            }
            catch (error:Error) {
                soundChannel = null;
            }
            if (soundChannel) {
                soundChannel.addEventListener (Event.SOUND_COMPLETE, soundCompleteListener);
                soundChannelsDict [sound] = soundChannel;
                soundBySoundChannelDict [soundChannel] = sound;
                setSoundVolume (sound, volume);
            }
            else {
                destroySound (sound);
            }
        }

        private function setSoundVolume (sound:Sound, soundVolume:Number):void {
            if (soundTransformsDict [sound] == null) {
                soundTransformsDict [sound] = new SoundTransform ();
            }
            var soundTransform:SoundTransform = soundTransformsDict [sound];
            var volumeCoefficient:Number = volumeCoefficientsDict [sound];
            soundTransform.volume = soundVolume * volumeCoefficient;
            var soundChannel:SoundChannel = soundChannelsDict [sound];
            soundChannel.soundTransform = soundTransform;
        }

        private function pauseSound (sound:Sound):void {
            var soundChannel:SoundChannel = soundChannelsDict [sound];
            if (soundChannel) {
                positionDict [sound] = soundChannel.position;
            }
            destroySoundChannel (sound);
        }

        private function resumeSound (sound:Sound):void {
            if (positionDict [sound] != null) {
                var position:Number = positionDict [sound];
                playSound (sound, position);
            }
        }

        private function destroySound (sound:Sound):void {
            destroySoundChannel (sound);

            sound.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
            soundChannelsDict [sound] = null;
            loopsDict [sound] = null;
            volumeCoefficientsDict [sound] = null;

            try {
                sound.close ();
            }
            catch (error:Error) {
                //
            }
        }

        private function destroySoundChannel (sound:Sound):void {
            //destroy sound channel:
            var soundChannel:SoundChannel = soundChannelsDict [sound];
            if (soundChannel) {
                soundChannel.stop ();
                soundChannel.removeEventListener (Event.SOUND_COMPLETE, soundCompleteListener);
                soundBySoundChannelDict [soundChannel] = null;
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

		protected function soundCompleteListener(event:Event):void {
            var sound:Sound = soundBySoundChannelDict [event.currentTarget];
            var loop:int = loopsDict [sound]

                    ;
			if (loop == 0) {
                destroySound (sound);
                var index:int = sounds.indexOf (sound);
                if (index != -1) {
                    sounds.splice (index, 1);
                }
            }
            else {
                if (loop > 0) {
                    loop -= 1;
                    loopsDict [sound] = loop;
                }
                playSound (sound);
            }
		}

		private function ioErrorListener (event:Event):void {
            event.currentTarget.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
//			throw ("Sound " + event.currentTarget + " IO error!");
		}

    }
}
