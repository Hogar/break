/**
 * ResizeUtilities
 * @author Hogar (Igor Korol),
 */
package com.hogargames.utils {

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;

    /**
     * Утилиты для изменения размеров.
     */
    public class ResizeUtilities {

        /**
         * Режим масштабирования (с сохранением соотношения сторон) до полного заполнения заданной области масштабирования.
         * Размеры одной из сторон объекта после масштабирования
         * могут превышать размер соответствующей заданной области масштабирования.
         */
        public static const MODE_FILLING:String = "filling";
        /**
         * Режим масштабирования (с сохранением соотношения сторон) под заданную область масштабирования.
         * Размеры одной из сторон объекта после масштабирования
         * могут быть меньше размера соответствующей заданной области масштабирования.
         */
        public static const MODE_SCALING:String = "scaling";
        /**
         * Режим масштабирования (с сохранением соотношения сторон) по ширине.
         * Ширина объекта после масштабирования точно будет равна
         * заданной ширине масштабирования.
         */
        public static const BY_WIDTH:String = "by width";

        /**
         * Режим масштабирования (с сохранением соотношения сторон) по высоте.
         * Высота объекта после масштабирования точно будет равна
         * заданной высоте масштабирования.
         */
        public static const BY_HEIGHT:String = "by height";

        /**
         * Масштабирование объекта (с сохранением соотношения сторон).
         *
         * @param obj Объект для масштабирования.
         * @param areaWidth Ширина области масштабирования.
         * @param areaHeight Высота области масштабирования.
         * @param resizeMode Режим масштабирования (см. константы).
         */
        public static function resizeObj (obj:DisplayObject, areaWidth:Number, areaHeight:Number, resizeMode:String = MODE_SCALING):void {
            var scale:Number = getScale (obj, areaWidth, areaHeight, resizeMode);
            var newWidth:Number = obj.width * scale;
            var newHeight:Number = obj.height * scale;
            obj.width = newWidth;
            obj.height = newHeight;
        }

        /**
         * Масштабирование объекта <code>Bitmap</code> (с сохранением соотношения сторон).
         * Метод создаёт новый объект <code>BitmapData</code> и новый объект <code>Bitmap</code>.
         * Поэтому, в случае с маленькими картинками, возможно существенное ухудшение качества.
         * В этом случае следует использовать метод <code>resizeObj()</code>
         *
         * @param bmp <code>Bitmap</code> для масштабирования.
         * @param bmpWidth Ширина области масштабирования.
         * @param bmpHeight Высота области масштабирования.
         * @param resizeMode Режим масштабирования (см. константы).
         *
         * @return Новый Bitmap нужного размера.
         */
        public static function resizeBitmap (bmp:Bitmap, bmpWidth:Number, bmpHeight:Number, resizeMode:String = MODE_SCALING):Bitmap {
            var MTRX:Matrix = new Matrix ();
            bmp.smoothing = true;
            var scale:Number = getScale (bmp, bmpWidth, bmpHeight, resizeMode);
            MTRX.scale (scale, scale);
            var scaledBitmapData:BitmapData = new BitmapData (bmpWidth, bmpHeight, true, 0x00ffffff);
            scaledBitmapData.draw (bmp.bitmapData, MTRX);
            var scaledBitmap:Bitmap = new Bitmap (scaledBitmapData);
            scaledBitmap.smoothing = true;
            return (scaledBitmap);
        }

        private static function getScale (obj:DisplayObject, areaWidth:Number, areaHeight:Number, resizeMode:String = MODE_SCALING):Number {
            if ((obj == null) || (obj.width == 0) || (obj.height == 0)) {
                return 1;
            }
            var scale:Number = 1;
            if (resizeMode == MODE_FILLING) {
                scale = Math.max (areaWidth / obj.width, areaHeight / obj.height);
            }
            else if (resizeMode == MODE_SCALING) {
                scale = Math.min (areaWidth / obj.width, areaHeight / obj.height);
            }
            else if (resizeMode == BY_WIDTH) {
                scale = areaWidth / obj.width;
            }
            else if (resizeMode == BY_HEIGHT) {
                scale = areaHeight / obj.height;
            }
            else {
                throw new Error ("ResizeUtilities Error. Incorrect resize mode! (resizeMode = " + resizeMode + ")");
            }
            return scale;
        }
    }
}