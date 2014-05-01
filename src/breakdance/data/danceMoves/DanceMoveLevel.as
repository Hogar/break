package breakdance.data.danceMoves {

    import breakdance.core.Utils;
    import breakdance.core.staticData.StaticTableRow;

    public class DanceMoveLevel {
        private var _id:int;
        private var _transitionToMove:Vector.<String>;
        private var _awardId:String;
        private var _coins:int;
        private var _bucks:int;
        private var _stability:int;

        private var _masteryPoints:int;
        private var _energyRequired:int;

        public function DanceMoveLevel (row:StaticTableRow) {
            _id = row.getAsInt ("id");

            _energyRequired = row.getAsInt ("energy");
            _masteryPoints = row.getAsInt ("mastery_points");
            _coins = row.getAsInt ("coins");
            _bucks = row.getAsInt ("bucks");
            _bucks = row.getAsInt ("bucks");
            _stability = row.getAsInt ("stability");
            _awardId = row.getAsString ("award_id", false, "");

            _transitionToMove = new Vector.<String> ();

            var tempObject:Object = Utils.parseObject (row.getAsString ("transition_to", false));
            for (var key:String in tempObject) {
                _transitionToMove.push (key);
            }
        }

        public function get energyRequired ():int {
            return _energyRequired;
        }

        public function get masteryPoints ():int {
            return _masteryPoints;
        }


        public function get coins ():int {
            return _coins;
        }

        public function get bucks ():int {
            return _bucks;
        }

        public function get transitionToMove ():Vector.<String> {
            return _transitionToMove;
        }

        public function get id ():int {
            return _id;
        }

        public function get awardId ():String {
            return _awardId;
        }

        public function get stability ():int {
            return _stability;
        }
    }
}