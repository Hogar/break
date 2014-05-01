/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 25.06.13
 * Time: 18:35
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens {

    import breakdance.BreakdanceApp;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.ScreenWithHide;
    import breakdance.ui.commons.buttons.Button;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class ClosingScreen extends ScreenWithHide {

        protected var btnClose:Button;

        public function ClosingScreen (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function destroy ():void {
            if (btnClose) {
                btnClose.removeEventListener (MouseEvent.CLICK, clickListener_btnClose);
                btnClose.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener_btnClose);
                btnClose.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener_btnClose);
                btnClose.destroy ();
                btnClose = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            btnClose = new Button (mc ["btnClose"]);
            btnClose.addEventListener (MouseEvent.CLICK, clickListener_btnClose);
            btnClose.addEventListener (MouseEvent.ROLL_OVER, rollOverListener_btnClose);
            btnClose.addEventListener (MouseEvent.ROLL_OUT, rollOutListener_btnClose);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        protected function clickListener_btnClose (event:MouseEvent):void {
            hide ();
        }

        private function rollOverListener_btnClose (event:MouseEvent):void {
            var message:String = TextsManager.instance.getText ("close");
            var positionPoint:Point = localToGlobal (new Point (btnClose.x + btnClose.width / 2, btnClose.y + btnClose.height));
            BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
        }

        private function rollOutListener_btnClose (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }

    }
}
