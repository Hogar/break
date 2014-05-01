/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 16:42
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view {

    import breakdance.BreakdanceApp;
    import breakdance.battle.events.BattleDanceRoutineEvent;
    import breakdance.battle.events.BattleEvent;
    import breakdance.battle.events.ChangeBattlePlayerChipsEvent;
    import breakdance.battle.events.ChangeBattlePlayerStaminaEvent;
    import breakdance.battle.events.ProcessBattleDanceMoveEvent;
    import breakdance.battle.events.UseStaminaConsumableEvent;
    import breakdance.battle.model.IBattle;
    import breakdance.battle.model.IBattlePlayer;
    import breakdance.battle.view.logPanel.BattleLogPanel;
    import breakdance.battle.view.roundIndicator.RoundsIndicatorContainer;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.ui.commons.BattlePlayerAvatarContainer;

    import com.greensock.TweenLite;
    import com.hogargames.utils.StringUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.text.TextField;

    /**
     * Элемент, управляющий отображением данных игрока батла.
     * Содержит ссылки на несколько визуальных элементов (лог-панель, аватар, прогресс бары выносливости и мастерства).
     */
    public class BattlePlayerView {

        public var animationCount:int = 1;//Для анимации прогрессбаров.

        protected var logPanel:BattleLogPanel;

        private var _battle:IBattle;//Ссылка на модель боя.
        private var _player:IBattlePlayer;//Ссылка на модель игрока в бою.

        private var mcMasteryPointsProgressBar:MovieClip;
        private var tfMasteryPoints:TextField;
        private var mcStaminaProgressBar:MovieClip;
        private var mcStaminaConsumable:MovieClip;
        private var mcStaminaConsumable2:MovieClip;
        private var tfStamina:TextField;
        private var tfPlayerName:TextField;

        private var avatarContainer:BattlePlayerAvatarContainer;
        private var roundsIndicator:RoundsIndicatorContainer;
        private var additionalRoundPause:int;//Пауза перед началом дополнительного раунда.

        public function BattlePlayerView (mcInfo:Sprite, mcAvatarContainer:MovieClip, tfPlayerName:TextField, logTemplate:MovieClip, roundsIndicatorContainer:MovieClip) {
            this.tfPlayerName = tfPlayerName;

            mcMasteryPointsProgressBar = mcInfo['mcPointsProgressBar'];
            mcMasteryPointsProgressBar.gotoAndStop (1);

            mcStaminaProgressBar = mcInfo['mcStaminaProgressBar'];
            mcStaminaProgressBar.gotoAndStop (1);

            mcStaminaConsumable = mcInfo['mcStaminaConsumable'];
            mcStaminaConsumable.gotoAndStop (1);

            mcStaminaConsumable2 = mcStaminaConsumable['mcStaminaConsumable'];
            mcStaminaConsumable2.gotoAndStop (1);

            tfMasteryPoints = mcInfo['tfPoints'];

            tfStamina = mcInfo['tfStamina'];

            avatarContainer = new BattlePlayerAvatarContainer (mcAvatarContainer);

            roundsIndicator = new RoundsIndicatorContainer (roundsIndicatorContainer);

            additionalRoundPause = parseInt (StaticData.instance.getSetting ("additional_round_pause"));

            createLogPanel (logTemplate);
        }

        public function get battle ():IBattle {
            return _battle;
        }


        public function set battle (value:IBattle):void {
            if (_battle) {
                _battle.removeEventListener (BattleEvent.START_BATTLE, startBattleListener);
                _battle.removeEventListener (BattleEvent.START_ADDITIONAL_ROUND, startAdditionalRoundListener);
                _battle.removeEventListener (ProcessBattleDanceMoveEvent.BATTLE_DANCE_MOVE_WAS_PROCESSED, processBattleDanceMoveListener);
                _battle.removeEventListener (BattleDanceRoutineEvent.BEGIN_BATTLE_DANCE_ROUTINE, beginBattleDanceRoutineListener);
                _battle.removeEventListener (BattleDanceRoutineEvent.ADD_BATTLE_DANCE_ROUTINE, addBattleDanceRoutineListener);
            }
            _battle = value;
            if (_battle) {
                _battle.addEventListener (BattleEvent.START_BATTLE, startBattleListener);
                _battle.addEventListener (BattleEvent.START_ADDITIONAL_ROUND, startAdditionalRoundListener);
                _battle.addEventListener (ProcessBattleDanceMoveEvent.BATTLE_DANCE_MOVE_WAS_PROCESSED, processBattleDanceMoveListener);
                _battle.addEventListener (BattleDanceRoutineEvent.BEGIN_BATTLE_DANCE_ROUTINE, beginBattleDanceRoutineListener);
                _battle.addEventListener (BattleDanceRoutineEvent.ADD_BATTLE_DANCE_ROUTINE, addBattleDanceRoutineListener);
                roundsIndicator.showRounds (_battle.numRounds);
                roundsIndicator.completeRounds (-1);
            }
            logPanel.battle = value;
        }

        public function get player ():IBattlePlayer {
            return _player;
        }

        public function set player (value:IBattlePlayer):void {
            if (player) {
                player.removeEventListener (UseStaminaConsumableEvent.USE_STAMINA_CONSUMABLE, useStaminaConsumableListener);
                player.removeEventListener (ChangeBattlePlayerStaminaEvent.CHANGE_STAMINA, changeBattlePlayerStaminaListener);
                player.removeEventListener (ChangeBattlePlayerChipsEvent.CHANGE_CHIPS, changeBattlePlayerChipsListener);
            }
            _player = value;
            if (player) {
                player.addEventListener (UseStaminaConsumableEvent.USE_STAMINA_CONSUMABLE, useStaminaConsumableListener);
                player.addEventListener (ChangeBattlePlayerStaminaEvent.CHANGE_STAMINA, changeBattlePlayerStaminaListener);
                player.addEventListener (ChangeBattlePlayerChipsEvent.CHANGE_CHIPS, changeBattlePlayerChipsListener);
            }
            logPanel.player = _player;
            updatePlayerParams ();
        }

        public function highlightSameDanceMoves (danceMoveType:DanceMoveType):void {
            logPanel.highlightSameDanceMoves (danceMoveType);
        }

        public function deselectAll ():void {
            logPanel.deselectAllBlocks ();
        }

        public function destroy ():void {
            logPanel.destroy ();
            logPanel = null;

            tfPlayerName = null;
            tfMasteryPoints = null;

            mcMasteryPointsProgressBar = null;
            mcStaminaProgressBar = null;
            mcStaminaConsumable = null;
            mcStaminaConsumable2 = null;

            if (avatarContainer) {
                avatarContainer.destroy ();
                avatarContainer = null;
            }

            tfStamina = null;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        protected function createLogPanel (logTemplate:MovieClip):void {
            logPanel = new BattleLogPanel (logTemplate);
        }

        protected function setStamina (stamina:int, maxStamina:int):void {
            tfStamina.text = stamina + "/" + maxStamina;
            if (maxStamina !=0 ){
                mcStaminaProgressBar.gotoAndStop (Math.floor (100.0 * stamina / maxStamina) + 1);
            }
            else {
                mcStaminaProgressBar.gotoAndStop (1);
            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function updatePlayerParams ():void {
            if (_player) {
                avatarContainer.visible = true;
                avatarContainer.initByPlayerData (_player);
                tfPlayerName.text = TextsManager.instance.getText ("b-boy") + " " + _player.name;
                setStamina (_player.stamina, _player.maxStamina);
                var maxPoints:int;
                if (_battle) {
                    if (_battle.player1 && _battle.player2) {
                        maxPoints = Math.max (_battle.player1.points, _battle.player2.points)
                    }
                    else {
                        maxPoints = 0;
                    }
                }
                setMasteryPoints (_player.points, maxPoints);
            }
            else {
                avatarContainer.visible = false;
                setStamina (0, 0);
                setMasteryPoints (0, 0);
            }
        }

        private function clearBattleData ():void {
            logPanel.clear ();
            roundsIndicator.deselectAllRounds ();
            roundsIndicator.completeRounds (-1);
        }

        private function setMasteryPoints (points:int, maxPoints:int):void {
            tfMasteryPoints.text = String (points)/* + "/" + maxPoints*/;
            var percent:Number;
            if (maxPoints > 0) {
                percent = points / maxPoints;
            }
            else {
                percent = 0;
            }
            mcMasteryPointsProgressBar.gotoAndStop (Math.floor (percent * 100) + 1);
        }

        private function onMasteryPointAnimationComplete (currentMasteryPointFrame:int):void {
            TweenLite.to (this, additionalRoundPause / 2, {animationCount:currentMasteryPointFrame, onUpdate:onMasteryPointAnimationUpdate});
        }

        private function onMasteryPointAnimationUpdate ():void {
            mcMasteryPointsProgressBar.gotoAndStop (animationCount);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        protected function startBattleListener (event:Event):void {
            mcMasteryPointsProgressBar.gotoAndStop (1);
            clearBattleData ();
        }

        protected function startAdditionalRoundListener (event:Event):void {
            TweenLite.killTweensOf (this);
            var currentMasteryPointFrame:int = mcMasteryPointsProgressBar.currentFrame;
            animationCount = currentMasteryPointFrame;
            TweenLite.to (
                    this,
                    additionalRoundPause / 2,
                    {
                        animationCount:1,
                        onUpdate:onMasteryPointAnimationUpdate,
                        onComplete:onMasteryPointAnimationComplete,
                        onCompleteParams:[currentMasteryPointFrame]
                    }
            );
        }

        //Обработка танц. движения.
        private function processBattleDanceMoveListener (event:ProcessBattleDanceMoveEvent):void {
            updatePlayerParams ();
        }

        //Начало новой связки.
        private function beginBattleDanceRoutineListener (event:BattleDanceRoutineEvent):void {
            if (_battle) {
                var playerUid:String = event.uid;
                if (_player) {
                    if (_player.uid == playerUid) {
                        roundsIndicator.selectRound (event.round);//Отображаем текущий раунд.
                        roundsIndicator.completeRounds (event.round);//ПОмечаем все раунды до текущего, как завершённые.
                    }
                    else {
                        roundsIndicator.deselectAllRounds ();
                    }
                }
            }
        }

        //Добавление новой связки.
        private function addBattleDanceRoutineListener (event:BattleDanceRoutineEvent):void {
//            if (_battle) {
//                var playerUid:String = event.uid;
//                if (_player) {
//                    if (_player.uid == playerUid) {
//                        roundsIndicator.completeRounds (event.round + 1);//Показываем общее кол-во раундов.
//                    }
//                }
//            }
        }

        private function useStaminaConsumableListener (event:UseStaminaConsumableEvent):void {
            updatePlayerParams ();
            var positionPoint:Point = tfStamina.localToGlobal (new Point (tfStamina.width / 2, 0));
            BreakdanceApp.instance.showInfoMessage ("+" + event.addingStamina, positionPoint);
            if (!StringUtilities.isNotValueString (event.staminaConsumableId)) {
                mcStaminaConsumable.gotoAndPlay (1);
                mcStaminaConsumable2.gotoAndStop (event.staminaConsumableId);
            }
        }

        protected function changeBattlePlayerStaminaListener (event:ChangeBattlePlayerStaminaEvent):void {
            updatePlayerParams ();
        }

        protected function changeBattlePlayerChipsListener (event:ChangeBattlePlayerChipsEvent):void {
            updatePlayerParams ();
        }

    }
}