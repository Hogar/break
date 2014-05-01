/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.07.13
 * Time: 23:06
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.basePopUps {

    import breakdance.BreakdanceApp;
    import breakdance.core.texts.TextsManager;
    import breakdance.ui.commons.buttons.Button;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class ClosingPopUp extends BasePopUp {

        protected var btnClose:Button;

        public function ClosingPopUp (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function destroy ():void {
            if (btnClose) {
                btnClose.removeEventListener (MouseEvent.CLICK, clickListener_close);
                btnClose.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener_close);
                btnClose.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
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
            btnClose.addEventListener (MouseEvent.CLICK, clickListener_close);
            btnClose.addEventListener (MouseEvent.ROLL_OVER, rollOverListener_close);
            btnClose.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
        }

        protected function onClickCloseButton ():void {
            hide ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        protected function clickListener_close (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btnClose:
                    onClickCloseButton ();
                    break;
            }
        }

        protected function rollOverListener_close (event:MouseEvent):void {
            var message:String = TextsManager.instance.getText ("close");
            var positionPoint:Point = localToGlobal (new Point (btnClose.x + btnClose.width / 2, btnClose.y + btnClose.height));
            BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
        }

        protected function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }
    }
}
