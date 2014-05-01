package com.hogargames.debug {

    import com.hogargames.display.scrolls.TextFieldScroll;

    import flash.display.Sprite;

    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     * Текстовое поле для вывода отладочных сообщений.
     * Экземпляры <code>TracerTextField</code> могут быть привязаны к классу <code>Tracer</code>
     * при помощи метода <code>addTracerOutput()</code>.
     *
     * @see com.hogargames.debug.Tracer#addTracerOutput()
     */
    public class TracerTextField extends Sprite implements ITracerOutput {

        private var tf:TextField;
        private var scroll:TextFieldScroll;

        private const TF_COLOR:uint = 0x999999;
        private const ALPHA:Number = .9;
        private const SCROLL_BASE_COLOR:uint = 0xaaaaaa;
        private const SCROLL_BUTTON_COLOR:uint = 0xcccccc;

        private const TEXT_FORMAT_SIZE:int = 14;
        private const TEXT_FORMAT_COLOR:Number = 0xffffff;

        public function TracerTextField () {
            tf = new TextField ();
//            tf.multiline = true;
//            tf.wordWrap = true;
            tf.background = true;
            tf.backgroundColor = TF_COLOR;
            tf.alpha = ALPHA;
            tf.defaultTextFormat = new TextFormat (null, TEXT_FORMAT_SIZE, TEXT_FORMAT_COLOR);
            scroll = new TextFieldScroll (tf);
            scroll.baseAlpha = ALPHA;
            scroll.barAlpha = ALPHA;
            scroll.buttonAlpha = ALPHA;
            scroll.buttonArrowAlpha = ALPHA;
            scroll.baseColor = SCROLL_BASE_COLOR;
            scroll.buttonColor = SCROLL_BUTTON_COLOR;
            addChild (scroll);
            addChild (tf);
        }

        override public function get width ():Number {
            return (tf.width + scroll.totalWidth);
        }

        override public function set width (value:Number):void {
            tf.width = value - scroll.totalWidth;
            scroll.x = value - scroll.totalWidth;
        }

        override public function get height ():Number {
            return tf.height;
        }

        override public function set height (value:Number):void {
            tf.height = value;
            scroll.y = scroll.totalButtonHeight;
            scroll.baseHeight = value - scroll.totalButtonHeight * 2;
        }

        /**
         * Вывод сообщения в текстовом поле.
         */
        public function log (message:String):ITracerOutput {
            tf.appendText (message.substr (0, message.length - 2) + "\n");
            if (tf.maxScrollV == 200) {
                tf.text = "...\n";
            }
            scroll.update ();
            return this;
        }

    }
}