/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 30.12.13
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.bottomPanel.friendList {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.ButtonWithText;

    public class AddFriendItem extends ButtonWithText implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        public function AddFriendItem () {
            super (Template.createSymbol (Template.ADD_FRIEND_ITEM));
        }

        public function setTexts ():void {
            text = textsManager.getText ("inviteFriends2");
        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);
            super.destroy ();
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            textsManager.addTextContainer (this);
        }

    }
}
