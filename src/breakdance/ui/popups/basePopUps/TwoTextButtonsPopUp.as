/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.07.13
 * Time: 10:03
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.basePopUps {

    import breakdance.ui.commons.buttons.ButtonWithText;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class TwoTextButtonsPopUp extends OneTextButtonPopUp {

        protected var btn2:ButtonWithText;

        public function TwoTextButtonsPopUp (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////


        override public function destroy ():void {
            if (btn2) {
                btn2.removeEventListener (MouseEvent.CLICK, clickListener);
                btn2.destroy ();
                btn2 = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            btn2 = new ButtonWithText (mc ["btn2"]);
            btn2.text = "";
            btn2.addEventListener (MouseEvent.CLICK, clickListener);
        }

        protected function onClickSecondButton ():void {
            hide ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        override protected function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btn1:
                    onClickFirstButton ();
                    break;
                case btn2:
                    onClickSecondButton ();
                    break;
            }
        }

    }
}
