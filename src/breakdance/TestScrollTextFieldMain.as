/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.03.14
 * Time: 3:25
 * To change this template use File | Settings | File Templates.
 */
package breakdance {

    import com.hogargames.display.scrolls.BasicScroll;
    import com.hogargames.display.scrolls.TextFieldScroll;

    import flash.display.Bitmap;

    import flash.display.DisplayObject;
    import flash.display.Loader;

    import flash.display.Shape;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    [SWF(width="810", height="675", frameRate="30", backgroundColor="#ffffff")]
    public class TestScrollTextFieldMain extends Sprite {

        private var tf:TextField;

        private var scroll:BasicScroll;
        private var textFieldScroll:TextFieldScroll;

        private var btn1:Sprite;
        private var btn2:Sprite;
        private var btn3:Sprite;
        private var btn4:Sprite;
        private var btn5:Sprite;
        private var btn6:Sprite;
        private var btn7:Sprite;
        private var btn8:Sprite;
        private var btn9:Sprite;
        private var btn10:Sprite;
        private var btn11:Sprite;
        private var btn12:Sprite;
        private var btn13:Sprite;
        private var btn14:Sprite;
        private var btn15:Sprite;
        private var btn16:Sprite;

        public function TestScrollTextFieldMain () {
            var shape:Shape = new Shape ();
            var shapeContainer:Sprite = new Sprite ();
            shapeContainer.x = 200;
            shapeContainer.y = 300;
            shapeContainer.addChild (shape);
            shape.x = 0;
            shape.y = 50;
            shape.graphics.beginFill (0x00ff00, 1);
            shape.graphics.drawCircle (0, 0, 50);
            shape.graphics.endFill ();
            addChild (shapeContainer);
            scroll = new BasicScroll (shape, true);
            scroll.useScrollInvert = false;
            scroll.movingArea = -200;
            scroll.x = 10;
            scroll.y = 20;
            addChild (scroll);

            tf = new TextField ();
            tf.x = 400;
            tf.y = 20;
            tf.border = true;
            addChild (tf);

            textFieldScroll = new TextFieldScroll (tf);
            textFieldScroll.x = tf.x + tf.width;
            textFieldScroll.y = tf.y + textFieldScroll.totalButtonHeight;
            textFieldScroll.baseHeight = tf.height - textFieldScroll.totalButtonHeight * 2;
            addChild (textFieldScroll);


            const BUTTONS_START_X:int = 10;
            const STEP_X:int = 65;
            const BUTTONS_START_Y:int = 300;
            const STEP_Y:int = 25;
            btn1 = createButton ("base_w++", BUTTONS_START_X, BUTTONS_START_Y);
            btn2 = createButton ("base_w--", BUTTONS_START_X + STEP_X, BUTTONS_START_Y);
            btn3 = createButton ("bar_w++", BUTTONS_START_X, BUTTONS_START_Y+ STEP_Y);
            btn4 = createButton ("bar_w--", BUTTONS_START_X + STEP_X, BUTTONS_START_Y+ STEP_Y);
            btn5 = createButton ("bt_w++", BUTTONS_START_X, BUTTONS_START_Y + STEP_Y * 2);
            btn6 = createButton ("bt_w--", BUTTONS_START_X + STEP_X, BUTTONS_START_Y + STEP_Y * 2);
            btn7 = createButton ("bt_h++", BUTTONS_START_X, BUTTONS_START_Y + STEP_Y * 3);
            btn8 = createButton ("bt_h--", BUTTONS_START_X + STEP_X, BUTTONS_START_Y + STEP_Y * 3);
            btn9 = createButton ("bt_m++", BUTTONS_START_X, BUTTONS_START_Y + STEP_Y * 4);
            btn10 = createButton ("bt_m--", BUTTONS_START_X + STEP_X, BUTTONS_START_Y + STEP_Y * 4);
            btn11 = createButton ("true", BUTTONS_START_X, BUTTONS_START_Y + STEP_Y * 5);
            btn12 = createButton ("false", BUTTONS_START_X + STEP_X, BUTTONS_START_Y + STEP_Y * 5);
            btn13 = createButton ("200", BUTTONS_START_X, BUTTONS_START_Y + STEP_Y * 6);
            btn14 = createButton ("-200", BUTTONS_START_X + STEP_X, BUTTONS_START_Y + STEP_Y * 6);
            btn15 = createButton ("Доб. строку", BUTTONS_START_X, BUTTONS_START_Y + STEP_Y * 7);
            btn16 = createButton ("Убр. строку", BUTTONS_START_X + STEP_X, BUTTONS_START_Y + STEP_Y * 7);
            addChild (btn1);

//            loadFile ("btn.png", completeListener_buttons);
        }

        private function loadFile (url:String, completeListener:Function):void {
            var loader:Loader = new Loader ();
            loader.contentLoaderInfo.addEventListener (Event.COMPLETE, completeListener);
            loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
            loader.load (new URLRequest (url));
        }

        private function createButton (title:String, positionX:int, positionY:int, withListeners:Boolean = true):Sprite {
            const BUTTON_WIDTH:int = 60;
            const BUTTON_HEIGHT:int = 20;
            var tf:TextField = new TextField ();
            var textFormat:TextFormat = tf.getTextFormat ();
            textFormat.align = TextFormatAlign.CENTER;
            tf.setTextFormat (textFormat);
            tf.defaultTextFormat = textFormat;
            tf.multiline = false;
            tf.width = BUTTON_WIDTH;
            tf.height = BUTTON_HEIGHT;
            tf.selectable = false;
            tf.mouseEnabled = false;
            tf.text = title;
            var btn:Sprite = new Sprite ();
            btn.graphics.beginFill (0x999999);
            btn.graphics.drawRect (0, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
            btn.graphics.endFill ();
            btn.buttonMode = true;
            btn.useHandCursor = true;
            btn.addChild (tf);

            btn.x = positionX;
            btn.y = positionY;

            addChild (btn);

            if (withListeners) {
                btn.addEventListener (MouseEvent.CLICK, clickListener);
            }
            return btn;
        }

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btn1:
                    scroll.baseWidth++;
                    break;
                case btn2:
                    scroll.baseWidth--;
                    break;
                case btn3:
                    scroll.barWidth++;
                    break;
                case btn4:
                    scroll.barWidth--;
                    break;
                case btn5:
                    scroll.buttonWidth++;
                    trace ("scroll.buttonWidth = " + scroll.buttonWidth);
                    break;
                case btn6:
                    scroll.buttonWidth--;
                    trace ("scroll.buttonWidth = " + scroll.buttonWidth);
                    break;
                case btn7:
                    scroll.buttonHeight++;
                    trace ("scroll.buttonHeight = " + scroll.buttonHeight);
                    break;
                case btn8:
                    scroll.buttonHeight--;
                    trace ("scroll.buttonHeight = " + scroll.buttonHeight);
                    break;
                case btn9:
                    scroll.buttonMargin++;
                    trace ("scroll.buttonMargin = " + scroll.buttonMargin);
                    break;
                case btn10:
                    scroll.buttonMargin--;
                    trace ("scroll.buttonMargin = " + scroll.buttonMargin);
                    break;
                case btn11:
                    scroll.useScrollInvert = true;
                    trace ("scroll.useScrollInvert = " + scroll.useScrollInvert);
                    break;
                case btn12:
                    scroll.useScrollInvert = false;
                    trace ("scroll.useScrollInvert = " + scroll.useScrollInvert);
                    break;
                case btn13:
                    scroll.movingArea = 200;
                    trace ("scroll.movingArea = " + scroll.movingArea);
                    break;
                case btn14:
                    scroll.movingArea = -200;
                    trace ("scroll.movingArea = " + scroll.movingArea);
                    break;
                case btn15:
                    var addingLine:String = String (tf.numLines);
                    if (addingLine.length == 1) {
                        addingLine = "0" + addingLine;
                    }
                    addingLine += ".";
                    addingLine += Math.random () > .5 ? "Шапокля" : (Math.random () > .5 ? "Генадий" : (Math.random () > .5 ? "Чебураш" : "Девочка"));
                    tf.appendText (addingLine + "\n");
                    textFieldScroll.update ();
                    break;
                case btn16:
                    tf.text = tf.text.substr (0, tf.text.length - 11);
                    textFieldScroll.update ();
                    break;
            }
        }

        private function completeListener_buttons (event:Event):void {
            var bmp:Bitmap = Bitmap (event.currentTarget.content);
            scroll.setExternalTopButton (new Bitmap (bmp.bitmapData));
            scroll.setExternalBottomButton (new Bitmap (bmp.bitmapData));
            loadFile ("scroll_bar.png", completeListener_bar);
        }

        private function completeListener_bar (event:Event):void {
            var bmp:Bitmap = Bitmap (event.currentTarget.content);
            scroll.setExternalScrollBar (bmp);
            loadFile ("scroll_base.png", completeListener_base);
        }

        private function completeListener_base (event:Event):void {
            var bmp:Bitmap = Bitmap (event.currentTarget.content);
            scroll.setExternalScrollBase (bmp);
        }

        private function ioErrorListener (event:IOErrorEvent):void {
            trace ("Не нашли картинку");
        }
    }
}
