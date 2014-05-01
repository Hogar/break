/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 08.10.13
 * Time: 22:11
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.controller {

    import breakdance.battle.ai.BasicArtificialIntelligence;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.model.BattlePlayer;
    import breakdance.battle.model.BattleUtils;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;

    public class LocalBattleController extends BattleController {

        private var _aiController:BasicArtificialIntelligence;

        public function LocalBattleController () {

        }

        public function get aiController ():BasicArtificialIntelligence {
            return _aiController;
        }

        public function set aiController (value:BasicArtificialIntelligence):void {
            _aiController = value;
        }

        /**
         * @inheritDoc
         */
        override public function addDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>, uid:String):void {
            super.addDanceRoutine (danceRoutine, uid);
            if (battle) {
                if (aiController) {
                    var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, uid);
                    if (opponent) {
                        var opponentDanceRoutine:Vector.<BattleDanceMoveData>;
                        if (TutorialManager.instance.currentStep == TutorialStep.BATTLE_MAIN) {
                            opponentDanceRoutine = new Vector.<BattleDanceMoveData> ();
                            var availableMoves:Vector.<BattleDanceMoveData> = opponent.availableMoves;
                            var danceRoutinesCount:int = BattleUtils.getDanceRoutinesCount (battle, opponent.uid);
                            if (danceRoutinesCount == 0) {
                                if (availableMoves.length > 0) {
                                    opponentDanceRoutine.push (availableMoves [0]);
                                }
                                if (availableMoves.length > 1) {
                                    opponentDanceRoutine.push (availableMoves [1]);
                                }
                            }
                            else {
                                if (availableMoves.length > 2) {
                                    opponentDanceRoutine.push (availableMoves [2]);
                                }
                                if (availableMoves.length > 3) {
                                    opponentDanceRoutine.push (availableMoves [3]);
                                }
                            }

                            for (var i:int = 0; i < opponentDanceRoutine.length; i++) {
                                var battleDanceMoveData:BattleDanceMoveData = opponentDanceRoutine [i];
                                battleDanceMoveData.calculateStability ();
                            }
                        }
                        else {
                            opponentDanceRoutine = aiController.createRandomDanceRoutine (battle, opponent);
                        }
                        battle.addDanceRoutine (opponentDanceRoutine, opponent.uid);
                    }
                }
            }
        }

        /**
         * @inheritDoc
         */
        override public function addAdditionalDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>, uid:String):void {
            super.addAdditionalDanceRoutine (danceRoutine, uid);
            if (battle) {
                if (aiController) {
                    var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (battle, uid);
                    var opponentDanceRoutine:Vector.<BattleDanceMoveData> = aiController.createRandomDanceRoutine (battle, opponent);
                    battle.addAdditionalDanceRoutine (opponentDanceRoutine, opponent.uid);
                }
            }
        }
    }
}
