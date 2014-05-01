/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 01.10.13
 * Time: 12:30
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.ai {

    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.data.BattleDataUtils;
    import breakdance.battle.model.BattleUtils;
    import breakdance.battle.model.IBattle;
    import breakdance.battle.model.IBattlePlayer;
    import breakdance.data.danceMoves.DanceMoveSubType;

    public class BasicArtificialIntelligence {

        public function BasicArtificialIntelligence () {

        }

        public function createRandomDanceRoutine (battle:IBattle, player:IBattlePlayer):Vector.<BattleDanceMoveData> {
            var danceRoutine:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
            var availableStamina:int = player.stamina;
            var availableMoves:Vector.<BattleDanceMoveData> = player.availableMoves;
            var availableStartDanceMoves:Vector.<BattleDanceMoveData> = BattleDataUtils.getDanceMovesOfSubType (availableMoves, DanceMoveSubType.START);
            availableStartDanceMoves = BattleDataUtils.getDanceMovesByAvailableStamina (availableStartDanceMoves, availableStamina);
            if (availableStartDanceMoves.length > 0) {
                var randomStartMove:BattleDanceMoveData = availableStartDanceMoves [Math.round (Math.random () * (availableStartDanceMoves.length - 1))];
                danceRoutine.push (randomStartMove);
                availableStamina -= randomStartMove.stamina;
                var numMoves:int = battle.maxDanceMoves - 1;
                var availableDanceMovesForContinue:Vector.<BattleDanceMoveData> = BattleDataUtils.getDanceMovesByAvailableStamina (availableMoves, availableStamina);
                var previousBattleDanceMove:BattleDanceMoveData = danceRoutine [danceRoutine.length - 1];
                availableDanceMovesForContinue = BattleDataUtils.getDanceMovesForPrevMove (availableDanceMovesForContinue, previousBattleDanceMove);
                var availableNormalMovesForSelect:Vector.<BattleDanceMoveData>;
                for (var i:int = 0; i < numMoves; i++) {
                    availableNormalMovesForSelect = BattleDataUtils.getDanceMovesByAvailableStamina (availableDanceMovesForContinue, availableStamina);
                    if (availableNormalMovesForSelect.length > 0) {
                        var randomNormalDanceMove:BattleDanceMoveData = availableNormalMovesForSelect [availableNormalMovesForSelect.length - 1];
                        danceRoutine.push (randomNormalDanceMove);
                        availableStamina -= randomNormalDanceMove.stamina;
                    }
                    else {
                        break;
                    }
                }
                var availableOriginalMoves:Vector.<BattleDanceMoveData> = BattleDataUtils.getDanceMovesOfSubType (availableMoves, DanceMoveSubType.ORIGINAL);
                availableOriginalMoves = BattleDataUtils.getDanceMovesByAvailableStamina (availableOriginalMoves, availableStamina);
                if (availableOriginalMoves.length > 0 && player.chips > 0) {
                    if (!BattleUtils.getPlayerWasUsingOriginalMove (battle, player.uid)) {
                        var randomOriginalDanceMove:BattleDanceMoveData = availableOriginalMoves [availableOriginalMoves.length - 1];
                        danceRoutine.push (randomOriginalDanceMove);
                        availableStamina -= randomOriginalDanceMove.stamina;
                    }
                }
            }
            //TODO:А мега умный контроллер ещё и проанилизирует, какие движения у противника, чтобы были уникальными.
            for (i = 0; i < danceRoutine.length; i++) {
                var battleDanceMoveData:BattleDanceMoveData = danceRoutine [i];
                battleDanceMoveData.calculateStability ();
            }
            return danceRoutine;
        }
    }
}
