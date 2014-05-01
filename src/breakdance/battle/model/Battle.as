/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 13:47
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.model {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalVariables;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.data.BattleData;
    import breakdance.battle.events.BattleDanceRoutineEvent;
    import breakdance.battle.events.BattleEndEvent;
    import breakdance.battle.events.BattleEvent;
    import breakdance.battle.events.ProcessBattleDanceMoveEvent;
    import breakdance.core.staticData.StaticData;
    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.user.UserLevel;
    import breakdance.user.UserLevelCollection;

    import com.hogargames.debug.Tracer;

    import flash.events.EventDispatcher;

    /**
     * Модель для боя.
     */
    public class Battle extends EventDispatcher implements IBattle {

        /**
         * Отправляется при начале боя.
         *
         * @eventType breakdance.battle.events.BattleEvent.START_BATTLE
         */
        [Event(name="start battle", type="breakdance.battle.events.BattleEvent")]

        /**
         * Отправляется при начале боя.
         *
         * @eventType breakdance.battle.events.BattleEvent.START_ADDITIONAL_TURN
         */
        [Event(name="start additional turn", type="breakdance.battle.events.BattleEvent")]

        /**
         * Отправляется при попыте обработки отказе.
         *
         * @eventType breakdance.battle.events.BattleEvent.PROCESS_FAILURE
         */
        [Event(name="process failure", type="breakdance.battle.events.BattleEvent")]

        /**
         * Отправляется при изменении модели для возможноти дальнейшей обработки движений.
         *
         * @eventType breakdance.battle.events.BattleEvent.READY_TO_NEXT_MOVE
         */
        [Event(name="ready to next", type="breakdance.battle.events.BattleEvent")]

        /**
         * Отправляется при добавлении новой связки.
         *
         * @eventType breakdance.battle.events.BattleDanceRoutineEvent.ADD_BATTLE_DANCE_ROUTINE
         */
        [Event(name="add battle dance routine", type="breakdance.battle.events.BattleDanceRoutineEvent")]

        /**
         * Отправляется при начале обрабоки связки.
         *
         * @eventType breakdance.battle.events.BattleDanceRoutineEvent.BEGIN_BATTLE_DANCE_ROUTINE
         */
        [Event(name="begin battle dance routine", type="breakdance.battle.events.BattleDanceRoutineEvent")]

        /**
         * Отправляется при завершении боя.
         *
         * @eventType breakdance.battle.events.BattleEndEvent.END_BATTLE
         */
        [Event(name="end battle", type="breakdance.battle.events.BattleEndEvent")]

        /**
         * Отправляется при обработке танц. движения.
         *
         * @eventType breakdance.battle.events.ProcessBattleDanceMoveEvent.BATTLE_DANCE_MOVE_WAS_PROCESSED
         */
        [Event(name="battle dance move was processed", type="breakdance.battle.events.ProcessBattleDanceMoveEvent")]

        private var _player1:BattlePlayer;
        private var _player2:BattlePlayer;
        private var _bet:int;
        private var _maxDanceMoves:int;
        private var _numRounds:int;
        private var _dailyDanceRoutine:Array/*of Strings*/;

        //Парамеры для определения текущего движения в бою:
        private var _currentRound:int;//Текущий тур;
        private var _currentDanceRoutinesStack:int;//Текущий стек. Стек первого игрока или стек второго игрока.
        private var _currentDanceMove:int;//Текущий обрабатываемый стек. Стек первого игрока или стек второго игрока.

        private var _danceRoutinesStack1:DanceRoutinesStack;//Первый стек связок игрока (не обязательно player1).
        private var _danceRoutinesStack2:DanceRoutinesStack;//Второй стек связок игрока (не обязательно player2).
        private var _additionalDanceRoutinesStack1:AdditionalDanceRoutinesStack;//Первый стек доп. связок игрока (не обязательно player1).
        private var _additionalDanceRoutinesStack2:AdditionalDanceRoutinesStack;//Второй стек доп. связок игрока (не обязательно player2).

        private var isProcessed:Boolean = false;
        private var _userBattleResultInfo:UserBattleResultInfo = null;

        /**
         * Модель для боя.
         * @param battleData Данные о битве.
         * @param dailyDanceRoutine Связка дня.
         */
        public function Battle (battleData:BattleData, dailyDanceRoutine:Array/*of Strings*/ = null):void {//TODO:Перенести связку дня в данные о битве.
            if (!battleData) {
                throw new Error ("Ошибка модели боя! Попытка создать модель с нулевыми данными!");
            }
            if (!battleData.player1) {
                throw new Error ("Ошибка модели боя! Отсутствуют данные первого игрока!");
            }
            if (!battleData.player2) {
                throw new Error ("Ошибка модели боя! Отсутствуют данные второго игрока!");
            }

            _numRounds = battleData.turns;
            _bet = battleData.bet;

            _maxDanceMoves = 1;//На всякий случай, устанавливаем определенное макс. кол-во движений.
            //Определяем макс. кол-во движений для игроков:
            var maxLevel:int = Math.max (battleData.player1.level, battleData.player2.level);
            var userLevel:UserLevel = UserLevelCollection.instance.getUserLevel (maxLevel);
            if (userLevel) {
                _maxDanceMoves = userLevel.maxMoves;
            }
            else {
                trace ("WARNING!!! Не получены данные об уровне " + maxLevel + ".");
            }

            _player1 = new BattlePlayer (battleData.player1);
            _player2 = new BattlePlayer (battleData.player2);

            _dailyDanceRoutine = dailyDanceRoutine;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        //***********************************************
        //МЕТОДЫ ИМПЛЕМЕНТИРОВАННОГО ИНТЕРФЕЙСА
        //(ДЛЯ ПОЛУЧЕНИЯ ДАННЫХ ИЗ VIEW):
        //**********************************************

        /**
         * @inheritDoc
         */
        public function get currentRound ():int {
            return _currentRound;
        }

        /**
         * @inheritDoc
         */
        public function get numRounds ():int {
            return _numRounds;
        }

        /**
         * @inheritDoc
         */
        public function get maxDanceMoves ():int {
            return _maxDanceMoves;
        }

        /**
         * @inheritDoc
         */
        public function get player1 ():BattlePlayer {
            return _player1;
        }

        /**
         * @inheritDoc
         */
        public function get player2 ():BattlePlayer {
            return _player2;
        }

        /**
         * @inheritDoc
         */
        public function get bet ():int {
            return _bet;
        }

        /**
         * @inheritDoc
         */
        public function get currentDanceRoutinesStack ():int {
            return _currentDanceRoutinesStack;
        }

        /**
         * @inheritDoc
         */
        public function get currentDanceMove ():int {
            return _currentDanceMove;
        }

        /**
         * @inheritDoc
         */
        public function get currentRoundIsAdditional ():Boolean {
            return (_currentRound == _numRounds);
        }

        /**
         * @inheritDoc
         */
        public function get danceRoutinesStack1 ():DanceRoutinesStack {
            return _danceRoutinesStack1;
        }

        /**
         * @inheritDoc
         */
        public function get danceRoutinesStack2 ():DanceRoutinesStack {
            return _danceRoutinesStack2;
        }

        /**
         * @inheritDoc
         */
        public function get additionalDanceRoutinesStack1 ():AdditionalDanceRoutinesStack {
            return _additionalDanceRoutinesStack1;
        }

        /**
         * @inheritDoc
         */
        public function get additionalDanceRoutinesStack2 ():AdditionalDanceRoutinesStack {
            return _additionalDanceRoutinesStack2;
        }

        public function get dailyDanceRoutine ():Array/*of Strings*/ {
            return _dailyDanceRoutine;
        }

        /**
         * Результат боя.
         */
        public function get userBattleResultInfo ():UserBattleResultInfo {
            return _userBattleResultInfo;
        }

//***********************************************
        //МЕТОДЫ ДЛЯ КОММАНД ИЗ КОНТРОЛЛЕРА:
        //**********************************************

        /**
         * Подготовка боя:
         */
        public function startBattle ():void {
            resetParams ();
            isProcessed = true;
            _userBattleResultInfo = null;
            dispatchEvent (new BattleEvent (BattleEvent.START_BATTLE));
        }

        /**
         * Сдаться.
         */
        public function surrender ():void {
            if (isProcessed) {
                _userBattleResultInfo = new UserBattleResultInfo ();
                _userBattleResultInfo.battleResult = BattleResultType.SURRENDER;
                var user:BattlePlayer = getBattlePlayer (BreakdanceApp.instance.appUser.uid);
                var opponent:BattlePlayer = getBattleOpponent (BreakdanceApp.instance.appUser.uid);
                if (user && opponent) {
                    _userBattleResultInfo.userPoints = user.points;
                    _userBattleResultInfo.opponentPoints = opponent.points;
                }
                resetParams ();
                isProcessed = false;
                dispatchEvent (new BattleEndEvent (_userBattleResultInfo));
            }
            else {
                Tracer.log ("Модель битвы. Попытка сдаться, когда бой не обрабатывается.");
            }
        }

        /**
         * Победить.
         */
        public function autoWin ():void {
            if (isProcessed) {
                _userBattleResultInfo = new UserBattleResultInfo ();
                _userBattleResultInfo.battleResult = BattleResultType.OPPONENT_SURRENDER;
                var user:BattlePlayer = getBattlePlayer (BreakdanceApp.instance.appUser.uid);
                var opponent:BattlePlayer = getBattleOpponent (BreakdanceApp.instance.appUser.uid);
                if (user && opponent) {
                    _userBattleResultInfo.userPoints = user.points;
                    _userBattleResultInfo.opponentPoints = opponent.points;
                }
                resetParams ();
                isProcessed = false;
                dispatchEvent (new BattleEndEvent (_userBattleResultInfo));
            }
            else {
                Tracer.log ("Модель битвы. Попытка принять поражение противника, когда бой не обрабатывается.");
            }
        }

        /**
         * Добавление в стек новой связки танцевальных движений.
         * @param danceRoutine Связка.
         * @param uid Id игрока, выполняющего связку.
         */
        public function addDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>, uid:String):void {
            if (isProcessed) {
                var danceRoutinesStack:DanceRoutinesStack = getOrCreatePlayerDanceRoutinesStack (uid);
                if (danceRoutinesStack) {
                    var stackDanceRoutine:Vector.<BattleDanceMove>;
                    if (danceRoutinesStack.stack.length < _numRounds) {//Добавляем только связки основного тура (не дополнительного)!
                        //***********************************************
                        //Добавление связки в стек:
                        //***********************************************
                        stackDanceRoutine = danceRoutinesStack.addDanceRoutine (danceRoutine);
                        var round:int = danceRoutinesStack.stack.length;
                        dispatchEvent (new BattleDanceRoutineEvent (stackDanceRoutine, uid, round - 1, BattleDanceRoutineEvent.ADD_BATTLE_DANCE_ROUTINE));

                        //***********************************************
                        //Проверка доступности обработки следующего танц. движения:
                        //***********************************************
                        danceRoutinesStack = (_currentDanceRoutinesStack == 0) ? _danceRoutinesStack1 : _danceRoutinesStack2;
                        if (danceRoutinesStack) {
                            //находим текущую связку танц. движений:
                            var currentDanceRoutine:Vector.<BattleDanceMove> = danceRoutinesStack.getDanceRoutine (_currentRound);
                            if (currentDanceRoutine) {
                                dispatchEvent (new BattleEvent (BattleEvent.READY_TO_NEXT_MOVE));
                            }
                        }
                    }
                }
            }
            else {
                Tracer.log ("Модель битвы. Попытка добавить связку, когда бой не обрабатывается.");
            }
        }

        /**
         * Добавление выносливости в бою (принятие энергетика).
         * @param addingStamina Кол-во добавляемых очков выносливости.
         * @param uid Id игрока, пополняющего выносливость.
         * @param noLessStamina Установка свойства "нет потери выносливости в бою"
         * @param staminaConsumableId Id энергетика, который пополнил выносливость.
         */
        public function addStamina (addingStamina:int, uid:String, noLessStamina:Boolean = false, staminaConsumableId:String = ""):void {
            if (isProcessed) {
                var player:BattlePlayer = getBattlePlayer (uid);
                player.addStamina (addingStamina, noLessStamina, staminaConsumableId);
            }
            else {
                Tracer.log ("Модель битвы. Попытка добавить выносливость, когда бой не обрабатывается.");
            }
        }

        /**
         * Добавление в стек связки танцевальных движений для дополнительного раунда.
         * @param danceRoutine Связка для дополнительного тура.
         * @param uid Id игрока, выполняющего связку.
         */
        public function addAdditionalDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>, uid:String):void {
            if (isProcessed) {
                var additionalDanceRoutinesStack:AdditionalDanceRoutinesStack = getOrCreateAdditionalDanceRoutinesStack (uid);
                if (additionalDanceRoutinesStack) {
                    //***********************************************
                    //Добавление связки в стек:
                    //***********************************************
                    if (additionalDanceRoutinesStack.getAdditionDanceRoutine () == null) {
                        var stackDanceRoutine:Vector.<BattleDanceMove> = additionalDanceRoutinesStack.setAdditionDanceRoutine (danceRoutine);
                        var round:int = _numRounds;
                        dispatchEvent (new BattleDanceRoutineEvent (stackDanceRoutine, uid, round, BattleDanceRoutineEvent.ADD_BATTLE_DANCE_ROUTINE));
                        //***********************************************
                        //Проверка доступности обработки следующего танц. движения:
                        //***********************************************
                        dispatchEvent (new BattleEvent (BattleEvent.READY_TO_NEXT_MOVE));
                    }
                }
            }
            else {
                Tracer.log ("Модель битвы. Попытка добавить связку доп.тура, когда бой не обрабатывается.");
            }
        }

        /**
         * Обработка текущего танц. движения в бою, установка счётчиков на следующее танц. движение.
         */
        public function processNextDanceMove ():void {
            if (isProcessed) {
//                Tracer.log ("Battle [model]:---Обработка танц. движения---");
//                Tracer.log ("Battle [model]: Текущий тур: " + _currentRound + "; текущий стек: " + _currentDanceRoutinesStack + "; текущее танц. движение: " + _currentDanceMove);
//                Tracer.log ("Battle [model]:------");
                //находим текущий стек связок:
                var danceRoutinesStack:DanceRoutinesStack = (_currentDanceRoutinesStack == 0) ? _danceRoutinesStack1 : _danceRoutinesStack2;
                var player:BattlePlayer;
                if (danceRoutinesStack) {
                    //находим текущую связку танц. движений:
                    var danceRoutine:Vector.<BattleDanceMove>;
                    if (currentRoundIsAdditional) {
                        var additionalDanceRoutinesStack:AdditionalDanceRoutinesStack = (_currentDanceRoutinesStack == 0) ? _additionalDanceRoutinesStack1 : _additionalDanceRoutinesStack2;
                        if (additionalDanceRoutinesStack) {
                            danceRoutine = additionalDanceRoutinesStack.getAdditionDanceRoutine ();
                            player = getBattlePlayer (additionalDanceRoutinesStack.uid);
                        }
//                        trace ("Попытка взять связку доп. тура! danceRoutine = " + danceRoutine);
                    }
                    else {
                        danceRoutine = danceRoutinesStack.getDanceRoutine (_currentRound);
                        player = getBattlePlayer (danceRoutinesStack.uid);
//                        trace ("Попытка взять связку " + _currentRound + " тура! danceRoutine = " + danceRoutine);
                    }
                    if (danceRoutine && player) {
                        //***********************************************
                        //РАСЧЁТ ДВИЖЕНИЯ:
                        //***********************************************
                        if (_currentDanceMove == 0) {
                            dispatchEvent (new BattleDanceRoutineEvent (danceRoutine, danceRoutinesStack.uid, _currentRound, BattleDanceRoutineEvent.BEGIN_BATTLE_DANCE_ROUTINE));
                        }
                        //находим текущее танц. движение:
                        var battleDanceMove:BattleDanceMove;
                        if (danceRoutine.length > _currentDanceMove) {
                            battleDanceMove = danceRoutine [_currentDanceMove];
                        }
                        if (battleDanceMove) {
                            //Расчитываем очки текущего танц движения:
                            var asDailyDanceRoutineMove:Boolean = isDailyDanceRoutine (danceRoutine);
                            var completedDanceMoves:Vector.<BattleDanceMove> = getCompletedDanceMovesBeforeNextDanceMove ();
                            calculateDanceMovePoints (battleDanceMove, completedDanceMoves, player, asDailyDanceRoutineMove);
//                            Tracer.log ("Battle [model]: Танц. движение [" + battleDanceMove.type + "] обработано!");
                            dispatchEvent (new ProcessBattleDanceMoveEvent (currentRound, currentDanceRoutinesStack, currentDanceMove, player.uid, battleDanceMove));
                        }
                        else {
                            //Обработка нулевого танц. движения (пустая связка).
//                            Tracer.log ("Battle [model]: Связка пустая!");
                            dispatchEvent (new ProcessBattleDanceMoveEvent (currentRound, currentDanceRoutinesStack, currentDanceMove, player.uid, null));
                        }

                        //***********************************************
                        //ПРИРАЩЕНИЕ СЧЁТЧИКОВ:
                        //***********************************************
                        if (_currentDanceMove >= danceRoutine.length - 1) {//Если все движения в связке отработаны
                            if (_currentDanceRoutinesStack == 0) {
                                _currentDanceRoutinesStack++;//Переключаемся на второй стек связок.
                                _currentDanceMove = 0;//Переключаемся на первое движение второго стека связок.
                            }
                            else {
                                if (_currentRound == _numRounds - 1) {//Если это последний раунд
                                    endMainBattle ();
                                }
                                else if (currentRoundIsAdditional) {//Если это дополнительный раунд
                                    endBattle ();
                                }
                                else {
                                    _currentRound++;//Переключаемся на следующий раунд.
                                    _currentDanceRoutinesStack = 0;//Переключаемся на первый стек связок следующего раунда.
                                    _currentDanceMove = 0;//Переключаемся первое движение первого стека связок следующего раунда.
                                }
                            }
                        }
                        else {
                            _currentDanceMove++;//Переключаемся на следующее движение.
                        }
                    }
                    else {
                        dispatchEvent (new BattleEvent (BattleEvent.PROCESS_FAILURE));
//                        Tracer.log ("Battle [model]: Облом! Сзязка " + _currentRound + " игрока '" + playerDanceRoutinesStack.uid + "' ещё не добавлена в стек связок.");
                    }
                }
                else {
                    dispatchEvent (new BattleEvent (BattleEvent.PROCESS_FAILURE));
//                    Tracer.log ("Battle [model]: Облом! Стек сзязок " + _currentDanceRoutinesStack + " ещё не создан.");
                }
//                Tracer.log ("Battle [model]: ---");
            }
            else {
                Tracer.log ("Модель битвы. Попытка обработать следующуую связку, когда бой не обрабатывается.");
            }
        }

        /**
         * Завершение основного боя (без дополнительного раунда).
         * Подсчёт очков и определение необходимости доп.тура.
         */
        public function endMainBattle ():void {
            if (isProcessed) {
                if (_currentRound != _numRounds) {
                    var needAdditionalTurn:Boolean = (_player1.points == _player2.points);
                    if (needAdditionalTurn) {
                        //***********************************************
                        //Обнуляем оставщиеся в связке движения:
                        //***********************************************
                        var playerDanceRoutinesStack:DanceRoutinesStack = (_currentDanceRoutinesStack == 0) ? _danceRoutinesStack1 : _danceRoutinesStack2;
                        if (playerDanceRoutinesStack) {
                            var danceMovesAfterNextDanceMove:Vector.<BattleDanceMove> = getDanceMovesAfterNextDanceMove ();
                            if (danceMovesAfterNextDanceMove) {
                                for (var i:int = 0; i < danceMovesAfterNextDanceMove.length; i++) {
                                    var battleDanceMove:BattleDanceMove = danceMovesAfterNextDanceMove [i];
                                    battleDanceMove.process (0, battleDanceMove.basicMasteryPoints, 0);
                                }
                            }
                        }
                        //***********************************************
                        //Добавляем дополнительный тур:
                        //***********************************************
                        _currentRound = _numRounds;//Переключаемся на дополнительный раунд.
                        _currentDanceRoutinesStack = 0;//Переключаемся на первый стек связок дополнительного раунда.
                        _currentDanceMove = 0;//Переключаемся первое движение первого стека связок дополнительного раунда.
                        dispatchEvent (new BattleEvent (BattleEvent.START_ADDITIONAL_ROUND));
                    }
                    else {
                        endBattle ();
                    }
                }
                else {
                    endBattle ();
                }
            }
            else {
                Tracer.log ("Модель битвы. Попытка добавить связку, когда бой не обрабатывается.");
            }
        }


/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        /**
         * Расчёт очков, полученных за движение (с учётом оригинальности, связки дня и т.д.)
         * @param battleDanceMove Танц. движение для расчёта очков.
         * @param completedDanceMoves Список завёршённых (расчитанных) предыдущих танц. движений.
         * @param player Игрок, выполняющий связку.
         * @param asDailyDanceRoutineMove Является ли "связкой дня" текущая связка (в которой находится само танц. движение).
         */
        private function calculateDanceMovePoints (battleDanceMove:BattleDanceMove, completedDanceMoves:Vector.<BattleDanceMove>, player:BattlePlayer, asDailyDanceRoutineMove:Boolean = false):void {
            var numCompletedDanceMoves:int = completedDanceMoves.length;
            var basicMasteryPoints:int = battleDanceMove.basicMasteryPoints;

            var positiveBonus:Number = 0;
            var negativeBonus:Number = 0;

//            Tracer.log ("Battle [model]: Расчёт движения (" + battleDanceMove.getDanceMoveType().id + ") ---");
//            Tracer.log ("Battle [model]: Базовые очки: " + basicMasteryPoints + "; положит. бонус: " + positiveBonus + "; отриц. бонус: " + negativeBonus);

            //***********************************************
            //Проверяем уникальность движения:
            //***********************************************
            var numSameDanceMoves:int = 0;
            var danceMoveType:DanceMoveType = battleDanceMove.getDanceMoveType ();
            if (//Если движение оригинальное, или состоит в связке дня, то штрафа за оригинальность нет.
                    (danceMoveType && danceMoveType.subType == DanceMoveSubType.ORIGINAL) ||
                    !asDailyDanceRoutineMove
            ) {
                for (var i:int = 0; i < numCompletedDanceMoves; i++) {
                    var completeDanceMove:BattleDanceMove = completedDanceMoves [i];
                    if (completeDanceMove.type == battleDanceMove.type) {
                        numSameDanceMoves++;
                    }
                }
            }
            var repeatsRate:String = StaticData.instance.getSetting ("repeats_rate");
            var repeatsRateAsArray:Array = repeatsRate.split (",");

            var uniquenessModifier:Number = 1;
            if (numSameDanceMoves > 0) {
                if (repeatsRateAsArray.length > numSameDanceMoves - 1) {
                    uniquenessModifier = parseInt (repeatsRateAsArray [numSameDanceMoves - 1]) / 100;
                }
                else {
                    uniquenessModifier = repeatsRateAsArray [repeatsRateAsArray.length - 1] / 100;
                }
            }

//            Tracer.log ("Battle [model]: Повторы: " + numSameDanceMoves + "; Коэф. уникальности: " + uniquenessModifier);
            //Движения 10 уровня теряют меньше при повторах:
            var repeatsLev10Bonus:Number = parseInt (StaticData.instance.getSetting ("repeats_lev10_bonus"));
            if (battleDanceMove.level == 10) {
                uniquenessModifier = Math.min (1, uniquenessModifier + repeatsLev10Bonus);
//                Tracer.log ("Battle [model]: Движение 10 уроння, коэф. уникальности: " + uniquenessModifier);
            }

            negativeBonus += Math.max (0, basicMasteryPoints * (1 - uniquenessModifier));//Отнимаем очки за повторы движения.
//            Tracer.log ("Battle [model]: Применяем коэф. уникальности. Положит. бонус: " + positiveBonus + "; отриц. бонус: " + negativeBonus);

            //***********************************************
            //Проверяем стабильность движения:
            //***********************************************
            var stabilityModifier:Number = battleDanceMove.stability / 100;
            var currentMasteryPoint:int = basicMasteryPoints - negativeBonus;
            negativeBonus += Math.max (0, currentMasteryPoint * (1 - stabilityModifier));//Отнимаем очки за нестабильно выполненное движение.
//            Tracer.log ("Battle [model]: Применяем коэф. стабильности (" + stabilityModifier + "). Положит. бонус: " + positiveBonus + "; отриц. бонус: " + negativeBonus);


            //***********************************************
            //Проверяем модификаторы от надетой одежды:
            //***********************************************
            positiveBonus += BattleUtils.getItemsBonus (danceMoveType, player);
//            Tracer.log ("Battle [model]: Расчитываем бонусы от вещей. Положит. бонус: " + positiveBonus + "; отриц. бонус: " + negativeBonus);

            //***********************************************
            //Добавляем игроку очки мастерства и отнимаем выносливость:
            //***********************************************

            CONFIG::debug {
                if (GlobalVariables.noMasteryPoints) {
//                    if (!currentRoundIsAdditional) {
                        positiveBonus = 100;
                        negativeBonus = basicMasteryPoints;
//                        Tracer.log ("Battle [model]: Обнуляем расчитанные бонусы (режим тестирования ничьей). Положит. бонус: " + positiveBonus + "; отриц. бонус: " + negativeBonus);
//                    }
                }
            }

            battleDanceMove.process (positiveBonus, negativeBonus, numSameDanceMoves);
            player.points += battleDanceMove.masteryPoints;
            if (!player.noLossStamina) {
                player.stamina -= battleDanceMove.stamina;
            }

            if (danceMoveType && danceMoveType.subType == DanceMoveSubType.ORIGINAL) {
                player.chips -= 1;
            }

//            Tracer.log ("Battle [model]: ---");
        }

        /**
         * Получение вектора всех движений до следующего обрабатываемого (включая его).
         * @return Вектор всех движений до текущего обрабатываемого.
         */
        private function getCompletedDanceMovesBeforeNextDanceMove ():Vector.<BattleDanceMove> {
            var completedDanceMoves:Vector.<BattleDanceMove> = new Vector.<BattleDanceMove> ();
            for (var i:int = 0; i <= _currentRound; i++) {
                var numStacks:int = 1;
                if (i == _currentRound) {
                    numStacks = _currentDanceRoutinesStack;
                }
                for (var j:int = 0; j <= numStacks; j++) {
                    var danceRoutine:Vector.<BattleDanceMove> = null;
                    if (i == _numRounds) {
                        var additionalDanceRoutinesStack:DanceRoutinesStack;
                        if (j == 0) {
                            additionalDanceRoutinesStack = _danceRoutinesStack1;
                        }
                        else {
                            additionalDanceRoutinesStack = _danceRoutinesStack2;
                        }
                        if (additionalDanceRoutinesStack) {
                            danceRoutine = additionalDanceRoutinesStack.getDanceRoutine (i);
                        }
                    }
                    else {
                        var danceRoutinesStack:DanceRoutinesStack;
                        if (j == 0) {
                            danceRoutinesStack = _danceRoutinesStack1;
                        }
                        else {
                            danceRoutinesStack = _danceRoutinesStack2;
                        }
                        if (danceRoutinesStack) {
                            danceRoutine = danceRoutinesStack.getDanceRoutine (i);
                        }
                    }
                    if (danceRoutine) {
                        if (//если это текущая обрабатываеемая связка
                                (i == _currentRound) &&
                                (j == _currentDanceRoutinesStack)
                                ) {
                            for (var k:int = 0; k < _currentDanceMove; k++) {
                                completedDanceMoves.push (danceRoutine [k]);
                            }
                        }
                        else {
                            //добавляем обработанную связку в общий массив обработанных танц. движений:
                            completedDanceMoves = completedDanceMoves.concat (danceRoutine);
                        }
                    }
                }
            }
            return completedDanceMoves;
        }

        /**
         * Получение вектора всех движений после следующего обрабатываемого (не включая его).
         * @return Вектор всех движений после текущего обрабатываемого.
         */
        private function getDanceMovesAfterNextDanceMove ():Vector.<BattleDanceMove> {
            var danceMoves:Vector.<BattleDanceMove> = new Vector.<BattleDanceMove> ();
            for (var i:int = _currentRound; i < _numRounds; i++) {
                var startStack:int = 0;
                if (i == _currentRound) {
                    startStack = _currentDanceRoutinesStack;
                }
                for (var j:int = startStack; j <= 1; j++) {
                    var playerDanceRoutinesStack:DanceRoutinesStack;
                    if (j == 0) {
                        playerDanceRoutinesStack = _danceRoutinesStack1;
                    }
                    else {
                        playerDanceRoutinesStack = _danceRoutinesStack2;
                    }
                    if (playerDanceRoutinesStack) {
                        var danceRoutine:Vector.<BattleDanceMove> = playerDanceRoutinesStack.getDanceRoutine (i);
                        if (danceRoutine) {
                            if (//если это текущая обрабатываеемая связка
                                    (i == _currentRound) &&
                                    (j == _currentDanceRoutinesStack)
                            ) {
                                for (var k:int = _currentDanceMove + 1; k < danceRoutine.length; k++) {
                                    danceMoves.push (danceRoutine [k]);
                                }
                            }
                            else {
                                //добавляем не обработанную связку в общий массив необработанных танц. движений:
                                danceMoves = danceMoves.concat (danceRoutine);
                            }
                        }
                    }
                }
            }
            return danceMoves;
        }

        /**
         * Проверка, являтся ли связка связкой дня или нет.
         * @param danceRoutine Связка для проверки.
         * @return
         */
        private function isDailyDanceRoutine (danceRoutine:Vector.<BattleDanceMove>):Boolean {
            if (!_dailyDanceRoutine) {
                return false;
            }
            else {
                var dailyDanceRoutineAsString:String = _dailyDanceRoutine.toString ();
                var danceRoutineAsArray:Array/*of String*/ = [];
                var numDanceMoves:int = danceRoutine.length;
                for (var i:int = 0; i < numDanceMoves; i++) {
                    danceRoutineAsArray.push (_dailyDanceRoutine [i]);
                }
                var danceRoutineAsString:String = danceRoutineAsArray.toString ();
                return (dailyDanceRoutineAsString == danceRoutineAsString);
            }
        }

        private function endBattle ():void {
            if (isProcessed) {
                _userBattleResultInfo = new UserBattleResultInfo ();
                var user:BattlePlayer = getBattlePlayer (BreakdanceApp.instance.appUser.uid);
                var opponent:BattlePlayer = getBattleOpponent (BreakdanceApp.instance.appUser.uid);
                if (user && opponent) {
                    var userPoints:int = user.points;
                    var opponentPoints:int = opponent.points;
                    _userBattleResultInfo.userPoints = userPoints;
                    _userBattleResultInfo.opponentPoints = opponentPoints;
                    if (userPoints > opponentPoints) {
                        _userBattleResultInfo.battleResult = BattleResultType.WIN;
                    }
                    else if (userPoints == opponentPoints) {
                        _userBattleResultInfo.battleResult = BattleResultType.TIE;
                    }
                    else {
                        _userBattleResultInfo.battleResult = BattleResultType.LOSE;
                    }
                }
                else {
                    _userBattleResultInfo.battleResult = BattleResultType.LOSE;
                }
                resetParams ();
                isProcessed = false;
                dispatchEvent (new BattleEndEvent (_userBattleResultInfo));
            }
        }

        //Установка параметров начала боя:
        private function resetParams ():void {
            //Сброс счётчиков состояния:
            _currentRound = 0;
            _currentDanceRoutinesStack = 0;
            _currentDanceMove = 0;
            _danceRoutinesStack1 = null;
            _danceRoutinesStack2 = null;
            _additionalDanceRoutinesStack1 = null;
            _additionalDanceRoutinesStack2 = null;
            _dailyDanceRoutine = null;
            _player1.reset ();
            _player2.reset ();
        }

        //Получение стека связок по uid'у игрока.
        private function getPlayerDanceRoutinesStack (uid:String):DanceRoutinesStack {
            if (_danceRoutinesStack1 && (_danceRoutinesStack1.uid == uid)) {
                return _danceRoutinesStack1;
            }
            else if (_danceRoutinesStack2 && (_danceRoutinesStack2.uid == uid)) {
                return _danceRoutinesStack2;
            }
            else {
                return null;
            }
        }

        //Получение стека связок по uid'у игрока.
        private function getOrCreatePlayerDanceRoutinesStack (uid:String):DanceRoutinesStack {
            var playerDanceRoutinesStack:DanceRoutinesStack = getPlayerDanceRoutinesStack (uid);
            if (!playerDanceRoutinesStack) {
                if (!_danceRoutinesStack1) {
                    _danceRoutinesStack1 = new DanceRoutinesStack (uid);
                    playerDanceRoutinesStack = _danceRoutinesStack1;
//                    Tracer.log ("Battle [model]: Создаём стек 1 для игрока " + uid + ".");
                }
                else if (!_danceRoutinesStack2) {
                    _danceRoutinesStack2 = new DanceRoutinesStack (uid);
                    playerDanceRoutinesStack = _danceRoutinesStack2;
//                    Tracer.log ("Battle [model]: Создаём стек 2 для игрока " + uid + ".");
                }
                else {
//                    Tracer.log (
//                            "Battle [model]: ERROR! Попытка создать третий стек связок игрока " + uid +
//                            " в битве двух игроков (" + _battlePlayerDanceRoutinesStack1.uid + ", " + _battlePlayerDanceRoutinesStack2.uid + ")."
//                    );
                }
            }
            return playerDanceRoutinesStack;
        }

        //Получение стека связок для доп. раунда по uid'у игрока.
        private function getAdditionalDanceRoutinesStack (uid:String):AdditionalDanceRoutinesStack {
            if (_additionalDanceRoutinesStack1 && (_additionalDanceRoutinesStack1.uid == uid)) {
                return _additionalDanceRoutinesStack1;
            }
            else if (_additionalDanceRoutinesStack2 && (_additionalDanceRoutinesStack2.uid == uid)) {
                return _additionalDanceRoutinesStack2;
            }
            else {
                return null;
            }
        }

        //Получение стека связок для доп. раунда по uid'у игрока.
        private function getOrCreateAdditionalDanceRoutinesStack (uid:String):AdditionalDanceRoutinesStack {
            var additionalDanceRoutinesStack:AdditionalDanceRoutinesStack = getAdditionalDanceRoutinesStack (uid);
            if (!additionalDanceRoutinesStack) {
                if (!_additionalDanceRoutinesStack1) {
                    _additionalDanceRoutinesStack1 = new AdditionalDanceRoutinesStack (uid);
                    additionalDanceRoutinesStack = _additionalDanceRoutinesStack1;
//                    Tracer.log ("Battle [model]: Создаём стек 1 для игрока для доп. раунда " + uid + ".");
                }
                else if (!_additionalDanceRoutinesStack2) {
                    _additionalDanceRoutinesStack2 = new AdditionalDanceRoutinesStack (uid);
                    additionalDanceRoutinesStack = _additionalDanceRoutinesStack2;
//                    Tracer.log ("Battle [model]: Создаём стек 2 для игрока для доп. раунда " + uid + ".");
                }
                else {
//                    Tracer.log (
//                            "Battle [model]: ERROR! Попытка создать третий стек связок игрока для доп. раунда " + uid +
//                            " в битве двух игроков (" + _battlePlayerDanceRoutinesStack1.uid + ", " + _battlePlayerDanceRoutinesStack2.uid + ")."
//                    );
                }
            }
            return additionalDanceRoutinesStack;
        }

        //Получение игрока по uid'у игрока.
        private function getBattlePlayer (uid:String):BattlePlayer {
            if (_player1.uid == uid) {
                return _player1;
            }
            else if (_player2.uid == uid) {
                return _player2;
            }
            else {
                return null;
            }
        }

        //Получение оппонента по uid'у игрока.
        private function getBattleOpponent (uid:String):BattlePlayer {
            if (_player1.uid == uid) {
                return _player2;
            }
            else if (_player2.uid == uid) {
                return _player1;
            }
            else {
                return null;
            }
        }

    }
}
