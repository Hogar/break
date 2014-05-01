/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.01.14
 * Time: 18:15
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import com.hogargames.display.GraphicStorage;

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;

    public class CoinsAwardAnimation extends GraphicStorage {

        private var tfCoins:TextField;

        public function CoinsAwardAnimation (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function showCoins (coins:int):void {
            tfCoins.text = String (coins);
            mc.gotoAndPlay (1);
            mc.visible = coins > 0;
        }

        public function hide ():void {
            mc.visible = false;
            mc.gotoAndStop (1);
        }

        override public function destroy ():void {
            removeEventListener (Event.ENTER_FRAME, enterFrameListener);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            for (var i:int = 0; i < mc.numChildren; i++) {
                var child:DisplayObject = mc.getChildAt (i);
            }
            var mcCoins:Sprite = getElement ("mcCoins");
            var mcCoins2:Sprite = mc ["mcCoins"];
            tfCoins = getElement ("tf", mcCoins);

            mouseEnabled = false;
            mouseChildren = false;

            addEventListener (Event.ENTER_FRAME, enterFrameListener);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function enterFrameListener (event:Event):void {
            if (mc.currentFrame == mc.totalFrames) {
                hide ();
            }
        }

    }
}