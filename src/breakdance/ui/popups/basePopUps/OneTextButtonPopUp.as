/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.09.13
 * Time: 14:46
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.basePopUps {

    import breakdance.ui.commons.buttons.ButtonWithText;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class OneTextButtonPopUp extends TextsPopUp {

        protected var btn1:ButtonWithText;

        public function OneTextButtonPopUp (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function destroy ():void {
            if (btn1) {
                btn1.removeEventListener (MouseEvent.CLICK, clickListener);
                btn1.destroy ();
                btn1 = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            btn1 = new ButtonWithText (getElement ("btn1"));
            btn1.addEventListener (MouseEvent.CLICK, clickListener);
            btn1.text = "";
        }

        protected function onClickFirstButton ():void {

        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        protected function clickListener (event:MouseEvent):void {
            onClickFirstButton ();
        }

    }
}
