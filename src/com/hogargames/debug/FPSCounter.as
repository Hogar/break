/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 29.02.12
 * Time: 14:43
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.debug {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.getTimer;

    /**
     * Счётчик fps.
     */
    public class FPSCounter extends Sprite {

        private var last:uint = getTimer ();
        private var ticks:uint = 0;
        private var tf:TextField;

        /**
         *
         * @param xPos Позиция x.
         * @param yPos Позиция y.
         * @param fontSize Размер шрифта.
         * @param fontColor Цвет шрифта.
         * @param fillBackground Заливка.
         * @param backgroundColor Цвет заливки.
         */
        public function FPSCounter (xPos:int = 0, yPos:int = 0, fontSize:Number = NaN, fontColor:uint = 0xffffff, fillBackground:Boolean = true, backgroundColor:uint = 0x000000) {
            x = xPos;
            y = yPos;
            tf = new TextField ();
            tf.textColor = fontColor;
            tf.text = "----- fps";
            tf.selectable = false;
            tf.background = fillBackground;
            tf.backgroundColor = backgroundColor;
            tf.autoSize = TextFieldAutoSize.LEFT;
            if (!isNaN (fontSize)) {
                var textFormat:TextFormat = tf.getTextFormat ();
                textFormat.size = fontSize;
                tf.setTextFormat (textFormat);
                tf.defaultTextFormat = textFormat;
            }
            addChild (tf);
            tf.width = tf.textWidth + 4;
            tf.height = tf.textHeight + 4;
            addEventListener (Event.ENTER_FRAME, tick);
        }

        private function tick (evt:Event):void {
            ticks++;
            var now:uint = getTimer ();
            var delta:uint = now - last;
            if (delta >= 1000) {
                var fps:Number = ticks / delta * 1000;
                tf.text = fps.toFixed (1) + " fps";
                ticks = 0;
                last = now;
            }
        }
    }
}
