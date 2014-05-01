/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 16.10.13
 * Time: 9:58
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    public class SendInvitePopUp extends InvitePopUp {

        public function SendInvitePopUp () {

        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            btn1.visible = false;
        }

    }
}