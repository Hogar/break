/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.09.13
 * Time: 18:03
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.model {

    import breakdance.IPlayerData;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.data.BattlePlayerData;
    import breakdance.battle.data.PlayerItemData;
    import breakdance.battle.events.ChangeBattlePlayerChipsEvent;
    import breakdance.battle.events.ChangeBattlePlayerEvent;
    import breakdance.battle.events.ChangeBattlePlayerStaminaEvent;
    import breakdance.battle.events.UseStaminaConsumableEvent;

    import com.hogargames.utils.StringUtilities;

    import flash.events.EventDispatcher;

    /**
     * Модель для игрока, учавствующего в бою.
     */
    public class BattlePlayer extends EventDispatcher implements IBattlePlayer, IPlayerData {

        private var _name:String;
        private var _nick:String;
        private var _level:int;
        private var _uid:String;
        private var _hairId:int;
        private var _faceId:int;
        private var _body:PlayerItemData;
        private var _head:PlayerItemData;
        private var _hands:PlayerItemData;
        private var _legs:PlayerItemData;
        private var _shoes:PlayerItemData;
        private var _music:PlayerItemData;
        private var _cover:PlayerItemData;
        private var _other:PlayerItemData;

        private var _maxStamina:int;
        private var _startStamina:int;
        private var _stamina:int;
        private var _chips:int;
        private var _noLossStamina:Boolean;
        private var _points:int;

        private var _availableMoves:Vector.<BattleDanceMoveData>;

        /**
         * @param battlePlayerData Данные об игроке.
         */
        public function BattlePlayer (battlePlayerData:BattlePlayerData) {
            init (battlePlayerData);
        }

        /**
         * Инициализация данными.
         * @param battlePlayerData Данные об игроке.
         */
        public function init (battlePlayerData:BattlePlayerData):void {
            if (battlePlayerData) {
                _name = battlePlayerData.name;
                _nick = battlePlayerData.nickname;
                _level = battlePlayerData.level;
                _uid = battlePlayerData.uid;
                _hairId = battlePlayerData.hairId;
                _faceId = battlePlayerData.faceId;
                _body = battlePlayerData.body;
                _head = battlePlayerData.head;
                _hands = battlePlayerData.hands;
                _legs = battlePlayerData.legs;
                _shoes = battlePlayerData.shoes;
                _music = battlePlayerData.music;
                _cover = battlePlayerData.cover;
                _other = battlePlayerData.other;
                _stamina = battlePlayerData.stamina;
                _chips = battlePlayerData.chips;
                _noLossStamina = battlePlayerData.noLossStamina;
                _startStamina = battlePlayerData.stamina;
                _maxStamina = battlePlayerData.maxStamina;
                _availableMoves = battlePlayerData.availableMoves.concat ();
            }
            reset ();
        }

        public function get name ():String {
            return _name;
        }

        public function get nickname ():String {
            return _name;
        }

        public function get level ():int {
            return _level;
        }

        public function get uid ():String {
            return _uid;
        }

        public function get hairId ():int {
            return _hairId;
        }

        public function get faceId ():int {
            return _faceId;
        }

        public function get body ():PlayerItemData {
            return _body;
        }

        public function get head ():PlayerItemData {
            return _head;
        }

        public function get hands ():PlayerItemData {
            return _hands;
        }

        public function get legs ():PlayerItemData {
            return _legs;
        }

        public function get shoes ():PlayerItemData {
            return _shoes;
        }

        public function get music ():PlayerItemData {
            return _music;
        }

        public function get cover ():PlayerItemData {
            return _cover;
        }

        public function get other ():PlayerItemData {
            return _other;
        }

        public function get stamina ():int {
            return _stamina;
        }
        public function set stamina (value:int):void {
            var changeBattlePlayerStaminaEvent:ChangeBattlePlayerStaminaEvent = new ChangeBattlePlayerStaminaEvent ();
            changeBattlePlayerStaminaEvent.currentStamina = value;
            changeBattlePlayerStaminaEvent.previousStamina = _stamina;
            _stamina = value;
            dispatchEvent (changeBattlePlayerStaminaEvent);
            dispatchEvent (new ChangeBattlePlayerEvent ());
        }

        public function addStamina (addingStamina:int, noLessStamina:Boolean = false, staminaConsumableId:String = ""):void {
            var changeBattlePlayerStaminaEvent:ChangeBattlePlayerStaminaEvent = new ChangeBattlePlayerStaminaEvent ();
            var newStamina:int = Math.min (_stamina + addingStamina, _maxStamina);
            changeBattlePlayerStaminaEvent.currentStamina = newStamina;
            changeBattlePlayerStaminaEvent.previousStamina = _stamina;
            _stamina = newStamina;
            if (noLessStamina) {
                _noLossStamina = noLessStamina;
            }
            if (!StringUtilities.isNotValueString (staminaConsumableId)) {
                dispatchEvent (new UseStaminaConsumableEvent (addingStamina, staminaConsumableId));
            }
            dispatchEvent (changeBattlePlayerStaminaEvent);
            dispatchEvent (new ChangeBattlePlayerEvent ());
        }

        public function get startStamina ():int {
            return _stamina;
        }

        public function get chips ():int {
            return _chips;
        }

        public function set chips (value:int):void {
            var changeBattlePlayerChipsEvent:ChangeBattlePlayerChipsEvent = new ChangeBattlePlayerChipsEvent ();
            changeBattlePlayerChipsEvent.currentChips = value;
            changeBattlePlayerChipsEvent.previousChips = _chips;
            _chips = value;
            dispatchEvent (changeBattlePlayerChipsEvent);
            dispatchEvent (new ChangeBattlePlayerEvent ());
        }

        public function get noLossStamina ():Boolean {
            return _noLossStamina;
        }

        public function get maxStamina ():int {
            return _maxStamina;
        }

        public function get points ():int {
            return _points;
        }

        public function set points (value:int):void {
            _points = value;
            dispatchEvent (new ChangeBattlePlayerEvent ());
        }

        public function reset ():void {
            _stamina = _startStamina;
            _points = 0;
        }

        public function get availableMoves ():Vector.<BattleDanceMoveData> {
            return _availableMoves;
        }
    }
}
