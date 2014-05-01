package breakdance.user {

    import breakdance.core.staticData.StaticTableRow;

    public class UserLevel {

        private var _id:int;
        private var _division:int;

        private var _winsRequired:int;
        private var _energyRequired:int;

        private var _maxStamina:int;
        private var _maxMoves:int;

        private var _award:String;

        private var _additionalBattleTime:String;

        public function UserLevel (row:StaticTableRow) {
            if (row == null) {
                _id = 0;
                return;
            }

            _id = row.getAsInt ("id");
            _division = row.getAsInt ("division");
            _winsRequired = row.getAsInt ("wins");
            _energyRequired = row.getAsInt ("energy");
            _maxStamina = row.getAsInt ("stamina_max");
            _maxMoves = row.getAsInt ("max_moves");
            _award = row.getAsString ("award");
            _additionalBattleTime = row.getAsString ("additional_battle_time");
        }

        public function get id ():int {
            return _id;
        }

        public function get division ():int {
            return _division;
        }

        public function get winsRequired ():int {
            return _winsRequired;
        }

        public function get energyRequired ():int {
            return _energyRequired;
        }

        public function get maxStamina ():int {
            return _maxStamina;
        }

        public function get maxMoves ():int {
            return _maxMoves;
        }

        public function get award ():String {
            return _award;
        }

        public function get additionalBattleTime ():String {
            return _additionalBattleTime;
        }
    }
}