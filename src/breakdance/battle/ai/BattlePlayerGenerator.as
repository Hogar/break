/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.10.13
 * Time: 9:22
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.ai {

    import breakdance.BreakdanceApp;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.data.BattlePlayerData;
    import breakdance.battle.data.PlayerItemData;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.danceMoves.DanceMoveLevel;
    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;
    import breakdance.data.danceMoves.DanceMoveTypeConditionType;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.user.UserDanceMove;
    import breakdance.user.UserLevel;
    import breakdance.user.UserLevelCollection;

    public class BattlePlayerGenerator {

        private static const CREATE_NEW_START_DANCE_MOVE:String = "create new dance moves";
        private static const CREATE_NEW_TRANSITION_DANCE_MOVE:String = "create new transition dance moves";
        private static const UPGRADE_DANCE_MOVE:String = "upgrade dance moves";
        private static const CREATE_NEW_ORIGINAL_DANCE_MOVE:String = "create new original dance moves";
        private static const UPGRADE_ORIGINAL_DANCE_MOVE:String = "upgrade original dance moves";

        private static const FIRST_PLAYER_DANCE_MOVE_1:String = "indian_step";
        private static const FIRST_PLAYER_DANCE_MOVE_2:String = "ken_swift";
        private static const FIRST_PLAYER_DANCE_MOVE_3:String = "salsa_rock_front";
        private static const FIRST_PLAYER_DANCE_MOVE_4:String = "six_step";

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Создание фейкового противника для игрока.
         * @return Фейковый противник для игрока.
         */
        public static function createBattleOpponentForFirstBattle ():BattlePlayerData {
            var fakeBattlePlayerData:BattlePlayerData = new BattlePlayerData ();
            fakeBattlePlayerData.uid = String (Math.ceil (Math.random () * 99999));
            var textsManager:TextsManager = TextsManager.instance;
            fakeBattlePlayerData.name = textsManager.getText ("fistBattlePlayerName");
            fakeBattlePlayerData.nickname = textsManager.getText ("fistBattlePlayerName");
            fakeBattlePlayerData.level = 1;
            fakeBattlePlayerData.faceId = 1;
            fakeBattlePlayerData.hairId = 1;

            fakeBattlePlayerData.maxStamina = 10;
            fakeBattlePlayerData.stamina = 10;
            fakeBattlePlayerData.chips = 0;

            var availableMoves:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
            var battleDanceMoveData:BattleDanceMoveData = new BattleDanceMoveData ();
            battleDanceMoveData.type = FIRST_PLAYER_DANCE_MOVE_1;
            battleDanceMoveData.level = 1;
            availableMoves.push (battleDanceMoveData);
            battleDanceMoveData = new BattleDanceMoveData ();
            battleDanceMoveData.type = FIRST_PLAYER_DANCE_MOVE_2;
            battleDanceMoveData.level = 1;
            availableMoves.push (battleDanceMoveData);
            battleDanceMoveData = new BattleDanceMoveData ();
            battleDanceMoveData.type = FIRST_PLAYER_DANCE_MOVE_3;
            battleDanceMoveData.level = 1;
            availableMoves.push (battleDanceMoveData);
            battleDanceMoveData = new BattleDanceMoveData ();
            battleDanceMoveData.type = FIRST_PLAYER_DANCE_MOVE_4;
            battleDanceMoveData.level = 1;
            availableMoves.push (battleDanceMoveData);
            fakeBattlePlayerData.availableMoves = availableMoves;
            return fakeBattlePlayerData;
        }

        /**
         * Создание фейкового противника для игрока.
         * @return Фейковый противник для игрока.
         */
        public static function createFakeBattleOpponentForAppUser ():BattlePlayerData {
            var playerLevel:int = BreakdanceApp.instance.appUser.level;

            //Вычисляем общую затраченную энергию:
            var i:int;
            var energySpent:int = 0;
            var originalEnergySpent:int = 0;
            var availableMoves:Vector.<UserDanceMove> = BreakdanceApp.instance.appUser.getAvailableMoves ();
            for (i = 0; i < availableMoves.length; i++) {
                var userDanceMove:UserDanceMove = availableMoves [i];
                if (userDanceMove) {
                    var danceMoveType:DanceMoveType = userDanceMove.type;
                    if (danceMoveType) {
                        var danceMoveLevel:DanceMoveLevel = danceMoveType.getLevel (userDanceMove.level);
                        if (danceMoveLevel) {
                            if (danceMoveType.subType == DanceMoveSubType.ORIGINAL) {
                                originalEnergySpent += danceMoveLevel.energyRequired;
                                originalEnergySpent += userDanceMove.energySpent;
                            }
                            else {
                                energySpent += danceMoveLevel.energyRequired;
                                energySpent += userDanceMove.energySpent;
                            }
                        }
                    }
                }
            }

            return createFakeBattlePlayer (playerLevel, energySpent, originalEnergySpent);
        }

        /**
         * Создание фекового игрока заданного уровня.
         * @param level Заданный уровень.
         * @param availableEnergy Общее кол-во энергии для изучения обычных танц. движений.
         * @param availableOriginalEnergy Общее кол-во энергии для изучения оригинальных танц. движений.
         * @return Фейковый игрок.
         */
        public static function createFakeBattlePlayer (level:int, availableEnergy:int, availableOriginalEnergy:int):BattlePlayerData {
            var fakeBattlePlayerData:BattlePlayerData = new BattlePlayerData ();
            fakeBattlePlayerData.uid = String (Math.ceil (Math.random () * 99999));
            fakeBattlePlayerData.name = "Test " + Math.ceil (Math.random () * 100);
            fakeBattlePlayerData.level = level;
            fakeBattlePlayerData.faceId = Math.ceil (Math.random () * 5.99 + 0.01);
            fakeBattlePlayerData.hairId = Math.ceil (Math.random () * 5.99 + 0.01);

            var userLevel:UserLevel = UserLevelCollection.instance.getUserLevel (level);
            fakeBattlePlayerData.maxStamina = userLevel.maxStamina;
//            fakeBattlePlayerData.stamina = Math.floor (fakeBattlePlayerData.maxStamina / 2) + Math.round (Math.random () * (fakeBattlePlayerData.maxStamina / 2));
            fakeBattlePlayerData.stamina = userLevel.maxStamina;
            fakeBattlePlayerData.chips = Math.random () < .5 ? 1 : 0;//TODO:Наличие фишки можно вынести в настройки сложности ИИ в будущем.

            fakeBattlePlayerData.head = createFakeShopItemId (ShopItemCategory.HEAD);
            fakeBattlePlayerData.hands = createFakeShopItemId (ShopItemCategory.HANDS);
            fakeBattlePlayerData.body = createFakeShopItemId (ShopItemCategory.BODY);
            fakeBattlePlayerData.legs = createFakeShopItemId (ShopItemCategory.LEGS);
            fakeBattlePlayerData.shoes = createFakeShopItemId (ShopItemCategory.SHOES);
            fakeBattlePlayerData.other = createFakeShopItemId (ShopItemCategory.OTHER);

            fakeBattlePlayerData.availableMoves = createFakeAvailableMoves (availableEnergy, availableOriginalEnergy);
            return fakeBattlePlayerData;
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        /**
         * Создание рандомной связки движений.
         * @param availableEnergy Общее кол-во энергии для изучения обычных танц. движений.
         * @param availableOriginalEnergy Общее кол-во энергии для изучения оригинальных танц. движений.
         * @return Рандомная связка движений.
         */
        private static function createFakeAvailableMoves (availableEnergy:int, availableOriginalEnergy:int):Vector.<BattleDanceMoveData> {
            var availableMoves:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
//            trace ("---ГЕНЕРИРУЕМ ИГРОКА (энергия: " + availableEnergy + ", энергия на ориг.: " + availableOriginalEnergy + ")");

            var index:int;
            var beforeCommandAvailableEnergy:int;
            var randomCommand:String;

            var numGenerationSteps:int = 0;//Кол-во шагов генерации (для отладки).
            //ГЕНЕРАЦИЯ ОБЫЧНЫХ ДВИЖЕНИЙ:
            var availableCommands:Vector.<String> = new Vector.<String> ();//Общий список доступных команд для шагов генерации.
            availableCommands.push (CREATE_NEW_START_DANCE_MOVE);
            availableCommands.push (CREATE_NEW_TRANSITION_DANCE_MOVE);
            availableCommands.push (UPGRADE_DANCE_MOVE);
            var currentAvailableCommands:Vector.<String> = availableCommands.concat ();//Конкретный список доступных команд для шагов генерации (может модифицироватся на каждом шаге).
            if (availableMoves.length == 0) {
                numGenerationSteps++;
//                trace ("---" + numGenerationSteps + ". Создаём первое стартовое движение:");
                availableEnergy = createNewFakeDanceMoveWithSubType (DanceMoveSubType.START, availableMoves, availableEnergy);
//                traceAvailableMovesAndEnergy (availableMoves, availableEnergy);
            }
            while (availableEnergy > 0) {
                numGenerationSteps++;
                if (currentAvailableCommands.length == 0) {
//                    trace ("---Нет доступных комманд, закончили цикл генерации обычных движений.");
                    break;
                }
                else {
                    beforeCommandAvailableEnergy = availableEnergy;
                    randomCommand = currentAvailableCommands [Math.round (Math.random () * (currentAvailableCommands.length - 1))];
//                    trace ('---' + numGenerationSteps + '. Выполняем команду "' + randomCommand + '".');
                    switch (randomCommand) {
                        case (UPGRADE_DANCE_MOVE):
                            availableEnergy = upgradeRandomFakeDanceMove (availableMoves, availableEnergy);
                            break;
                        case (CREATE_NEW_START_DANCE_MOVE):
                            availableEnergy = createNewFakeDanceMoveWithSubType (DanceMoveSubType.START, availableMoves, availableEnergy);
                            break;
                        case (CREATE_NEW_TRANSITION_DANCE_MOVE):
                            availableEnergy = createNewTransitionFakeDanceMove (availableMoves, availableEnergy);
                            break;
                    }
                    if (availableEnergy == beforeCommandAvailableEnergy) {
//                        trace ('---' + numGenerationSteps + '. Команду "' + randomCommand + '" невозможно выполнить.');
                        index = currentAvailableCommands.indexOf (randomCommand);
                        currentAvailableCommands.splice (index, 1);
                    }
                    else {
//                        trace ('---' + numGenerationSteps + '. Выполнили команду "' + randomCommand + '".');
//                        traceAvailableMovesAndEnergy (availableMoves, availableEnergy);
                        currentAvailableCommands = availableCommands.concat ();
                    }
                }
            }

            //ГЕНЕРАЦИЯ ОРИГИНАЛЬНЫХ ДВИЖЕНИЙ:
            if (availableOriginalEnergy > 0) {
                numGenerationSteps++;
//                trace ("---" + numGenerationSteps + ". Создаём первое оригинальное движение:");
                availableOriginalEnergy = createNewFakeDanceMoveWithSubType (DanceMoveSubType.ORIGINAL, availableMoves, availableOriginalEnergy);
//                traceAvailableMovesAndEnergy (availableMoves, availableOriginalEnergy);
            }
            availableCommands = new Vector.<String> ();//Общий список доступных команд для шагов генерации.
            availableCommands.push (CREATE_NEW_ORIGINAL_DANCE_MOVE);
            availableCommands.push (UPGRADE_ORIGINAL_DANCE_MOVE);
            currentAvailableCommands = availableCommands.concat ();//Конкретный список доступных команд для шагов генерации (может модифицироватся на каждом шаге).
            while (availableOriginalEnergy > 0) {
                numGenerationSteps++;
                if (currentAvailableCommands.length == 0) {
//                    trace ("---Нет доступных комманд, закончили цикл генерации оригинальных движений.");
                    break;
                }
                else {
                    beforeCommandAvailableEnergy = availableOriginalEnergy;
                    randomCommand = currentAvailableCommands [Math.round (Math.random () * (currentAvailableCommands.length - 1))];
//                    trace ('---' + numGenerationSteps + '. Выполняем команду "' + randomCommand + '".');
                    switch (randomCommand) {
                    case (CREATE_NEW_ORIGINAL_DANCE_MOVE):
                        availableOriginalEnergy = createNewFakeDanceMoveWithSubType (DanceMoveSubType.ORIGINAL, availableMoves, availableOriginalEnergy);
                        break;
                    case (UPGRADE_ORIGINAL_DANCE_MOVE):
                        availableOriginalEnergy = upgradeRandomFakeOriginalDanceMove (availableMoves, availableOriginalEnergy);
                        break;
                    }
                    if (availableOriginalEnergy == beforeCommandAvailableEnergy) {
//                        trace ('---' + numGenerationSteps + '. Команду "' + randomCommand + '" невозможно выполнить.');
                        index = currentAvailableCommands.indexOf (randomCommand);
                        currentAvailableCommands.splice (index, 1);
                    }
                    else {
//                        traceAvailableMovesAndEnergy (availableMoves, availableOriginalEnergy);
//                        trace ('---' + numGenerationSteps + '. Выполнили команду "' + randomCommand + '".');
                        currentAvailableCommands = availableCommands.concat ();
                    }
                }
            }
//            trace ("---|---");
            return availableMoves;
        }

        private static function traceAvailableMovesAndEnergy (availableMoves:Vector.<BattleDanceMoveData>, availableEnergy:int):void {
            var str:String = "---|---availableMoves = [";
            for (var i:int = 0; i < availableMoves.length; i++) {
                var battleDanceMoveData:BattleDanceMoveData = availableMoves [i];
                str += "[" + battleDanceMoveData.type + ":" + battleDanceMoveData.level + "]";
                if (i != availableMoves.length - 1) {
                    str += ", "
                }
            }
            str += "] availableEnergy = " + availableEnergy;
            trace (str);
        }

        private static function createFakeShopItemId (category:String):PlayerItemData {
            var battlePlayerItemData:PlayerItemData = new PlayerItemData ();
            if (Math.random () > .5) {
                var randomShopItem:ShopItem = ShopItemCollection.instance.getRandomShopItemOfCategory (category);
                if (randomShopItem) {
                    battlePlayerItemData.itemId = randomShopItem.id;
                }
            }
            return battlePlayerItemData;
        }

        /**
         * Создание следующего рандомного движения с указанным подтипом.
         * @param subType Подтип движения.
         * @param availableMoves Вектор уже созданных движений.
         * @param availableEnergy Доступная энергия.
         * @return Оставшаяся после добавления движения доступная энергия.
         */
        private static function createNewFakeDanceMoveWithSubType (subType:String, availableMoves:Vector.<BattleDanceMoveData>, availableEnergy:int):int {
            var danceMoveTypeList:Vector.<DanceMoveType> = DanceMoveTypeCollection.instance.getDanceMoveTypesOfSubtype (subType);
            //Фильтруем доступность движений:
            var availableDanceMoveTypeList:Vector.<DanceMoveType> = new Vector.<DanceMoveType> ();

            var allTypesId:Array/*ofString*/ = [];
            var filteredTypesId:Array/*ofString*/ = [];

            for (var i:int = 0; i < danceMoveTypeList.length; i++) {
                var danceMoveType:DanceMoveType = danceMoveTypeList [i];
                allTypesId.push (danceMoveType.id);
                if (danceMoveType.conditionType == DanceMoveTypeConditionType.STEP) {
                    var conditionValueAsArray:Array = danceMoveType.conditionValue.split(":");
                    var stepId:String = conditionValueAsArray [0];
                    var stepLevel:int = parseInt (conditionValueAsArray [1]);
                    for (var j:int = 0; j < availableMoves.length; j++) {
                        var battleDanceMoveData:BattleDanceMoveData = availableMoves [j];
                        if (
                                (battleDanceMoveData.type == stepId) &&
                                (battleDanceMoveData.level >= stepLevel)
                        ) {
                            availableDanceMoveTypeList.push (danceMoveType);
                            filteredTypesId.push (danceMoveType.id);
                            break;
                        }
                    }
                }
                else {
                    availableDanceMoveTypeList.push (danceMoveType);
                    filteredTypesId.push (danceMoveType.id);
                }
            }

//            trace ("---|---Фильтр доступности: [" + allTypesId + "] => [" + filteredTypesId + "]");

            return createNewFakeDanceMoveByTypeList (availableDanceMoveTypeList, availableMoves, availableEnergy);
        }

        /**
         * Создание следующего рандомного движения для продолжения связки (опираемся на доступность переходов уже разученных движений).
         * @param availableMoves Вектор уже созданных движений.
         * @param availableEnergy Доступная энергия.
         * @return Оставшаяся после добавления движения доступная энергия.
         */
        private static function createNewTransitionFakeDanceMove (availableMoves:Vector.<BattleDanceMoveData>, availableEnergy:int):int {
            var availableTransitionMoves:Vector.<String> = new Vector.<String> ();
            var danceMoveType:DanceMoveType;
            var battleDanceMoveData:BattleDanceMoveData;
            var danceMoveTypeId:String;
            //Формируем список движений, на которые можно перейти из текущих движений.
            for (var i:int = 0; i < availableMoves.length; i++) {
                battleDanceMoveData = availableMoves [i];
                danceMoveType = battleDanceMoveData.getDanceMoveType ();
                if (danceMoveType) {
                    var currentAvailableTransitionMoves:Vector.<String> = danceMoveType.getAvailableTransitionMoves (battleDanceMoveData.level);
                    if (currentAvailableTransitionMoves) {
                        availableTransitionMoves = availableTransitionMoves.concat (currentAvailableTransitionMoves);
                    }
                }
            }
//            trace ("---|---Список движений для продолжения: [" + availableTransitionMoves + "]");

            //Удаляем повторы:
            var filteredAvailableTransitionMoves:Vector.<String> = new Vector.<String> ();
            for (i = 0; i < availableTransitionMoves.length; i++) {
                danceMoveTypeId = availableTransitionMoves [i];
                if (filteredAvailableTransitionMoves.indexOf (danceMoveTypeId) == -1) {
                    filteredAvailableTransitionMoves.push (danceMoveTypeId);
                }
            }
            availableTransitionMoves = filteredAvailableTransitionMoves;
//            trace ("---|---Список движений для продолжения (фильтр повторов): [" + availableTransitionMoves + "]");

            //Удаляем изученные движения:
            if (availableTransitionMoves.length > 0) {
                for (i = 0; i < availableMoves.length; i++) {
                    battleDanceMoveData = availableMoves [i];
                    var index:int = availableTransitionMoves.indexOf (battleDanceMoveData.type);
                    if (index != -1) {
                        availableTransitionMoves.splice (index, 1);
                    }
                }
            }
//            trace ("---|---Список движений для продолжения (фильтр уже изученных движений): [" + availableTransitionMoves + "]");

            //Фильтруем доступные движения:
            filteredAvailableTransitionMoves = new Vector.<String> ();
            for (i = 0; i < availableTransitionMoves.length; i++) {
                danceMoveTypeId = availableTransitionMoves [i];
                danceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (danceMoveTypeId);
                if (danceMoveType.conditionType == DanceMoveTypeConditionType.STEP) {
                    var conditionValueAsArray:Array = danceMoveType.conditionValue.split(":");
                    var stepId:String = conditionValueAsArray [0];
                    var stepLevel:int = parseInt (conditionValueAsArray [1]);
                    for (var j:int = 0; j < availableMoves.length; j++) {
                        battleDanceMoveData = availableMoves [j];
                        if (
                                (battleDanceMoveData.type == stepId) &&
                                (battleDanceMoveData.level >= stepLevel)
                        ) {
                            filteredAvailableTransitionMoves.push (danceMoveTypeId);
                            break;
                        }
                    }
                }
                else {
                    filteredAvailableTransitionMoves.push (danceMoveTypeId);
                }
            }
            availableTransitionMoves = filteredAvailableTransitionMoves;
//            trace ("---|---Список движений для продолжения (фильтр доспупных): [" + availableTransitionMoves + "]");

            //Выбираем одно движение из созданного списка движений.
            if (availableTransitionMoves.length > 0) {
                var randomDanceMoveTypeId:String = availableTransitionMoves [Math.round (Math.random () * (availableTransitionMoves.length - 1))];
                danceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (randomDanceMoveTypeId);
                return createNewFakeDanceMoveByDanceMoveType (danceMoveType, availableMoves, availableEnergy);
            }
            else {
                return createNewFakeDanceMoveWithSubType (DanceMoveSubType.START, availableMoves, availableEnergy);
            }
            return availableEnergy;
        }

        /**
         * Создание следующего рандомного движения из указанного вектора типов.
         * @param danceMoveTypeList Вектор типов движений для выбора.
         * @param availableMoves Вектор уже созданных движений.
         * @param availableEnergy Доступная энергия.
         * @return Оставшаяся после добавления движения доступная энергия.
         */
        private static function createNewFakeDanceMoveByTypeList (danceMoveTypeList:Vector.<DanceMoveType>, availableMoves:Vector.<BattleDanceMoveData>, availableEnergy:int):int {
            //Удаляем из вектора типов все движения, которые уже изучены:
            for (var i:int = 0; i < availableMoves.length; i++) {
                var battleDanceMoveData:BattleDanceMoveData = availableMoves [i];
                var index:int = danceMoveTypeList.indexOf (battleDanceMoveData.getDanceMoveType ());
                if (index != -1) {
                    danceMoveTypeList.splice (index, 1);
                }
            }
            //Выбираем рандомное движение:
            if (danceMoveTypeList.length > 0) {
                var randomDanceMoveType:DanceMoveType = danceMoveTypeList [Math.round (Math.random () * (danceMoveTypeList.length - 1))];
                if (randomDanceMoveType) {
                    return createNewFakeDanceMoveByDanceMoveType (randomDanceMoveType, availableMoves, availableEnergy);
                }
            }
            return availableEnergy;
        }

        private static function createNewFakeDanceMoveByDanceMoveType (danceMoveType:DanceMoveType, availableMoves:Vector.<BattleDanceMoveData>, availableEnergy:int):int {
            if (danceMoveType) {
                var battleDanceMoveData:BattleDanceMoveData = new BattleDanceMoveData ();
                battleDanceMoveData.type = danceMoveType.id;
                battleDanceMoveData.level = 1;
                var danceMoveLevel:DanceMoveLevel = danceMoveType.getLevel (1);
                if (danceMoveLevel) {
                    availableMoves.push (battleDanceMoveData);
                    return availableEnergy - danceMoveLevel.energyRequired;
                }
            }
            return availableEnergy;
        }

        private static function upgradeRandomFakeDanceMove (availableMoves:Vector.<BattleDanceMoveData>, availableEnergy:int):int {
            var battleDanceMoveData:BattleDanceMoveData;
            var danceMoveType:DanceMoveType;
            //Удаляем все движения макс. уровня:
            var notMaxLevelAvailableMoves:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
            for (var i:int = 0; i < availableMoves.length; i++) {
                battleDanceMoveData = availableMoves [i];
                danceMoveType = battleDanceMoveData.getDanceMoveType ();
                if (battleDanceMoveData.level != danceMoveType.numLevels) {
                    notMaxLevelAvailableMoves.push (battleDanceMoveData);
                }
            }
            //Выбираем случайное движение:
            if (notMaxLevelAvailableMoves.length > 0) {
                var randomBattleDanceMoveData:BattleDanceMoveData = notMaxLevelAvailableMoves [Math.round (Math.random () * (notMaxLevelAvailableMoves.length - 1))];
                if (randomBattleDanceMoveData) {
                    danceMoveType = randomBattleDanceMoveData.getDanceMoveType ();
                    var currentDanceMoveLevel:DanceMoveLevel = danceMoveType.getLevel (randomBattleDanceMoveData.level);
                    var nextDanceMoveLevel:DanceMoveLevel = danceMoveType.getLevel (randomBattleDanceMoveData.level + 1);
                    randomBattleDanceMoveData.level++;//Повышаем уровень.
                    return availableEnergy - (nextDanceMoveLevel.energyRequired - currentDanceMoveLevel.energyRequired);
                }
            }
            return availableEnergy;
        }

        private static function upgradeRandomFakeOriginalDanceMove (availableMoves:Vector.<BattleDanceMoveData>, availableEnergy:int):int {
            var battleDanceMoveData:BattleDanceMoveData;
            var danceMoveType:DanceMoveType;
            //Удаляем все движения макс. уровня, выбираем только оригинальные движения:
            var notMaxLevelOriginalAvailableMoves:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
            for (var i:int = 0; i < availableMoves.length; i++) {
                battleDanceMoveData = availableMoves [i];
                danceMoveType = battleDanceMoveData.getDanceMoveType ();
                if (
                        (battleDanceMoveData.level != danceMoveType.numLevels) &&
                        danceMoveType.subType == DanceMoveSubType.ORIGINAL
                ) {
                    notMaxLevelOriginalAvailableMoves.push (battleDanceMoveData);
                }
            }
            //Выбираем случайное движение:
            if (notMaxLevelOriginalAvailableMoves.length > 0) {
                var randomBattleDanceMoveData:BattleDanceMoveData = notMaxLevelOriginalAvailableMoves [Math.round (Math.random () * (notMaxLevelOriginalAvailableMoves.length - 1))];
                if (randomBattleDanceMoveData) {
                    danceMoveType = randomBattleDanceMoveData.getDanceMoveType ();
                    var currentDanceMoveLevel:DanceMoveLevel = danceMoveType.getLevel (randomBattleDanceMoveData.level);
                    var nextDanceMoveLevel:DanceMoveLevel = danceMoveType.getLevel (randomBattleDanceMoveData.level + 1);
                    randomBattleDanceMoveData.level++;
                    return availableEnergy - (nextDanceMoveLevel.energyRequired - currentDanceMoveLevel.energyRequired);
                }
            }
            return availableEnergy;
        }
    }
}