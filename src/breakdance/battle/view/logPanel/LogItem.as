/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.09.13
 * Time: 10:07
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel {

    import breakdance.template.Template;

    import com.hogargames.Orientation;
    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     * Одиночный лог.
     */
    public class LogItem extends GraphicStorage {

        protected var mcContainer:Sprite;
        protected var tfCaption:TextField;
        protected var tfAmount:TextField;

        protected var mcArrowRight:MovieClip;
        protected var mcArrowLeft:MovieClip;

        private var _bold:Boolean;
        private var _textColor:uint;

        private var _arrowPosition:String = Orientation.LEFT;
        private var _arrowVisible:Boolean = false;

        public function LogItem (caption:String = "", amount:String = "", bold:Boolean = false, textColor:int = 0xffffff) {
            super (Template.createSymbol (Template.MOVE_LOG_ITEM));

            this.caption = caption;
            this.amount = amount;

            this.bold = bold;
            this.textColor = textColor;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get textColor ():int {
            return _textColor;
        }

        public function set textColor (value:int):void {
            if (_textColor == value) {
                return;
            }

            _textColor = value;

            var textFormat:TextFormat = new TextFormat ();
            textFormat.color = _textColor;
            tfCaption.setTextFormat (textFormat);
            tfCaption.defaultTextFormat = textFormat;
            tfAmount.setTextFormat (textFormat);
            tfAmount.defaultTextFormat = textFormat;
        }

        public function get bold ():Boolean {
            return _bold;
        }

        public function set bold (value:Boolean):void {
            if (_bold == value)
                return;

            _bold = value;

            var textFormat:TextFormat = new TextFormat ();
            textFormat.bold = _bold;
            tfCaption.setTextFormat (textFormat);
            tfCaption.defaultTextFormat = textFormat;
            tfAmount.setTextFormat (textFormat);
            tfAmount.defaultTextFormat = textFormat;
        }

        public function get caption ():String {
            return tfCaption.text;
        }

        public function set caption (value:String):void  {
            tfCaption.text = value;
        }

        public function get amount ():String {
            return tfAmount.text;
        }

        public function set amount (value:String):void  {
            tfAmount.text = value;
        }

        public function get arrowPosition ():String {
            return _arrowPosition;
        }

        public function set arrowPosition (value:String):void {
            _arrowPosition = value;
            mcArrowRight.visible = false;
            mcArrowLeft.visible = false;
            if (_arrowPosition == Orientation.LEFT) {
                mcArrowLeft.visible = _arrowVisible;
            }
            else {
                mcArrowRight.visible = _arrowVisible;
            }
        }

        public function get arrowVisible ():Boolean {
            return _arrowVisible;
        }

        public function set arrowVisible (value:Boolean):void {
            _arrowVisible = value;
            var currentArrow:MovieClip;
            if (_arrowPosition == Orientation.LEFT) {
                currentArrow = mcArrowLeft;
            }
            else {
                currentArrow = mcArrowRight;
            }
            if (currentArrow) {
                currentArrow.visible = _arrowVisible;
                if (_arrowVisible) {
                    currentArrow.gotoAndPlay (1);
                }
            }
        }

        override public function destroy ():void {
            tfCaption = null;
            tfAmount = null;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcContainer = getElement ('mcContainer');
            tfCaption = getElement ('tfCaption', mcContainer);
            tfCaption.textColor = textColor;

            mcArrowRight = getElement ("mcArrowRight");
            mcArrowLeft = getElement ("mcArrowLeft");

            tfAmount = getElement ('tfAmount', mcContainer);
            tfAmount.textColor = textColor;

            arrowPosition = _arrowPosition;
            arrowVisible = _arrowVisible;
        }
    }
}