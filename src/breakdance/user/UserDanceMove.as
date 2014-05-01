package breakdance.user {

    import breakdance.data.danceMoves.DanceMoveType;

    public class UserDanceMove {

        private var _type:DanceMoveType;

        private var _level:int;
        private var _energySpent:int;

        public function UserDanceMove (type:DanceMoveType) {
            _type = type;

            clear ();
        }

        public function clear ():void {
            _level = 0;
            _energySpent = 0;
        }

        public function get type ():DanceMoveType {
            return _type;
        }

        public function get level ():int {
            return _level;
        }

        public function set level (value:int):void {
            if (_type) {
                value = Math.max (0, Math.min (value, _type.numLevels));
            }
            _level = value;
        }

        public function get energySpent ():int {
            return _energySpent;
        }

        public function set energySpent (value:int):void {
            _energySpent = value;
        }

        public function getAvailableTransitionMoves ():Vector.<String> {
            var availableTransitionMoves:Vector.<String> = new Vector.<String> ();
            if (_type) {
                return _type.getAvailableTransitionMoves (_level);
            }
            return availableTransitionMoves;
        }

        public function getStability ():int {
            if (_type) {
                return _type.getStability (_level);
            }
            else {
                return 0;
            }
        }

    }
}