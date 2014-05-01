package breakdance.template {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalConstants;
    import breakdance.core.IAsyncInitObject;
    import breakdance.core.texts.TextsManager;
    import breakdance.events.LoadingStepEvent;

    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.SWFLoader;
    import com.hogargames.errors.SingletonError;

    public class TemplateDefault implements IAsyncInitObject {

        private static var _instance:TemplateDefault;

        private var completeCallback:Function;
        private var errorCallback:Function;
        private var progressCallback:Function;

        private var currentStep:int;

        private var queue:LoaderMax;

        public function TemplateDefault (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
        }

        static public function get instance ():TemplateDefault {
            if (!_instance) {
                _instance = new TemplateDefault (new SingletonKey ());
            }

            return _instance;
        }

        public function init (completeCallback:Function, errorCallback:Function, progressCallback:Function):void {
            Template.TEMPLATE_NAME = 'default';

            this.completeCallback = completeCallback;
            this.errorCallback = errorCallback;
            this.progressCallback = progressCallback;

            queue = new LoaderMax ({ skipFailed: false, onComplete: completeHandler, onError: errorHandler, onProgress: progressHandler });

            queue.append (new SWFLoader (GlobalConstants.ASSETS_URL + 'ui.swf', { noCache: true, name: Template.UI_SWF, autoPlay: false }));
            queue.append (new SWFLoader (GlobalConstants.ASSETS_URL + 'character.swf', { noCache: true, name: Template.CHARACTER_SWF, autoPlay: false }));
            queue.append (new SWFLoader (GlobalConstants.ASSETS_URL + 'sounds.swf', { noCache: true, name: Template.SOUNDS_SWF, autoPlay: false }));

            queue.addEventListener (LoaderEvent.CHILD_COMPLETE, childCompleteListener);

            currentStep = 0;

            BreakdanceApp.instance.appDispatcher.dispatchEvent (new LoadingStepEvent (LoadingStepEvent.START_LOADING_STEP, "Загрузка ui"));

            //start loading
            queue.load ();
        }

        private function completeHandler (event:LoaderEvent):void {
            var templateLoader:SWFLoader;

            templateLoader = queue.getLoader (Template.UI_SWF);
            Template.addSymbol (Template.DEFAULT_FONT, templateLoader.getClass ("default_font"));

            Template.addSymbol (Template.TOP_PANEL, templateLoader.getClass ("mcTopPanel"));
            Template.addSymbol (Template.DEBUG_BUTTON, templateLoader.getClass ("mcDebugButton"));

            Template.addSymbol (Template.BOTTOM_PANEL, templateLoader.getClass ("mcBottomPanel"));
            Template.addSymbol (Template.FRIENDS_LIST_ITEM, templateLoader.getClass ("mcFriendListItem"));
            Template.addSymbol (Template.ADD_FRIEND_ITEM, templateLoader.getClass ("mcAddFriendItem"));

            Template.addSymbol (Template.SETTINGS_PANEL, templateLoader.getClass ("mcSettingsPanel"));

            Template.addSymbol (Template.HOME_SCREEN, templateLoader.getClass ("mcHomeScreen"));

            Template.addSymbol (Template.SHOP_WINDOW, templateLoader.getClass ("mcShopWindow"));
            Template.addSymbol (Template.SHOP_LIST_ITEM, templateLoader.getClass ("mcShopListItem"));

            Template.addSymbol (Template.DANCE_MOVIES_WINDOWS, templateLoader.getClass ("mcDanceMoviesWindow"));
            Template.addSymbol (Template.DANCE_MOVIES_LIST_ITEM, templateLoader.getClass ("mcDanceMoviesListItem"));

            Template.addSymbol (Template.BATTLE_SCREEN, templateLoader.getClass ("mcBattleScreen"));
            Template.addSymbol (Template.MOVE_LOG_ITEM, templateLoader.getClass ("mcMoveLogItem"));
            Template.addSymbol (Template.MOVE_CHOICE_ITEM, templateLoader.getClass ("mcMoveChoiceItem"));
            Template.addSymbol (Template.MOVE_CHOICE_ORIGINAL_ITEM, templateLoader.getClass ("mcMoveChoiceOriginalItem"));
            Template.addSymbol (Template.LOG_ARROW, templateLoader.getClass ("mcLogArrow"));
            Template.addSymbol (Template.BTN_GO, templateLoader.getClass ("btnGo"));
            Template.addSymbol (Template.GUESS_MOVE_GAME_SCREEN, templateLoader.getClass ("mcGuessMoveGameScreen"));
            Template.addSymbol (Template.GUESS_MOVE_LIST_ITEM, templateLoader.getClass ("mcGuessMovesListItem"));

            Template.addSymbol (Template.CREATE_CHAR_POPUP, templateLoader.getClass ("mcCreateCharacterPopUp"));
            Template.addSymbol (Template.EDIT_CHARACTER_POPUP, templateLoader.getClass ("mcEditCharacterPopUp"));
            Template.addSymbol (Template.INFO_POP_UP_1, templateLoader.getClass ("mcInfoPopUp1"));
            Template.addSymbol (Template.INFO_POP_UP_2, templateLoader.getClass ("mcInfoPopUp2"));
            Template.addSymbol (Template.INFO_POP_UP_3, templateLoader.getClass ("mcInfoPopUp3"));
            Template.addSymbol (Template.INFO_POP_UP_4, templateLoader.getClass ("mcInfoPopUp4"));
            Template.addSymbol (Template.INVITE_BATTLE_POPUP, templateLoader.getClass ("mcInviteBattlePopUp"));
            Template.addSymbol (Template.TWO_BUTTONS_POPUP, templateLoader.getClass ("mcTwoButtonsPopup"));
            Template.addSymbol (Template.ONE_BUTTON_CHARACTER_POPUP, templateLoader.getClass ("mcOneButtonCharacterPopup"));
            Template.addSymbol (Template.TWO_BUTTONS_CHARACTER_POPUP, templateLoader.getClass ("mcTwoButtonsCharacterPopup"));
            Template.addSymbol (Template.TWO_BUTTONS_CHARACTER_CLOSING_POPUP, templateLoader.getClass ("mcTwoButtonsCharacterClosingPopup"));
            Template.addSymbol (Template.INFO_POPUP_WITH_CHARACTER, templateLoader.getClass ("mcInfoPopUpWithCharacter"));
            Template.addSymbol (Template.BATTLE_WIN_POPUP, templateLoader.getClass ("mcBattleWinPopUp"));
            Template.addSymbol (Template.BATTLE_TIE_POPUP, templateLoader.getClass ("mcBattleTiePopUp"));
            Template.addSymbol (Template.BATTLE_DEFEAT_POPUP, templateLoader.getClass ("mcBattleDefeatPopUp"));
            Template.addSymbol (Template.BUCKS_OFFERS_POPUP, templateLoader.getClass ("mcBucksOffersPopUp"));
            Template.addSymbol (Template.BATTLE_LIST_POPUP, templateLoader.getClass ("mcBattleListPopUp"));
            Template.addSymbol (Template.BATTLE_LIST_ITEM, templateLoader.getClass ("mcBattleListItem"));
            Template.addSymbol (Template.LANGUAGE_POP_UP, templateLoader.getClass ("mcLanguagePopUp"));
            Template.addSymbol (Template.TOP_PLAYERS_POP_UP, templateLoader.getClass ("mcTopPlayersPopUp"));
            Template.addSymbol (Template.TOP_PLAYERS_LIST_ITEM, templateLoader.getClass ("mcTopPlayersListItem"));
            Template.addSymbol (Template.PVP_LOG_POP_UP, templateLoader.getClass ("mcPvpLogPopUp"));
            Template.addSymbol (Template.PVP_LOG_LIST_ITEM, templateLoader.getClass ("mcPvpLogListItem"));
            Template.addSymbol (Template.GUESS_MOVE_GAME_RESULT_POP_UP, templateLoader.getClass ("mcGuessMoveGameResultPopUp"));
            Template.addSymbol (Template.NEW_LEVEL_POP_UP, templateLoader.getClass ("mcNewLevelPopUp"));
            Template.addSymbol (Template.BUCKS_TO_COINS_POP_UP, templateLoader.getClass ("mcBucksToCoinsPopUp"));
            Template.addSymbol (Template.DAILY_AWARD_POP_UP, templateLoader.getClass ("mcDailyAwardPopUp"));
            Template.addSymbol (Template.RESTORE_STAMINA_POP_UP, templateLoader.getClass ("mcRestoreStaminaPopUp"));
            Template.addSymbol (Template.BEAT_STREET_SHOP_POP_UP, templateLoader.getClass ("mcBeatStreetShopPopUp"));
            Template.addSymbol (Template.FIVE_STEPS_POP_UP, templateLoader.getClass ("mc5stepsPopUp"));
            Template.addSymbol (Template.NEWS_POP_UP, templateLoader.getClass ("mcNewsPopUp"));
            Template.addSymbol (Template.NEWS_LIST_ITEM, templateLoader.getClass ("mcNewsListItem"));

            Template.addSymbol (Template.TOOLTIP, templateLoader.getClass ("mcTooltip"));
            Template.addSymbol (Template.INFO_MESSAGE, templateLoader.getClass ("mcInfoMessage"));
            Template.addSymbol (Template.LOADING_SCREEN, templateLoader.getClass ("mcLoadingScreen"));
            Template.addSymbol (Template.TUTORIAL, templateLoader.getClass ("mcTutorial"));

            templateLoader = queue.getLoader (Template.CHARACTER_SWF);
            Template.addSwf (Template.CHARACTER_SWF, templateLoader);
            Template.addSymbol (Template.CHARACTER, templateLoader.getClass ("mcCharacter"));
            Template.addSymbol (Template.AVATAR, templateLoader.getClass ("mcAvatar"));
            Template.addSymbol (Template.T_SHIRT, templateLoader.getClass ("mcTshirt"));
            Template.addSymbol (Template.MC_ITEM, templateLoader.getClass ("mcItem"));

            templateLoader = queue.getLoader (Template.SOUNDS_SWF);
            Template.addSymbol (Template.SND_MAIN_THEME, templateLoader.getClass ("sndMainTheme"));
            Template.addSymbol (Template.SND_BATTLE, templateLoader.getClass ("sndBattle"));
            Template.addSymbol (Template.SND_BUTTON_DOWN, templateLoader.getClass ("sndButtonDown"));
            Template.addSymbol (Template.SND_BUTTON_OVER, templateLoader.getClass ("sndButtonOver"));
            Template.addSymbol (Template.SND_BREAK_BEAT_ENERGY, templateLoader.getClass ("sndBreakBeatEnergy"));
            Template.addSymbol (Template.SND_BREAK_BEAT, templateLoader.getClass ("sndBreakBeat"));
            Template.addSymbol (Template.SND_COINS, templateLoader.getClass ("sndCoins"));
            Template.addSymbol (Template.SND_PRE_BATTLE, templateLoader.getClass ("sndPreBattle"));
            Template.addSymbol (Template.SND_CAMERA_SHOT, templateLoader.getClass ("sndCameraShot"));
            Template.addSymbol (Template.SND_TAPE_DECK_IN, templateLoader.getClass ("sndTapeDeckIn"));
            Template.addSymbol (Template.SND_TAPE_DECK_IN_2, templateLoader.getClass ("sndTapeDeckIn2"));
            Template.addSymbol (Template.SND_TAPE_DECK_OUT, templateLoader.getClass ("sndTapeDeckOut"));

            var prefixRu:String = "_" + TextsManager.RU;
            Template.addSymbol (Template.SND_VOICE_BATTLE_ADDITIONAL_ROUND + prefixRu, templateLoader.getClass ("sndVoiceBattleAdditionalRound" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_BEGIN + prefixRu, templateLoader.getClass ("sndVoiceBattleBegin" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_BEGIN_1 + prefixRu, templateLoader.getClass ("sndVoiceBattleBegin1" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_BEGIN_2 + prefixRu, templateLoader.getClass ("sndVoiceBattleBegin2" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_BEGIN_3 + prefixRu, templateLoader.getClass ("sndVoiceBattleBegin3" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_BEGIN_4 + prefixRu, templateLoader.getClass ("sndVoiceBattleBegin4" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_END + prefixRu, templateLoader.getClass ("sndVoiceBattleEnd" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_LAST_ROUND + prefixRu, templateLoader.getClass ("sndVoiceBattleLastRound" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_GO + prefixRu, templateLoader.getClass ("sndVoiceBattleGo" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_ROUND_2 + prefixRu, templateLoader.getClass ("sndVoiceBattleRound2" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_ROUND_3 + prefixRu, templateLoader.getClass ("sndVoiceBattleRound3" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_BATTLE_WHO_BEGINS + prefixRu, templateLoader.getClass ("sndVoiceBattleWhoBegins" + prefixRu));

            Template.addSymbol (Template.SND_VOICE_TUTOR_TRAINING_OPEN + prefixRu, templateLoader.getClass ("sndVoiceTutorTrainingOpen" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_BATTLE_START + prefixRu, templateLoader.getClass ("sndVoiceTutorBattleStart" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_BATTLE_WIN + prefixRu, templateLoader.getClass ("sndVoiceTutorBattleWin" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_TRAINING_MOVE_1 + prefixRu, templateLoader.getClass ("sndVoiceTutorTrainingMove1" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_TRAINING_MOVE_2 + prefixRu, templateLoader.getClass ("sndVoiceTutorTrainingMove2" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_TRAINING_MOVE_3 + prefixRu, templateLoader.getClass ("sndVoiceTutorTrainingMove3" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_SHOP_OPEN + prefixRu, templateLoader.getClass ("sndVoiceTutorShopOpen" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_SHOP_SELECT_ITEM_1 + prefixRu, templateLoader.getClass ("sndVoiceTutorShopSelectItem1" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_SHOP_SELECT_ITEM_2 + prefixRu, templateLoader.getClass ("sndVoiceTutorShopSelectItem2" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_SHOP_SELECT_ITEM_3 + prefixRu, templateLoader.getClass ("sndVoiceTutorShopSelectItem3" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_BATTLE_OPEN + prefixRu, templateLoader.getClass ("sndVoiceTutorBattleOpen" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_CREATE_SCREEN_SHOT + prefixRu, templateLoader.getClass ("sndVoiceTutorCreateScreenShot" + prefixRu));

            var prefixEn:String = "_" + TextsManager.EN;
            Template.addSymbol (Template.SND_VOICE_BATTLE_ADDITIONAL_ROUND + prefixEn, templateLoader.getClass ("sndVoiceBattleAdditionalRound" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_BEGIN + prefixEn, templateLoader.getClass ("sndVoiceBattleBegin" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_BEGIN_1 + prefixEn, templateLoader.getClass ("sndVoiceBattleBegin1" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_BEGIN_2 + prefixEn, templateLoader.getClass ("sndVoiceBattleBegin2" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_BEGIN_3 + prefixEn, templateLoader.getClass ("sndVoiceBattleBegin3" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_BEGIN_4 + prefixEn, templateLoader.getClass ("sndVoiceBattleBegin4" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_END + prefixEn, templateLoader.getClass ("sndVoiceBattleEnd" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_LAST_ROUND + prefixEn, templateLoader.getClass ("sndVoiceBattleLastRound" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_GO + prefixEn, templateLoader.getClass ("sndVoiceBattleGo" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_ROUND_2 + prefixEn, templateLoader.getClass ("sndVoiceBattleRound2" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_ROUND_3 + prefixEn, templateLoader.getClass ("sndVoiceBattleRound3" + prefixEn));
            Template.addSymbol (Template.SND_VOICE_BATTLE_WHO_BEGINS + prefixEn, templateLoader.getClass ("sndVoiceBattleWhoBegins" + prefixEn));

            Template.addSymbol (Template.SND_VOICE_TUTOR_TRAINING_OPEN + prefixEn, templateLoader.getClass ("sndVoiceTutorTrainingOpen" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_BATTLE_START + prefixEn, templateLoader.getClass ("sndVoiceTutorBattleStart" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_BATTLE_WIN + prefixEn, templateLoader.getClass ("sndVoiceTutorBattleWin" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_TRAINING_MOVE_1 + prefixEn, templateLoader.getClass ("sndVoiceTutorTrainingMove1" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_TRAINING_MOVE_2 + prefixEn, templateLoader.getClass ("sndVoiceTutorTrainingMove2" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_TRAINING_MOVE_3 + prefixEn, templateLoader.getClass ("sndVoiceTutorTrainingMove3" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_SHOP_OPEN + prefixEn, templateLoader.getClass ("sndVoiceTutorShopOpen" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_SHOP_SELECT_ITEM_1 + prefixEn, templateLoader.getClass ("sndVoiceTutorShopSelectItem1" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_SHOP_SELECT_ITEM_2 + prefixEn, templateLoader.getClass ("sndVoiceTutorShopSelectItem2" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_SHOP_SELECT_ITEM_3 + prefixEn, templateLoader.getClass ("sndVoiceTutorShopSelectItem3" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_BATTLE_OPEN + prefixEn, templateLoader.getClass ("sndVoiceTutorBattleOpen" + prefixRu));
            Template.addSymbol (Template.SND_VOICE_TUTOR_CREATE_SCREEN_SHOT + prefixEn, templateLoader.getClass ("sndVoiceTutorCreateScreenShot" + prefixRu));

            completeCallback ();
        }

        private function errorHandler (event:LoaderEvent):void {
            errorCallback ("Loading error (" + event.target + ")");
        }

        private function progressHandler (event:LoaderEvent):void {
            progressCallback (event.target.progress);
        }

        private function childCompleteListener (event:LoaderEvent):void {
            currentStep++;
            var message:String = "";
            switch (currentStep) {
                case (1):
                    message = "Загрузка персонажа";
                    break;
                case (2):
                    message = "Загрузка звука";
                    break;
            }
            BreakdanceApp.instance.appDispatcher.dispatchEvent (new LoadingStepEvent (LoadingStepEvent.START_LOADING_STEP, message));
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}