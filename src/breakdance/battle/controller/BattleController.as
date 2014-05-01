/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 22:18
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.controller {

    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.model.Battle;

    /**
     * Обычный контроллер боя. Применяестя для локальных битв (без PvP).
     */
    public class BattleController implements IBattleController {

        private var _battle:Battle;

        public function BattleController () {

        }

        public function get battle ():Battle {
            return _battle;
        }

        public function set battle (value:Battle):void {
            _battle = value;
        }

        /**
         * @inheritDoc
         */
        public function startBattle ():void {
            if (_battle) {
                _battle.startBattle ();
            }
        }

        /**
         * @inheritDoc
         */
        public function timeIsUp ():void {
            if (_battle) {
                _battle.endMainBattle ();
            }
        }

        /**
         * @inheritDoc
         */
        public function surrender ():void {
            if (_battle) {
                _battle.surrender ();
            }
        }

        /**
         * @inheritDoc
         */
        public function addDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>, uid:String):void {
            if (_battle) {
                _battle.addDanceRoutine (danceRoutine, uid);
            }
        }

        /**
         * @inheritDoc
         */
        public function addAdditionalDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>, uid:String):void {
            if (_battle) {
                _battle.addAdditionalDanceRoutine (danceRoutine, uid);
            }
        }

        /**
         * @inheritDoc
         */
        public function addStamina (addingStamina:int, uid:String, noLessStamina:Boolean = false, staminaConsumableId:String = ""):void {
            if (_battle) {
                _battle.addStamina (addingStamina, uid, noLessStamina, staminaConsumableId);
            }
        }

        /**
         * @inheritDoc
         */
        public function processNextDanceMove ():void {
            if (_battle) {
                _battle.processNextDanceMove ();
            }
        }

        /**
         * @inheritDoc
         */
        public function get type ():String {
            return ControllerType.LOCAL;
        }

        public function destroy ():void {

        }
    }
}
