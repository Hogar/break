package breakdance.user {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalConstants;
    import breakdance.MiniGames;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.data.BattlePlayerData;
    import breakdance.battle.data.PlayerItemData;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.server.ServerApi;
    import breakdance.core.server.ServerTime;
    import breakdance.core.sound.SoundManager;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.awards.AwardCollection;
    import breakdance.data.bucksOffers.BucksOffer;
    import breakdance.data.consumables.Consumable;
    import breakdance.data.consumables.ConsumableBonus;
    import breakdance.data.consumables.ConsumableBonusType;
    import breakdance.data.consumables.ConsumableCollection;
    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;
    import breakdance.data.news.NewData;
    import breakdance.data.news.NewDataCollection;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemBonusType;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.data.shop.ShopItemConditionType;
    import breakdance.events.BreakDanceAppEvent;
    import breakdance.tutorial.TutorialManager;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.popups.dailyAwardPopUp.DailyAwardPopUp;
    import breakdance.ui.popups.newLevelPopUp.NewLevelPopUp;
    import breakdance.user.events.ChangeUserEvent;
    import breakdance.user.events.GetCollectionItemEvent;
    import breakdance.user.events.WinsInRowEvent;

    import com.hogargames.debug.Tracer;
    import com.hogargames.utils.StringUtilities;

    import flash.events.EventDispatcher;

    public class AppUser extends EventDispatcher {

        private var _currentFriendData:FriendData;

        private var textsManager:TextsManager = TextsManager.instance;

        private var _uid:String;
        private var _authKey:String;
        private var _name:String = "";
        private var _nickname:String = "";
        private var _avatarUrl:String;

        private var _level:int = 0;

        private var _energy:int;
        private var _energyMax:int;
        private var _energySpent:int;
        private var _energyRestoreTime:Number; //seconds
        private var _staminaRestoreTime:Number; //seconds
        private var _energyRestoreBonuses:Number; //seconds
        private var _staminaRestoreBonuses:Number; //seconds

        private var _stamina:int;
        private var _staminaMax:int;

        private var _coins:int;
        private var _bucks:int;
        private var _chips:int;
        private var _wins:int;
        private var _draws:int;
        private var _lastBet:int;
        private var _lastTurns:int;
        private var _guessMoveGameRecord:int;

        private var _character:Character;

        private var _userDanceMoves:Vector.<UserDanceMove>;
        private var _userNoAppFriendsUids:Vector.<String> = new Vector.<String> ();
        private var _userAppFriends:Vector.<FriendData> = new Vector.<FriendData> ();

        private var _purchasedItems:Vector.<UserPurchasedItem> = new Vector.<UserPurchasedItem>;//Купленные в магазине вещи.
        private var _purchasedConsumables:Vector.<UserPurchasedConsumable> = new Vector.<UserPurchasedConsumable>;//Купленные расходники (пока только энергетики для восстановления выносливости).
        private var _newItems:Vector.<String> = new Vector.<String>;//Новые вещи для отображения в магазине.
        private var _readNews:Vector.<String> = new Vector.<String>;//Прочитанные новости.
        private var _userMissions:Vector.<String> = new Vector.<String>;//Список выполненых миссий для окна "5 шагов".
        private var _userAwards:Vector.<String> = new Vector.<String>;//Список полученных игроком одноразовых наград.
        private var _userCollections:Vector.<UserCollectionData> = new Vector.<UserCollectionData>;//Список полученных игроком элементов коллекций.

        private var _energyUpdateDate:Date;
        private var _staminaUpdateDate:Date;
        private var awardDay:int;

        private var _winsInRow:int;//Кол-во побед подряд.

        private var serverTime:ServerTime;

        public var installed:Boolean;

        private static const MIN_STAMINA_FOR_BATTLE:int = 4;
        private static const DEBUG_PLAYER:String = "Debug Player";
        private static const DEBUG_PLAYER_AVATAR:String = "http://cs10182.vk.me/u140678096/d_baa75e69.jpg";

        public function AppUser () {

            _energyRestoreTime = parseInt (StaticData.instance.getSetting ("energy_time"));
            _staminaRestoreTime = parseInt (StaticData.instance.getSetting ("stamina_time"));

            _level = 0;
            _energy = 0;
            _energyMax = 1;
            _energySpent = 0;
            _stamina = 0;
            _staminaMax = 1;
            _coins = 0;
            _chips = 0;
            _nickname = "";

            _character = new Character ();

            serverTime = ServerTime.instance;

            _userDanceMoves = new Vector.<UserDanceMove> ();
            for (var i:int = 0; i < DanceMoveTypeCollection.instance.list.length; i++) {
                _userDanceMoves.push (new UserDanceMove (DanceMoveTypeCollection.instance.list[i]));
            }

            if (BreakdanceApp.instance.flashVars.hasOwnProperty ("uid")) {
                _uid = BreakdanceApp.instance.flashVars["uid"];
                _authKey = BreakdanceApp.instance.flashVars["auth_key"];
            }
            else {
                _uid = GlobalConstants.DEBUG_USER_UID;
                CONFIG::test {
                    _uid = GlobalConstants.DEBUG_USER_TEST_UID;
                }
                _authKey = GlobalConstants.DEBUG_AUTH_KEY;
            }
            CONFIG::mixpanel {
                BreakdanceApp.mixpanel.identify (_uid);
            }
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get uid ():String {
            return _uid;
        }

        public function get authKey ():String {
            return _authKey;
        }

        public function get name ():String {
            return _name;
        }

        public function get nickname ():String {
            return _nickname;
        }

        public function get avatarUrl ():String {
            return _avatarUrl;
        }

        public function get level ():int {
            return _level;
        }

        public function get energy ():int {
            return _energy;
        }

        public function get energyMax ():int {
            return _energyMax;
        }

        public function get energySpent ():int {
            return _energySpent;
        }

        public function get stamina ():int {
            return _stamina;
        }

        public function get staminaMax ():int {
            return _staminaMax;
        }

        public function get coins ():int {
            return _coins;
        }

        public function get bucks ():int {
            return _bucks;
        }

        public function get chips ():int {
            return _chips;
        }

        public function get wins ():int {
            return _wins;
        }

        public function get draws ():int {
            return _draws;
        }

        public function get lastBet ():int {
            return _lastBet;
        }

        public function set lastBet (value:int):void {
            _lastBet = value;
        }

        public function get lastTurns ():int {
            return _lastTurns;
        }

        public function set lastTurns (value:int):void {
            _lastTurns = value;
        }

        public function get userDanceMoves ():Vector.<UserDanceMove> {
            return _userDanceMoves;
        }

        public function get energyUpdateDate ():Date {
            return _energyUpdateDate;
        }

        public function get staminaUpdateDate ():Date {
            return _staminaUpdateDate;
        }

        public function get winsInRow ():int {
            return _winsInRow;
        }

        public function get userAppFriends ():Vector.<FriendData> {
            return _userAppFriends;
        }

        public function get userNoAppFriendsUids ():Vector.<String> {
            return _userNoAppFriendsUids;
        }

        public function get character ():Character {
            return _character;
        }

        public function get newItems ():Vector.<String> {
            return _newItems;
        }

        public function get readNews ():Vector.<String> {
            return _readNews;
        }

        public function get hasUnReadNews ():Boolean {
            return (readNews.length < NewDataCollection.instance.enabledList.length);
        }

        public function getUnreadNewData ():NewData {
            var newDataList:Vector.<NewData> = NewDataCollection.instance.enabledList;
            for (var i:int = 0; i < newDataList.length; i++) {
                var newData:NewData = newDataList [i];
                if (_readNews.indexOf (newData.id) == -1) {
                    return newData;
                }
            }
            return null;
        }

        public function get guessMoveGameRecord ():int {
            return this._guessMoveGameRecord;
        }

        public function getBestUserFriendsInGuessMoveGame ():FriendData {
            var bestFriendData:FriendData;
            for (var i:int = 0; i < this._userAppFriends.length; i++) {
                var currentFriendData:FriendData = this._userAppFriends[i];
                if (bestFriendData == null) {
                    bestFriendData = currentFriendData;
                }
                else if (currentFriendData.guessMoveGameRecord > bestFriendData.guessMoveGameRecord) {
                    bestFriendData = currentFriendData;
                }
            }
            return bestFriendData;
        }

        public function addNewItem (itemId:String):void {
            if (_newItems.indexOf (itemId) == -1) {
                _newItems.push (itemId);
            }
            dispatchEvent (new ChangeUserEvent ());
        }

        public function removeNewItems (ids:Array):void {
            for (var i:int = 0; i < ids.length; i++) {
                var id:String = ids [i];
                var index:int = _newItems.indexOf (id);
                if (index != -1) {
                    _newItems.splice (index, 1);
                }
            }
            dispatchEvent (new ChangeUserEvent ());
        }

        public function addNew (newId:String):void {
            if (_readNews.indexOf (newId) == -1) {
                _readNews.push (newId);
            }
            dispatchEvent (new ChangeUserEvent ());
        }

        public function get purchasedItems ():Vector.<UserPurchasedItem> {
            return _purchasedItems;
        }

        public function get purchasedConsumables ():Vector.<UserPurchasedConsumable> {
            return _purchasedConsumables;
        }

        public function get userMissions ():Vector.<String> {
            return _userMissions;
        }

        public function get userAwards ():Vector.<String> {
            return _userAwards;
        }

        public function get userCollections ():Vector.<UserCollectionData> {
            return _userCollections;
        }

        public function getUserDanceMoviesByCategory (categoryId:String):Vector.<UserDanceMove> {
            var _userDanceMoviesOfChosenCategory:Vector.<UserDanceMove> = new Vector.<UserDanceMove> ();
            var numUserMovies:int = _userDanceMoves.length;
            for (var i:int = 0; i < numUserMovies; i++) {
                var currentUserMovie:UserDanceMove = _userDanceMoves [i];
                if (currentUserMovie.type.category == categoryId) {
                    _userDanceMoviesOfChosenCategory.push (currentUserMovie);
                }
            }
            return _userDanceMoviesOfChosenCategory;
        }

        public function saveUserSettings ():void {
            ServerApi.instance.query (
                    ServerApi.SAVE_SETTINGS,
                    {
                        sfx: int (SoundManager.instance.enableSound),
                        music: int (SoundManager.instance.enableMusic),
                        bet: _lastBet,
                        turns: _lastTurns,
                        lang: textsManager.currentLanguage
                    },
                    onSaveUserSettings
            )
        }

        public function getAvailableMoves ():Vector.<UserDanceMove> {
            var moves:Vector.<UserDanceMove> = new Vector.<UserDanceMove> ();
            for (var i:int = 0; i < _userDanceMoves.length; i++) {
                if (_userDanceMoves[i].level > 0)
                    moves.push (_userDanceMoves[i]);
            }
            return moves;
        }

        public function getDanceMoveLevel (danceMoveId:String):int {
            for (var i:int = 0; i < _userDanceMoves.length; i++) {
                var userDanceMove:UserDanceMove = _userDanceMoves[i];
                if (userDanceMove.type.id == danceMoveId) {
                    return userDanceMove.level;
                }
            }
            return 0;
        }

        public function setCurrentFriendData (friendData:FriendData):void {
            _currentFriendData = friendData;

        }


        public function get currentFriendData ():FriendData {
            return _currentFriendData;
        }

        public function set currentFriendData (value:FriendData):void {
            _currentFriendData = value;
            dispatchEvent (new ChangeUserEvent (ChangeUserEvent.CHANGE_USER_FRIEND));
        }

        /**
         * Проверка, есть ли товар с таким id у пользователя.
         * @param itemId Ид предмета.
         * @return
         */
        public function itemIsPurchased (itemId:String, showPopUps:Boolean = false):Boolean {
            var numPurchasedItems:int = purchasedItems.length;
            for (var i:int = 0; i < numPurchasedItems; i++) {
                var userPurchasedItem:UserPurchasedItem = purchasedItems [i];
                if (userPurchasedItem.itemId == itemId) {
                    return true;
                }
            }
            return false;
        }

        /**
         * Проверка, хватает ли монет/баксов для покупки товара.
         */
        public function hasCurrencyForBuyItem (shopItem:ShopItem, showPopUps:Boolean = false):Boolean {
            var availableToBuy:Boolean = true;
            if (shopItem) {
                if (shopItem.coins > coins) {
                    if (showPopUps) {
                        PopUpManager.instance.notEnoughCoinsPopUp.show ();
                    }
                    availableToBuy = false;
                }
                else if (shopItem.bucks > bucks) {
                    if (showPopUps) {
                        PopUpManager.instance.notEnoughBucksPopUp.show ();
                    }
                    availableToBuy = false;
                }
            }
            return availableToBuy;
        }

        /**
         * Проверка, соблюдаются ли доп. условия для покупки товара.
         */
        public function metAdditionConditionsForBuyItem (shopItem:ShopItem):Boolean {
            var availableToBuy:Boolean = true;
            if (shopItem) {
                switch (shopItem.conditionType) {
                    case (ShopItemConditionType.LEVEL):
                        if (level < parseInt (shopItem.conditionValue)) {
                            availableToBuy = false;
                        }
                        break;
                    case (ShopItemConditionType.STEP):
                        var conditionValueAsArray:Array = shopItem.conditionValue.split (":");
                        var stepId:String = conditionValueAsArray [0];
                        var stepLevel:int = parseInt (conditionValueAsArray [1]);
                        var currentStepLevel:int = getDanceMoveLevel (stepId);
                        if (currentStepLevel < stepLevel) {
                            availableToBuy = false;
                        }
                        break;
                    case (ShopItemConditionType.WINS):
                        if (wins < parseInt (shopItem.conditionValue)) {
                            availableToBuy = false;
                        }
                        break;
                }
            }
            return availableToBuy;
        }

        public function getUserPurchaseItemByItemIdAndColor (itemId:String, color:String = ""):UserPurchasedItem {
            for (var i:int = 0; i < _purchasedItems.length; i++) {
                var userPurchasedItem:UserPurchasedItem = _purchasedItems [i];
                if (
                        (userPurchasedItem.itemId == itemId) &&
                        (userPurchasedItem.color == color)
                        ) {
                    return userPurchasedItem;
                }
            }
            return null;
        }

        public function getUserPurchaseConsumable (id:String):UserPurchasedConsumable {
            for (var i:int = 0; i < _purchasedConsumables.length; i++) {
                var userPurchasedConsumable:UserPurchasedConsumable = _purchasedConsumables [i];
                if (userPurchasedConsumable.id == id) {
                    return userPurchasedConsumable;
                }
            }
            return null;
        }

        /**
         * Представление данных об игроке в бою.
         * @return Данные об игроке в бою.
         *
         * @see breakdance.battle.data.BattlePlayerData
         */
        public function asBattlePlayerData ():BattlePlayerData {
            var battlePlayerData:BattlePlayerData = new BattlePlayerData ();
            battlePlayerData.name = name;
            battlePlayerData.nickname = nickname;
            battlePlayerData.uid = uid;
            battlePlayerData.level = level;
            battlePlayerData.hairId = character.hairId;
            battlePlayerData.faceId = character.faceId;

            var bodyData:PlayerItemData = new PlayerItemData ();
            if (character.body) {
                bodyData.itemId = character.body.itemId;
                bodyData.color = character.body.color;
            }
            battlePlayerData.body = bodyData;

            var headData:PlayerItemData = new PlayerItemData ();
            if (character.head) {
                headData.itemId = character.head.itemId;
                headData.color = character.head.color;
            }
            battlePlayerData.head = headData;

            var handsData:PlayerItemData = new PlayerItemData ();
            if (character.hands) {
                handsData.itemId = character.hands.itemId;
                handsData.color = character.hands.color;
            }
            battlePlayerData.hands = handsData;

            var legsData:PlayerItemData = new PlayerItemData ();
            if (character.legs) {
                legsData.itemId = character.legs.itemId;
                legsData.color = character.legs.color;
            }
            battlePlayerData.legs = legsData;

            var shoesData:PlayerItemData = new PlayerItemData ();
            if (character.shoes) {
                shoesData.itemId = character.shoes.itemId;
                shoesData.color = character.shoes.color;
            }
            battlePlayerData.shoes = shoesData;

            var otherData:PlayerItemData = new PlayerItemData ();
            if (character.other) {
                otherData.itemId = character.other.itemId;
                otherData.color = character.other.color;
            }
            battlePlayerData.other = otherData;

            battlePlayerData.stamina = _stamina;
            battlePlayerData.maxStamina = _staminaMax;
            battlePlayerData.chips = _chips;
            battlePlayerData.noLossStamina = getConsumableBonusTimeLeft (ConsumableBonusType.NO_LOSS_STAMINA) > 0;

            var battleAvailableDanceMoves:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
            var availableDanceMoves:Vector.<UserDanceMove> = getAvailableMoves ();
            var numAvailableDanceMoves:int = availableDanceMoves.length;
            for (var i:int = 0; i < numAvailableDanceMoves; i++) {
                var userDanceMove:UserDanceMove = availableDanceMoves [i];
                var battleDanceMoveData:BattleDanceMoveData = new BattleDanceMoveData ();
                battleDanceMoveData.type = userDanceMove.type.id;
                battleDanceMoveData.level = userDanceMove.level;
                battleAvailableDanceMoves.push (battleDanceMoveData);
            }

            battlePlayerData.availableMoves = battleAvailableDanceMoves;
            return battlePlayerData;
        }

        /**
         * Проверка на возможность начать бой.
         * @param showPopUps Показывать ли попапы с информацией о том, чего не хватает игроку.
         * @return Врзвращает <code>true</code>, если игрок готов к бою.
         */
        public function testReadyToBattle (showPopUps:Boolean = true):Boolean {
            var availableStartMoves:Vector.<UserDanceMove> = getAvailableStartMoves ();
            var minStamina:int = MIN_STAMINA_FOR_BATTLE;
            var title:String;
            var message:String;
            //Определяем мин. выносливость для выполнения хотя бы одного движения:
            for (var i:int = 0; i < availableStartMoves.length; i++) {
                var currentAvailableMove:UserDanceMove = availableStartMoves [i];
                var danceMoveType:DanceMoveType = currentAvailableMove.type;
                if (danceMoveType) {
                    var prevMinStamina:int = minStamina;
                    minStamina = Math.min (minStamina, danceMoveType.stamina);
                }
            }
            //Проверяем, есть ли стартовые движения:
            if (availableStartMoves.length == 0) {
                if (showPopUps) {
                    title = textsManager.getText ("notEnoughMovesTitle");
                    message = textsManager.getText ("notEnoughMovesText");
                    PopUpManager.instance.infoPopUp.showMessage (title, message);
                }
                return false;
            }
            //Проверяем, хватает ли минимальной выносливости:
//            else if (_stamina <= minStamina) {
            else if (_stamina <= MIN_STAMINA_FOR_BATTLE) {
                if (showPopUps) {
//                    title = textsManager.getText ("notEnoughStaminaTitle");
//                    message = textsManager.getText ("notEnoughStaminaText");
//                    PopUpManager.instance.infoPopUp.showMessage (title, message);
                    PopUpManager.instance.restoreStaminaPopUp.show ();
                }
                return false;
            }
            else {
                return true;
            }
        }

        public function getConsumableBonusTimeLeft (bonusType:String):int {
            var timeLeft:int = 0;
            for (var i:int = 0; i < _purchasedConsumables.length; i++) {
                var userPurchasedConsumable:UserPurchasedConsumable = _purchasedConsumables [i];
                var consumable:Consumable = ConsumableCollection.instance.getConsumable (userPurchasedConsumable.id);
                for (var j:int = 0; j < consumable.bonuses.length; j++) {
                    var consumableBonus:ConsumableBonus = consumable.bonuses [j];
                    if (consumableBonus.type == bonusType) {
                        timeLeft = Math.max (timeLeft, userPurchasedConsumable.applyDate.time + consumable.time * 60 * 1000 - ServerTime.instance.time);
                    }
                }
            }
            return timeLeft;
        }

        public function getMaxConsumableBonusValue (bonusType:String):int {
            var bonusValue:int = 0;
            for (var i:int = 0; i < _purchasedConsumables.length; i++) {
                var userPurchasedConsumable:UserPurchasedConsumable = _purchasedConsumables [i];
                var consumable:Consumable = ConsumableCollection.instance.getConsumable (userPurchasedConsumable.id);
                for (var j:int = 0; j < consumable.bonuses.length; j++) {
                    var consumableBonus:ConsumableBonus = consumable.bonuses [j];
                    if (consumableBonus.type == bonusType) {
                        var timeLeft:int = Math.max (0, userPurchasedConsumable.applyDate.time + consumable.time * 60 * 1000 - ServerTime.instance.time);
                        if (timeLeft > 0) {
                            bonusValue = Math.max (bonusValue, consumableBonus.value);
                        }
                    }
                }
            }
            return bonusValue;
        }

    /////////////////////////////////////////////
    //ОБРАБОТЧИКИ СЕРВЕРНЫХ ОТВЕТОВ:
    /////////////////////////////////////////////
        /**
         *
         * @param response
         * @param saveSettings Сохранить текущие настройки звука и музыки, вместо того, чтобы инициализировать принятые.
         */
        public function init (response:Object, saveSettings:Boolean = false):void {
            var i:int;
            if (!saveSettings) {
                var userSettings:Object = response.data.user_settings;
                if (userSettings) {
                    if (userSettings.hasOwnProperty ("lang")) {
                        textsManager.setCurrentLanguage (userSettings.lang, false);
                    }
                    if (userSettings.hasOwnProperty ("sfx") && userSettings.hasOwnProperty ("music")) {
                        SoundManager.instance.setParams (StringUtilities.parseToBoolean (userSettings.sfx), StringUtilities.parseToBoolean (userSettings.music));
                    }
                    if (userSettings.hasOwnProperty ("bet")) {
                        _lastBet = userSettings.bet;
                    }
                    if (userSettings.hasOwnProperty ("turns")) {
                        _lastTurns = userSettings.turns;
                    }
                }
            }
            else {
                saveUserSettings ();
            }

            serverTime.synchronize (response.server_date);

            var data:Object = response.data;

            if (data.hasOwnProperty ("user_item_list")) {//Сначала его, т.к. надо распарсить user_slot_list
                var userItemList:Array = data.user_item_list;
                _purchasedItems = new Vector.<UserPurchasedItem> ();
                var userPurchasedItem:UserPurchasedItem;
                for (i = 0; i < userItemList.length; i++) {
                    var itemData:Object = userItemList[i];
                    userPurchasedItem = new UserPurchasedItem ();
                    userPurchasedItem.id = itemData.id;
                    userPurchasedItem.itemId = itemData.item_id;
                    userPurchasedItem.color = itemData.color;
                    _purchasedItems.push (userPurchasedItem);
                }
            }

            parseSlotList (data);//Сначала его, т.к. надо вычислить бонусы времени восстановления энергии.

            if (data) {
                parseUserData (data.user, false);
            }


            for (i = 0; i < _userDanceMoves.length; i++) {
                _userDanceMoves [i].clear ();
            }

            if (data.hasOwnProperty ("user_step_list")) {
                var moveListData:Array = data.user_step_list;
                var userDanceMove:UserDanceMove;
                var moveData:Object;
                for (i = 0; i < moveListData.length; i++) {
                    moveData = moveListData[i];
                    userDanceMove = getUserMove (moveData.step_id);
                    if (userDanceMove) {
                        userDanceMove.energySpent = moveData.energy_spent;
                        userDanceMove.level = moveData.level;
                    }
                }
            }

            if (data.hasOwnProperty ("user_news_list")) {
                var userNewsList:Object = data.user_news_list;
                _newItems = new Vector.<String> ();
                _readNews = new Vector.<String> ();
                for (i = 0; i < userNewsList.length; i++) {
                    var userNewData:Object = userNewsList [i];
                    if (ShopItemCollection.instance.getShopItem (userNewData.item_id) != null) {
                        _newItems.push (userNewData.item_id);
                    }
                    else if (NewDataCollection.instance.getNewData (userNewData.item_id) != null) {
                        _readNews.push (userNewData.item_id);
                    }
                }
            }

            if (data.hasOwnProperty ("user_scores_list")) {
                var userScoresList:Object = data.user_scores_list;
                for (i = 0; i < userScoresList.length; i++) {
                    var userScoreObject:Object = userScoresList [i];
                    if (userScoreObject.hasOwnProperty ("game_id")) {
                        if (userScoreObject.hasOwnProperty ("scores")) {
                            if (userScoreObject.game_id == MiniGames.GUESS_MOVE_GAME) {
                                this._guessMoveGameRecord = userScoreObject.scores;
                            }
                        }
                    }
                }
            }
            parseConsumablesList (data);

            if (data.hasOwnProperty ("user_tutorial_list")) {
                var userTutorialList:Object = data.user_tutorial_list;
                var tutorialSteps:Vector.<String> = new Vector.<String> ();
                for (i = 0; i < userTutorialList.length; i++) {
                    var tutorialObject:Object = userTutorialList [i];
                    if (tutorialObject.hasOwnProperty ("tutorial_id")) {
                        tutorialSteps.push (tutorialObject.tutorial_id);
                    }
                }
                TutorialManager.instance.initSteps (tutorialSteps);
            }

            parseMissionsList (data);
            parseAwardsList (data);
            parseCollectionsList (data);

            dispatchEvent (new ChangeUserEvent ());
        }

        public function onSocialGetUser (response:JsQueryResult):void {
            if (!response || !response.success) {
                _name = DEBUG_PLAYER;
                _avatarUrl = DEBUG_PLAYER_AVATAR;
                return;
            }

            _name = response.data.response[0].first_name + " " + response.data.response[0].last_name;
            _avatarUrl = response.data.response[0].photo_medium;
        }

        public function onSocialGetAppFriends (response:Object):void {
            if (response.success) {
                var resp:Object = response.data.response;
                _userAppFriends = new Vector.<FriendData> ();
                for each (var obj:Object in resp) {
                    var friendData:FriendData = new FriendData ();
                    friendData.uid = obj.uid;
                    friendData.avatarUrl = obj.photo_medium;
                    friendData.shortName = obj.first_name;
                    friendData.name = obj.first_name + " " + obj.last_name;
                    _userAppFriends.push (friendData);
                }
            }
            CONFIG::debug {
                if (_userAppFriends.length == 0) {
                    for (var i:int = 0; i < 40; i++) {
                        friendData = new FriendData ();
                        friendData.uid = GlobalConstants.DEBUG_USER_TEST_UID;
                        friendData.avatarUrl = _avatarUrl;
                        friendData.shortName = "Игрок " + i;
                        friendData.name = "Игрок " + i;
                        _userAppFriends.push (friendData);
                    }
                }
            }
        }

        public function onSocialGetAllFriends (response:Object):void {
            var appFriendsIds:Vector.<String> = new Vector.<String> ();
            for (var i:int = 0; i < _userAppFriends.length; i++) {
                var appFriendData:FriendData = _userAppFriends [i];
                appFriendsIds.push (appFriendData.uid);
            }
            if (response.success) {
                var resp:Object = response.data.response;
                _userNoAppFriendsUids = new Vector.<String> ();
                for each (var obj:Object in resp) {
                    if (appFriendsIds.indexOf (obj.uid) == -1) {
                        _userNoAppFriendsUids.push (obj.first_name + " " + obj.last_name);
                    }
                }
            }

        }

        public function onSocialPlaceOrder (response:Object, bucksOffer:BucksOffer):void {
            if (response.success && bucksOffer) {
                _bucks += bucksOffer.bucks + bucksOffer.bonus;
                dispatchEvent (new ChangeUserEvent ());
            }
        }

        public function onBuyItem (response:Object, itemId:String, color:String = "", withDress:Boolean = true):void {
            var purchasedItemId:String = response.data.item_id;
            var userPurchasedItem:UserPurchasedItem = new UserPurchasedItem ();
            userPurchasedItem.id = response.data.user_item_id;
            userPurchasedItem.itemId = itemId;
            userPurchasedItem.color = color;
            _purchasedItems.push (userPurchasedItem);
            if (withDress) {
                _character.fittingPurchasedItem (userPurchasedItem);
                _character.dressing (userPurchasedItem);
            }
            parseUserData (response.data);
        }

        public function onBuyConsumable (response:Object):void {
            parseConsumablesList (response.data);
            if (response.hasOwnProperty ("data")) {
                parseUserData (response.data.user);
            }
        }

        public function onApplyConsumable (response:Object):void {
            parseConsumablesList (response.data);
            if (response.hasOwnProperty ("data")) {
                parseUserData (response.data.user);
            }
        }

        public function onSaveMission (response:Object):void {
            parseMissionsList (response.data);
            dispatchEvent (new ChangeUserEvent ());
        }

        public function onGiveAward (response:Object):void {
            parseAwardsList (response.data);
            if (response.data) {
                if (response.data.hasOwnProperty ("user")) {
                    parseUserData (response.data.user);
                }
            }
            dispatchEvent (new ChangeUserEvent ());
        }

        public function onSellItem (response:Object, sellingItemId:int):void {
            parseUserData (response.data);
            var numPurchasedItems:int = purchasedItems.length;
            for (var i:int = 0; i < numPurchasedItems; i++) {
                var userPurchasedItem:UserPurchasedItem = purchasedItems [i];
                if (userPurchasedItem.id == sellingItemId) {
                    purchasedItems.splice (i, 1);
                    break;
                }
            }
            dispatchEvent (new ChangeUserEvent ());
        }

        public function onBattleWin (response:Object):void {
            var numWinsInRow:int = parseInt (StaticData.instance.getSetting ("num_wins_in_row"));
            var previousWinsInRow:int = _winsInRow;
            if (response.data) {
                if (response.data.hasOwnProperty ("user")) {
                    parseUserData (response.data.user, false);
                }
            }

            parseCollectionsList (response.data);

            var collectionId:String = response.data.collections_id;
            var amount:int = 1;
            //Находим предыдущее кол-во элементов коллекции:
            for (var i:int = 0; i < _userCollections.length; i++) {
                var userCollectionData:UserCollectionData = _userCollections [i];
                if (userCollectionData.id == collectionId) {
                    amount = userCollectionData.count;
                    break;
                }
            }

            dispatchEvent (new ChangeUserEvent ());
            if ((_winsInRow == 0) && (previousWinsInRow == numWinsInRow - 1)) {
                dispatchEvent (new WinsInRowEvent ());
            }
            dispatchEvent (new GetCollectionItemEvent (collectionId, amount));
        }

        public function onBattleDraw (response:Object):void {
            if (response.data) {
                if (response.data.hasOwnProperty ("user")) {
                    parseUserData (response.data.user, false);
                }
            }

            parseCollectionsList (response.data);

            var collectionId:String = response.data.collections_id;
            var amount:int = 1;
            //Находим предыдущее кол-во элементов коллекции:
            for (var i:int = 0; i < _userCollections.length; i++) {
                var userCollectionData:UserCollectionData = _userCollections [i];
                if (userCollectionData.id == collectionId) {
                    amount = userCollectionData.count;
                    break;
                }
            }
            parseUserData (response.data, true);
            dispatchEvent (new GetCollectionItemEvent (collectionId, amount));
        }

        public function onGiveConsumables (response:Object):void {
            if (response.data) {
                if (response.data.hasOwnProperty ("user")) {
                    parseUserData (response.data.user, false);
                }
            }
            parseConsumablesList (response.data);
            dispatchEvent (new ChangeUserEvent ());
        }

        public function onGiveCollections (response:Object):void {
            if (response.data) {
                if (response.data.hasOwnProperty ("user")) {
                    parseUserData (response.data.user, false);
                }
            }
            parseCollectionsList (response.data);
            dispatchEvent (new ChangeUserEvent ());
        }

        public function onResponseWithUpdateUserData (response:Object):void {
            parseUserData (response.data, true);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function getAvailableStartMoves ():Vector.<UserDanceMove> {
            var moves:Vector.<UserDanceMove> = new Vector.<UserDanceMove> ();
            for (var i:int = 0; i < _userDanceMoves.length; i++) {
                var userDanceMove:UserDanceMove = _userDanceMoves[i];
                if ((userDanceMove.level > 0) && userDanceMove.type.subType == DanceMoveSubType.START) {
                    moves.push (userDanceMove);
                }
            }
            return moves;
        }

        private function getUserMove (moveId:String):UserDanceMove {
            for (var i:int = 0; i < _userDanceMoves.length; i++) {
                if (_userDanceMoves[i].type.id == moveId)
                    return _userDanceMoves[i];
            }
            return null;
        }

        private function getUserPurchaseItem (id:int):UserPurchasedItem {
            for (var i:int = 0; i < _purchasedItems.length; i++) {
                var userPurchasedItem:UserPurchasedItem = _purchasedItems [i];
                if (userPurchasedItem.id == id) {
                    return userPurchasedItem;
                }
            }
            return null;
        }

        private function parseUserData (userData:Object, dispatchChange:Boolean = true):void {
            if (!userData) {
                return;
            }
            if (userData.hasOwnProperty ("level")) {
                var previousLevel:int = _level;
                _level = userData.level;
                if (previousLevel != 0 && (previousLevel < _level)) {
                    var newLevelPopUp:NewLevelPopUp = PopUpManager.instance.newLevelPopUp;
                    newLevelPopUp.setLevel (_level);
                    newLevelPopUp.show ();
                }
            }
            if (userData.hasOwnProperty ("nickname")) {
                _nickname = unescape (userData.nickname);
            }
            if (userData.hasOwnProperty ("energy")) {
                _energy = userData.energy;
            }
            if (userData.hasOwnProperty ("energy_max")) {
                _energyMax = userData.energy_max;
            }
            if (userData.hasOwnProperty ("energy_spent")) {
                _energySpent = userData.energy_spent;
            }
            if (userData.hasOwnProperty ("stamina")) {
                _stamina = userData.stamina;
            }
            if (userData.hasOwnProperty ("stamina_max")) {
                _staminaMax = userData.stamina_max;
            }
            if (userData.hasOwnProperty ("coins")) {
                _coins = userData.coins;
            }
            if (userData.hasOwnProperty ("bucks")) {
                _bucks = userData.bucks;
            }
            if (userData.hasOwnProperty ("chips")) {
                _chips = userData.chips;
            }
            if (userData.hasOwnProperty ("wins")) {
                _wins = userData.wins;
            }
            if (userData.hasOwnProperty ("draws")) {
                _draws = userData.draws;
            }
            if (userData.hasOwnProperty ("hair_id")) {
                _character.hairId = userData.hair_id;
            }
            if (userData.hasOwnProperty ("face_id")) {
                _character.faceId = userData.face_id;
            }
            if (userData.hasOwnProperty ("row_wins")) {
                var numWinsInRow:int = parseInt (StaticData.instance.getSetting ("num_wins_in_row"));
                _winsInRow = userData.row_wins;
            }
            if (userData.hasOwnProperty ("award_day")) {
                awardDay = userData.award_day;
            }
            if (userData.hasOwnProperty ("award_date")) {
                var awardDateString:String = userData.award_date;
                var awardDate:Date = serverTime.parseDateStr (awardDateString);
                var delta:Number = serverTime.time - awardDate.time;
                const DAY_MILLISECONDS:int = 60 * 60 * 24 * 1000;
                var day:int = 0;
                if (delta > DAY_MILLISECONDS * 2) {
                    day = 1;
//                    trace ("Не было более 2- х суток. day = " + day);
                }
                else if (delta > DAY_MILLISECONDS) {
                    day = awardDay + 1;
                    if (day > AwardCollection.instance.dailyAwards.length) {
                        day = 1;
                    }
//                    trace ("Не было более суток. day = " + day);
                }
                if (day > 0) {
                    var dailyAwardPopUp:DailyAwardPopUp = PopUpManager.instance.dailyAwardPopUp;
                    dailyAwardPopUp.setDay (day);
                    if (!dailyAwardPopUp.isShowed) {
                        dailyAwardPopUp.show ();
                    }
                }
            }

            var date:Date;
            if (userData.hasOwnProperty ("energy_date")) {
                var _fullEnergyRestoreTime:Number = _energyRestoreTime + _energyRestoreBonuses / 100 * _energyRestoreTime;
//                if (_fullEnergyRestoreTime != _energyRestoreTime) {
//                    Tracer.log ("Модификация вост. энергии: " + _energyRestoreTime + " => " + _fullEnergyRestoreTime);
//                }
                date = serverTime.parseDateStr (userData.energy_date);
                _energyUpdateDate = new Date ();
                _energyUpdateDate.setTime (date.time + _fullEnergyRestoreTime * 1000);
                Tracer.log (
                        "_energyUpdateDate = userData.energy_date (" + date.toString () +
                        ") (" + date.getTime () + ") + _fullEnergyRestoreTime  * 1000 (" + _fullEnergyRestoreTime * 1000 + ") = " +
                        _energyUpdateDate.toString() + "(" + _energyUpdateDate.getTime () + ")"
                );
            }
            if (userData.hasOwnProperty ("stamina_date")) {
                var _fullStaminaRestoreTime:Number = _staminaRestoreTime + _staminaRestoreBonuses / 100 * _staminaRestoreTime;
                if (_fullStaminaRestoreTime != _staminaRestoreTime) {
                    Tracer.log ("Модификация вост. выносливости: " + _staminaRestoreTime + " => " + _fullStaminaRestoreTime);
                }
                _staminaUpdateDate = new Date (serverTime.parseDateStr (userData.stamina_date).time + _fullStaminaRestoreTime * 1000);
            }

            if (dispatchChange) {
                dispatchEvent (new ChangeUserEvent ());
            }
        }

        private function parseSlotList (data:Object):void {
            if (data) {
                _energyRestoreBonuses = 0;
                _staminaRestoreBonuses = 0;
                if (data.hasOwnProperty ("user_slot_list")) {
                    var userSlotList:Object = data.user_slot_list;
                    var userPurchasedItem:UserPurchasedItem;
                    for (var i:int = 0; i < userSlotList.length; i++) {
                        var slotData:Object = userSlotList[i];
                        var slotDataSlotId:String = slotData.slot_id;
                        var slotDataUserItemId:int = slotData.user_item_id;
                        var slotDataUserBonusType:String = slotData.bonus_type;
                        var slotDataUserBonusValue:int = slotData.bonus_value;
                        if (slotDataUserBonusType == ShopItemBonusType.ENERGY_TIME) {
                            _energyRestoreBonuses += slotDataUserBonusValue;
                        }
                        if (slotDataUserBonusType == ShopItemBonusType.STAMINA_TIME) {
                            _staminaRestoreBonuses += slotDataUserBonusValue;
                        }
                        userPurchasedItem = getUserPurchaseItem (slotDataUserItemId);
                        if (userPurchasedItem) {
                            _character.setItem (slotDataSlotId, userPurchasedItem);
                        }
                    }
                }
            }
        }

        private function parseConsumablesList (data:Object):void {
            if (data) {
                if (data.hasOwnProperty ("user_consumables_list")) {
                    _purchasedConsumables = new Vector.<UserPurchasedConsumable> ();
                    var userConsumablesList:Object = data.user_consumables_list;
                    for (var i:int = 0; i < userConsumablesList.length; i++) {
                        var userConsumableObject:Object = userConsumablesList [i];
                        var userPurchasedConsumable:UserPurchasedConsumable = new UserPurchasedConsumable ();
                        userPurchasedConsumable.id = userConsumableObject.consumables_id;
                        userPurchasedConsumable.count = userConsumableObject.count;
                        userPurchasedConsumable.applyDate = serverTime.parseDateStr (userConsumableObject.apply_date);
                        _purchasedConsumables.push (userPurchasedConsumable);
                    }
                }
            }
        }

        private function parseMissionsList (data:Object):void {
            if (data) {
                if (data.hasOwnProperty ("user_mission_list")) {
                    var userMissionsList:Object = data.user_mission_list;
                    _userMissions = new Vector.<String> ();
                    for (var i:int = 0; i < userMissionsList.length; i++) {
                        var missionObject:Object = userMissionsList [i];
                        if (missionObject.hasOwnProperty ("mission_id")) {
                            _userMissions.push (missionObject.mission_id);
                        }
                    }
                }
            }
        }

        private function parseAwardsList (data:Object):void {
            if (data) {
                if (data.hasOwnProperty ("user_award_list")) {
                    var userAwardsList:Object = data.user_award_list;
                    _userAwards = new Vector.<String> ();
                    for (var i:int = 0; i < userAwardsList.length; i++) {
                        var awardObject:Object = userAwardsList [i];
                        if (awardObject.hasOwnProperty ("award_id")) {
                            _userAwards.push (awardObject.award_id);
                        }
                    }
                }
            }
        }

        private function parseCollectionsList (data:Object):void {
            if (data) {
                if (data.hasOwnProperty ("user_collections_list")) {
                    var userCollectionsList:Object = data.user_collections_list;
                    _userCollections = new Vector.<UserCollectionData> ();
                    for (var i:int = 0; i < userCollectionsList.length; i++) {
                        var collectionObject:Object = userCollectionsList [i];
                        if (
                                collectionObject.hasOwnProperty ("collections_id") &&
                                collectionObject.hasOwnProperty ("amount")
                        ) {
                            var userCollectionData:UserCollectionData = new UserCollectionData ();
                            userCollectionData.id = collectionObject.collections_id;
                            userCollectionData.count = collectionObject.amount;
                            _userCollections.push (userCollectionData);
                        }
                    }
                }
            }
        }

        private function onSaveUserSettings (response:Object):void {
            //
        }

    }
}