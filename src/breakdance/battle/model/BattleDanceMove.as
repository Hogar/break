/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 22:21
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.model {

    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.events.BattleDanceMoveEvent;
    import breakdance.data.danceMoves.DanceMoveType;

    import flash.events.EventDispatcher;

    public class BattleDanceMove extends EventDispatcher {

        /**
         * Отправляется при изменении очков танц движения.
         *
         * @eventType breakdance.battle.events.BattleDanceMoveEvent.SET_POINTS
         */
        [Event(name="set points", type="breakdance.battle.events.BattleDanceMoveEvent")]

        private var _battleDanceMoveData:BattleDanceMoveData;
        private var _positiveBonus:int;
        private var _negativeBonus:int;
        private var _stability:int;//Расчитанная стабильность.
        private var _repeat:int;
        private var _wasProcessed:Boolean = false;

        public function BattleDanceMove (battleDanceMoveData:BattleDanceMoveData):void {
            _battleDanceMoveData = battleDanceMoveData;
            _stability = battleDanceMoveData.stability;
        }

        /**
         * Обработака движения, указание отрицательнох и положительных бонусов.
         * @param positiveBonus Сумма положительных бонусов.
         * @param negativeBonus Сумма отрицательных бонусов.
         */
        public function process (positiveBonus:int, negativeBonus:int, repeat:int):void {
            this._positiveBonus = positiveBonus;
            this._negativeBonus = negativeBonus;
            this._repeat = repeat;
            _wasProcessed = true;
            dispatchEvent (new BattleDanceMoveEvent (BattleDanceMoveEvent.SET_POINTS));
        }

        /**
         * Проверка, был ли произведён расчёт очков танц. движения.
         * @return Возвращет <code>true</code>, если расчёт танц. движения был произведён.
         */
        public function get wasProcessed ():Boolean {
            return _wasProcessed;
        }

        /**
         * Базовое (номинальное) значение очков, которое должно дать движение (без учёта уникальности движения и т.д.)
         */
        public function get basicMasteryPoints ():int {
            return _battleDanceMoveData.masteryPoints;
        }

        /**
         * Очки за движение.
         * Значение расчитывается во время боя (может зависить от уникальности движения, связки дня и т.д.).
         * При значении -1 очки не за выполнение движения ещё не расчитаны.
         */
        public function get masteryPoints ():int {
            return basicMasteryPoints + _positiveBonus - _negativeBonus;
        }

        public function get type ():String {
            return _battleDanceMoveData.type;
        }

        public function get level ():int {
            return _battleDanceMoveData.level;
        }

        public function getDanceMoveType ():DanceMoveType {
            return _battleDanceMoveData.getDanceMoveType ();
        }

        /**
         * Базовая стабильность.
         */
        public function get basicStability ():int {
            return _battleDanceMoveData.basicStability;
        }

        /**
         * Расчитанная стабильность.
         */
        public function get stability ():int {
            return _stability;
        }

        public function get stamina ():int {
            return _battleDanceMoveData.stamina;
        }

        /**
         * Сумма положительных бонусов.
         */
        public function get positiveBonus ():int {
            return _positiveBonus;
        }

        /**
         * Сумма отрицательных бонусов.
         */
        public function get negativeBonus ():int {
            return _negativeBonus;
        }

        /**
         * Колличество повторов движения до его исполнения.
         */
        public function get repeat ():int {
            return _repeat;
        }
    }
}
