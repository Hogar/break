/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.09.13
 * Time: 13:49
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.battleDanceRoutineBlock {

    import breakdance.BreakdanceApp;
    import breakdance.battle.model.BattleDanceMove;
    import breakdance.battle.model.IBattlePlayer;
    import breakdance.battle.view.logPanel.RoundLogItem;
    import breakdance.data.danceMoves.DanceMoveType;

    import com.hogargames.Orientation;

    import flash.display.Sprite;

    /**
     * Блок связки танц. движений с динамическими данными (ссылка на модель).
     */
    public class BattleDanceRoutineBlock extends Sprite {

        protected var _player:IBattlePlayer;//Ссылка на модель игрока в бою.

        private var roundLogItem:RoundLogItem;//Лог, с описанием раунда.
        private var items:Vector.<BattleDanceRoutineBlockItem> = new <BattleDanceRoutineBlockItem> [];

        private const ITEM_HEIGHT:int = 19;

        public function BattleDanceRoutineBlock () {
            roundLogItem = new RoundLogItem ();
            addChild (roundLogItem);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Ссылка на модель игрока в бою.
         */
        public function get player ():IBattlePlayer {
            return _player;
        }

        public function set player (value:IBattlePlayer):void {
            _player = value;
        }

        public function init (battleDanceRoutine:Vector.<BattleDanceMove>):void {
            clear ();
            var startY:int = ITEM_HEIGHT;
            for (var i:int = 0; i < battleDanceRoutine.length; i++) {
                var battleDanceMove:BattleDanceMove = battleDanceRoutine [i];
                var battleDanceRoutinePanelItem:BattleDanceRoutineBlockItem = new BattleDanceRoutineBlockItem ();
                if (_player && (BreakdanceApp.instance.appUser.uid == _player.uid)) {
                    battleDanceRoutinePanelItem.arrowPosition = Orientation.RIGHT;
                }
                else {
                    battleDanceRoutinePanelItem.arrowPosition = Orientation.LEFT;
                }
                battleDanceRoutinePanelItem.player = player;
                battleDanceRoutinePanelItem.battleDanceMove = battleDanceMove;
                battleDanceRoutinePanelItem.y = startY + ITEM_HEIGHT * i;
                addChild (battleDanceRoutinePanelItem);
                items.push (battleDanceRoutinePanelItem);
            }
        }

        public function get round ():int {
            return roundLogItem.round;
        }

        public function set round (value:int):void {
            roundLogItem.round = value;
        }

        public function get additionalRound ():Boolean {
            return roundLogItem.additionalRound;
        }

        public function set additionalRound (value:Boolean):void {
            roundLogItem.additionalRound = value;
        }

        public function selectItemByBattleDanceMove (battleDanceMove:BattleDanceMove):void {
            var itemForSelect:BattleDanceRoutineBlockItem;
            for (var i:int = 0; i < items.length; i++) {
                var currentItem:BattleDanceRoutineBlockItem = items [i];
                if (currentItem.battleDanceMove == battleDanceMove) {
                    itemForSelect = currentItem;
                }
            }
            selectItem (itemForSelect);
        }

        public function deselectAllItems ():void {
            selectItem (null);
        }

        override public function get height ():Number {
            var numItems:int;
            if (items) {
                numItems = items.length;
            }
            else {
                numItems = 0;
            }
            return roundLogItem.height + ITEM_HEIGHT * numItems;
        }

        public function highlightSameDanceMoves (danceMoveType:DanceMoveType):void {
            for (var i:int = 0; i < items.length; i++) {
                var battleDanceRoutinePanelItem:BattleDanceRoutineBlockItem = BattleDanceRoutineBlockItem (items [i]);
                if (battleDanceRoutinePanelItem.battleDanceMove) {
                    if (battleDanceRoutinePanelItem.battleDanceMove.getDanceMoveType () == danceMoveType) {
                        battleDanceRoutinePanelItem.highlight ();
                    }
                }
            }
        }

        public function destroy ():void {
            clear ();
            roundLogItem.destroy ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function selectItem (item:BattleDanceRoutineBlockItem):void {
            for (var i:int = 0; i < items.length; i++) {
                var currentItem:BattleDanceRoutineBlockItem = items [i];
                currentItem.selected = (currentItem == item);
            }
        }

        private function clear ():void {
            for (var i:int = 0; i < items.length; i++) {
                var battleDanceRoutinePanelItem:BattleDanceRoutineBlockItem = BattleDanceRoutineBlockItem (items [i]);
                if (contains (battleDanceRoutinePanelItem)) {
                    removeChild (battleDanceRoutinePanelItem);
                }
                battleDanceRoutinePanelItem.destroy ();
            }
            items = new Vector.<BattleDanceRoutineBlockItem> ();
        }
    }
}
