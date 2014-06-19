/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 15:37
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view {

    import breakdance.BreakdanceApp;
    import breakdance.battle.BattleManager;
    import breakdance.battle.controller.ControllerType;
    import breakdance.battle.controller.IBattleController;
    import breakdance.battle.events.BattleDanceRoutineEvent;
    import breakdance.battle.events.BattleEndEvent;
    import breakdance.battle.events.BattleEvent;
    import breakdance.battle.events.ProcessBattleDanceMoveEvent;
    import breakdance.battle.model.AdditionalDanceRoutinesStack;
    import breakdance.battle.model.Battle;
    import breakdance.battle.model.BattleDanceMove;
    import breakdance.battle.model.BattlePlayer;
    import breakdance.battle.model.BattleResultType;
    import breakdance.battle.model.BattleUtils;
    import breakdance.battle.model.DanceRoutinesStack;
    import breakdance.battle.model.IBattle;
    import breakdance.battle.model.UserBattleResultInfo;
    import breakdance.core.server.ServerApi;
    import breakdance.core.sound.SoundManager;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.Screen;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.socketServer.SocketServerManager;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.commons.BaseInfoMessage;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.commons.buttons.DebugButton;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.popups.battlePopUp.BattleDefeatPopUp;
    import breakdance.ui.popups.battlePopUp.BattleWinPopUp;
    import breakdance.ui.popups.battlePopUp.IBattlePopUp;
    import breakdance.user.AppUser;
    import breakdance.user.UserLevel;
    import breakdance.user.UserLevelCollection;
	import breakdance.data.achievements.NameAchievements;

    import com.greensock.TweenLite;
    import com.hogargames.utils.TextFieldUtilities;

    import flash.display.FrameLabel;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.utils.Timer;

    public class BattleScreen extends Screen implements ITextContainer, IBattleView {

        private var _battle:IBattle;//Ссылка на модель.
        private var _controller:IBattleController;//Ссылка на контроллер боя.

        private var mcInfoPanel:Sprite;
        private var mcCenterPanel:Sprite;
        private var mcArrow1:MovieClip;
        private var mcArrow2:MovieClip;
        private var mcAutoBattle:Sprite;
        private var tfTimer:TextField;

        private var additionRoundMessage:BaseInfoMessage;

        private var playerView1:UserBattlePlayerView;
        private var playerView2:BattlePlayerView;

        private var danceMoviePlayer:DanceMoviePlayer;

        private var btnSurrender:ButtonWithText;
        private var btnAutoBattle:ButtonWithText;

        private var battleTimer:Timer = new Timer (1000);//таймер боя.
        private var battleTime:int;//время на бой.
        private var selectAdditionalDanceRoutineTimer:Timer = new Timer (1000);//таймер составления связки доп. тура.
        private var selectAdditionalDanceRoutineTime:int;//время на составление связки в дополнительном раунде.
        private var additionalRoundPause:int;//пауза перед началом дополнительного раунда.

        private var lock:Boolean = false;//Блокировка наступает при отображении анимации, связанной с отображением движения.
        private var userBattleResultInfo:UserBattleResultInfo;//Результат боя.

        private var numShowAnimationFrame:int;

        private var appUser:AppUser;
        private var textsManager:TextsManager = TextsManager.instance;
        private var tutorialManager:TutorialManager;

        CONFIG::debug {
            private var btnWin:DebugButton;
        }

        private static const DANGER_TIME_LEFT:int = 10;
        private static const DANGER_TIME_LEFT_COLOR:uint = 0xff0000;
        private static const NORMAL_TIME_LEFT_COLOR:uint = 0xffffff;

        private static const TIE:String = "TIE";
        private static const GO:String = "Go!";

        private static const HIDE_FRAME:String = "hide";

        private static const SHOW_POP_UP_DELAY:Number = 1.2;

        private static const HIDE_TWEEN_TIME:Number = .3;
        private static const SHOW_TWEEN_TIME:Number = .3;

        public function BattleScreen () {
            appUser = BreakdanceApp.instance.appUser;
            tutorialManager = TutorialManager.instance;
            super (Template.createSymbol (Template.BATTLE_SCREEN));
			// gray_crow  			
			// время брать на одно движение и умножать его на (кол-во выходов* кол-во движений)
			//battleTime = parseInt (StaticData.instance.getSetting ("battle_time_motion")); * _battle.numRounds * _battle.maxDanceMoves;			
			// какое-то начальное время (пока что )
			battleTime = parseInt (StaticData.instance.getSetting ("battle_time"));             
//            CONFIG::debug {
//                battleTime -= 70;
//            }
            selectAdditionalDanceRoutineTime = parseInt (StaticData.instance.getSetting ("select_additional_dance_routine_time"));
            additionalRoundPause = parseInt (StaticData.instance.getSetting ("additional_round_pause"));
            addEventListener (Event.ENTER_FRAME, enterFrameListener);
            battleTimer.addEventListener (TimerEvent.TIMER, mainBattleTimerListener);
            selectAdditionalDanceRoutineTimer.addEventListener (TimerEvent.TIMER, additionalTurnTimerListener);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Ссылка на модель.
         */
        public function get battle ():IBattle {
            return _battle;
        }

        /**
         * @inheritDoc
         */
        public function set battle (value:IBattle):void {
            if (_battle) {
                _battle.removeEventListener (BattleEvent.READY_TO_NEXT_MOVE, readyToNextMoveListener);
                _battle.removeEventListener (BattleEvent.START_BATTLE, startBattleListener);
                _battle.removeEventListener (BattleEvent.START_ADDITIONAL_ROUND, startAdditionalRoundListener);
                _battle.removeEventListener (BattleEvent.PROCESS_FAILURE, processFailureListener);
                _battle.removeEventListener (ProcessBattleDanceMoveEvent.BATTLE_DANCE_MOVE_WAS_PROCESSED, battleDanceMoveWasProcessedListener);
                _battle.removeEventListener (BattleEndEvent.END_BATTLE, endBattleListener);
                _battle.removeEventListener (BattleDanceRoutineEvent.ADD_BATTLE_DANCE_ROUTINE, addBattleDanceRoutineListener);
                _battle.removeEventListener (BattleDanceRoutineEvent.BEGIN_BATTLE_DANCE_ROUTINE, beginBattleDanceRoutineListener);
            }
            _battle = value;
            if (_battle){
                _battle.addEventListener (BattleEvent.READY_TO_NEXT_MOVE, readyToNextMoveListener);
                _battle.addEventListener (BattleEvent.START_BATTLE, startBattleListener);
                _battle.addEventListener (BattleEvent.START_ADDITIONAL_ROUND, startAdditionalRoundListener);
                _battle.addEventListener (BattleEvent.PROCESS_FAILURE, processFailureListener);
                _battle.addEventListener (ProcessBattleDanceMoveEvent.BATTLE_DANCE_MOVE_WAS_PROCESSED, battleDanceMoveWasProcessedListener);
                _battle.addEventListener (BattleEndEvent.END_BATTLE, endBattleListener);
                _battle.addEventListener (BattleDanceRoutineEvent.ADD_BATTLE_DANCE_ROUTINE, addBattleDanceRoutineListener);
                _battle.addEventListener (BattleDanceRoutineEvent.BEGIN_BATTLE_DANCE_ROUTINE, beginBattleDanceRoutineListener);
            }
            if (_battle && _battle.player1 && _battle.player2) {
                var player:BattlePlayer;
                var enemy:BattlePlayer;
                if (_battle.player1.uid == appUser.uid) {
                    player = _battle.player1;
                    enemy = _battle.player2;
                }
                else {
                    player = _battle.player2;
                    enemy = _battle.player1;
                }
                playerView1.player = player;
                playerView2.player = enemy;
            }
            else {
                playerView1.player = null;
                playerView2.player = null;
            }
            playerView1.battle = _battle;
            playerView2.battle = _battle;
        }

        /**
         * Ссылка на контроллер боя.
         */
        public function get controller ():IBattleController {
            return _controller;
        }

        /**
         * @inheritDoc
         */
        public function set controller (value:IBattleController):void {
            _controller = value;
            playerView1.controller = _controller;
        }

        override public function onShow ():void {
            super.onShow ();
            mc.gotoAndPlay (1);
            lock = false;
            btnSurrender.enable = true;
            SoundManager.instance.playMusic (Template.SND_BATTLE);
            if (tutorialManager.currentStep == TutorialStep.BATTLE_START) {
                btnSurrender.enable = false;
            }
            else {
                btnSurrender.enable = true;
            }
        }

        override public function onHide ():void {
//            SoundManager.instance.playMusic (Template.SND_MAIN_THEME);
            SoundManager.instance.playRadio ();
        }

        public function setTexts ():void {
            btnSurrender.text = textsManager.getText ("surrender");
            btnAutoBattle.text = textsManager.getText ("autoBattle");
            additionRoundMessage.setMessage (textsManager.getText ("additionalRound_2"));
        }

        override public function destroy ():void {
            if (btnSurrender) {
                btnSurrender.removeEventListener (MouseEvent.CLICK, clickListener);
                btnSurrender.destroy ();
                btnSurrender = null;
            }

            if (danceMoviePlayer) {
                danceMoviePlayer.destroy ();
                danceMoviePlayer = null;
            }
            if (btnAutoBattle) {
                btnAutoBattle.removeEventListener (MouseEvent.CLICK, clickListener);
                btnAutoBattle.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnAutoBattle.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btnAutoBattle.destroy ();
                btnAutoBattle = null;
            }

            textsManager.removeTextContainer (this);

            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcInfoPanel = getElement ('mcInfoPanel');
            mcCenterPanel = getElement ('mcCenterPanel');
            mcArrow1 = getElement ('mcArrow1', mcCenterPanel);
            mcArrow2 = getElement ('mcArrow2', mcCenterPanel);
            var mcAdditionRoundMessage:MovieClip = getElement ("mcAdditionRoundMessage");
            additionRoundMessage = new BaseInfoMessage (mcAdditionRoundMessage ["mcAdditionRoundMessage"]);
            mcAutoBattle = getElement ("mcAutoBattle", mcCenterPanel);
            tfTimer = getElement ("tfTimer", mcInfoPanel);

            additionRoundMessage.hide ();

            TextFieldUtilities.setBold (tfTimer);

            btnAutoBattle = new ButtonWithText (mcAutoBattle ["btnAutoBattle"], false);
            btnAutoBattle.addEventListener (MouseEvent.CLICK, clickListener);
            btnAutoBattle.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnAutoBattle.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            btnSurrender = new ButtonWithText (mcCenterPanel ['btnSurrender']);
            btnSurrender.addEventListener (MouseEvent.CLICK, clickListener);

            playerView1 = new UserBattlePlayerView (
                    mcInfoPanel ['mcPlayerInfo1'],
                    mc ['mcAvatarContainer1']['mcAvatarContainer'],
                    mc ['mcPlayerName1']['tfPlayerName'],
                    mc ['mcPlayerLogContainer1'] ['mcPlayerLogContainer'],
                    mc ['mcRoundsIndicator'] ['mcRoundsIndicator1']
            );
            playerView2 = new BattlePlayerView (
                    mcInfoPanel ['mcPlayerInfo2'],
                    mc ['mcAvatarContainer2']['mcAvatarContainer'],
                    mc ['mcPlayerName2'] ['tfPlayerName'],
                    mc ['mcPlayerLogContainer2'] ['mcPlayerLogContainer'],
                    mc ['mcRoundsIndicator'] ['mcRoundsIndicator2']
            );
            danceMoviePlayer = new DanceMoviePlayer (mc ['mcVideoDummy']);

            var labels:Array = mc.currentLabels;
            for (var i:int = 0; i < labels.length; i++) {
                var label:FrameLabel = labels [i];
                if (label.name == HIDE_FRAME) {
                    numShowAnimationFrame = label.frame;
                }
            }

            CONFIG::debug {
                btnWin = new DebugButton ("ПОБЕДИТЬ");
                btnWin.x = 650;
                btnWin.y = 450;
                addChild (btnWin);
                btnWin.addEventListener (MouseEvent.CLICK, clickListener_win);
            }

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function endBattle ():void {
            if (_battle && userBattleResultInfo) {
                var bet:int = _battle.bet;
                var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (_battle, appUser.uid);
                switch (userBattleResultInfo.battleResult) {
                    case BattleResultType.LOSE:
                        lose ();
                        break;
                    case BattleResultType.SURRENDER:
                        lose ();
                        if (_controller && (_controller.type == ControllerType.PVP)) {
                            SocketServerManager.instance.cancelBattle (opponent.uid);
                        }
                        break;
                    case BattleResultType.WIN:
                    case BattleResultType.OPPONENT_SURRENDER:
                        win ();
                        break;
                    case BattleResultType.TIE:
                        tie ();
                        break;
                }
                if (_controller.type == ControllerType.PVP) {
                    SocketServerManager.instance.endBattle (opponent.uid, userBattleResultInfo);
                }
                userBattleResultInfo = null;
                SoundManager.instance.playVoice (Template.SND_VOICE_BATTLE_END);
                battleTimer.stop ();
                selectAdditionalDanceRoutineTimer.stop ();
                mc.gotoAndPlay (HIDE_FRAME);
                playerView1.deselectAll ();
                playerView2.deselectAll ();
                BattleManager.instance.endCurrentBattle ();
            }
        }

        private function lose ():void {
            if (_battle) {
                var bet:int = _battle.bet;
                var battleDefeatPopUp:BattleDefeatPopUp = PopUpManager.instance.battleDefeatPopUp;
                battleDefeatPopUp.setCoins (bet);
                TweenLite.delayedCall (SHOW_POP_UP_DELAY, openPopUp, [battleDefeatPopUp]);
                if (_controller && _controller.type == ControllerType.LOCAL) {
                    ServerApi.instance.query (ServerApi.BATTLE_LOSE, { bet:bet }, onBattleLose);
					// добавить ачивку 
					ServerApi.instance.query (ServerApi.SET_ACHIEVEMENT_ADD, { achievement_id:NameAchievements.ACH_ACCEPT_DEFEAT }, onGiveAchievement);	
					// добавить ачивку 
					ServerApi.instance.query (ServerApi.SET_ACHIEVEMENT_ADD, { achievement_id:NameAchievements.ACH_FIGHTER}, onGiveAchievement);	
                }
            }
        }

        private function onBattleLose (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (response.response_code == 1) {
                appUser.onResponseWithUpdateUserData (response);
            }
        }

        private function win ():void {
            if (_battle) {
                var bet:int = _battle.bet;
                var opponent:BattlePlayer = BattleUtils.getBattlePlayerOpponent (_battle, appUser.uid);
                var battleWinPopUp:BattleWinPopUp = PopUpManager.instance.battleWinPopUp;
                battleWinPopUp.setCoins (bet);
                TweenLite.delayedCall (SHOW_POP_UP_DELAY, openPopUp, [battleWinPopUp]);
                if (_controller && _controller.type == ControllerType.LOCAL) {
                    TransactionOverlay.instance.show ();
                    ServerApi.instance.query (ServerApi.BATTLE_WIN, {bet:bet}, onBattleWin);
                }
                else {
                    if (opponent) {
                        TransactionOverlay.instance.show ();
                        ServerApi.instance.query (ServerApi.BATTLE_WIN, { opponent:opponent.uid , bet:bet }, onBattleWin);
						// добавить ачивку 
						ServerApi.instance.query (ServerApi.SET_ACHIEVEMENT_ADD, { achievement_id:NameAchievements.ACH_WINNER }, onGiveAchievement);	
						ServerApi.instance.query (ServerApi.SET_ACHIEVEMENT_ADD, { achievement_id:NameAchievements.ACH_FIGHTER}, onGiveAchievement);	
                    }
                }
            }
        }
		
		private function onGiveAchievement (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (response.response_code == 1) {
                appUser.onGiveAchievement (response);
				// если пришла награда - выдача окна награды
            }
        }		

        private function onBattleWin (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (response.response_code == 1) {
                appUser.onBattleWin (response);
            }
        }

        private function tie ():void {
            if (_battle) {
                TweenLite.delayedCall (SHOW_POP_UP_DELAY, openPopUp, [PopUpManager.instance.battleTiePopUp]);
            }
            TransactionOverlay.instance.show ();
            ServerApi.instance.query (ServerApi.BATTLE_DRAW, { }, onBattleDraw);
			// добавить ачивку 
			ServerApi.instance.query (ServerApi.SET_ACHIEVEMENT_ADD, { achievement_id:NameAchievements.ACH_OPPONENT }, onGiveAchievement);	
			ServerApi.instance.query (ServerApi.SET_ACHIEVEMENT_ADD, { achievement_id:NameAchievements.ACH_FIGHTER}, onGiveAchievement);	
        }

        private function onBattleDraw (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (response.response_code == 1) {
                appUser.onBattleDraw (response);
            }
        }

        private function openPopUp (popUp:IBattlePopUp):void {
            popUp.battle = _battle;
            popUp.show ();
        }

        private function onShowMovie ():void {
            lock = false;
            if (userBattleResultInfo) {
                endBattle ();
            }
            else {
                if (_controller) {
                    _controller.processNextDanceMove ();
                }
            }
        }

        private function setTimeLeft (value:int, withDangerTime:Boolean = true):void {
            tfTimer.text = String (value);
            if (withDangerTime) {
                if (value <= DANGER_TIME_LEFT) {
                    tfTimer.textColor = DANGER_TIME_LEFT_COLOR;
                    TweenLite.to (tfTimer, HIDE_TWEEN_TIME, {alpha:0, onComplete:onHideTfTimer});
                }
                else {
                    tfTimer.textColor = NORMAL_TIME_LEFT_COLOR;
                }
            }
            else {
                tfTimer.textColor = NORMAL_TIME_LEFT_COLOR;
            }
        }

        private function onHideTfTimer ():void {
            TweenLite.to (tfTimer, SHOW_TWEEN_TIME, {alpha:1, onComplete:onHideTfTimer});
        }

        private function highlightSameDanceMoves (danceMoveType:DanceMoveType):void {
            playerView1.highlightSameDanceMoves (danceMoveType);
            playerView2.highlightSameDanceMoves (danceMoveType);
        }

        //Начало отсчёта для составления связки дополнительного раунда:
        private function startAdditionalDanceRoutineTimer ():void {
            selectAdditionalDanceRoutineTimer.reset ();
            selectAdditionalDanceRoutineTimer.start ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btnSurrender:
                    onSurrenderClick ();
                    break;
                case btnAutoBattle:
//                    btnAutoBattle.selected = !btnAutoBattle.selected;
                    break;
            }
        }

        CONFIG::debug {
            private function clickListener_win (event:MouseEvent):void {
                if (_battle) {
                    Battle (_battle).autoWin ();
                }
            }
        }

        private function rollOverListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btnAutoBattle:
                    BreakdanceApp.instance.showTooltipMessage (textsManager.getText ("comingSoon"));
                    break;
            }
        }

        private function rollOutListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btnAutoBattle:
                    BreakdanceApp.instance.hideTooltip ();
                    break;
            }
        }

        private function onSurrenderClick ():void {
            if (_controller) {
                _controller.surrender ();
                btnSurrender.enable = false;
            }
        }

        private function readyToNextMoveListener (event:BattleEvent):void {
            if (!lock) {
                controller.processNextDanceMove ();
            }
        }

        private function processFailureListener (event:BattleEvent):void {
            if (!lock) {
                danceMoviePlayer.showStandMove ();
            }
        }

        //Отображение обработки следующего танц. движения.
        private function battleDanceMoveWasProcessedListener (event:ProcessBattleDanceMoveEvent):void {
            if (_battle) {
                var playerUid:String = event.uid;
                var userBattlePlayerView:BattlePlayerView;
                if (playerView1.player && playerView1.player.uid == playerUid) {
                    userBattlePlayerView = playerView1;
                }
                else if (playerView2.player && playerView2.player.uid == playerUid) {
                    userBattlePlayerView = playerView2;
                }
                if (userBattlePlayerView) {
                    var danceMove:BattleDanceMove = event.danceMove;
                    if (danceMove) {
                        danceMoviePlayer.showMove (danceMove.type, onShowMovie);
                        lock = true;
                    }
                    else {
                        danceMoviePlayer.showStandMove (-1, onShowMovie);
                    }
                }
                if (event.danceMove) {
                    if (event.danceMove.repeat > 0) {
                        highlightSameDanceMoves (event.danceMove.getDanceMoveType ());
                    }
                }
            }
        }

        //Начало боя.
        private function startBattleListener (event:BattleEvent):void {			
            if (tutorialManager.currentStep != TutorialStep.BATTLE_START) {
                SoundManager.instance.playVoice (Template.SND_VOICE_BATTLE_BEGIN);
            }
            SoundManager.instance.playSound (Template.SND_PRE_BATTLE);
			
			// gray_crow  время брать на одно движение и умножать его на (кол-во выходов* кол-во движений)
			if (_battle) {
				trace('BattleScreen :startBattleListener :  кол-во выходов '+_battle.numRounds +'   '+ _battle.maxDanceMoves)
				battleTime = parseInt (StaticData.instance.getSetting ("battle_time_motion")) * _battle.numRounds * _battle.maxDanceMoves;
			}	
			
            battleTimer.reset ();
            battleTimer.start ();			
            tfTimer.text = String (battleTime);
            userBattleResultInfo = null;
            mcArrow1.visible = false;
            mcArrow2.visible = false;
            danceMoviePlayer.showStandMove ();
        }

        //Начало дополнительного тура.
        private function startAdditionalRoundListener (event:BattleEvent):void {
            additionRoundMessage.show ();
            SoundManager.instance.playSound (Template.SND_PRE_BATTLE);
            battleTimer.stop ();
            TweenLite.delayedCall (additionalRoundPause, startAdditionalDanceRoutineTimer);
            tfTimer.text = TIE;
            tfTimer.textColor = NORMAL_TIME_LEFT_COLOR;
            userBattleResultInfo = null;
//            danceMoviePlayer.showStandMove ();
            lock = false;
        }

        //Окончание боя.
        private function endBattleListener (event:BattleEndEvent):void {
            mcArrow1.visible = false;
            mcArrow2.visible = false;
            if (_battle) {
                userBattleResultInfo = event.userBattleResultInfo;
                if (!lock) {
                    endBattle ();
                }
                else {
                    if (userBattleResultInfo) {
                        if (userBattleResultInfo.battleResult == BattleResultType.SURRENDER) {
                            endBattle ();
                            userBattleResultInfo = null;
                        }
                    }
                }

            }
        }

        //Добавление связки. Если добавили связку для доп. тура, то скрываем таймер составления связки для доп тура.
        private function addBattleDanceRoutineListener (event:BattleDanceRoutineEvent):void {
            if (_battle) {
                var uid:String = event.uid;
                if (appUser.uid == uid) {
                    if (_battle) {
                        var additionalStack:AdditionalDanceRoutinesStack = BattleUtils.getAdditionalDanceRoutineStack (_battle, uid);
                        if (additionalStack) {
                            if (additionalStack.getAdditionDanceRoutine () != null) {
                                selectAdditionalDanceRoutineTimer.stop ();
                                tfTimer.text = GO;
                                tfTimer.textColor = NORMAL_TIME_LEFT_COLOR;
                            }
                        }
                    }
                }
            }
        }

        //Начало отображения связки.
        private function beginBattleDanceRoutineListener (event:BattleDanceRoutineEvent):void {
            mcArrow1.visible = false;
            mcArrow2.visible = false;
            if (_battle) {
                var uid:String = event.uid;
                var stack:DanceRoutinesStack = BattleUtils.getDanceRoutineStack (_battle, uid);
                var additionalStack:AdditionalDanceRoutinesStack = BattleUtils.getAdditionalDanceRoutineStack (_battle, uid);
                if (appUser.uid == uid) {
                    mcArrow1.visible = true;
                    mcArrow1.gotoAndPlay (1);
                }
                else {
                    mcArrow2.visible = true;
                    mcArrow2.gotoAndPlay (1);
                }
                if (additionalStack) {
                    if (appUser.uid == uid) {
                        mcArrow1.visible = true;
                        mcArrow1.gotoAndStop (1);
                        if (_battle) {
                            if (additionalStack.getAdditionDanceRoutine () != null) {
                                selectAdditionalDanceRoutineTimer.stop ();
                                tfTimer.text = GO;
                                tfTimer.textColor = NORMAL_TIME_LEFT_COLOR;
                            }
                        }
                    }
                }
                if (stack == _battle.danceRoutinesStack1) {
                    if (_battle.currentRound == 0) {
                        SoundManager.instance.playVoice (Template.SND_VOICE_BATTLE_GO);
                    }
                    else if (_battle.currentRound == _battle.numRounds - 1) {
                        SoundManager.instance.playVoice (Template.SND_VOICE_BATTLE_LAST_ROUND);
                    }
                    else if (_battle.currentRound == _battle.numRounds) {
                        SoundManager.instance.playVoice (Template.SND_VOICE_BATTLE_ADDITIONAL_ROUND);
                    }
                    else if (_battle.currentRound == 1) {
                        SoundManager.instance.playVoice (Template.SND_VOICE_BATTLE_ROUND_2);
                    }
                    else if (_battle.currentRound == 2) {
                        SoundManager.instance.playVoice (Template.SND_VOICE_BATTLE_ROUND_3);
                    }
                }
            }
        }

        //Таймер для основного боя (без доп. раунда)
        private function mainBattleTimerListener (event:TimerEvent):void {
            var userLevel:UserLevel = UserLevelCollection.instance.getUserLevel (appUser.level);
            var additionalTimeBattle:int = 0;
            if (userLevel) {
                additionalTimeBattle = appUser.level;
            }
            var timeLeft:int = battleTime + additionalTimeBattle - battleTimer.currentCount;
            setTimeLeft (timeLeft);
            if (timeLeft == 0) {
                battleTimer.stop ();
                tfTimer.text = "";
                tfTimer.textColor = NORMAL_TIME_LEFT_COLOR;
                if (_controller) {
                    _controller.timeIsUp ();
                }
            }
        }

        //Таймер для составления связки.
        private function additionalTurnTimerListener (event:TimerEvent):void {
            var timeLeft:int = selectAdditionalDanceRoutineTime - selectAdditionalDanceRoutineTimer.currentCount;
            setTimeLeft (timeLeft, false);
            if (timeLeft == 0) {
                selectAdditionalDanceRoutineTimer.stop ();
                tfTimer.text = GO;
                tfTimer.textColor = NORMAL_TIME_LEFT_COLOR;
            }
        }

        private function enterFrameListener (event:Event):void {
            if (mc.currentFrame == Math.round (numShowAnimationFrame / 2)) {
                if (_battle) {
                    if (tutorialManager.currentStep != TutorialStep.BATTLE_START) {
                        SoundManager.instance.playVoice (Template.SND_VOICE_BATTLE_BEGIN + (_battle.numRounds));
                    }
                }
            }
            else if (mc.currentFrame == numShowAnimationFrame - 2) {
                if (_controller && (_controller.type == ControllerType.PVP)) {
                    if (tutorialManager.currentStep != TutorialStep.BATTLE_START) {
                        SoundManager.instance.playVoice (Template.SND_VOICE_BATTLE_WHO_BEGINS);
                    }
                }
            }
        }

    }
}