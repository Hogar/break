/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.12.13
 * Time: 19:53
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {


    public class LeaveMiniGameScreenPopUp extends LeaveScreenPopUp {

        public function LeaveMiniGameScreenPopUp () {

        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            super.setTexts ();
            tf.text = textsManager.getText ("acceptLeaveScreenMinigame");
            positionText ();
        }

    }
}
