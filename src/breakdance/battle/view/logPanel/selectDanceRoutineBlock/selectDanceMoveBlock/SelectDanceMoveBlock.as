/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.09.13
 * Time: 13:06
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.selectDanceRoutineBlock.selectDanceMoveBlock {

    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.model.IBattlePlayer;
    import breakdance.battle.view.logPanel.selectDanceRoutineBlock.selectDanceMoveBlock.events.SelectDanceMoveEvent;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     * Блок выбора танц. движения для связки.
     */
    public class SelectDanceMoveBlock extends Sprite {

        /**
         * Отправляется при выборе танц. движения.
         *
         * @eventType breakdance.battle.view.logPanel.selectDanceRoutinePanel.selectDanceMovePanel.events.SelectDanceMoveEvent.SELECT_DANCE_MOVE
         */
        [Event(name="select dance move", type="breakdance.battle.view.logPanel.selectDanceRoutineBlock.selectDanceMoveBlock.events.SelectDanceMoveEvent")]

        protected var _player:IBattlePlayer;//Ссылка на модель игрока в бою.

        private var items:Vector.<SelectDanceMoveBlockItem> = new Vector.<SelectDanceMoveBlockItem> ();

        private var selectionTimer:Timer;
        private var selectionContainer:Sprite;//Для анимации.
        private var selectionCount:int = 0;//Для анимации.

        private const ANIMATION_TIME:Number = .3;
        private const ITEM_HEIGHT:int = 21;
        private const SELECTION_COLOR:uint = 0xffffff;
        private const SELECTION_ALPHA:Number = .1;
        private const SELECTION_WIDTH:int = 210;
        private const SELECTION_ELLIPSE_SIZE:int = 10;

        public function SelectDanceMoveBlock () {
            selectionContainer = new Sprite ();
            addChild (selectionContainer);
            selectionTimer = new Timer (ANIMATION_TIME * 1000);
            selectionTimer.addEventListener (TimerEvent.TIMER, timerListener);
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

        public function init (availableDanceMoves:Vector.<BattleDanceMoveData>):void {
            clearItems ();
            for (var i:int = 0; i < availableDanceMoves.length; i++) {
                var battleDanceMoveData:BattleDanceMoveData = availableDanceMoves [i];
                var selectDanceMovePanelItem:SelectDanceMoveBlockItem = new SelectDanceMoveBlockItem ();
                selectDanceMovePanelItem.player = _player;
                selectDanceMovePanelItem.battleDanceMoveData = battleDanceMoveData;
                selectDanceMovePanelItem.y = ITEM_HEIGHT * i;
                selectDanceMovePanelItem.addEventListener (MouseEvent.CLICK, clickListener);
                selectDanceMovePanelItem.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                selectDanceMovePanelItem.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                addChild (selectDanceMovePanelItem);
                items.push (selectDanceMovePanelItem);
            }
            selectionCount = 0;
            selectionTimer.start ();
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
            clear ();
            selectionTimer.removeEventListener (TimerEvent.TIMER, timerListener);
            selectionTimer.stop ();
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
                var selectDanceMovePanelItem:SelectDanceMoveBlockItem = SelectDanceMoveBlockItem (items [i]);
                selectDanceMovePanelItem.removeEventListener (MouseEvent.CLICK, clickListener);
                selectDanceMovePanelItem.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                selectDanceMovePanelItem.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                if (contains (selectDanceMovePanelItem)) {
                    removeChild (selectDanceMovePanelItem);
                }
                selectDanceMovePanelItem.destroy ();
            }
            items = new Vector.<SelectDanceMoveBlockItem> ();
        }

        private function redrawSelection ():void {
//            graphics.clear ();
//            graphics.beginFill (SELECTION_COLOR, SELECTION_ALPHA);
//            graphics.drawRoundRect (0, 0, SELECTION_WIDTH, items.length * ITEM_HEIGHT, SELECTION_ELLIPSE_SIZE, SELECTION_ELLIPSE_SIZE);
//            graphics.endFill ();
            for (var i:int = 0; i < items.length; i++) {
                var item:SelectDanceMoveBlockItem = items [i];
                item.showHighlight = (i == selectionCount);
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var selectDanceMovePanelItem:SelectDanceMoveBlockItem = SelectDanceMoveBlockItem (event.currentTarget);
            var battleDanceMoveData:BattleDanceMoveData = selectDanceMovePanelItem.battleDanceMoveData;
            if (battleDanceMoveData) {
                dispatchEvent (new SelectDanceMoveEvent (battleDanceMoveData));
            }
        }

        private function rollOverListener (event:MouseEvent):void {
            for (var i:int = 0; i < items.length; i++) {
                var item:SelectDanceMoveBlockItem = items [i];
                item.showHighlight = false;
            }
            selectionTimer.stop ();
        }

        private function rollOutListener (event:MouseEvent):void {
            selectionCount = 0;
            selectionTimer.start ();
        }

        private function timerListener (event:TimerEvent):void {
            selectionCount++;
            if (selectionCount > items.length) {
                selectionCount = 0;
            }
            redrawSelection ();
        }

    }
}
    