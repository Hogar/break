/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 01.03.12
 * Time: 9:12
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.display.animation {

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * Растеризованный мувиклип (представленный в виде набора картинок).
     * @autor Elmortem, modify by Hogar.
     */
    public class CacheMovieClip extends Sprite {

        /**
         * Массив кадров мувиклипа в виде картинок.
         */
        internal var frames:Vector.<BitmapData>;
        /**
         * Массив отступов для картинок-кадров.
         */
        internal var offsets:Vector.<Point>;
        /**
         * Массив подписей для картинок-кадров.
         */
        internal var labels:Vector.<String>;

        private var _currentFrame:int = 1;

        private var bmp:Bitmap;

        public function CacheMovieClip () {
            bmp = new Bitmap ();
            addChild (bmp);
        }

        /**
         * Текущий кадр.
         */
        public function get currentFrame ():int {
            return _currentFrame;
        }

        /**
         * Растеризация мувиклипа.
         * @param mc Мувиклип для растеризации.
         */
        public function buildFromMovieClip (mc:MovieClip):void {
            if (mc == null) {
                throw("mc is null.");
            }
            frames = new Vector.<BitmapData> ();
            offsets = new Vector.<Point> ();
            labels = new Vector.<String> ();

            var rect:Rectangle;
            var bitmapData:BitmapData;
            var matrix:Matrix = new Matrix ();

            var i:int;
            var length:int = mc.totalFrames;
            for (i = 1; i <= length; ++i) {
                mc.gotoAndStop (i);
                rect = mc.getBounds (mc);
                bitmapData = new BitmapData (Math.max (1, rect.width), Math.max (1, rect.height), true, 0x00000000);
                matrix.identity ();
                matrix.translate (-rect.x, -rect.y);
                matrix.scale (mc.scaleX, mc.scaleY);
                bitmapData.draw (mc, matrix);
                frames.push (bitmapData);
                offsets.push (new Point (rect.x * mc.scaleX, rect.y * mc.scaleY));
                labels.push (mc.currentLabel);
            }
            gotoAndStop (1);
        }

        /**
         * Деактивация.
         */
        public function destroy ():void {
            removeChild (bmp);
            bmp = null;
            frames = null;
            offsets = null;
            labels = null;
        }

        /**
         * Общее число кадров.
         */
        public function get totalFrames ():int {
            return frames.length;
        }

        /**
         * Текущая подпись кадра.
         */
        public function get currentLabel ():String {
            if (totalFrames == 0) {
                return "";
            }
            return labels [_currentFrame - 1];
        }

        /**
         * Подпись следующего за текущим кадра.
         */
        public function get nextLabel ():String {
            if ((totalFrames == 0) || (_currentFrame == totalFrames)) {
                return "";
            }
            return labels [_currentFrame];
        }

        /**
         * Переход в соответствующий кадр.
         * @param frame Номер кадра.
         */
        public function gotoAndStop (frame:int):void {
            if (totalFrames == 0) {
                return;
            }
            _currentFrame = Math.max (1, Math.min (totalFrames, frame));
            bmp.bitmapData = frames [_currentFrame - 1];
            bmp.x = offsets [_currentFrame - 1].x;
            bmp.y = offsets [_currentFrame - 1].y;
            bmp.smoothing = true;
//            tf.text = String (currentFrame);
        }

        /**
         * Переход на следующий кадр.
         */
        public function nextFrame ():void {
            if (totalFrames == 0) {
                return;
            }
            var nextFrame:int;
            if (_currentFrame < totalFrames) {
                nextFrame = _currentFrame + 1;
            }
            else {
                nextFrame = _currentFrame;
            }
            gotoAndStop (nextFrame);
        }

        /**
         * Переход в кадр с соответствующей подписью.
         * @param frame Подпись кадра.
         */
        public function gotoLabelAndStop (label:String):void {
            var index:int = labels.indexOf (label);
            if (index != -1) {
                gotoAndStop (index + 1);
            }
        }

    }
}
