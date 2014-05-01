/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.11.13
 * Time: 21:40
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.model {

    import breakdance.battle.data.BattleDanceMoveData;

    public class AdditionalDanceRoutinesStack {

        private var _uid:String;

        private var _additionDanceRoutine:Vector.<BattleDanceMove>;

        public function AdditionalDanceRoutinesStack (uid:String) {
            _uid = uid;
            reset ();
        }

        /**
         * Ид игрока, которому принадлежит стек.
         */
        public function get uid ():String {
            return _uid;
        }

        /**
         * Добавление связки дополнительного тура в стек связок игрока.
         * @param danceRoutine Связка.
         */
        public function setAdditionDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>):Vector.<BattleDanceMove> {
            //Перегоняем из статичных данных в данные для модели (c переменной для хранения очков и т.д.):
            var stackDanceRoutine:Vector.<BattleDanceMove> = new Vector.<BattleDanceMove> ();
            for (var i:int = 0; i < danceRoutine.length; i++) {
                var battleDanceMoveData:BattleDanceMoveData = danceRoutine [i];
                var battleDanceMove:BattleDanceMove = new BattleDanceMove (battleDanceMoveData);
                stackDanceRoutine.push (battleDanceMove);
            }
            _additionDanceRoutine = stackDanceRoutine;
            return stackDanceRoutine;
        }

        /**
         * Добавление связки дополнительного тура в стек связок игрока.
         * @param danceRoutine Связка.
         */
        public function getAdditionDanceRoutine ():Vector.<BattleDanceMove> {
            return _additionDanceRoutine;
        }

        public function reset ():void {
            _additionDanceRoutine = null;
        }
    }
}
