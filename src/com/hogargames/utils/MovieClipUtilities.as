/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 31.08.11
 * Time: 18:33
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.utils {

    import flash.display.MovieClip;

    /**
     * Утилиты для работы с <code>MovieClip</code>'ами.
     */
    public class MovieClipUtilities {

        /**
         * Вызов <code>gotoAndStop()</code> для <code>MovieClip</code>'а с проверкой наличия соответствующего кадра.
         *
         * @return <code>true</code> - <code>gotoAndStop()</code> вызван,
         * <code>false</code> - <code>gotoAndStop()</code> не вызван, т.к. кадра не найдено.
         *
         * @see #frameIsAvailable()
         */
        public static function gotoAndStop (mc:MovieClip, frame:Object):Boolean {
            if (frameIsAvailable (mc, frame)) {
                try {
                    mc.gotoAndStop (frame);
                }
                catch (error:Error) {
                    return false;
                }
                return true;
            }
            return false;
        }

        /**
         * Вызов <code>gotoAndPlay()</code> для <code>MovieClip</code>'а с проверкой наличия соответствующего кадра.
         *
         * @return <code>true</code> - <code>gotoAndPlay()</code> вызван,
         * <code>false</code> - <code>gotoAndPlay()</code> не вызван, т.к. кадра не найдено.
         *
         * @see #frameIsAvailable()
         */
        public static function gotoAndPlay (mc:MovieClip, frame:Object):Boolean {
            if (frameIsAvailable (mc, frame)) {
                mc.gotoAndPlay (frame);
                return true;
            }
            return false;
        }

        /**
         * Проверка наличия в <code>MovieClip</code>'е соответствующего кадра.
         *
         * @return <code>true</code> - соответствующий кадр есть, <code>false</code> - кадра нет.
         */
        public static function frameIsAvailable (mc:MovieClip, frame:Object):Boolean {
            var list:Array = mc.currentLabels;
            for (var i:int = 0; i < list.length; i++) {
                if (String (list[i].name) == String (frame)) {
                    return true;
                }
            }
//            trace ('MovieClipUtilities. frame "' + frame + '" in "' + mc + ' (' + mc.name + ')" not found.');
            return false;
        }

        public static function getNextLabel (mc:MovieClip):String {
            var list:Array = mc.currentLabels;
            if (mc.currentFrame == mc.totalFrames) {
                return null;
            }
            else {
                mc.nextFrame ();
                var currentLabel:String = mc.currentLabel;
                mc.prevFrame ();
                return currentLabel;
            }
//            else {
//                var nextLabel:FrameLabel = list [mc.currentFrame];
//                return nextLabel.name;
//            }
        }

    }
}
