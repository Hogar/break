package breakdance.data.danceMoves {

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;
    import breakdance.core.staticData.StaticTableRow;
    import breakdance.core.texts.TextData;

    public class DanceMoveType {

        private var _intId:int;//Короткий цифровой id для передачи серверу.
        private var _id:String;
        private var _category:String;
        private var _textData:TextData;
        private var _stamina:int;
        private var _video:String;
        private var _subType:String;
        private var _conditionType:String;
        private var _conditionValue:String;

        private var _levels:Vector.<DanceMoveLevel>;

        public function DanceMoveType (intId:int, row:StaticTableRow) {
            _intId = intId;
            _id = row.getId ();
            _stamina = row.getAsInt ("stamina");
            _video = row.getAsString ("video");
            _category = row.getAsString ("category");
            _conditionType = row.getAsString ("condition_type", false, "");
            _conditionValue = row.getAsString ("condition_value", false, "");

            _subType = row.getAsString ("type", false);

            _levels = new Vector.<DanceMoveLevel> ();

            var table:StaticTable = StaticData.instance.getTable (_id);
            for (var i:int = 0; i < table.rows.length; i++) {
                _levels.push (new DanceMoveLevel (table.rows[i]));
            }
        }

        public function get category ():String {
            return _category;
        }

        public function get video ():String {
            return _video;
        }

        public function get numLevels ():int {
            return _levels.length;
        }

        public function getLevel (levelId:int):DanceMoveLevel {
            if ((levelId > 0) && (levelId <= _levels.length)) {
                return _levels [levelId - 1];
            }
            else {
                return null;
            }
        }

        public function get stamina ():int {
            return _stamina;
        }

        public function get subType ():String {
            return _subType;
        }

        public function get conditionType ():String {
            return _conditionType;
        }

        public function get conditionValue ():String {
            return _conditionValue;
        }

        public function get name ():String {
            if (_textData) {
                return _textData.currentLanguageText;
            }
            else {
                return "---";
            }
        }

        public function get intId ():int {
            return _intId;
        }

        public function get id ():String {
            return _id;
        }

        public function get textData ():TextData {
            return _textData;
        }

        public function set textData (value:TextData):void {
            _textData = value;
        }

        /**
         * Получение списка доступных движений для продожения связки.
         * @param level
         * @return
         */
        public function getAvailableTransitionMoves (level:int):Vector.<String> {
            var moves:Vector.<String> = new Vector.<String> ();
            for (var i:int = 0; i < _levels.length; i++) {
                if (level > i) {
                    var danceMoveLevel:DanceMoveLevel = _levels [i];
                    if (danceMoveLevel) {
                        moves = moves.concat (danceMoveLevel.transitionToMove);
                    }
                }
            }
            return moves;
        }


        public function getStability (level:int):int {
            var _stability:int;
            if (level > 0 && level <= numLevels) {
                var danceMoveLevel:DanceMoveLevel = _levels [level - 1];
                if (danceMoveLevel) {
                    _stability = danceMoveLevel.stability;
                }
            }
            return _stability;
        }
    }
}