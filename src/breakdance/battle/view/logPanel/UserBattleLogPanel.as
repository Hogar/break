/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 25.09.13
 * Time: 15:13
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel {

    import breakdance.BreakdanceApp;
    import breakdance.CurrencyColors;
    import breakdance.battle.controller.IBattleController;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.events.BattleDanceRoutineEvent;
    import breakdance.battle.events.BattleEndEvent;
    import breakdance.battle.events.BattleEvent;
    import breakdance.battle.model.BattleUtils;
    import breakdance.battle.model.IBattle;
    import breakdance.battle.model.IBattlePlayer;
    import breakdance.battle.view.logPanel.selectDanceRoutineBlock.SelectDanceRoutineBlock;
    import breakdance.battle.view.logPanel.selectDanceRoutineBlock.events.SelectDanceRoutineEvent;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.consumables.ConsumableBonusType;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.user.AppUser;

    import com.greensock.TweenLite;
    import com.hogargames.utils.StringUtilities;
    import com.hogargames.utils.TextFieldUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.utils.Timer;

    /**
     * Панель логов танц. движений игрока.
     * Содержит элемент выбора танц. движения.
     */
    public class UserBattleLogPanel extends BattleLogPanel implements ITextContainer {

        private var _controller:IBattleController;//Ссылка на контроллер боя

        private var danceRoutineSelectorBlock:SelectDanceRoutineBlock;//Блок выбора танцю движений для связки
        private var mcUserInfoPanel:Sprite;
        private var tfStaminaAndPointsTitle:TextField;
        private var tfStaminaAndPoints:TextField;
        private var tfDanceRoutineTimeLeftTitle:TextField;
        private var tfDanceRoutineTimeLeft:TextField;
        private var mcArrow:MovieClip;

        //Таймер связки танц. движений.
        private var danceRoutineTimer:Timer = new Timer (1000);//таймер для составления связки
        private var selectFirstDanceRoutineTime:int;//время на составление первой связки танц. движений (в секундах)
        private var selectMoveTime:int;//время на выбор танц. движения при составлении связки (в секундах)
        private var danceRoutineTime:int;//время на составление связки танц. движений (в секундах)
        private var selectAdditionalDanceRoutineTime:int;//время на составление связки в дополнительном раунде
        private var additionalRoundPause:int;//пауза перед началом дополнительного раунда
        private var addStaminaTime:int;//пауза для добавления выносливости

        private var tutorialManager:TutorialManager;
        private var textsManager:TextsManager = TextsManager.instance;

        private static const TWEEN_TIME:Number = .3;
        private static const HIDE_DELAY:Number = 1;

        private static const DANGER_TIME_LEFT:int = 3;
        private static const DANGER_TIME_LEFT_COLOR:uint = 0xff0000;
        private static const NORMAL_TIME_LEFT_COLOR:uint = 0xffffff;

        private static const HIDE_TF_TIMER_TWEEN_TIME:Number = .25;
        private static const HIDE_TF_TIMER_DELAY:Number = .12;
        private static const SHOW_TWEEN_TIME:Number = .25;

        public function UserBattleLogPanel (mc:MovieClip) {
            tutorialManager = TutorialManager.instance;

            super (mc);
            danceRoutineSelectorBlock = new SelectDanceRoutineBlock ();
            danceRoutineSelectorBlock.addEventListener (SelectDanceRoutineEvent.UPDATE_DANCE_ROUTINE, updateDanceDanceRoutineListener);
            danceRoutineSelectorBlock.addEventListener (SelectDanceRoutineEvent.SHOW_RESTORE_STAMINA_POP_UP, showRestoreStaminaPopUpListener);
            danceRoutineSelectorBlock.addEventListener (SelectDanceRoutineEvent.COMPLETE_DANCE_ROUTINE, completeDanceRoutineListener);
            danceRoutineSelectorBlock.addEventListener (SelectDanceRoutineEvent.GO, goListener);
            danceRoutineTimer.addEventListener (TimerEvent.TIMER, timerListener);

            selectFirstDanceRoutineTime = parseInt (StaticData.instance.getSetting ("select_first_dance_routine_time"));
            selectMoveTime = parseInt (StaticData.instance.getSetting ("select_move_time"));
            selectAdditionalDanceRoutineTime = parseInt (StaticData.instance.getSetting ("select_additional_dance_routine_time"));
            additionalRoundPause = parseInt (StaticData.instance.getSetting ("additional_round_pause"));
            addStaminaTime = parseInt (StaticData.instance.getSetting ("add_stamina_time"));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function set battle (value:IBattle):void {
            if (_battle) {
                _battle.removeEventListener (BattleEvent.START_ADDITIONAL_ROUND, startAdditionalTurnListener);
                _battle.removeEventListener (BattleDanceRoutineEvent.BEGIN_BATTLE_DANCE_ROUTINE, beginBattleDanceRoutineListener);
                _battle.removeEventListener (BattleEndEvent.END_BATTLE, battleEndListener);
            }
            super.battle = value;
            if (_battle) {
                _battle.addEventListener (BattleEvent.START_ADDITIONAL_ROUND, startAdditionalTurnListener);
                _battle.addEventListener (BattleDanceRoutineEvent.BEGIN_BATTLE_DANCE_ROUTINE, beginBattleDanceRoutineListener);
                _battle.addEventListener (BattleEndEvent.END_BATTLE, battleEndListener);
            }
            danceRoutineSelectorBlock.battle = value;
        }

        override public function set player (value:IBattlePlayer):void {
            super.player = value;
            danceRoutineSelectorBlock.player = value;
        }

        public function get controller ():IBattleController {
            return _controller;
        }

        public function set controller (value:IBattleController):void {
            _controller = value;
        }

        public function setTexts ():void {
            tfStaminaAndPointsTitle.text = textsManager.getText ("staminaAndPoints");
            tfDanceRoutineTimeLeftTitle.text = textsManager.getText ("danceRoutineTimeLeftTitle");
            if (danceRoutineTimer.running) {
                setTimeLeft (danceRoutineTime - danceRoutineTimer.currentCount);
            }
            else {
                setTimeLeft (0);
            }
        }

        override public function clear ():void {
            danceRoutineSelectorBlock.clear ();
            hideSelectPanel ();
            super.clear ();
        }

        override public function destroy ():void {
            danceRoutineSelectorBlock.removeEventListener (SelectDanceRoutineEvent.UPDATE_DANCE_ROUTINE, updateDanceDanceRoutineListener);
            danceRoutineSelectorBlock.removeEventListener (SelectDanceRoutineEvent.COMPLETE_DANCE_ROUTINE, completeDanceRoutineListener);
            danceRoutineSelectorBlock.removeEventListener (SelectDanceRoutineEvent.GO, goListener);
            danceRoutineSelectorBlock.destroy ();
            danceRoutineSelectorBlock = null;
            super.destroy ();

            textsManager.removeTextContainer (this);
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcUserInfoPanel = getElement ("mcUserInfoPanel");
            tfStaminaAndPointsTitle = getElement ("tfStaminaAndPointsTitle", mcUserInfoPanel);
            tfStaminaAndPoints = getElement ("tfStaminaAndPoints", mcUserInfoPanel);
            tfDanceRoutineTimeLeftTitle = getElement ("tfDanceRoutineTimeLeftTitle", mcUserInfoPanel);
            tfDanceRoutineTimeLeft = getElement ("tfDanceRoutineTimeLeft", mcUserInfoPanel);
            mcArrow = getElement ("mcArrow", mcUserInfoPanel);

            TextFieldUtilities.setBold (tfStaminaAndPoints);
            TextFieldUtilities.setBold (tfDanceRoutineTimeLeft);

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function showSelectPanel ():void {
            if (containsBlock (danceRoutineSelectorBlock)) {
                return;
            }

            setBattleDanceRoutineParams (0, 0);
            TweenLite.killTweensOf (mcUserInfoPanel);
            TweenLite.to (mcUserInfoPanel, TWEEN_TIME, {alpha:1});
            setTimeLeft (0);
            mcArrow.gotoAndPlay (1);
//            trace ("showSelectPanel");

            removeBlock (danceRoutineSelectorBlock);

            if (_battle && _player) {
                if (!containsBlock (danceRoutineSelectorBlock)) {
                    addBlock (danceRoutineSelectorBlock);
                }
                danceRoutineSelectorBlock.init ();
            }
        }

        private function hideSelectPanel (delay:Number = HIDE_DELAY):void {
//            trace ("hideSelectPanel");
            removeBlock (danceRoutineSelectorBlock);
            TweenLite.killTweensOf (mcUserInfoPanel);
            TweenLite.to (mcUserInfoPanel, TWEEN_TIME, {alpha:0, delay:delay});
            danceRoutineTimer.stop ();
        }

        private function setBattleDanceRoutineParams (stamina:int, masteryPoints:int):void {
            tfStaminaAndPoints.htmlText =
            "<b><font color='" + CurrencyColors.STAMINA_COLOR + "'>" + stamina + "</font>" +
            "/" +
            "<font color='" + CurrencyColors.MASTERY_COLOR + "'>" + masteryPoints + "</font></b>";
        }

        private function startDanceRoutineTimer (time:int):void {
            danceRoutineTime = time;
            danceRoutineTimer.reset ();
            danceRoutineTimer.start ();
            setTimeLeft (time);
        }

        private function addDanceRoutineTime (time:int):void {
            danceRoutineTime += time;
            setTimeLeft (danceRoutineTime - danceRoutineTimer.currentCount);
        }

        private function setTimeLeft (value:int):void {
            var strTimeLeft:String = textsManager.getText ("danceRoutineTimeLeftText");
            strTimeLeft = strTimeLeft.replace ("#1", value);
            var suffix:String = "";
            if (textsManager.currentLanguage == TextsManager.EN) {
                suffix = StringUtilities.getEnglishSuffixForNumber (value);
            }
            strTimeLeft = strTimeLeft.replace ("#2", suffix);
            tfDanceRoutineTimeLeft.htmlText = strTimeLeft;
            if (value <= DANGER_TIME_LEFT) {
                tfDanceRoutineTimeLeft.textColor = DANGER_TIME_LEFT_COLOR;
                TweenLite.killTweensOf (tfDanceRoutineTimeLeft);
                TweenLite.to (tfDanceRoutineTimeLeft, HIDE_TF_TIMER_TWEEN_TIME, {alpha:0, onComplete:onHideTfTimer, delay:HIDE_TF_TIMER_DELAY});
            }
            else {
                tfDanceRoutineTimeLeft.textColor = NORMAL_TIME_LEFT_COLOR;
            }
        }

        private function onHideTfTimer ():void {
            TweenLite.to (tfDanceRoutineTimeLeft, SHOW_TWEEN_TIME, {alpha:1, onComplete:onHideTfTimer});
        }

        private function addDanceRoutine ():void {
            if (_controller && _player) {
                var danceRoutine:Vector.<BattleDanceMoveData> = danceRoutineSelectorBlock.danceRoutine;

                //перерасчитываем стабильность:
                for (var i:int = 0; i < danceRoutine.length; i++) {
                    var danceMoveData:BattleDanceMoveData = danceRoutine [i];
                    var appUser:AppUser = BreakdanceApp.instance.appUser;
                    var stabilityBonus:int = 0;
                    if (_player.uid == appUser.uid) {
                        stabilityBonus = appUser.getMaxConsumableBonusValue (ConsumableBonusType.STABILITY);
                    }
                    danceMoveData.calculateStability (stabilityBonus);
                }

                //добавляем связку:
                if (danceRoutineSelectorBlock.round == _battle.numRounds) {
                    _controller.addAdditionalDanceRoutine (danceRoutine, _player.uid);
                }
                else {
                    _controller.addDanceRoutine (danceRoutine, _player.uid);
                }
            }
        }

        private function showAdditionalRoundSelectPanel ():void {
            startDanceRoutineTimer (selectAdditionalDanceRoutineTime);
            showSelectPanel ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        //Начало боя.
        override protected function startBattleListener (event:Event):void {
            super.startBattleListener (event);
            if (tutorialManager.currentStep != TutorialStep.BATTLE_START) {
                startDanceRoutineTimer (selectFirstDanceRoutineTime);
            }
            showSelectPanel ();
        }

        //Добавление новой связки.
        override protected function addBattleDanceRoutineListener (event:BattleDanceRoutineEvent):void {
            super.addBattleDanceRoutineListener (event);
            if (_battle) {
                if (_player) {
                    if (_player.uid == event.uid) {
                        hideSelectPanel ();//Скрываем панель выбора свзки, если мы добавили связку.
                    }
                }
            }
        }

        //Начало новой связки.
        private function beginBattleDanceRoutineListener (event:BattleDanceRoutineEvent):void {
            if (_battle) {
                var playerUid:String = event.uid;
                if (_player) {
                    if (_player.uid != playerUid) {//Если ходит противник
                        var danceRoutineCount:int = BattleUtils.getDanceRoutinesCount (_battle, _player.uid);
                        if (danceRoutineCount < _battle.numRounds) {//Если ещё можно добавить связку.
                            var extraTime:int = BattleUtils.getPlayerWasUsingOriginalMove (_battle, _player.uid) ? 0 : 1;
                            startDanceRoutineTimer (selectMoveTime * (_battle.maxDanceMoves  + extraTime));
                            showSelectPanel ();//Показываем панель выбора связки
                        }
                    }
                }
            }
        }

        private function timerListener (event:TimerEvent):void {
            var timeLeft:int = danceRoutineTime - danceRoutineTimer.currentCount;
            setTimeLeft (timeLeft);
            if (timeLeft == 0) {
                danceRoutineTimer.stop ();
                hideSelectPanel ();
                if (_battle && _player) {
                    var danceRoutineCount:int = BattleUtils.getDanceRoutinesCount (_battle, _player.uid);
                    if (danceRoutineCount == 0) {//Для первой связки:
                        if (danceRoutineSelectorBlock.danceRoutine.length > 0) {
                            //Принудительное добавление связки, в которой есть хоть одно движение:
                            addDanceRoutine ();
                        }
                        else {
                            //Автопоражение из-за торможения (не выбрали ни одного движения).
                            if (_controller) {
                                _controller.surrender ();
                            }
                        }
                    }
                    else {
                        //Принудительное добавление связки:
                        addDanceRoutine ();
                    }
                }
            }
        }

        private function showRestoreStaminaPopUpListener (event:SelectDanceRoutineEvent):void {
            addDanceRoutineTime (addStaminaTime);
        }

        private function updateDanceDanceRoutineListener (event:SelectDanceRoutineEvent):void {
            var stamina:int = 0;
            var masteryPoints:int = 0;
            var danceRoutine:Vector.<BattleDanceMoveData> = danceRoutineSelectorBlock.danceRoutine;
            if (danceRoutine) {
                for (var i:int = 0; i < danceRoutine.length; i++) {
                    var battleDanceMoveData:BattleDanceMoveData = danceRoutine [i];
                    stamina += battleDanceMoveData.stamina;
                    masteryPoints += battleDanceMoveData.masteryPoints;
                }
            }
            setBattleDanceRoutineParams (stamina, masteryPoints);
        }

        private function completeDanceRoutineListener (event:SelectDanceRoutineEvent):void {
            if (_battle && _player) {
                var danceRoutinesCount:int = BattleUtils.getDanceRoutinesCount (_battle, _player.uid);
                if (
                        (danceRoutinesCount != 0) &&//Связка подготавливается не для первого раунда.
                        (!_battle.currentRoundIsAdditional)//Связка подготавливается не для дополнительного раунда.
                ) {
                    addDanceRoutine ();
                }
            }
        }

        private function goListener (event:SelectDanceRoutineEvent):void {
            if (_controller && _player) {
                addDanceRoutine ();
            }
        }

        private function battleEndListener (event:BattleEndEvent):void {
            hideSelectPanel ();
        }

        //Начало дополнительного тура.
        private function startAdditionalTurnListener (event:BattleEvent):void {
            hideSelectPanel (0);
            TweenLite.delayedCall (additionalRoundPause, showAdditionalRoundSelectPanel);
        }

    }
}
