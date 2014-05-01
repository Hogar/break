/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 03.10.13
 * Time: 12:23
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.model {

    /**
     * Информация о результатах боя для игрока.
     */
    public class UserBattleResultInfo {

        public var battleResult:String;
        public var userPoints:int;
        public var opponentPoints:int;

        private static const BATTLE_RESULT_ID:int = 0;
        private static const USER_POINTS_ID:int = 1;
        private static const OPPONENT_POINTS_ID:int = 2;

        public function asData ():Object {
            var arr:Array = [];
            arr [BATTLE_RESULT_ID] = battleResult;
            arr [USER_POINTS_ID] = userPoints;
            arr [OPPONENT_POINTS_ID] = opponentPoints;
            return arr;
        }

        public function init (data:Object):void {
            if (data) {
                var dataAsArray:Array = data as Array;
                battleResult = dataAsArray [BATTLE_RESULT_ID];
                userPoints = dataAsArray [USER_POINTS_ID];
                opponentPoints = dataAsArray [OPPONENT_POINTS_ID];
            }
        }

    }
}
