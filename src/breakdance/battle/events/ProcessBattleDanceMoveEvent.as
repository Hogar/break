/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.09.13
 * Time: 11:53
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.events {

    import breakdance.battle.model.BattleDanceMove;

    import flash.events.Event;

    /**
     * Событие обработки танц. движения.
     */
    public class ProcessBattleDanceMoveEvent extends Event {

        private var _currentTurn:int;
        private var _currentDanceRoutineStack:int;
        private var _currentDanceMove:int;
        private var _uid:String;
        private var _danceMove:BattleDanceMove;

        public static const BATTLE_DANCE_MOVE_WAS_PROCESSED:String = "battle dance move was processed";//Завершение обработки танц. движения.

        public function ProcessBattleDanceMoveEvent (currentTurn:int, currentDanceRoutineStack:int, currentDanceMove:int, currentPlayer:String, danceMove:BattleDanceMove, type:String = BATTLE_DANCE_MOVE_WAS_PROCESSED) {
            super (type);
            this.currentTurn = currentTurn;
            this.currentDanceRoutineStack = currentDanceRoutineStack;
            this.currentDanceMove = currentDanceMove;
            this.uid = currentPlayer;
            this.danceMove = danceMove;
        }


        public function get currentTurn ():int {
            return _currentTurn;
        }

        public function set currentTurn (value:int):void {
            _currentTurn = value;
        }

        public function get currentDanceRoutineStack ():int {
            return _currentDanceRoutineStack;
        }

        public function set currentDanceRoutineStack (value:int):void {
            _currentDanceRoutineStack = value;
        }

        public function get currentDanceMove ():int {
            return _currentDanceMove;
        }

        public function set currentDanceMove (value:int):void {
            _currentDanceMove = value;
        }

        public function get uid ():String {
            return _uid;
        }

        public function set uid (value:String):void {
            _uid = value;
        }

        public function get danceMove ():BattleDanceMove {
            return _danceMove;
        }

        public function set danceMove (value:BattleDanceMove):void {
            _danceMove = value;
        }


    }
}
