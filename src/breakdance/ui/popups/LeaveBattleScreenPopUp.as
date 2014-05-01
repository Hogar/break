/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.12.13
 * Time: 19:38
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.battle.BattleManager;

    public class LeaveBattleScreenPopUp extends LeaveScreenPopUp {

        public function LeaveBattleScreenPopUp () {

        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            super.setTexts ();
            tf.text = textsManager.getText ("acceptLeaveScreenBattle");
            positionText ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function onClickFirstButton ():void {
            BattleManager.instance.cancelCurrentBattle ();
            hide ();
        }

    }
}
