/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 25.09.13
 * Time: 14:44
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.selectDanceRoutineBlock {

    import breakdance.BreakdanceApp;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.data.BattleDataUtils;
    import breakdance.battle.model.BattleUtils;
    import breakdance.battle.model.IBattle;
    import breakdance.battle.model.IBattlePlayer;
    import breakdance.battle.view.logPanel.RoundLogItem;
    import breakdance.battle.view.logPanel.danceRoutineBlock.DanceRoutineBlock;
    import breakdance.battle.view.logPanel.selectDanceRoutineBlock.events.SelectDanceRoutineEvent;
    import breakdance.battle.view.logPanel.selectDanceRoutineBlock.selectDanceMoveBlock.SelectDanceMoveBlock;
    import breakdance.battle.view.logPanel.selectDanceRoutineBlock.selectDanceMoveBlock.events.SelectDanceMoveEvent;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.PopUpManager;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    /**
     * Блок для выбора связки танц. движений пользователем.
     */
    public class SelectDanceRoutineBlock extends Sprite implements ITextContainer {

        /**
         * Отправляется при нажатии пользователем кнопки "go!".
         *
         * @eventType breakdance.battle.view.logPanel.selectDanceRoutinePanel.events.SelectDanceRoutinePanelEvent.GO
         */
        [Event(name="go", type="breakdance.battle.view.logPanel.selectDanceRoutineBlock.events.SelectDanceRoutineEvent")]

        /**
         * Отправляется при завершении связки.
         *
         * @eventType breakdance.battle.view.logPanel.selectDanceRoutinePanel.events.SelectDanceRoutinePanelEvent.COMPLETE_DANCE_ROUTINE
         */
        [Event(name="complete dance routine", type="breakdance.battle.view.logPanel.selectDanceRoutineBlock.events.SelectDanceRoutineEvent")]

        private var textsManager:TextsManager = TextsManager.instance;

        protected var _battle:IBattle;//Ссылка на модель боя.
        protected var _player:IBattlePlayer;//Ссылка на модель игрока в бою.

        //визуальные элементы:
        private var roundLogItem:RoundLogItem;//Лог, с описанием раунда.
        private var danceRoutinePanel:DanceRoutineBlock;//Панель уже выбранных танц. движений.
        private var selectDanceMovePanel:SelectDanceMoveBlock;//Панель для выбора очередного танц. движения в связку.
        private var btnSelectOriginalDanceMove:SelectOriginalDanceMoveButton;//Кнопка добавления оригинального танц. движения.
        private var btnGo:ButtonWithText;//Кнопка для начала боя (применяется в первом раунде или в дополнительном раунде).
        private var arrow:MovieClip;

        //Данные:
        private var availableDanceMoves:Vector.<BattleDanceMoveData>;//Список доступных для выбора танц. движений;
        private var maxDanceMoves:int;//Максимальное число танц. движений в связке.
        private var availableStamina:int;//Выносливость игрока.
        private var _danceRoutine:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();//Связка выбранных танц. движений.

        private var _showButtonGo:Boolean = true;//Отображение кноки "go". Кнопка отображается только во время первого и дополнительного тура.

        private static const ARROW_NORMAL_FRAME:int = 1;
        private static const ARROW_ORIGINAL_FRAME:int = 2;
        private static const ITEM_HEIGHT:int = 19;

        public function SelectDanceRoutineBlock () {
            roundLogItem = new RoundLogItem ();
            addChild (roundLogItem);

            btnGo = new ButtonWithText (Template.createSymbol (Template.BTN_GO));
            btnGo.addEventListener (MouseEvent.CLICK, clickListener_btnGo);

            btnSelectOriginalDanceMove = new SelectOriginalDanceMoveButton ();
            btnSelectOriginalDanceMove.addEventListener (MouseEvent.CLICK, clickListener_btnSelectOriginal);

            arrow = Template.createSymbol (Template.LOG_ARROW);

            selectDanceMovePanel = new SelectDanceMoveBlock ();
            selectDanceMovePanel.addEventListener (SelectDanceMoveEvent.SELECT_DANCE_MOVE, selectDanceMoveEvent);
            selectDanceMovePanel.addEventListener (Event.RESIZE, resizeListener);
            addChild (selectDanceMovePanel);

            danceRoutinePanel = new DanceRoutineBlock ();
            danceRoutinePanel.addEventListener (Event.RESIZE, resizeListener);
            addChild (danceRoutinePanel);

            clear ();

            textsManager.addTextContainer (this);
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
            _battle = value;
            clear ();
        }

        /**
         * Ссылка на модель игрока в бою.
         */
        public function get player ():IBattlePlayer {
            return _player;
        }

        public function set player (value:IBattlePlayer):void {
            _player = value;
            selectDanceMovePanel.player = _player;
            danceRoutinePanel.player = player;
        }

        /**
         * Инициализация данными для выбора связки.
         */
        public function init ():void {
            clear ();
            var round:int;
            if (_battle.currentRoundIsAdditional) {//если текущий раунд дополнительный
                round = _battle.currentRound;
            }
            else {
                round = BattleUtils.getDanceRoutinesCount (_battle, _player.uid);
            }
            this.availableDanceMoves = _player.availableMoves;
            maxDanceMoves = Math.max (maxDanceMoves, 1);
            this.maxDanceMoves = _battle.maxDanceMoves;
            this.availableStamina = _player.stamina;
            roundLogItem.round = round;

            var currentRoundIsAdditional:Boolean = false;
            if (_battle) {
                currentRoundIsAdditional = _battle.currentRoundIsAdditional;
            }
            roundLogItem.additionalRound = currentRoundIsAdditional;
            showButtonGo = ((round == 0) || currentRoundIsAdditional);

            nextMoveChoice ();
        }

        /**
         * Раунд, для которого собирается связка.
         */
        public function get round ():int {
            return roundLogItem.round;
        }

        /**
         * Сброс выбора танц. движений.
         */
        public function clear ():void {
            _danceRoutine = new Vector.<BattleDanceMoveData> ();//Очищаем список выбранных танц. движений.
            danceRoutinePanel.clear ();
            selectDanceMovePanel.clear ();
            roundLogItem.additionalRound = false;
            roundLogItem.round = -1;
            removeArrow ();
            if (contains (btnSelectOriginalDanceMove)) {
                removeChild (btnSelectOriginalDanceMove);
            }
            //Скрываем кнопку "go". Т.е. игрок не сможет начать бой с пустой связкой.
            if (contains (btnGo)) {
                removeChild (btnGo);
            }
        }

        /**
         * Связка выбранных танц. движений.
         */
        public function get danceRoutine ():Vector.<BattleDanceMoveData> {
            return _danceRoutine;
        }

        /**
         * Режим отображения кноки "go". Кнопка отображается только во время первого и дополнительного тура.
         */
        public function get showButtonGo ():Boolean {
            return _showButtonGo;
        }

        public function set showButtonGo (value:Boolean):void {
            _showButtonGo = value;
            if (_showButtonGo) {
                if (_danceRoutine.length > 0) {
                    addChild (btnGo);//Отображаем кнопку "go", если игрок выбрал хотя бы одно танц. движение.
                    position ();
                }
            }
            else {
                if (contains (btnGo)) {
                    removeChild (btnGo);
                }
            }
        }

        public function setTexts ():void {
            btnGo.text = textsManager.getText ("go");
        }

        public function destroy ():void {
            clear ();

            //Убираем слушатели:
            btnGo.removeEventListener (MouseEvent.CLICK, clickListener_btnGo);
            btnSelectOriginalDanceMove.removeEventListener (MouseEvent.CLICK, clickListener_btnSelectOriginal);
            selectDanceMovePanel.removeEventListener (SelectDanceMoveEvent.SELECT_DANCE_MOVE, selectDanceMoveEvent);
            selectDanceMovePanel.removeEventListener (Event.RESIZE, resizeListener);
            danceRoutinePanel.removeEventListener (Event.RESIZE, resizeListener);

            //Деактиваируем панели и кнопки:
            btnGo.destroy ();
            btnSelectOriginalDanceMove.destroy ();
            roundLogItem.destroy ();
            selectDanceMovePanel.destroy ();
            danceRoutinePanel.destroy ();

            textsManager.removeTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        /**
         * Подготовка панели для выбора очередного танц. движения.
         */
        private function nextMoveChoice ():void {
            selectDanceMovePanel.clear ();
            if (availableDanceMoves && maxDanceMoves) {
                var totalUsingStamina:int = getTotalUsingStamina ();
                var totalAvailableStamina:int = availableStamina - totalUsingStamina;
                var availableDanceMovesForSelect:Vector.<BattleDanceMoveData>;
                //Выбор стартового танц. движения:
                if (_danceRoutine.length == 0) {
                    availableDanceMovesForSelect = BattleDataUtils.getDanceMovesOfSubType (availableDanceMoves, DanceMoveSubType.START);
//                    availableDanceMovesForSelect = BattleDataUtils.getDanceMovesByAvailableStamina (availableDanceMovesForSelect, totalAvailableStamina);
                    if (availableDanceMovesForSelect.length > 0) {
                        removeArrow ();
                        selectDanceMovePanel.init (availableDanceMovesForSelect);
                    }
                    else {
                        completeDanceRoutine ();//Завершение связки.
                    }
                }
                //Выбор танц. движения для продолжения связки:
                else if (_danceRoutine.length < maxDanceMoves) {
//                    availableDanceMovesForSelect = BattleDataUtils.getDanceMovesByAvailableStamina (availableDanceMoves, totalAvailableStamina);
                    availableDanceMovesForSelect = availableDanceMoves.concat ();
                    var previousBattleDanceMove:BattleDanceMoveData = _danceRoutine [_danceRoutine.length - 1];
                    availableDanceMovesForSelect = BattleDataUtils.getDanceMovesForPrevMove (availableDanceMovesForSelect, previousBattleDanceMove);
                    if (availableDanceMovesForSelect.length > 0) {
                        addArrow ();
                        arrow.gotoAndStop (ARROW_NORMAL_FRAME);
                        selectDanceMovePanel.init (availableDanceMovesForSelect);
                    }
                    else {
                        originalMoveChoice (totalAvailableStamina);//Выбор оригинального танц. движения
                    }
                }
                //Выбор оригинального танц. движения:
                else if (_danceRoutine.length == maxDanceMoves) {
                    originalMoveChoice (totalAvailableStamina);//Выбор оригинального танц. движения
                }
                //Завершение связки:
                else {
                    completeDanceRoutine ();
                }
            }
            position ();
        }

        /**
         * Завершение составления связки.
         */
        private function completeDanceRoutine ():void {
            selectDanceMovePanel.clear ();
            removeArrow ();
            if (contains (btnSelectOriginalDanceMove)) {
                removeChild (btnSelectOriginalDanceMove);
            }
            dispatchEvent (new SelectDanceRoutineEvent (SelectDanceRoutineEvent.UPDATE_DANCE_ROUTINE));
            dispatchEvent (new SelectDanceRoutineEvent (SelectDanceRoutineEvent.COMPLETE_DANCE_ROUTINE));
        }

        /**
         * Подготовка панели для выбора оригинального танц. движения.
         */
        private function originalMoveChoice (totalAvailableStamina:int):void {
            //Проверяем, не вляется ли последнее движение в связке оригинальным:
            if (_danceRoutine.length > 1) {
                var lastMove:BattleDanceMoveData = _danceRoutine [_danceRoutine.length - 1];
                var danceMoveType:DanceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (lastMove.type);
                if (danceMoveType && danceMoveType.subType == DanceMoveSubType.ORIGINAL) {
                    completeDanceRoutine ();
                    return;
                }
            }
            //Отображаем кнопку выбора спец. движения:
            if (player.chips > 0) {
                var originalAvailableDanceMoves:Vector.<BattleDanceMoveData> = BattleDataUtils.getDanceMovesOfSubType (availableDanceMoves, DanceMoveSubType.ORIGINAL);
//                originalAvailableDanceMoves = BattleDataUtils.getDanceMovesByAvailableStamina (originalAvailableDanceMoves, totalAvailableStamina);
                if (originalAvailableDanceMoves.length > 0) {
                    if (_battle) {
                        if (!BattleUtils.getPlayerWasUsingOriginalMove (_battle, _player.uid)) {
                            addArrow ();
                            arrow.gotoAndStop (ARROW_ORIGINAL_FRAME);
                            addChild (btnSelectOriginalDanceMove);
                            return;
                        }
                    }
                }
            }
            completeDanceRoutine ();
        }

        /**
         * Получение общей выносливости всех танц. движений в собранной игроком связке.
         * @return Общая выносливость всех танц. движений в собранной игроком связке.
         */
        private function getTotalUsingStamina ():int {
            var totalUsingStamina:int = 0;
            for (var i:int = 0; i < _danceRoutine.length; i++) {
                var battleDanceMoveData:BattleDanceMoveData = _danceRoutine [i];
                var danceMoveType:DanceMoveType = battleDanceMoveData.getDanceMoveType ();
                if (danceMoveType) {
                    totalUsingStamina += danceMoveType.stamina;
                }
            }
            return totalUsingStamina;
        }

        /**
         * Добавление нового танц. движения в связку.
         */
        private function addBattleDanceMoveData (battleDanceMoveData:BattleDanceMoveData):void {
            if (battleDanceMoveData) {
                var totalStamina:int = 0;
                for (var i:int = 0; i < _danceRoutine.length; i++) {
                    totalStamina += _danceRoutine [i].stamina;
                }
                if (battleDanceMoveData.stamina + totalStamina <= _player.stamina) {
                    _danceRoutine.push (battleDanceMoveData);
                    dispatchEvent (new SelectDanceRoutineEvent (SelectDanceRoutineEvent.UPDATE_DANCE_ROUTINE));
                    danceRoutinePanel.init (_danceRoutine);//Обновляем данные в панеле уже выбранных танц. движений.
                    if (_showButtonGo) {
                        addChild (btnGo);//Отображаем кнопку "go", т.к. игрок добавил в связку хотя бы одно танц. движение.
                    }
                    position ();
                }
                else {
                    PopUpManager.instance.restoreStaminaPopUp.show ();
                    dispatchEvent (new SelectDanceRoutineEvent (SelectDanceRoutineEvent.SHOW_RESTORE_STAMINA_POP_UP));
                }
            }

        }

        /**
         * Позиционирование всех элементов в панели относительно друг друга.
         */
        private function position ():void {
            var nextPositionY:Number = ITEM_HEIGHT;
            danceRoutinePanel.y = nextPositionY;
            nextPositionY += danceRoutinePanel.height;
            if (contains (arrow)) {
                arrow.y = nextPositionY;
                nextPositionY += arrow.height;
            }
            selectDanceMovePanel.y = nextPositionY;
            nextPositionY += selectDanceMovePanel.height;
            if (contains (btnSelectOriginalDanceMove)) {
                btnSelectOriginalDanceMove.y = nextPositionY;
                nextPositionY += btnSelectOriginalDanceMove.height;
            }
            if (contains (btnGo)) {
                btnGo.y = nextPositionY;
            }
            dispatchEvent (new Event (Event.RESIZE));
        }

        private function addArrow ():void {
            addChild (arrow);
        }

        private function removeArrow ():void {
            if (contains (arrow)) {
                removeChild (arrow);
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener_btnGo (event:Event):void {
            completeDanceRoutine ();
            if (contains (btnGo)) {
                removeChild (btnGo);
            }
            dispatchEvent (new SelectDanceRoutineEvent (SelectDanceRoutineEvent.GO));
        }

        private function clickListener_btnSelectOriginal (event:Event):void {
            if (availableDanceMoves) {
                var originalAvailableDanceMoves:Vector.<BattleDanceMoveData> = BattleDataUtils.getDanceMovesOfSubType (availableDanceMoves, DanceMoveSubType.ORIGINAL);
                var totalUsingStamina:int = getTotalUsingStamina ();
                var totalAvailableStamina:int = availableStamina - totalUsingStamina;
//                originalAvailableDanceMoves = BattleDataUtils.getDanceMovesByAvailableStamina (originalAvailableDanceMoves, totalAvailableStamina);
                if (originalAvailableDanceMoves.length > 0) {
                    addBattleDanceMoveData (originalAvailableDanceMoves [Math.round (Math.random () * (originalAvailableDanceMoves.length - 1))]);
                }
            }
            nextMoveChoice ();
        }

        private function selectDanceMoveEvent (event:SelectDanceMoveEvent):void {
            var tutorialManager:TutorialManager = TutorialManager.instance;
            if (tutorialManager.currentStep == TutorialStep.BATTLE_START) {
                tutorialManager.completeStep (TutorialStep.BATTLE_START);
            }
            var battleDanceMoveData:BattleDanceMoveData = event.battleDanceMoveData;
            addBattleDanceMoveData (battleDanceMoveData);
            nextMoveChoice ();
        }

        private function resizeListener (event:Event):void {
            position ();
        }
    }
}
