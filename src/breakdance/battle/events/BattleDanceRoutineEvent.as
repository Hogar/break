/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 30.09.13
 * Time: 16:19
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.events {

    import breakdance.battle.model.BattleDanceMove;

    import flash.events.Event;

    public class BattleDanceRoutineEvent extends Event {

        private var _uid:String;//Id игрока, добавившего связку.
        private var _round:int;//Раунд, к которому относится эта связка.
        private var _battleDanceRoutine:Vector.<BattleDanceMove>;//Связка.

        /**
         * Добавление связки танц. движений в стек связок.
         */
        public static const ADD_BATTLE_DANCE_ROUTINE:String = "add battle dance routine";
        /**
         * Начало обработки связки танц. движений.
         */
        public static const BEGIN_BATTLE_DANCE_ROUTINE:String = "begin battle dance routine";

        /**
         * @param battleDanceRoutine Связка.
         * @param uid Id игрока, добавившего связку.
         * @param round Раунд, к которому будет относится эта связка.
         * @param type
         */
        public function BattleDanceRoutineEvent (battleDanceRoutine:Vector.<BattleDanceMove>, uid:String, round:int, type:String = ADD_BATTLE_DANCE_ROUTINE) {
            this.battleDanceRoutine = battleDanceRoutine;
            this.uid = uid;
            this.round = round;
            super (type);
        }

        /**
         * Id игрока, добавившего связку.
         */
        public function get uid ():String {
            return _uid;
        }

        public function set uid (value:String):void {
            _uid = value;
        }

        /**
         * Раунд, в котором будет выполнена эта связка.
         */
        public function get round ():int {
            return _round;
        }

        public function set round (value:int):void {
            _round = value;
        }

        /**
         * Связка.
         */
        public function get battleDanceRoutine ():Vector.<BattleDanceMove> {
            return _battleDanceRoutine;
        }

        public function set battleDanceRoutine (value:Vector.<BattleDanceMove>):void {
            _battleDanceRoutine = value;
        }
    }
}
