/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 12.03.12
 * Time: 7:22
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.sound.events {

    import flash.events.Event;

    /**
     * Событие, отправляемые менеджером звука.
     */
    public class SoundManagerEvent extends Event {

        private var _volume:Number = 1;

        /**
         * Установка громкости.
         */
        public static const SET_VOLUME:String = "set volume";
        /**
         * Выключение звука.
         */
        public static const MUTE:String = "mute";
        /**
         * Включение звука.
         */
        public static const UNMUTE:String = "unmute";
        /**
         * Включение.
         */
        public static const ENABLE:String = "enable";
        /**
         * Выключение.
         */
        public static const DISABLE:String = "disable";
        /**
         * Пауза.
         */
        public static const PAUSE:String = "pause";
        /**
         * Продолжение воспроизведения после паузы.
         */
        public static const RESUME:String = "resume";

        public function SoundManagerEvent (type:String, volume:Number = 1, bubbles:Boolean = false, cancelable:Boolean = true) {
            super (type, bubbles, cancelable);
        }

        /**
         * Уровень громкости.
         */
        public function get volume ():Number {
            return _volume;
        }

        public function set volume (value:Number):void {
            _volume = value;
        }
    }
}
