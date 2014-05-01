/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 30.07.13
 * Time: 18:01
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.battleListPopUp {

    import breakdance.core.staticData.StaticData;
    import breakdance.ui.commons.buttons.ButtonWithText;

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class BattleSettingsPanel extends GraphicStorage {

        private var turnTabs:Vector.<ButtonWithText>;
        private var betTabs:Vector.<ButtonWithText>;

        private var selectedTurnTab:ButtonWithText;
        private var selectedBetTab:ButtonWithText;

        private var _enabled:Boolean;

        private const NUM_TURN_TABS:int = 3;
        private const NUM_BET_TABS:int = 3;

        public function BattleSettingsPanel (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        public function get enabled ():Boolean {
            return _enabled;
        }

        public function set enabled (value:Boolean):void {
            _enabled = value;
            mouseChildren = _enabled;
            mouseEnabled = _enabled;
        }

        public function get turns ():int {
            if (selectedTurnTab) {
                return parseInt (selectedTurnTab.tf.text);
            }
            else {
                return 0;
            }
        }



        public function set turns (value:int):void {
            var complete:Boolean = false;
            for (var i:int = 0; i < turnTabs.length; i++) {
                var turnTab:ButtonWithText = turnTabs [i];
                turnTab.selected = (parseInt (turnTab.tf.text) == value);
                if (turnTab.selected) {
                    complete = true;
                }
            }
            if (!complete) {
                turnTabs [0].selected = true;
            }
        }

        public function get bet ():int {
            if (selectedBetTab) {
                return parseInt (selectedBetTab.tf.text);
            }
            else {
                return 0;
            }
        }

        public function set bet (value:int):void {
            var complete:Boolean = false;
            for (var i:int = 0; i < betTabs.length; i++) {
                var betTab:ButtonWithText = betTabs [i];
                betTab.selected = (parseInt (betTab.tf.text) == value);
                if (betTab.selected) {
                    complete = true;
                }
            }
            if (!complete) {
                betTabs [0].selected = true;
            }
        }

        public function setDefault ():void {
            selectBetTab (betTabs [0]);
            selectTurnTab (turnTabs [0]);
        }

        override public function destroy ():void {
            var i:int;
            for (i = 0; i < turnTabs.length; i++) {
                turnTabs [i].destroy ();
            }
            for (i = 0; i < betTabs.length; i++) {
                betTabs [i].destroy ();
            }
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            turnTabs = new Vector.<ButtonWithText> ();
            betTabs = new Vector.<ButtonWithText> ();
            var i:int;
            var pvpBattlesTurns:String = StaticData.instance.getSetting ("pvp_battles_turns");
            var pvpBattlesTurnsAsArray:Array = pvpBattlesTurns.split (",");
            for (i = 0; i < NUM_TURN_TABS; i++) {
                var turnTab:ButtonWithText = new ButtonWithText (getElement ("btnTurns" + (i + 1)));
                if (pvpBattlesTurnsAsArray.length > i) {
                    turnTab.text = "<b>" + pvpBattlesTurnsAsArray [i] + "</b>";
                    turnTab.addEventListener (MouseEvent.CLICK, clickListener_turnTabs);
                    turnTabs.push (turnTab);
                }
                else {
                    turnTab.visible = false;
                }
            }
            var pvpBattlesBets:String = StaticData.instance.getSetting ("pvp_battles_bets");
            var pvpBattlesBetsAsArray:Array = pvpBattlesBets.split (",");
            for (i = 0; i < NUM_BET_TABS; i++) {
                var betTab:ButtonWithText = new ButtonWithText (getElement ("btnBet" + (i + 1)));
                if (pvpBattlesBetsAsArray.length > i) {
                    betTab.text = "<b>" + pvpBattlesBetsAsArray [i] + "</b>";
                    betTab.addEventListener (MouseEvent.CLICK, clickListener_betTabs);
                    betTabs.push (betTab);
                }
                else {
                    betTab.visible = false;
                }
            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function selectTurnTab (tab:ButtonWithText):void {
            for (var i:int = 0; i < turnTabs.length; i++) {
                var currentTab:ButtonWithText = turnTabs [i];
                currentTab.selected = currentTab == tab;
            }
            selectedTurnTab = tab;
        }

        private function selectBetTab (tab:ButtonWithText):void {
            for (var i:int = 0; i < betTabs.length; i++) {
                var currentTab:ButtonWithText = betTabs [i];
                currentTab.selected = currentTab == tab;
            }
            selectedBetTab = tab;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener_turnTabs (event:MouseEvent):void {
            selectTurnTab (ButtonWithText (event.currentTarget));
        }

        private function clickListener_betTabs (event:MouseEvent):void {
            selectBetTab (ButtonWithText (event.currentTarget));
        }


    }
}
