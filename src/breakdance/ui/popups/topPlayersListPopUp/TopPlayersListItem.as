/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.10.13
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.topPlayersListPopUp {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.AvatarContainer;

    import com.hogargames.display.GraphicStorage;

    import flash.text.TextField;

    public class TopPlayersListItem extends GraphicStorage implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var avatarContainer:AvatarContainer;
        private var tfId:TextField;
        private var tfName:TextField;
        private var tfName2:TextField;
        private var tfLevelTitle:TextField;
        private var tfLevel:TextField;
        private var tfPoints:TextField;

        private var _playerData:TopPlayerData;
        private var _id:int;

        public function TopPlayersListItem () {
            super (Template.createSymbol (Template.TOP_PLAYERS_LIST_ITEM));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////


        public function get id ():int {
            return _id;
        }

        public function set id (value:int):void {
            _id = value;
            tfId.text = String (value);
        }

        public function get playerData ():TopPlayerData {
            return _playerData;
        }

        public function set playerData (value:TopPlayerData):void {
            _playerData = value;
            if (_playerData) {
                avatarContainer.initByPlayerData (_playerData);
            }
            setTexts ();
        }

        public function setTexts ():void {
            if (_playerData) {
                tfName.text = _playerData.nickname;
                tfName2.text = _playerData.name;
                tfLevelTitle.text = textsManager.getText ("level_2");
                tfLevel.text = String (_playerData.level);
                tfPoints.text = String (_playerData.points);
            }
            else {
                tfName.text = "";
                tfName2.text = "";
                tfLevelTitle.text = "";
                tfLevel.text = "";
                tfPoints.text = "";
            }
        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);
            if (avatarContainer) {
                avatarContainer.destroy ();
                avatarContainer = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            avatarContainer = new AvatarContainer (mc ["mcAvatarContainer"]);
            tfName = getElement ("tfName");
            tfLevel = getElement ("tfLevel");
            tfId = getElement ("tfId");
            tfName2 = getElement ("tfName2");
            tfLevelTitle = getElement ("tfLevelTitle");
            tfPoints = getElement ("tfPoints");

            textsManager.addTextContainer (this);
        }

    }
}
