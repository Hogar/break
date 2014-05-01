/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.07.13
 * Time: 10:26
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalConstants;
    import breakdance.core.server.ServerApi;
    import breakdance.core.ui.overlay.OverlayManager;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.ui.commons.buttons.Button;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;

    import com.greensock.TweenLite;

    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class DeleteUserPopUp extends TwoTextButtonsPopUp {

        protected var btnClose:Button;

        public function DeleteUserPopUp () {
            super (Template.createSymbol(Template.TWO_BUTTONS_CHARACTER_CLOSING_POPUP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
            OverlayManager.instance.addOverlay (this, OverlayManager.TRANSACTION_LAYER_PRIORITY);
            if (mc && useShowAnimation) {
                TweenLite.killTweensOf (mc);
                mc.y = mcY - GlobalConstants.APP_HEIGHT / 2;
                TweenLite.to (mc, TWEEN_TIME, {y:mcY});
            }
        }

        override public function setTexts ():void {
            btn1.text = textsManager.getText ("yes");
            btn2.text = textsManager.getText ("no");
            tfTitle.text = textsManager.getText ("deleteUserTitle");
            tf.text = textsManager.getText ("deleteUserText");
            positionText ();
        }

        override public function destroy ():void {
            if (btnClose) {
                btnClose.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener_btnClose);
                btnClose.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener_btnClose);
                btnClose.removeEventListener (MouseEvent.CLICK, clickListener_btnClose);
                btnClose.destroy ();
                btnClose = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function onClickFirstButton ():void {
            TransactionOverlay.instance.show ();
            ServerApi.instance.query (ServerApi.DELETE_USER, {}, onDeleteUser);
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            btnClose = new Button (mc ["btnClose"]);
            btnClose.addEventListener (MouseEvent.CLICK, clickListener_btnClose);
            btnClose.addEventListener (MouseEvent.ROLL_OVER, rollOverListener_btnClose);
            btnClose.addEventListener (MouseEvent.ROLL_OUT, rollOutListener_btnClose);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function onDeleteUser (response:Object):void {
            TransactionOverlay.instance.hide ();
            PopUpManager.instance.createCharacterPopUp.show ();
            TutorialManager.instance.reset ();
            BreakdanceApp.instance.appUser.installed = false;
            hide ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        protected function clickListener_btnClose (event:MouseEvent):void {
            hide ();
        }

        private function rollOverListener_btnClose (event:MouseEvent):void {
            var message:String = textsManager.getText ("close");
            var positionPoint:Point = localToGlobal (new Point (btnClose.x + btnClose.width / 2, btnClose.y + btnClose.height));
            BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
        }

        private function rollOutListener_btnClose (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }
    }
}
