/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.09.13
 * Time: 16:01
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.model {

    import breakdance.battle.data.BattleDanceMoveData;

    /**
     * Стек танц. связок игрока.
     */
    public class DanceRoutinesStack {

        private var _uid:String;

        private var _stack:Vector.<Vector.<BattleDanceMove>>;

        public function DanceRoutinesStack (uid:String) {
            _uid = uid;
            reset ();
        }

        /**
         * Ид игрока, которому принадлежит стек.
         */
        public function get uid ():String {
            return _uid;
        }

        public function get stack ():Vector.<Vector.<BattleDanceMove>> {
            return _stack;
        }

        /**
         * Добавление связки в стек связок игрока.
         * @param danceRoutine Связка.
         */
        public function addDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>):Vector.<BattleDanceMove> {
            //Перегоняем из статичных данных в данные для модели (c переменной для хранения очков и т.д.):
            var stackDanceRoutine:Vector.<BattleDanceMove> = new Vector.<BattleDanceMove> ();
            var numDanceMoves:int = danceRoutine.length;
            for (var i:int = 0; i < danceRoutine.length; i++) {
                var battleDanceMoveData:BattleDanceMoveData = danceRoutine [i];
                var battleDanceMove:BattleDanceMove = new BattleDanceMove (battleDanceMoveData);
                stackDanceRoutine.push (battleDanceMove);
            }
            _stack.push (stackDanceRoutine);
            return stackDanceRoutine;
        }

        /**
         * Получение связки.
         * @param turn Раунд.
         * @return Связка.
         */
        public function getDanceRoutine (turn:int):Vector.<BattleDanceMove> {
            if (_stack.length > turn) {
                var danceRoutine:Vector.<BattleDanceMove> = _stack [turn];
                return danceRoutine;
            }
            return null;
        }

        public function reset ():void {
            _stack = new Vector.<Vector.<BattleDanceMove>> ();
        }
    }
}
