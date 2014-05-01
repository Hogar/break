/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.09.13
 * Time: 0:18
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.data {

    import breakdance.IPlayerData;

    /**
     * Данные о игроке в бою.
     */
    public class BattlePlayerData implements IPlayerData {

        private var _uid:String;
        private var _name:String;
        private var _nickname:String;
        private var _level:int;
        private var _hairId:int;
        private var _faceId:int;

        public var maxStamina:int;
        public var stamina:int;
        public var chips:int;
        public var noLossStamina:Boolean;

        private var _head:PlayerItemData = new PlayerItemData ();
        private var _hands:PlayerItemData = new PlayerItemData ();
        private var _body:PlayerItemData = new PlayerItemData ();
        private var _legs:PlayerItemData = new PlayerItemData ();
        private var _shoes:PlayerItemData = new PlayerItemData ();
        private var _music:PlayerItemData = new PlayerItemData ();
        private var _cover:PlayerItemData = new PlayerItemData ();
        private var _other:PlayerItemData = new PlayerItemData ();

        public var availableMoves:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();

        private static const UID_ID:int = 0;
        private static const NAME_ID:int = 1;
        private static const NICK_ID:int = 2;
        private static const LEVEL_ID:int = 3;
        private static const HAIR_ID:int = 4;
        private static const FACE_ID:int = 5;
        private static const MAX_STAMINA_ID:int = 6;
        private static const STAMINA_ID:int = 7;
        private static const ITEMS_ID:int = 8;
        private static const MOVES_ID:int = 9;
        private static const NO_LESS_STAMINA:int = 10;
        private static const CHIPS_ID:int = 11;

        private static const HEAD_ID:int = 0;
        private static const HANDS_ID:int = 1;
        private static const BODY_ID:int = 2;
        private static const LEGS_ID:int = 3;
        private static const SHOES_ID:int = 4;
        private static const OTHER_ID:int = 5;
        private static const MUSIC_ID:int = 6;
        private static const COVER_ID:int = 7;

        public function BattlePlayerData () {

        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Кодирование в данные (для сервера).
         * @return Объект-данные.
         */
        public function asData ():Object {
            var arr:Array = [];
            arr [UID_ID] = _uid;
            arr [NAME_ID] = _name;
            arr [NICK_ID] = nickname;
            arr [LEVEL_ID] = _level;
            arr [HAIR_ID] = _hairId;
            arr [FACE_ID] = _faceId;
            arr [MAX_STAMINA_ID] = maxStamina;
            arr [STAMINA_ID] = stamina;
            arr [NO_LESS_STAMINA] = noLossStamina;
            arr [CHIPS_ID] = chips;
            var items:Array = [];
            items [HEAD_ID] = _head.asData ();
            items [HANDS_ID] = _hands.asData ();
            items [BODY_ID] = _body.asData ();
            items [LEGS_ID] = _legs.asData ();
            items [SHOES_ID] = _shoes.asData ();
            items [MUSIC_ID] = _music.asData ();
            items [COVER_ID] = _cover.asData ();
            items [OTHER_ID] = _other.asData ();
            arr [ITEMS_ID] = items;
            var moves:Array = [];
            for (var i:int = 0; i < availableMoves.length; i++) {
                var battleDanceMoveData:BattleDanceMoveData = availableMoves [i];
                moves.push (battleDanceMoveData.asData ());
            }
            arr [MOVES_ID] = moves;

            return arr;
        }

        /**
         * Инициализация данными (с сервера).
         * @param data Объект-данные.
         */
        public function init (data:Object):void {
            if (data) {
                var dataAsArray:Array = data as Array;
                _uid = dataAsArray [UID_ID];
                _name = dataAsArray [NAME_ID];
                _nickname = dataAsArray [NICK_ID];
                _level = dataAsArray [LEVEL_ID];
                _hairId = dataAsArray [HAIR_ID];
                _faceId = dataAsArray [FACE_ID];

                stamina = dataAsArray [STAMINA_ID];
                noLossStamina = dataAsArray [NO_LESS_STAMINA];
                maxStamina = dataAsArray [MAX_STAMINA_ID];
                if (dataAsArray.length > CHIPS_ID) {
                    chips = dataAsArray [CHIPS_ID];
                }

                var items:Array = dataAsArray [ITEMS_ID];
                _head = new PlayerItemData ();
                _hands = new PlayerItemData ();
                _body = new PlayerItemData ();
                _legs = new PlayerItemData ();
                _shoes = new PlayerItemData ();
                _music = new PlayerItemData ();
                _cover = new PlayerItemData ();
                _other = new PlayerItemData ();

                _head.init (items [HEAD_ID]);
                _hands.init (items [HANDS_ID]);
                _body.init (items [BODY_ID]);
                _legs.init (items [LEGS_ID]);
                _shoes.init (items [SHOES_ID]);
                _other.init (items [OTHER_ID]);
                if (items.length > MUSIC_ID) {
                    _music.init (items [MUSIC_ID]);
                }
                if (items.length > COVER_ID) {
                    _cover.init (items [COVER_ID]);
                }

                availableMoves = new Vector.<BattleDanceMoveData> ();
                var moves:Array = dataAsArray [MOVES_ID];
                for (var i:int = 0; i < moves.length; i++) {
                    var battleDanceMoveData:BattleDanceMoveData = new BattleDanceMoveData ();
                    battleDanceMoveData.init (moves [i]);
                    availableMoves.push (battleDanceMoveData);

                }

//                availableMoves = new Vector.<BattleDanceMoveData> ();
//                if (data.hasOwnProperty ("availableMoves")) {
//                    var numAvailableMoves:int = data.availableMoves.length;
//                    for (var i:int = 0; i < numAvailableMoves; i++) {
//                        var availableMove:Object = data.availableMoves [i];
//                        var battleDanceMoveData:BattleDanceMoveData = new BattleDanceMoveData ();
//                        battleDanceMoveData.init (availableMove);
//                        availableMoves.push (battleDanceMoveData);
//                    }
//                }
            }
        }

        public function get uid ():String {
            return _uid;
        }

        public function set uid (value:String):void {
            _uid = value;
        }

        public function get name ():String {
            return _name;
        }

        public function set name (value:String):void {
            _name = value;
        }

        public function get nickname ():String {
            return _nickname;
        }

        public function set nickname (value:String):void {
            _nickname = value;
        }

        public function get level ():int {
            return _level;
        }

        public function set level (value:int):void {
            _level = value;
        }

        public function get hairId ():int {
            return _hairId;
        }

        public function set hairId (value:int):void {
            _hairId = value;
        }

        public function get faceId ():int {
            return _faceId;
        }

        public function set faceId (value:int):void {
            _faceId = value;
        }

        public function get head ():PlayerItemData {
            return _head;
        }

        public function set head (value:PlayerItemData):void {
            _head = value;
        }

        public function get hands ():PlayerItemData {
            return _hands;
        }

        public function set hands (value:PlayerItemData):void {
            _hands = value;
        }

        public function get body ():PlayerItemData {
            return _body;
        }

        public function set body (value:PlayerItemData):void {
            _body = value;
        }

        public function get legs ():PlayerItemData {
            return _legs;
        }

        public function set legs (value:PlayerItemData):void {
            _legs = value;
        }

        public function get shoes ():PlayerItemData {
            return _shoes;
        }

        public function set shoes (value:PlayerItemData):void {
            _shoes = value;
        }

        public function get music ():PlayerItemData {
            return _music;
        }

        public function set music (value:PlayerItemData):void {
            _music = value;
        }

        public function get cover ():PlayerItemData {
            return _cover;
        }

        public function set cover (value:PlayerItemData):void {
            _cover = value;
        }

        public function get other ():PlayerItemData {
            return _other;
        }

        public function set other (value:PlayerItemData):void {
            _other = value;
        }

        public function toString ():String {
            var str:String;
            str = "[BattlePlayerData: ";
            str += "uid = " + uid + "; ";
            str += "name = " + name + "; ";
            str += "nick = " + nickname + "; ";
            str += "level = " + level + "; ";
            str += "hairId = " + hairId + "; ";
            str += "faceId = " + faceId + "; ";
            str += "maxStamina = " + maxStamina + "; ";
            str += "stamina = " + stamina + "; ";
            str += "head = " + head + "; ";
            str += "hands = " + hands + "; ";
            str += "body = " + body + "; ";
            str += "legs = " + legs + "; ";
            str += "shoes = " + shoes + "; ";
            str += "music = " + music + "; ";
            str += "cover = " + cover + "; ";
            str += "other = " + other + "; ";
            str += "availableMoves = [";
            for (var i:int = 0; i < availableMoves.length; i++) {
                var battleDanceMoveData:BattleDanceMoveData = availableMoves [i];
                str += battleDanceMoveData.toString ();
                if (i != availableMoves.length - 1) {
                    str += "; "
                }
            }
            str += "]";
            str += "]";
            return str;
        }
    }
}
