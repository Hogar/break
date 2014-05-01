/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 16:48
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel {

    import breakdance.BreakdanceApp;
    import breakdance.battle.events.BattleDanceRoutineEvent;
    import breakdance.battle.events.BattleEndEvent;
    import breakdance.battle.events.BattleEvent;
    import breakdance.battle.events.ProcessBattleDanceMoveEvent;
    import breakdance.battle.model.BattleDanceMove;
    import breakdance.battle.model.IBattle;
    import breakdance.battle.model.IBattlePlayer;
    import breakdance.battle.view.logPanel.battleDanceRoutineBlock.BattleDanceRoutineBlock;
    import breakdance.data.danceMoves.DanceMoveType;

    import com.greensock.TweenLite;
    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.NumericalUtilities;

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    /**
     * Панель логов танц движений.
     * Содержит группы логов (панели).
     */
    public class BattleLogPanel extends GraphicStorage {

        protected var _battle:IBattle;//Ссылка на модель боя.
        protected var _player:IBattlePlayer;//Ссылка на модель игрока в бою.

        private var _panelsContainerMask:Sprite;//Маска для контейнера (область отображения).
        private var _panelsContainer:Sprite;//Контейнер, в котором хранятся визуальные элементы (блоки).

        private var blocks:Vector.<Sprite> = new Vector.<Sprite> ();//Добавленные блоки.
        private var battleDanceRoutineBlocks:Vector.<BattleDanceRoutineBlock> = new Vector.<BattleDanceRoutineBlock> ();//Добавленные панели.

        private static const TWEEN_TIME:Number = .3;
        private static const STEP:int = 30;//Шаг при прокрутке лога.

        public function BattleLogPanel (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Ссылка на модель боя.
         */
        public function get battle ():IBattle {
            return _battle;
        }

        public function set battle (value:IBattle):void {
            clear ();
            if (_battle) {
                _battle.removeEventListener (BattleEvent.PROCESS_FAILURE, processFailureListener);
                _battle.removeEventListener (BattleEvent.START_BATTLE, startBattleListener);
                _battle.removeEventListener (BattleEndEvent.END_BATTLE, endBattleListener);
                _battle.removeEventListener (BattleDanceRoutineEvent.ADD_BATTLE_DANCE_ROUTINE, addBattleDanceRoutineListener);
                _battle.removeEventListener (ProcessBattleDanceMoveEvent.BATTLE_DANCE_MOVE_WAS_PROCESSED, battleDanceMoveWasProcessedListener);
            }
            _battle = value;
            if (_battle) {
                _battle.addEventListener (BattleEvent.PROCESS_FAILURE, processFailureListener);
                _battle.addEventListener (BattleEvent.START_BATTLE, startBattleListener);
                _battle.addEventListener (BattleEndEvent.END_BATTLE, endBattleListener);
                _battle.addEventListener (BattleDanceRoutineEvent.ADD_BATTLE_DANCE_ROUTINE, addBattleDanceRoutineListener);
                _battle.addEventListener (ProcessBattleDanceMoveEvent.BATTLE_DANCE_MOVE_WAS_PROCESSED, battleDanceMoveWasProcessedListener);
            }
        }

        /**
         * Ссылка на модель игрока в бою.
         */
        public function get player ():IBattlePlayer {
            return _player;
        }

        public function set player (value:IBattlePlayer):void {
            clear ();
            _player = value;
        }

        public function deselectAllBlocks ():void {
            for (var i:int = 0; i < battleDanceRoutineBlocks.length; i++) {
                var block:BattleDanceRoutineBlock = battleDanceRoutineBlocks [i];
                block.deselectAllItems ();
            }
        }

        /**
         * Добавление блока, отображающего связку.
         * @param battleDanceRoutine
         * @param round
         */
        public function addBattleDanceRoutineBlock (battleDanceRoutine:Vector.<BattleDanceMove>, round:int):void {
            var battleDanceRoutinePanel:BattleDanceRoutineBlock = new BattleDanceRoutineBlock ();
            battleDanceRoutinePanel.player = player;
            battleDanceRoutinePanel.init (battleDanceRoutine);
            battleDanceRoutinePanel.round = round;
            var currentRoundIsAdditional:Boolean = false;
            if (_battle) {
                currentRoundIsAdditional = _battle.currentRoundIsAdditional;
            }
            battleDanceRoutinePanel.additionalRound = currentRoundIsAdditional;
            battleDanceRoutineBlocks.push (battleDanceRoutinePanel);
            addBlock (battleDanceRoutinePanel);
        }

        public function getBattleDanceRoutinePanel (round:int):BattleDanceRoutineBlock {
            for (var i:int = 0; i < battleDanceRoutineBlocks.length; i++) {
                var battleDanceRoutinePanel:BattleDanceRoutineBlock = battleDanceRoutineBlocks [i];
                if (battleDanceRoutinePanel.round - 1 == round){
                    return battleDanceRoutinePanel;
                }
            }
            return null;
        }

        public function highlightSameDanceMoves (danceMoveType:DanceMoveType):void {
            for (var i:int = 0; i < battleDanceRoutineBlocks.length; i++) {
                battleDanceRoutineBlocks [i].highlightSameDanceMoves (danceMoveType);
            }
        }

        /**
         * Удаление всех блоков, их деактивация:
         */
        public function clear ():void {
            //удаление всех панелей:
            while (blocks.length > 0) {
                var panel:Sprite = blocks [0];
                removeBlock (blocks [0]);
            }
            //деактивация панелей со связками танц. движений:
            for (var i:int = 0; i < battleDanceRoutineBlocks.length; i++) {
                battleDanceRoutineBlocks [i].destroy ();
            }
        }

        override public function destroy ():void {
            battle = null;
            player = null;
            clear ();
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            var mcContentContainer:DisplayObject = mc ['mcContentContainer'];
            mc.removeChild (mcContentContainer);

            _panelsContainer = new Sprite ();
            mc.addChild (_panelsContainer);

            _panelsContainerMask = new Sprite ();
            _panelsContainerMask.graphics.beginFill (0xff0000, 0);
            _panelsContainerMask.graphics.drawRect (0, 0, mcContentContainer.width, mcContentContainer.height);
            _panelsContainerMask.graphics.endFill ();
//            mc.addChild (_panelsContainerMask);

//            _panelsContainer.mask = _panelsContainerMask;

            addEventListener (MouseEvent.MOUSE_WHEEL, mouseWheelListener);
        }

        /**
         * Добавление панели.
         * @param panel Панель для добавления.
         */
        protected function addBlock (panel:Sprite):void {
            _panelsContainer.addChild (panel);
            panel.addEventListener (Event.RESIZE, resizeListener);
            blocks.push (panel);
            positionPanels ();
            moveToEnd ();
        }

        /**
         * Удаление панели.
         * @param panel Панель для удаления.
         */
        protected function removeBlock (panel:Sprite):void {
            var index:int = blocks.indexOf (panel);
            if (index != -1) {
                blocks.splice (index, 1);
                panel.removeEventListener (Event.RESIZE, resizeListener);
                if (_panelsContainer.contains (panel)) {
                    _panelsContainer.removeChild (panel);
                }
                positionPanels ();
                moveToEnd ();
            }
        }

        /**
         * Проверка наличия панели.
         * @param panel Панель для проверки.
         * @return Возвращает <code>true</code>, если панель присутствует в списке панелей.
         */
        protected function containsBlock (panel:Sprite):Boolean {
            return (blocks.indexOf (panel) != -1);
        }

        /**
         * Позиционирование всех панелей относительно друг друга.
         */
        protected function positionPanels ():void {
            var numPanels:int = blocks.length;
            var currentY:int = 0;
            for (var i:int = 0; i < blocks.length; i++) {
                var panel:Sprite = blocks [i];
                panel.y = currentY;
                currentY += panel.height;
            }
        }

        /**
         * Прокрутка списка логов в конец списка.
         */
        protected function moveToEnd ():void {
            var difference:int = Math.ceil (_panelsContainer.height - _panelsContainerMask.height);
            if (difference > 0) {
                var toY:int = - difference;
                TweenLite.to (_panelsContainer, TWEEN_TIME, {y:toY});
            }
            else {
//                TweenLite.killTweensOf (_panelsContainer);
//                _panelsContainer.y = 0;
                TweenLite.to (_panelsContainer, TWEEN_TIME, {y:0});
                _panelsContainer.y = 0;
            }
        }

        protected function moveUp ():void {
            var maxValue:int = Math.max (0, Math.ceil (_panelsContainer.height - _panelsContainerMask.height));
            var toY:int = _panelsContainer.y + STEP;
            toY = NumericalUtilities.correctValue (toY, - maxValue, 0);
            TweenLite.to (_panelsContainer, TWEEN_TIME, {y:toY});
        }

        protected function moveDown ():void {
            var maxValue:int = Math.max (0, Math.ceil (_panelsContainer.height - _panelsContainerMask.height));
            var toY:int = _panelsContainer.y - STEP;
            toY = NumericalUtilities.correctValue (toY, - maxValue, 0);
            TweenLite.to (_panelsContainer, TWEEN_TIME, {y:toY});
        }

        protected function resizeListener (event:Event):void {
            positionPanels ();
            moveToEnd ();
            BreakdanceApp.instance.hideTooltip ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////


        private function selectDanceMove (battleDanceMove:BattleDanceMove):void {
            if (battleDanceMove) {
                for (var i:int = 0; i < battleDanceRoutineBlocks.length; i++) {
                    var block:BattleDanceRoutineBlock = battleDanceRoutineBlocks [i];
                    block.selectItemByBattleDanceMove (battleDanceMove);
                }
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        //Начало боя.
        protected function startBattleListener (event:Event):void {
            clear ();
        }

        //Заверение боя.
        protected function endBattleListener (event:Event):void {
//            deselectAllBlocks ();
        }

        //Обработка добавления новой связки.
        protected function addBattleDanceRoutineListener (event:BattleDanceRoutineEvent):void {
            if (_battle) {
                var playerUid:String = event.uid;
                if (_player) {
                    if (_player.uid == event.uid) {
                        addBattleDanceRoutineBlock (event.battleDanceRoutine, event.round);
                    }
                }
            }
        }

        private function mouseWheelListener (event:MouseEvent):void {
            if (event.delta > 0) {
                moveUp ();
            }
            else {
                moveDown ();
            }
        }

        //Отображение обработки следующего танц. движения.
        private function battleDanceMoveWasProcessedListener (event:ProcessBattleDanceMoveEvent):void {
            deselectAllBlocks ();
            if (_player) {
                var playerUid:String = event.uid;
                if (_player.uid == playerUid) {
                    var danceMove:BattleDanceMove = event.danceMove;
                    if (danceMove) {
                        selectDanceMove (danceMove);
                    }
                }
            }
        }

        private function processFailureListener (event:BattleEvent):void {
            deselectAllBlocks ();
        }
    }
}