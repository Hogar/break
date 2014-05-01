/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 11.03.12
 * Time: 14:55
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.sound {

    import com.hogargames.sound.events.SoundManagerEvent;
    import com.hogargames.utils.NumericalUtilities;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.utils.Dictionary;

    /**
     * Отправляется при установке уровня громкости.
     *
     * @eventType com.hogargames.sound.events.SoundManagerEvent.SET_VOLUME
     */
    [Event(name="set volume", type="com.hogargames.sound.events.SoundManagerEvent")]

    /**
     * Отправляется при выключении звука.
     *
     * @eventType com.hogargames.sound.events.SoundManagerEvent.MUTE
     */
    [Event(name="mute", type="com.hogargames.sound.events.SoundManagerEvent")]

    /**
     * Отправляется при включении звука.
     *
     * @eventType com.hogargames.sound.events.SoundManagerEvent.UNMUTE
     */
    [Event(name="unmute", type="com.hogargames.sound.events.SoundManagerEvent")]

    /**
     * Отправляется при включении.
     *
     * @eventType com.hogargames.sound.events.SoundManagerEvent.ENABLE
     */
    [Event(name="enable", type="com.hogargames.sound.events.SoundManagerEvent")]

    /**
     * Отправляется при выключении.
     *
     * @eventType com.hogargames.sound.events.SoundManagerEvent.DISABLE
     */
    [Event(name="disable", type="com.hogargames.sound.events.SoundManagerEvent")]

    /**
     * Отправляется при паузе.
     *
     * @eventType com.hogargames.sound.events.SoundManagerEvent.PAUSE
     */
    [Event(name="pause", type="com.hogargames.sound.events.SoundManagerEvent")]

    /**
     * Отправляется при продолжении воспроизведения после паузы.
     *
     * @eventType com.hogargames.sound.events.SoundManagerEvent.RESUME
     */
    [Event(name="resume", type="com.hogargames.sound.events.SoundManagerEvent")]


    /**
     * Менеджер для работы со звуком.
     */
    public class SoundManager extends EventDispatcher {

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

        public function SoundManager () {

        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Громкость.
         */
        public function get volume ():Number {
            if (mute) {
                return 0;
            }
            return _volume;
        }

        public function set volume (value:Number):void {
            var oldVolume:Number = _volume;
            _volume = NumericalUtilities.correctValue (value);
            dispatchEvent (new SoundManagerEvent (SoundManagerEvent.SET_VOLUME, _volume));
            if (oldVolume != _volume && enable && !mute) {
                for (var i:int = 0; i < sounds.length; i++) {
                    setSoundVolume (sounds [i], _volume);
                }
            }
        }

        /**
         * Приглушение звука.
         */
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
                dispatchEvent (new SoundManagerEvent (SoundManagerEvent.MUTE, _volume));
            }
            else {
                for (i = 0; i < sounds.length; i++) {
                    setSoundVolume (sounds [i], volume);
                }
                dispatchEvent (new SoundManagerEvent (SoundManagerEvent.UNMUTE, _volume));
            }
        }

        /**
         * Включение/выключение.
         * При выключении останавливается воспроизведение и удаляются все текущие звуки, блокируется работата метода <code>play()</code>.
         */
        public function get enable ():Boolean {
            return _enable;
        }

        public function set enable (value:Boolean):void {
            _enable = value;
            if (value) {
                dispatchEvent (new SoundManagerEvent (SoundManagerEvent.ENABLE, _volume));
            }
            else {
                clear ();
                dispatchEvent (new SoundManagerEvent (SoundManagerEvent.DISABLE, _volume));
            }
        }

        /**
         * Пауза.
         */
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
                dispatchEvent (new SoundManagerEvent (SoundManagerEvent.PAUSE, _volume));
            }
            else {
                for (i = 0; i < sounds.length; i++) {
                    resumeSound (sounds [i]);
                }
                dispatchEvent (new SoundManagerEvent (SoundManagerEvent.RESUME, _volume));
            }
        }

        /**
         * Воспроизведение звука.
         * @param sound Звук.
         * @param loop Колличество повторений. При значении <code>-1</code> повторяется постоянно.
         * @param volumeCoefficient Индивидуальный уровень громкости звука.
         */
        public function play (sound:Sound, loop:int = 0, volumeCoefficient:Number = 1):void {
            if (!enable) {
                return;
            }

            loop = Math.max (loop, -1);
            volumeCoefficient = Math.max (0, volumeCoefficient);

            sound.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);

            sounds.push (sound);
            loopsDict [sound] = loop;
            volumeCoefficientsDict [sound] = volumeCoefficient;

            playSound (sound);
        }

        /**
         * Останавливается воспроизведение и удаляются все текущие звуки.
         */
        public function clear ():void {
            for (var i:int = 0; i < sounds.length; i++) {
                destroySound (sounds [i]);
            }
            sounds = new Vector.<Sound> ();
        }

        /**
         * Деактивация.
         */
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

            //create new sound channel, play sound:
            var soundChannel:SoundChannel = sound.play (position);
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

        protected function soundCompleteListener (event:Event):void {
            var sound:Sound = soundBySoundChannelDict [event.currentTarget];
            var loop:int = loopsDict [sound];
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
            trace ("Sound " + event.currentTarget + " IO error!");
        }

    }
}
