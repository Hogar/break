package breakdance.ui.screens.guessMoveGameScreen {

    import breakdance.BreakdanceApp;
    import breakdance.MiniGames;
    import breakdance.battle.view.DanceMoviePlayer;
    import breakdance.core.server.ServerApi;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.ScreenWithHide;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.Button;
    import breakdance.ui.popups.GuessMoveGameResultPopUp;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.ui.screenManager.events.ScreenManagerEvent;
    import breakdance.ui.screens.guessMoveGameScreen.events.SelectDanceMoveTypeEvent;

    import com.greensock.TweenLite;
    import com.greensock.easing.Linear;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.utils.Timer;
	import breakdance.data.achievements.NameAchievements;

    public class GuessMoveGameScreen extends ScreenWithHide implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        public var animationCount:int = 1;
        private var danceMoviePlayer:DanceMoviePlayer;
        private var btnReplay:Button;
        private var btnExit:Button;
        private var tfTitle:TextField;
        private var tfTimer:TextField;
        private var mcProgressBar:MovieClip;
        private var tfPoints:TextField;
        private var tfRecordTitle:TextField;
        private var tfRecord:TextField;
        private var guessMovesList:GuessMovesList;
        private var numQuestions:int;
        private var gameTime:int;
        private var preGameTimer:Timer;
        private var gameTimer:Timer;
        private var danceMoveTypesList:Vector.<DanceMoveType>;
        private var currentQuestion:int = 0;
        private var trueAnswers:int = 0;
        private var gameOver:Boolean = true;

        private static const POSITION_POINT_X:int = 15;
        private static const POSITION_POINT_Y:int = 15;
        private static const NEXT_QUESTION_DELAY:Number = 0.6;
        private static const DANGER_TIME_LEFT:int = 5;
        private static const DANGER_TIME_LEFT_COLOR:uint = 16711680;
        private static const NORMAL_TIME_LEFT_COLOR:uint = 16777215;
        private static const HIDE_TWEEN_TIME:Number = 0.3;
        private static const SHOW_TWEEN_TIME:Number = 0.3;
        private static const PRE_GAME_TIME:Number = 3;
        private static const GO:String = "Go!";

        public function GuessMoveGameScreen () {
            preGameTimer = new Timer (1000);
            gameTimer = new Timer (1000);
            super (Template.createSymbol (Template.GUESS_MOVE_GAME_SCREEN));
            numQuestions = parseInt (StaticData.instance.getSetting ("guess_move_game_num_questions"));
            gameTime = parseInt (StaticData.instance.getSetting ("guess_move_game_time"));
            gameTimer.addEventListener (TimerEvent.TIMER, mainGameTimerListener);
            preGameTimer.addEventListener (TimerEvent.TIMER, preGameTimerListener);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function onShow ():void {
            super.onShow ();
            startGame ();

        }

        override public function onHide ():void {
            super.onHide ();
            var guessMoveGameResultPopUp:GuessMoveGameResultPopUp = PopUpManager.instance.guessMoveGameResultPopUp;
            guessMoveGameResultPopUp.hide ();
            stopGame ();
        }

        public function setTexts ():void {
            tfTitle.text = textsManager.getText ("guessMovement");
            tfRecordTitle.text = textsManager.getText ("yourRecord");

        }

        override public function destroy ():void {
            if (guessMovesList) {
                guessMovesList.removeEventListener (SelectDanceMoveTypeEvent.SELECT_DANCE_MOVE_TYPE, selectDanceMoveTypeListener);
                guessMovesList.destroy ();
                guessMovesList = null;
            }
            if (btnReplay) {
                btnReplay.removeEventListener (MouseEvent.CLICK, clickListener);
                btnReplay.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnReplay.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btnReplay.destroy ();
                btnReplay = null;
            }
            if (btnExit) {
                btnExit.removeEventListener (MouseEvent.CLICK, clickListener);
                btnExit.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnExit.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btnExit.destroy ();
                btnExit = null;
            }
            ScreenManager.instance.removeEventListener (ScreenManagerEvent.REINIT, reIntListener);
            super.destroy ();

        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            var mcTopPanel:Sprite = getElement ("mcTopPanel");
            tfTitle = getElement ("tfTitle", mcTopPanel);
            tfTimer = getElement ("tfTimer", mcTopPanel);
            var mcProgressBarContainer:Sprite = getElement ("mcProgressBar", mcTopPanel);
            tfPoints = getElement ("tfPoints", mcProgressBarContainer);
            mcProgressBar = getElement ("mcProgressBar", mcProgressBarContainer);
            var mcRecord:Sprite = getElement ("mcRecord");
            tfRecordTitle = getElement ("tfRecordTitle", mcRecord);
            tfRecord = getElement ("tfRecord", mcRecord);
            guessMovesList = new GuessMovesList (mc["mcGuessMovesList"]["mcGuessMovesList"]);
            guessMovesList.addEventListener (SelectDanceMoveTypeEvent.SELECT_DANCE_MOVE_TYPE, selectDanceMoveTypeListener);
            btnReplay = new Button (mc["mcBtnReplay"]["btnReplay"]);
            btnExit = new Button (mc["mcBtnExit"]["btnExit"]);
            danceMoviePlayer = new DanceMoviePlayer (getElement ("mcVideoDummy"));
            btnReplay.addEventListener (MouseEvent.CLICK, clickListener);
            btnReplay.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnReplay.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            btnExit.addEventListener (MouseEvent.CLICK, clickListener);
            btnExit.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnExit.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            mc.addEventListener (Event.ENTER_FRAME, enterFrameListener);
            mc.stop ();
            ScreenManager.instance.addEventListener (ScreenManagerEvent.REINIT, reIntListener);
            textsManager.addTextContainer (this);

        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private static function getRandomMoveTypesVector (moveTypesVector:Vector.<DanceMoveType>):Vector.<DanceMoveType> {
            moveTypesVector = moveTypesVector.concat ();
            var numDanceTypeMoves:int = moveTypesVector.length;
            var randomMoveTypesVector:Vector.<DanceMoveType> = new Vector.<DanceMoveType>;
            while (randomMoveTypesVector.length < numDanceTypeMoves) {
                var randomIndex:int = Math.round (Math.random () * (moveTypesVector.length - 1));
                var randomDanceMoveType:DanceMoveType = moveTypesVector[randomIndex];
                if (randomMoveTypesVector.indexOf (randomDanceMoveType) == -1) {
                    randomMoveTypesVector.push (randomDanceMoveType);
                    moveTypesVector.splice (randomIndex, 1);
                }
            }
            return randomMoveTypesVector;
        }

        private function startGame ():void {
            var guessMoveGameResultPopUp:GuessMoveGameResultPopUp = PopUpManager.instance.guessMoveGameResultPopUp;
            guessMoveGameResultPopUp.hide ();
            stopGame ();
            mc.gotoAndPlay (1);
            guessMovesList.clear ();
            var totalDanceMovesTypeList:* = DanceMoveTypeCollection.instance.getDanceMoveTypesOfSubtype (DanceMoveSubType.NORMAL);
            totalDanceMovesTypeList = totalDanceMovesTypeList.concat (DanceMoveTypeCollection.instance.getDanceMoveTypesOfSubtype (DanceMoveSubType.START));
            danceMoveTypesList = new Vector.<DanceMoveType>;
            var numDanceMoves:int = Math.min (totalDanceMovesTypeList.length, numQuestions);
            while (danceMoveTypesList.length < numQuestions) {

                danceMoveTypesList = danceMoveTypesList.concat (getRandomMoveTypesVector (totalDanceMovesTypeList));
            }
            danceMoveTypesList.length = numQuestions;
            mcProgressBar.gotoAndStop (1);
            tfPoints.text = trueAnswers + "/" + BreakdanceApp.instance.appUser.guessMoveGameRecord;
            tfTimer.text = String (PRE_GAME_TIME);
            tfRecord.text = String (BreakdanceApp.instance.appUser.guessMoveGameRecord);
            TweenLite.to (this, PRE_GAME_TIME / 3, {animationCount: 100, onUpdate: onMasteryPointAnimationUpdate, onComplete: onMasteryPointAnimationComplete, delay: PRE_GAME_TIME / 3, ease: Linear.easeNone});
            gameOver = false;
            preGameTimer.start ();

        }

        private function stopGame ():void {
            mc.stop ();
            guessMovesList.clear ();
            danceMoveTypesList = new Vector.<DanceMoveType>;
            currentQuestion = -1;
            trueAnswers = 0;
            danceMoviePlayer.clear ();
            preGameTimer.reset ();
            gameTimer.reset ();
            preGameTimer.stop ();
            gameTimer.stop ();
            gameOver = true;
        }

        private function endGame ():void {
            var guessMoveGameResultPopUp:* = PopUpManager.instance.guessMoveGameResultPopUp;
            guessMoveGameResultPopUp.setResult (trueAnswers, currentQuestion - trueAnswers);
            guessMoveGameResultPopUp.show ();
            TransactionOverlay.instance.show ();
            ServerApi.instance.query (ServerApi.SAVE_USER_SCORES, { game_id: MiniGames.GUESS_MOVE_GAME, scores: trueAnswers }, onResponse);
			// конец миниигры - ставим ачивку на игру в Минидвижении
			ServerApi.instance.query (ServerApi.SET_ACHIEVEMENT_ADD, { achievement_id:NameAchievements.ACH_EXPERT}, onGiveAchievement);	
            stopGame ();
        }
		
		private function onGiveAchievement (response:Object):void {
            //TransactionOverlay.instance.hide ();			
            if (response.response_code == 1) {
                BreakdanceApp.instance.appUser.onGiveAchievement (response);
				// если пришла награда - выдача окна награды
            }
        }
		
		private function onResponse (response:Object):void {
            TransactionOverlay.instance.hide ();
        }

        private function showNextQuestion ():void {
            if (!gameOver) {
                currentQuestion++;
                if (currentQuestion < danceMoveTypesList.length) {
                    var danceMoveType:DanceMoveType = danceMoveTypesList[currentQuestion];
                    danceMoviePlayer.showMove (danceMoveType.id, onComplete);
                    guessMovesList.init (danceMoveType);
                }
                else {
                    endGame ();
                }
            }

        }

        private function onComplete ():void {
            var danceMoveType:DanceMoveType = danceMoveTypesList [currentQuestion];
            danceMoviePlayer.showMove (danceMoveType.id, onComplete);

        }

        private function setTimeLeft (param1:int, param2:Boolean = false):void {
            tfTimer.text = String (param1);
            if (param2) {
                if (param1 <= DANGER_TIME_LEFT) {
                    tfTimer.textColor = DANGER_TIME_LEFT_COLOR;
                    TweenLite.to (tfTimer, HIDE_TWEEN_TIME, {alpha: 0, onComplete: onHideTfTimer});
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
            TweenLite.to (tfTimer, SHOW_TWEEN_TIME, {alpha: 1, onComplete: onHideTfTimer});

        }

        private function onMasteryPointAnimationComplete ():void {
            TweenLite.to (this, PRE_GAME_TIME / 3, {animationCount: 1, onUpdate: onMasteryPointAnimationUpdate, ease: Linear.easeNone});

        }

        private function onMasteryPointAnimationUpdate ():void {
            mcProgressBar.gotoAndStop (animationCount);

        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btnReplay:
                {
                    startGame ();
                    break;
                }
                case btnExit:
                {
                    ScreenManager.instance.navigateTo (ScreenManager.HOME_SCREEN);
                    break;
                }
                default:
                {
                    break;
                }
            }

        }

        private function rollOverListener (event:MouseEvent):void {
            var message:String;
            var positionPoint:Point = null;
            switch (event.currentTarget) {
                case btnReplay:
                {
                    message = textsManager.getText ("ttReplay");
                    positionPoint = btnReplay.localToGlobal (new Point (POSITION_POINT_X, POSITION_POINT_Y));
                    break;
                }
                case btnExit:
                {
                    message = textsManager.getText ("ttExit");
                    positionPoint = btnExit.localToGlobal (new Point (POSITION_POINT_X, POSITION_POINT_Y));
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (message) {
                BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
            }

        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();

        }

        private function selectDanceMoveTypeListener (event:SelectDanceMoveTypeEvent):void {
            var danceMoveType:DanceMoveType = event.danceMoveType;
            if (danceMoveType) {
                var currentDanceMoveType:DanceMoveType = danceMoveTypesList [currentQuestion];
                var record:int = BreakdanceApp.instance.appUser.guessMoveGameRecord;
                if (currentDanceMoveType == danceMoveType) {
                    trueAnswers++;
                }
                tfPoints.text = trueAnswers + "/" + record;
                if (record) {
                    var percent:int = Math.min (1, trueAnswers / record) * 100;
                    mcProgressBar.gotoAndStop (percent);
                }
                TweenLite.delayedCall (NEXT_QUESTION_DELAY, showNextQuestion);
            }

        }

        private function enterFrameListener (event:Event):void {
            if (mc.currentFrame == (mc.totalFrames - 1)) {
                preGameTimer.start ();
            }

        }

        private function mainGameTimerListener (event:TimerEvent):void {
            var timeLeft:int = gameTime - gameTimer.currentCount;
            setTimeLeft (timeLeft);
            if (timeLeft == 0) {
                gameTimer.stop ();
                tfTimer.text = "";
                tfTimer.textColor = NORMAL_TIME_LEFT_COLOR;
                endGame ();
            }

        }

        private function preGameTimerListener (event:TimerEvent):void {
            var timeLeft:int = PRE_GAME_TIME - preGameTimer.currentCount;
            setTimeLeft (timeLeft, false);
            if (timeLeft == 0) {
                preGameTimer.stop ();
                tfTimer.text = GO;
                tfTimer.textColor = NORMAL_TIME_LEFT_COLOR;
                gameTimer.start ();
                showNextQuestion ();
            }

        }

        private function reIntListener (event:ScreenManagerEvent):void {
            if (event.screenId == ScreenManager.TRAINING_SCREEN) {
                startGame ();
            }
        }

    }
}
