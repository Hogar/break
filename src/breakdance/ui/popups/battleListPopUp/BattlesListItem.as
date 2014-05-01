/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.07.13
 * Time: 23:34
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.battleListPopUp {

    import breakdance.battle.data.BattleData;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.AvatarContainer;
    import breakdance.ui.commons.buttons.ButtonWithText;

    import com.hogargames.display.GraphicStorage;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class BattlesListItem extends GraphicStorage implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var avatarContainer:AvatarContainer;
        private var tfName:TextField;
        private var tfLevel:TextField;
        private var tfTurnsTitle:TextField;
        private var tfTurns:TextField;
        private var tfBetTitle:TextField;
        private var tfBet:TextField;
        private var btnStartBattle:ButtonWithText;

        private var _battleData:BattleData;

        private var _battleDataAsString:String;

        private static const AVATAR_SCALE:Number = .6;
        private static const AVATAR_X:int = 19;
        private static const AVATAR_Y:int = 17;

        public function BattlesListItem () {
            super (Template.createSymbol (Template.BATTLE_LIST_ITEM));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get battleData ():BattleData {
            return _battleData;
        }

        public function set battleData (value:BattleData):void {
            _battleData = value;
            if (_battleData) {
                if (_battleData.player1) {
                    avatarContainer.initByPlayerData (_battleData.player1);
                }
            }
            setTexts ();
            _battleDataAsString = _battleData.toString ();
            enabled = true;
        }

        public function get enabled ():Boolean {
            return btnStartBattle.enable;
        }

        public function set enabled (value:Boolean):void {
            btnStartBattle.enable = value;
        }

        public function get battleDataAsString ():String {
            return _battleDataAsString;
        }

        public function setTexts ():void {
            if (_battleData) {
                if (_battleData.player1) {
                    tfName.text = _battleData.player1.nickname;
                    tfLevel.text = String (_battleData.player1.level) + " " + textsManager.getText ("level");
                }
                else {
                    tfName.text = "";
                    tfLevel.text = "";
                }
                tfTurnsTitle.text = textsManager.getText ("turns");
                tfBetTitle.text = textsManager.getText ("bet");
                tfTurnsTitle.width = tfTurnsTitle.textWidth + 4;
                tfBetTitle.width = tfBetTitle.textWidth + 4;
                tfTurns.x = Math.ceil (tfTurnsTitle.x + tfTurnsTitle.width);
                tfBet.x = Math.ceil (tfBetTitle.x + tfBetTitle.width);
                tfTurns.text = String (_battleData.turns);
                tfBet.text = String (_battleData.bet);
            }
            else {
                tfName.text = "";
                tfLevel.text = "";
                tfTurnsTitle.text = "";
                tfBetTitle.text = "";
                tfTurns.text = "";
                tfBet.text = "";
            }
            btnStartBattle.text = textsManager.getText ("startBattle");
        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);
            if (avatarContainer) {
                avatarContainer.destroy ();
                avatarContainer = null;
            }
            if (btnStartBattle) {
                btnStartBattle.destroy();
                btnStartBattle = null;
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
            tfTurnsTitle = getElement ("tfTurnsTitle");
            tfTurns = getElement ("tfTurns");
            tfBetTitle = getElement ("tfBetTitle");
            tfBet = getElement ("tfBet");

            btnStartBattle = new ButtonWithText (mc ["btnStartBattle"]);
            btnStartBattle.addEventListener (MouseEvent.CLICK, clickListener);

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            dispatchEvent (new Event (Event.SELECT));
        }

    }
}
