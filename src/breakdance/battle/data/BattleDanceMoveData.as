/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 24.09.13
 * Time: 13:31
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.data {

    import breakdance.data.danceMoves.DanceMoveLevel;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;

    /**
     * Данные о танцевальном движении в бою.
     */
    public class BattleDanceMoveData {

        private var _type:String;
        private var _level:int;
        private var _stability:int = -1;

        private static const TYPE_ID:int = 0;
        private static const LEVEL_ID:int = 1;
        private static const STABILITY_ID:int = 2;

        public function BattleDanceMoveData () {

        }

        public function get type ():String {
            return _type;
        }

        public function set type (value:String):void {
            _type = value;
        }

        public function get level ():int {
            return _level;
        }

        public function set level (value:int):void {
            if (_level < 0) {
                trace ("level < 0");
            }
            _level = value;
        }

        public function get stability ():int {
            return _stability;
        }


        public function set stability (value:int):void {
            _stability = value;
        }

        public function get masteryPoints ():int {
            var _masteryPoints:int = 0;
            var danceMovieType:DanceMoveType = getDanceMoveType ();
            if (danceMovieType) {
                if (_level <= danceMovieType.numLevels) {
                    var danceMoveLevel:DanceMoveLevel = danceMovieType.getLevel (_level);
                    if (danceMoveLevel) {
                        _masteryPoints = danceMoveLevel.masteryPoints;
                    }
                }
            }
            return _masteryPoints;
        }

        public function get stamina ():int {
            var _stamina:int = 0;
            var danceMovieType:DanceMoveType = getDanceMoveType ();
            if (danceMovieType) {
                _stamina = danceMovieType.stamina;
            }
            return _stamina;
        }

        public function get basicStability ():int {
            var _stability:int = 0;
            var danceMovieType:DanceMoveType = getDanceMoveType ();
            if (danceMovieType) {
                _stability = danceMovieType.getStability (_level);
            }
            return _stability;
        }

        public function getDanceMoveType ():DanceMoveType {
            var danceMovieType:DanceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (_type);
            return danceMovieType;
        }

        /**
         * Кодирование в данные (для сервера).
         * @return Объект-данные.
         */
        public function asData ():Object {
            var arr:Array = [];
            var danceMoveType:DanceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (_type);
            arr [TYPE_ID] = danceMoveType.intId;
            arr [LEVEL_ID] = _level;
            arr [STABILITY_ID] = _stability;
            return arr;
        }

        public function calculateStability (stabilityBonus:int = 0):void {
            var _basicStability:int = basicStability;
            _stability = _basicStability + Math.round (Math.random () * (100 - _basicStability));
            if (stabilityBonus > 0) {
                var oldStability:int = _stability;
                _stability = Math.min (100, _stability + stabilityBonus);
//                trace ("stabilityBonus = " + stabilityBonus + "; _stability: " + oldStability + " -> " + _stability);
            }
            if (_stability > 100) {
                _stability = 100;
//                trace ("WARNING! Модификатор стабильности больше 100.");
            }
        }

        /**
         * Инициализация данными (с сервера).
         * @param data Объект-данные.
         */
        public function init (data:Object):void {
            var objAsArray:Array = data as Array;
            var intType:int = parseInt (objAsArray [TYPE_ID]);
            var danceMoveType:DanceMoveType = DanceMoveTypeCollection.instance.getDanceMoveTypeByIntId (intType);
            _type = danceMoveType.id;
            _level = int (objAsArray [LEVEL_ID]);
            _stability = int (objAsArray [STABILITY_ID]);
        }

        public function toString ():String {
            var str:String;
            str = "[BattleDanceMoveData: ";
            str += "type = " + _type + "; ";
            str += "level = " + _level + "; ";
            str += "stability = " + _stability;
            str += "]";
            return str;
        }

    }
}
