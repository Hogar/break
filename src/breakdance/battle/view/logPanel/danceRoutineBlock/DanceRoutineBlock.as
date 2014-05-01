/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.09.13
 * Time: 15:47
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.danceRoutineBlock {

    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.model.IBattlePlayer;

    import flash.display.Sprite;
    import flash.events.Event;

    /**
     * Блок связки танц. движений со статичными данными.
     */
    public class DanceRoutineBlock extends Sprite {

        protected var _player:IBattlePlayer;//Ссылка на модель игрока в бою.

        private var items:Vector.<DanceRoutineBlockItem> = new Vector.<DanceRoutineBlockItem> ();

        private static const ITEM_HEIGHT:int = 19;
        private static const TEXT_C0LOR:uint = 0xffffff;

        public function DanceRoutineBlock () {

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

        public function init (danceRoutine:Vector.<BattleDanceMoveData>):void {
            clearItems ();
            for (var i:int = 0; i < danceRoutine.length; i++) {
                var battleDanceMoveData:BattleDanceMoveData = danceRoutine [i];
                var danceRoutinePanelItem:DanceRoutineBlockItem = new DanceRoutineBlockItem ();
                danceRoutinePanelItem.player = player;
                danceRoutinePanelItem.textColor = TEXT_C0LOR;
                danceRoutinePanelItem.bold = true;
                danceRoutinePanelItem.battleDanceMoveData = battleDanceMoveData;
                danceRoutinePanelItem.y = ITEM_HEIGHT * i;
                addChild (danceRoutinePanelItem);
                items.push (danceRoutinePanelItem);
            }
            dispatchEvent (new Event (Event.RESIZE));
        }

        override public function get height ():Number {
            var numItems:int;
            if (items) {
                numItems = items.length;
            }
            else {
                numItems = 0;
            }
            return ITEM_HEIGHT * items.length;
        }

        public function destroy ():void {
            clearItems ();
            player = null;
        }

        public function clear ():void {
            clearItems ();
            dispatchEvent (new Event (Event.RESIZE));
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function clearItems ():void {
            for (var i:int = 0; i < items.length; i++) {
                var danceRoutinePanelItem:DanceRoutineBlockItem = DanceRoutineBlockItem (items [i]);
                if (contains (danceRoutinePanelItem)) {
                    removeChild (danceRoutinePanelItem);
                }
                danceRoutinePanelItem.destroy ();
            }
            items = new Vector.<DanceRoutineBlockItem> ();
        }

    }
}
