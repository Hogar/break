/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.10.13
 * Time: 9:56
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.text.TextField;

    public class BaseInfoMessage extends GraphicStorage {

        private var tf1:TextField;
        private var tf2:TextField;

        public function BaseInfoMessage (mc:MovieClip) {
            super (mc);
            mouseEnabled = false;
            mouseChildren = false;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function setMessage (message:String):void {
            tf1.htmlText = message;
            tf2.htmlText = message;
            positionText (tf1);
            positionText (tf2);
        }

        public function show ():void {
            visible = true;
            mc.gotoAndPlay (1);
        }

        public function hide ():void {
            visible = false;
            mc.gotoAndStop (1);
        }

        override public function destroy ():void {
            removeEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
            removeEventListener (Event.ENTER_FRAME, enterFrameListener);
            mc.stop ();
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            var mcText1:MovieClip = getElement ("mcText1");
            tf1 = getElement ("tf", mcText1);
            var mcText2:MovieClip = getElement ("mcText2");
            tf2 = getElement ("tf", mcText2);

            if (stage) {
                if (!hasEventListener (Event.ENTER_FRAME)) {
                    addEventListener (Event.ENTER_FRAME, enterFrameListener);
                }
            }
            else {
                addEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private static function positionText (tf:TextField):void {
            tf.width = Math.ceil (tf.textWidth + 4);
            tf.height = Math.ceil (tf.textHeight + 4);
            tf.x = -tf.width / 2;
            tf.y = -tf.height / 2;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        protected function enterFrameListener (event:Event):void {
            if (mc.currentFrame == mc.totalFrames) {
                hide ();
            }
        }

        private function addedToStageListener (event:Event):void {
            addEventListener (Event.ENTER_FRAME, enterFrameListener);
            removeEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
        }
    }
}
