/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.02.14
 * Time: 2:27
 * To change this template use File | Settings | File Templates.
 */
package breakdance.tutorial {

    import breakdance.GlobalConstants;
    import breakdance.core.server.ServerApi;
    import breakdance.core.sound.SoundManager;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.tutorial.events.TutorialEvent;
    import breakdance.tutorial.events.TutorialStepEvent;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.tutorial.TutorialOverlay;

    import com.hogargames.Orientation;
    import com.hogargames.errors.SingletonError;

    import flash.events.EventDispatcher;
    import flash.geom.Rectangle;

    public class TutorialManager extends EventDispatcher {

        private static var _instance:TutorialManager;

        private var _currentStep:String;

        private var completedSteps:Vector.<String>;

        public static const SHOP_ITEM_1:String = "t_shirt_b222";
        public static const SHOP_ITEM_2:String = "wristband_yellow_l";
        public static const SHOP_ITEM_3:String = "trousers_black";

        public static const DANCE_MOVE_1:String = "salsa_rock_back";
        public static const DANCE_MOVE_2:String = "six_step";
        public static const DANCE_MOVE_3:String = "turtle_freeze";

        public static const DRESS_ROOM_ITEM_1:String = "cardboard";
        public static const DRESS_ROOM_ITEM_2:String = "chinese_mafon";

        /////////////////////////////////////////////
        //TRAINING:
        /////////////////////////////////////////////

        private static const TRAINING_BUTTON_X:int = 452;
        private static const TRAINING_BUTTON_Y:int = 460;
        private static const TRAINING_BUTTON_WIDTH:int = 72;
        private static const TRAINING_BUTTON_HEIGHT:int = 90;
        private static const TRAINING_BUTTON_POS_X:int = TRAINING_BUTTON_X;
        private static const TRAINING_BUTTON_POS_Y:int = TRAINING_BUTTON_Y + 20;

        private static const MOVE_1_X:int = 123;
        private static const MOVE_1_Y:int = 142;
        private static const MOVE_2_X:int = 393;
        private static const MOVE_2_Y:int = 142;
        private static const MOVE_3_X:int = 123;
        private static const MOVE_3_Y:int = 142;
        private static const MOVE_WIDTH:int = 128;
        private static const MOVE_HEIGHT:int = 128;
        private static const MOVE_1_POS_X:int = MOVE_1_X;
        private static const MOVE_1_POS_Y:int = MOVE_1_Y + 20;
        private static const MOVE_2_POS_X:int = MOVE_2_X;
        private static const MOVE_2_POS_Y:int = MOVE_2_Y + 20;
        private static const MOVE_3_POS_X:int = MOVE_3_X;
        private static const MOVE_3_POS_Y:int = MOVE_3_Y + 20;

        private static const MOVE_CATEGORY_2_X:int = 213;
        private static const MOVE_CATEGORY_3_X:int = 313;
        private static const MOVE_CATEGORY_Y:int = 107;
        private static const MOVE_CATEGORY_WIDTH:int = 102;
        private static const MOVE_CATEGORY_HEIGHT:int = 28;
        private static const MOVE_CATEGORY_2_POS_X:int = MOVE_CATEGORY_2_X;
        private static const MOVE_CATEGORY_3_POS_X:int = MOVE_CATEGORY_3_X;
        private static const MOVE_CATEGORY_POS_Y:int = MOVE_CATEGORY_Y + Math.round (MOVE_CATEGORY_HEIGHT / 2);

        private static const TRAINING_CLOSE_BUTTON_X:int = 664;
        private static const TRAINING_CLOSE_BUTTON_Y:int = 80;
        private static const TRAINING_CLOSE_BUTTON_WIDTH:int = 31;
        private static const TRAINING_CLOSE_BUTTON_HEIGHT:int = 12;
        private static const TRAINING_CLOSE_BUTTON_POS_X:int = TRAINING_CLOSE_BUTTON_X;
        private static const TRAINING_CLOSE_BUTTON_POS_Y:int = TRAINING_CLOSE_BUTTON_Y + Math.round (TRAINING_CLOSE_BUTTON_HEIGHT / 2);

        /////////////////////////////////////////////
        //SHOP:
        /////////////////////////////////////////////

        private static const SHOP_BUTTON_X:int = 528;
        private static const SHOP_BUTTON_Y:int = 460;
        private static const SHOP_BUTTON_WIDTH:int = 72;
        private static const SHOP_BUTTON_HEIGHT:int = 90;
        private static const SHOP_BUTTON_POS_X:int = SHOP_BUTTON_X;
        private static const SHOP_BUTTON_POS_Y:int = SHOP_BUTTON_Y + 20;

        private static const SHOP_CATEGORY_2_X:int = 503;
        private static const SHOP_CATEGORY_3_X:int = 530;
        private static const SHOP_CATEGORY_Y:int = 105;
        private static const SHOP_CATEGORY_WIDTH:int = 28;
        private static const SHOP_CATEGORY_HEIGHT:int = 28;
        private static const SHOP_CATEGORY_2_POS_X:int = SHOP_CATEGORY_2_X;
        private static const SHOP_CATEGORY_3_POS_X:int = SHOP_CATEGORY_3_X;
        private static const SHOP_CATEGORY_POS_Y:int = SHOP_CATEGORY_Y + Math.round (SHOP_CATEGORY_HEIGHT / 2);

        private static const SHOP_ITEM_1_X:int = 431;
        private static const SHOP_ITEM_1_Y:int = 215;
        private static const SHOP_ITEM_2_X:int = 506;
        private static const SHOP_ITEM_2_Y:int = 215;
        private static const SHOP_ITEM_3_X:int = 581;
        private static const SHOP_ITEM_3_Y:int = 215;
        private static const SHOP_ITEM_1_POS_X:int = SHOP_ITEM_1_X;
        private static const SHOP_ITEM_1_POS_Y:int = SHOP_ITEM_1_Y + Math.round (SHOP_ITEM_WIDTH / 2);
        private static const SHOP_ITEM_2_POS_X:int = SHOP_ITEM_2_X;
        private static const SHOP_ITEM_2_POS_Y:int = SHOP_ITEM_2_Y + Math.round (SHOP_ITEM_WIDTH / 2);
        private static const SHOP_ITEM_3_POS_X:int = SHOP_ITEM_3_X;
        private static const SHOP_ITEM_3_POS_Y:int = SHOP_ITEM_3_Y + Math.round (SHOP_ITEM_WIDTH / 2);
        private static const SHOP_ITEM_WIDTH:int = 78;
        private static const SHOP_ITEM_HEIGHT:int = 78;

        private static const BUY_BUTTON_X:int = 486;
        private static const BUY_BUTTON_Y:int = 422;
        private static const BUY_BUTTON_WIDTH:int = 114;
        private static const BUY_BUTTON_HEIGHT:int = 33;
        private static const BUY_BUTTON_POS_X:int = BUY_BUTTON_X;
        private static const BUY_BUTTON_POS_Y:int = BUY_BUTTON_Y + Math.round (BUY_BUTTON_HEIGHT / 2);

        private static const T_SHIRT_CONSTRUCTOR_X:int = 425;
        private static const T_SHIRT_CONSTRUCTOR_Y:int = 134;
        private static const T_SHIRT_CONSTRUCTOR_WIDTH:int = 257;
        private static const T_SHIRT_CONSTRUCTOR_HEIGHT:int = 330;
        private static const T_SHIRT_CONSTRUCTOR_POS_X:int = 425;
        private static const T_SHIRT_CONSTRUCTOR_POS_Y:int = 214;

        private static const SHOP_CLOSE_BUTTON_X:int = 664;
        private static const SHOP_CLOSE_BUTTON_Y:int = 80;
        private static const SHOP_CLOSE_BUTTON_WIDTH:int = 31;
        private static const SHOP_CLOSE_BUTTON_HEIGHT:int = 12;
        private static const SHOP_CLOSE_BUTTON_POS_X:int = SHOP_CLOSE_BUTTON_X;
        private static const SHOP_CLOSE_BUTTON_POS_Y:int = SHOP_CLOSE_BUTTON_Y + Math.round (SHOP_CLOSE_BUTTON_HEIGHT / 2);

        /////////////////////////////////////////////
        //SHOP:
        /////////////////////////////////////////////

        private static const DRESS_ROOM_BUTTON_X:int = 600;
        private static const DRESS_ROOM_BUTTON_Y:int = 460;
        private static const DRESS_ROOM_BUTTON_WIDTH:int = 72;
        private static const DRESS_ROOM_BUTTON_HEIGHT:int = 90;
        private static const DRESS_ROOM_BUTTON_POS_X:int = DRESS_ROOM_BUTTON_X;
        private static const DRESS_ROOM_BUTTON_POS_Y:int = DRESS_ROOM_BUTTON_Y + 20;

        private static const DRESS_ROOM_CATEGORY_1_X:int = 611;
        private static const DRESS_ROOM_CATEGORY_2_X:int = 584;
        private static const DRESS_ROOM_CATEGORY_Y:int = 105;
        private static const DRESS_ROOM_CATEGORY_WIDTH:int = 28;
        private static const DRESS_ROOM_CATEGORY_HEIGHT:int = 28;
        private static const DRESS_ROOM_CATEGORY_1_POS_X:int = DRESS_ROOM_CATEGORY_1_X;
        private static const DRESS_ROOM_CATEGORY_2_POS_X:int = DRESS_ROOM_CATEGORY_2_X;
        private static const DRESS_ROOM_CATEGORY_POS_Y:int = DRESS_ROOM_CATEGORY_Y + Math.round (DRESS_ROOM_CATEGORY_HEIGHT / 2);

        private static const DRESS_ROOM_ITEM_1_X:int = 431;
        private static const DRESS_ROOM_ITEM_1_Y:int = 140;
        private static const DRESS_ROOM_ITEM_2_X:int = 431;
        private static const DRESS_ROOM_ITEM_2_Y:int = 140;
        private static const DRESS_ROOM_ITEM_1_POS_X:int = DRESS_ROOM_ITEM_1_X;
        private static const DRESS_ROOM_ITEM_1_POS_Y:int = DRESS_ROOM_ITEM_1_Y + Math.round (DRESS_ROOM_ITEM_WIDTH / 2);
        private static const DRESS_ROOM_ITEM_2_POS_X:int = DRESS_ROOM_ITEM_2_X;
        private static const DRESS_ROOM_ITEM_2_POS_Y:int = DRESS_ROOM_ITEM_2_Y + Math.round (DRESS_ROOM_ITEM_WIDTH / 2);
        private static const DRESS_ROOM_ITEM_WIDTH:int = 78;
        private static const DRESS_ROOM_ITEM_HEIGHT:int = 78;

        private static const SET_BUTTON_X:int = 430;
        private static const SET_BUTTON_Y:int = 422;
        private static const SET_BUTTON_WIDTH:int = 114;
        private static const SET_BUTTON_HEIGHT:int = 33;
        private static const SET_BUTTON_POS_X:int = SET_BUTTON_X;
        private static const SET_BUTTON_POS_Y:int = SET_BUTTON_Y + Math.round (SET_BUTTON_HEIGHT / 2);

        private static const DRESS_ROOM_CLOSE_BUTTON_X:int = 664;
        private static const DRESS_ROOM_CLOSE_BUTTON_Y:int = 80;
        private static const DRESS_ROOM_CLOSE_BUTTON_WIDTH:int = 31;
        private static const DRESS_ROOM_CLOSE_BUTTON_HEIGHT:int = 12;
        private static const DRESS_ROOM_CLOSE_BUTTON_POS_X:int = DRESS_ROOM_CLOSE_BUTTON_X;
        private static const DRESS_ROOM_CLOSE_BUTTON_POS_Y:int = SHOP_CLOSE_BUTTON_Y + Math.round (SHOP_CLOSE_BUTTON_HEIGHT / 2);

        /////////////////////////////////////////////
        //BATTLE:
        /////////////////////////////////////////////

        private static const BATTLE_BUTTON_X:int = 350;
        private static const BATTLE_BUTTON_Y:int = 450;
        private static const BATTLE_BUTTON_WIDTH:int = 105;
        private static const BATTLE_BUTTON_HEIGHT:int = 105;
        private static const BATTLE_BUTTON_POS_X:int = 370;
        private static const BATTLE_BUTTON_POS_Y:int = 445;

        private static const BATTLE_SELECT_BUTTON_X:int = 528;
        private static const BATTLE_SELECT_BUTTON_Y:int = 194;
        private static const BATTLE_SELECT_BUTTON_WIDTH:int = 132;
        private static const BATTLE_SELECT_BUTTON_HEIGHT:int = 42;
        private static const BATTLE_SELECT_BUTTON_POS_X:int = BATTLE_SELECT_BUTTON_X;
        private static const BATTLE_SELECT_BUTTON_POS_Y:int = BATTLE_SELECT_BUTTON_Y + Math.round (BATTLE_SELECT_BUTTON_HEIGHT / 2);

        private static const BATTLE_START_AREA_X:int = 0;
        private static const BATTLE_START_AREA_Y:int = 75;
        private static const BATTLE_START_AREA_WIDTH:int = 210;
        private static const BATTLE_START_AREA_HEIGHT:int = 420;
        private static const BATTLE_START_POS_X:int = 222;
        private static const BATTLE_START_POS_Y:int = 178;
        private static const BATTLE_START_ARROW_DELAY:Number = 2;

        private static const BATTLE_AREA_X:int = 0;
        private static const BATTLE_AREA_Y:int = 75;
        private static const BATTLE_AREA_WIDTH:int = GlobalConstants.APP_WIDTH;
        private static const BATTLE_AREA_HEIGHT:int = 420;

        /////////////////////////////////////////////
        //CHARACTER:
        /////////////////////////////////////////////

        private static const CHARACTER_MOVE_AREA_X:int = 90;
        private static const CHARACTER_MOVE_AREA_Y:int = 75;
        private static const CHARACTER_MOVE_AREA_WIDTH:int = 630;
        private static const CHARACTER_MOVE_AREA_HEIGHT:int = 370;
        private static const CHARACTER_MOVE_BUTTON_POS_X:int = 225;
        private static const CHARACTER_MOVE_BUTTON_POS_Y:int = 195;

        private static const CREATE_SCREEN_SHOT_AREA_X:int = 680;
        private static const CREATE_SCREEN_SHOT_AREA_Y:int = 570;
        private static const CREATE_SCREEN_SHOT_AREA_WIDTH:int = 114;
        private static const CREATE_SCREEN_SHOT_AREA_HEIGHT:int = 45;
        private static const CREATE_SCREEN_SHOT_POS_X:int = CREATE_SCREEN_SHOT_AREA_X + 53;
        private static const CREATE_SCREEN_SHOT_POS_Y:int = CREATE_SCREEN_SHOT_AREA_Y + 3;


        public function TutorialManager (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
        }

        static public function get instance ():TutorialManager {
            if (!_instance) {
                _instance = new TutorialManager (new SingletonKey ());
            }
            return _instance;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function initSteps (completedSteps:Vector.<String>):void {
            if ((this.completedSteps == null) && (currentStep == null)) {
                this.completedSteps = completedSteps;
//                setStep (TutorialStep.CREATE_SCREEN_SHOT);

                if (completedSteps.indexOf (TutorialStep.SKIP_TUTOR) != -1) {
                    setStep (null);
                }
                else if (completedSteps.indexOf (TutorialStep.NO_TUTOR) != -1) {
                    PopUpManager.instance.addTutorialPopUp.show ();
                }
                else if (completedSteps.indexOf (TutorialStep.STEPS [TutorialStep.STEPS.length - 1]) != -1) {
                    setStep (null);
                }
                else if (completedSteps.indexOf (TutorialStep.BATTLE_WIN) != -1) {
                    setStep (TutorialStep.MOVE_CHARACTER);
                }
                else if (completedSteps.indexOf (TutorialStep.SHOP_BUY_ITEM_3) != -1) {
                    setStep (TutorialStep.BATTLE_OPEN);
                }
                else if (completedSteps.indexOf (TutorialStep.SHOP_BUY_ITEM_2) != -1) {
                    setStep (TutorialStep.SHOP_OPEN);
                }
                else if (completedSteps.indexOf (TutorialStep.SHOP_BUY_ITEM_1) != -1) {
                    setStep (TutorialStep.SHOP_OPEN);
                }
                else if (completedSteps.indexOf (TutorialStep.TRAINING_MOVE_3) != -1) {
                    setStep (TutorialStep.SHOP_OPEN);
                }
                else if (completedSteps.indexOf (TutorialStep.TRAINING_MOVE_2) != -1) {
                    setStep (TutorialStep.TRAINING_OPEN);
                }
                else if (completedSteps.indexOf (TutorialStep.TRAINING_MOVE_1) != -1) {
                    setStep (TutorialStep.TRAINING_OPEN);
                }
                else {
                    setStep (TutorialStep.STEPS [0]);
                }
            }
        }

        public function skip ():void {
            completeStep (TutorialStep.SKIP_TUTOR);
            setStep (null);
        }

        public function reset ():void {
            _currentStep = null;
            completedSteps = null;
        }

        public function nextStep ():void {
            if (currentStep) {
                completeStep (currentStep);
            }
        }

        public function completeStep (stepId:String):void {
            var nextStepId:String;
            if (stepId == TutorialStep.TRAINING_OPEN) {
                if (completedSteps.indexOf (TutorialStep.TRAINING_MOVE_2) != -1) {
                    nextStepId = TutorialStep.TRAINING_SELECT_CATEGORY_3;
                }
                else if (completedSteps.indexOf (TutorialStep.TRAINING_MOVE_1) != -1) {
                    nextStepId = TutorialStep.TRAINING_SELECT_CATEGORY_2;
                }
            }
            if (stepId == TutorialStep.SHOP_OPEN) {
                if (completedSteps.indexOf (TutorialStep.SHOP_BUY_ITEM_2) != -1) {
                    nextStepId = TutorialStep.SHOP_SELECT_CATEGORY_3;
                }
                else if (completedSteps.indexOf (TutorialStep.SHOP_BUY_ITEM_1) != -1) {
                    nextStepId = TutorialStep.SHOP_SELECT_CATEGORY_2;
                }
            }

            var index:int = TutorialStep.STEPS.indexOf (stepId);

            if (stepId) {
                dispatchEvent (new TutorialStepEvent (stepId, TutorialStepEvent.COMPLETE_TUTORIAL_STEP));
                if (completedSteps && (completedSteps.indexOf (stepId) == -1)) {
                    ServerApi.instance.query (ServerApi.SAVE_TUTORIAL_STEP, {tutorial_id:stepId}, onSaveTutorialStep);
                    var stepAsString:String = String (index);
                    if (stepAsString.length == 1) {
                        stepAsString = "0" + stepAsString;
                    }
                    stepAsString += "_" + stepId;
//                    BreakdanceApp.mixpanel.track(
//                        'tutorial',
//                        {step:stepAsString}
//                    );
                }
            }

            if (nextStepId == null) {
                if (index != -1) {
                    if (index < TutorialStep.STEPS.length - 1) {
                        nextStepId = TutorialStep.STEPS [index + 1];
                    }
                }
            }
//            trace ("completeStep " + stepId + " (" + index + "/" + (TutorialStep.STEPS.length - 1) + "); nextStepId = " + nextStepId);
            setStep (nextStepId);
        }

        public function get currentStep ():String {
            return _currentStep;
        }

        public function setStep (stepId:String):void {
//            trace ("setStep: " + stepId);
            _currentStep = stepId;
            var tutorialOverlay:TutorialOverlay = TutorialOverlay.instance;
            var textsManager:TextsManager = TextsManager.instance;
            dispatchEvent (new TutorialStepEvent (_currentStep, TutorialStepEvent.SET_TUTORIAL_STEP));
            if (_currentStep) {
                var areas:Vector.<Rectangle> = new Vector.<Rectangle> ();
                var area:Rectangle;
                var message:String;
                tutorialOverlay.show ();
                tutorialOverlay.hideNextButton ();
                switch (_currentStep) {
                    case (TutorialStep.START):
                        dispatchEvent (new TutorialEvent (TutorialEvent.START_TUTORIAL));
                        tutorialOverlay.showNextButton ();
                        tutorialOverlay.showHidingBackground (null);
                        tutorialOverlay.hideArrow ();
                        message = textsManager.getText ("tutorialStart");
                        break;

                    /////////////////////////////////////////////
                    //TRAINING:
                    /////////////////////////////////////////////

                    case (TutorialStep.TRAINING_OPEN):
                        message = textsManager.getText ("tutorialTrainingOpen");
                        area = new Rectangle ();
                        area.x = TRAINING_BUTTON_X;
                        area.y = TRAINING_BUTTON_Y;
                        area.width = TRAINING_BUTTON_WIDTH;
                        area.height = TRAINING_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (TRAINING_BUTTON_POS_X, TRAINING_BUTTON_POS_Y);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_TRAINING_OPEN);
                        break;
                    case (TutorialStep.TRAINING_MOVE_1):
                        message = textsManager.getText ("tutorialTrainingMove1");
                        area = new Rectangle ();
                        area.x = MOVE_1_X;
                        area.y = MOVE_1_Y;
                        area.width = MOVE_WIDTH;
                        area.height = MOVE_HEIGHT;
                        tutorialOverlay.positionArrow (MOVE_1_POS_X, MOVE_1_POS_Y);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_TRAINING_MOVE_1);
                        break;
                    case (TutorialStep.TRAINING_SELECT_CATEGORY_2):
                        message = textsManager.getText ("tutorialTrainingSelectCategory2");
                        area = new Rectangle ();
                        area.x = MOVE_CATEGORY_2_X;
                        area.y = MOVE_CATEGORY_Y;
                        area.width = MOVE_CATEGORY_WIDTH;
                        area.height = MOVE_CATEGORY_HEIGHT;
                        tutorialOverlay.positionArrow (MOVE_CATEGORY_2_POS_X, MOVE_CATEGORY_POS_Y);
                        break;
                    case (TutorialStep.TRAINING_MOVE_2):
                        message = textsManager.getText ("tutorialTrainingMove2");
                        area = new Rectangle ();
                        area.x = MOVE_2_X;
                        area.y = MOVE_2_Y;
                        area.width = MOVE_WIDTH;
                        area.height = MOVE_HEIGHT;
                        tutorialOverlay.positionArrow (MOVE_2_POS_X, MOVE_2_POS_Y);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_TRAINING_MOVE_2);
                        break;
                    case (TutorialStep.TRAINING_SELECT_CATEGORY_3):
                        message = textsManager.getText ("tutorialTrainingSelectCategory3");
                        area = new Rectangle ();
                        area.x = MOVE_CATEGORY_3_X;
                        area.y = MOVE_CATEGORY_Y;
                        area.width = MOVE_CATEGORY_WIDTH;
                        area.height = MOVE_CATEGORY_HEIGHT;
                        tutorialOverlay.positionArrow (MOVE_CATEGORY_3_POS_X, MOVE_CATEGORY_POS_Y);
                        break;
                    case (TutorialStep.TRAINING_MOVE_3):
                        message = textsManager.getText ("tutorialTrainingMove3");
                        area = new Rectangle ();
                        area.x = MOVE_3_X;
                        area.y = MOVE_3_Y;
                        area.width = MOVE_WIDTH;
                        area.height = MOVE_HEIGHT;
                        tutorialOverlay.positionArrow (MOVE_3_POS_X, MOVE_3_POS_Y);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_TRAINING_MOVE_3);
                        break;
                    case (TutorialStep.TRAINING_CLOSE):

                        message = textsManager.getText ("tutorialTrainingClose");
                        area = new Rectangle ();
                        area.x = TRAINING_CLOSE_BUTTON_X;
                        area.y = TRAINING_CLOSE_BUTTON_Y;
                        area.width = TRAINING_CLOSE_BUTTON_WIDTH;
                        area.height = TRAINING_CLOSE_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (TRAINING_CLOSE_BUTTON_POS_X, TRAINING_CLOSE_BUTTON_POS_Y);
                        break;

                    /////////////////////////////////////////////
                    //SHOP:
                    /////////////////////////////////////////////

                    case (TutorialStep.SHOP_OPEN):
                        message = textsManager.getText ("tutorialShopOpen");
                        area = new Rectangle ();
                        area.x = SHOP_BUTTON_X;
                        area.y = SHOP_BUTTON_Y;
                        area.width = SHOP_BUTTON_WIDTH;
                        area.height = SHOP_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (SHOP_BUTTON_POS_X, SHOP_BUTTON_POS_Y);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_SHOP_OPEN);
                        break;
                    case (TutorialStep.SHOP_SELECT_ITEM_1):
                        message = textsManager.getText ("tutorialShopSelectItem1");
                        area = new Rectangle ();
                        area.x = SHOP_ITEM_1_X;
                        area.y = SHOP_ITEM_1_Y;
                        area.width = SHOP_ITEM_WIDTH;
                        area.height = SHOP_ITEM_HEIGHT;
                        tutorialOverlay.positionArrow (SHOP_ITEM_1_POS_X, SHOP_ITEM_1_POS_Y);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_SHOP_SELECT_ITEM_1);
                        break;
                    case (TutorialStep.SHOP_BUY_ITEM_1):
                        message = textsManager.getText ("tutorialShopBuyItem1");
                        area = new Rectangle ();
                        area.x = T_SHIRT_CONSTRUCTOR_X;
                        area.y = T_SHIRT_CONSTRUCTOR_Y;
                        area.width = T_SHIRT_CONSTRUCTOR_WIDTH;
                        area.height = T_SHIRT_CONSTRUCTOR_HEIGHT;
                        tutorialOverlay.positionArrow (T_SHIRT_CONSTRUCTOR_POS_X, T_SHIRT_CONSTRUCTOR_POS_Y);
                        break;
                    case (TutorialStep.SHOP_SELECT_CATEGORY_2):
                        message = textsManager.getText ("tutorialShopSelectCategory2");
                        area = new Rectangle ();
                        area.x = SHOP_CATEGORY_2_X;
                        area.y = SHOP_CATEGORY_Y;
                        area.width = SHOP_CATEGORY_WIDTH;
                        area.height = SHOP_CATEGORY_HEIGHT;
                        tutorialOverlay.positionArrow (SHOP_CATEGORY_2_POS_X, SHOP_CATEGORY_POS_Y);
                        break;
                    case (TutorialStep.SHOP_SELECT_ITEM_2):
                        message = textsManager.getText ("tutorialShopSelectItem2");
                        area = new Rectangle ();
                        area.x = SHOP_ITEM_2_X;
                        area.y = SHOP_ITEM_2_Y;
                        area.width = SHOP_ITEM_WIDTH;
                        area.height = SHOP_ITEM_HEIGHT;
                        tutorialOverlay.positionArrow (SHOP_ITEM_2_POS_X, SHOP_ITEM_2_POS_Y);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_SHOP_SELECT_ITEM_2);
                        break;
                    case (TutorialStep.SHOP_BUY_ITEM_2):
                        message = textsManager.getText ("tutorialShopBuyItem2");
                        area = new Rectangle ();
                        area.x = BUY_BUTTON_X;
                        area.y = BUY_BUTTON_Y;
                        area.width = BUY_BUTTON_WIDTH;
                        area.height = BUY_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (BUY_BUTTON_POS_X, BUY_BUTTON_POS_Y);
                        break;
                    case (TutorialStep.SHOP_SELECT_CATEGORY_3):
                        message = textsManager.getText ("tutorialShopSelectCategory3");
                        area = new Rectangle ();
                        area.x = SHOP_CATEGORY_3_X;
                        area.y = SHOP_CATEGORY_Y;
                        area.width = SHOP_CATEGORY_WIDTH;
                        area.height = SHOP_CATEGORY_HEIGHT;
                        tutorialOverlay.positionArrow (SHOP_CATEGORY_3_POS_X, SHOP_CATEGORY_POS_Y);
                        break;
                    case (TutorialStep.SHOP_SELECT_ITEM_3):
                        message = textsManager.getText ("tutorialShopSelectItem3");
                        area = new Rectangle ();
                        area.x = SHOP_ITEM_3_X;
                        area.y = SHOP_ITEM_3_Y;
                        area.width = SHOP_ITEM_WIDTH;
                        area.height = SHOP_ITEM_HEIGHT;
                        tutorialOverlay.positionArrow (SHOP_ITEM_3_POS_X, SHOP_ITEM_3_POS_Y);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_SHOP_SELECT_ITEM_3);
                        break;
                    case (TutorialStep.SHOP_BUY_ITEM_3):
                        message = textsManager.getText ("tutorialShopBuyItem3");
                        area = new Rectangle ();
                        area.x = BUY_BUTTON_X;
                        area.y = BUY_BUTTON_Y;
                        area.width = BUY_BUTTON_WIDTH;
                        area.height = BUY_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (BUY_BUTTON_POS_X, BUY_BUTTON_POS_Y);
                        break;
                    case (TutorialStep.SHOP_CLOSE):
                        message = textsManager.getText ("tutorialShopClose");
                        area = new Rectangle ();
                        area.x = SHOP_CLOSE_BUTTON_X;
                        area.y = SHOP_CLOSE_BUTTON_Y;
                        area.width = SHOP_CLOSE_BUTTON_WIDTH;
                        area.height = SHOP_CLOSE_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (SHOP_CLOSE_BUTTON_POS_X, SHOP_CLOSE_BUTTON_POS_Y);
                        break;

                    /////////////////////////////////////////////
                    //DRESS ROOM:
                    /////////////////////////////////////////////

                    case (TutorialStep.DRESS_ROOM_OPEN):
                        message = textsManager.getText ("tutorialDressRoomOpen");
                        area = new Rectangle ();
                        area.x = DRESS_ROOM_BUTTON_X;
                        area.y = DRESS_ROOM_BUTTON_Y;
                        area.width = DRESS_ROOM_BUTTON_WIDTH;
                        area.height = DRESS_ROOM_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (DRESS_ROOM_BUTTON_POS_X, DRESS_ROOM_BUTTON_POS_Y);
                        break;
                    case (TutorialStep.DRESS_ROOM_SELECT_CATEGORY_1):
                        message = textsManager.getText ("tutorialDressRoomSelectCategory1");
                        area = new Rectangle ();
                        area.x = DRESS_ROOM_CATEGORY_1_X;
                        area.y = DRESS_ROOM_CATEGORY_Y;
                        area.width = DRESS_ROOM_CATEGORY_WIDTH;
                        area.height = DRESS_ROOM_CATEGORY_HEIGHT;
                        tutorialOverlay.positionArrow (DRESS_ROOM_CATEGORY_1_POS_X, DRESS_ROOM_CATEGORY_POS_Y);
                        break;
                    case (TutorialStep.DRESS_ROOM_SELECT_ITEM_1):
                        message = textsManager.getText ("tutorialDressRoomSelectItem1");
                        area = new Rectangle ();
                        area.x = DRESS_ROOM_ITEM_1_X;
                        area.y = DRESS_ROOM_ITEM_1_Y;
                        area.width = DRESS_ROOM_ITEM_WIDTH;
                        area.height = DRESS_ROOM_ITEM_HEIGHT;
                        tutorialOverlay.positionArrow (DRESS_ROOM_ITEM_1_POS_X, DRESS_ROOM_ITEM_1_POS_Y);
                        break;
                    case (TutorialStep.DRESS_ROOM_SET_ITEM_1):
                        message = textsManager.getText ("tutorialDressRoomBuyItem2");
                        area = new Rectangle ();
                        area.x = SET_BUTTON_X;
                        area.y = SET_BUTTON_Y;
                        area.width = SET_BUTTON_WIDTH;
                        area.height = SET_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (SET_BUTTON_POS_X, SET_BUTTON_POS_Y);
                        break;
                    case (TutorialStep.DRESS_ROOM_SELECT_CATEGORY_2):
                        message = textsManager.getText ("tutorialDressRoomSelectCategory2");
                        area = new Rectangle ();
                        area.x = DRESS_ROOM_CATEGORY_2_X;
                        area.y = DRESS_ROOM_CATEGORY_Y;
                        area.width = DRESS_ROOM_CATEGORY_WIDTH;
                        area.height = DRESS_ROOM_CATEGORY_HEIGHT;
                        tutorialOverlay.positionArrow (DRESS_ROOM_CATEGORY_2_POS_X, DRESS_ROOM_CATEGORY_POS_Y);
                        break;
                    case (TutorialStep.DRESS_ROOM_SELECT_ITEM_2):
                        message = textsManager.getText ("tutorialDressRoomSelectItem2");
                        area = new Rectangle ();
                        area.x = DRESS_ROOM_ITEM_2_X;
                        area.y = DRESS_ROOM_ITEM_2_Y;
                        area.width = DRESS_ROOM_ITEM_WIDTH;
                        area.height = DRESS_ROOM_ITEM_HEIGHT;
                        tutorialOverlay.positionArrow (DRESS_ROOM_ITEM_2_POS_X, DRESS_ROOM_ITEM_2_POS_Y);
                        break;
                    case (TutorialStep.DRESS_ROOM_SET_ITEM_2):
                        message = textsManager.getText ("tutorialDressRoomBuyItem2");
                        area = new Rectangle ();
                        area.x = SET_BUTTON_X;
                        area.y = SET_BUTTON_Y;
                        area.width = SET_BUTTON_WIDTH;
                        area.height = SET_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (SET_BUTTON_POS_X, SET_BUTTON_POS_Y);
                        break;
                    case (TutorialStep.DRESS_ROOM_CLOSE):
                        message = textsManager.getText ("tutorialDressRoomClose");
                        area = new Rectangle ();
                        area.x = DRESS_ROOM_CLOSE_BUTTON_X;
                        area.y = DRESS_ROOM_CLOSE_BUTTON_Y;
                        area.width = DRESS_ROOM_CLOSE_BUTTON_WIDTH;
                        area.height = DRESS_ROOM_CLOSE_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (DRESS_ROOM_CLOSE_BUTTON_POS_X, DRESS_ROOM_CLOSE_BUTTON_POS_Y);
                        break;

                    /////////////////////////////////////////////
                    //BATTLE:
                    /////////////////////////////////////////////

                    case (TutorialStep.BATTLE_OPEN):
                        message = textsManager.getText ("tutorialBattleOpen");
                        area = new Rectangle ();
                        area.x = BATTLE_BUTTON_X;
                        area.y = BATTLE_BUTTON_Y;
                        area.width = BATTLE_BUTTON_WIDTH;
                        area.height = BATTLE_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (BATTLE_BUTTON_POS_X, BATTLE_BUTTON_POS_Y);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_BATTLE_OPEN);
                        break;
                    case (TutorialStep.BATTLE_SELECT):
                        message = textsManager.getText ("tutorialBattleSelect");
                        area = new Rectangle ();
                        area.x = BATTLE_SELECT_BUTTON_X;
                        area.y = BATTLE_SELECT_BUTTON_Y;
                        area.width = BATTLE_SELECT_BUTTON_WIDTH;
                        area.height = BATTLE_SELECT_BUTTON_HEIGHT;
                        tutorialOverlay.positionArrow (BATTLE_SELECT_BUTTON_POS_X, BATTLE_SELECT_BUTTON_POS_Y);
                        break;
                    case (TutorialStep.BATTLE_START):
                        message = textsManager.getText ("tutorialBattleStart");
                        area = new Rectangle ();
                        area.x = BATTLE_START_AREA_X;
                        area.y = BATTLE_START_AREA_Y;
                        area.width = BATTLE_START_AREA_WIDTH;
                        area.height = BATTLE_START_AREA_HEIGHT;
                        tutorialOverlay.positionArrow (BATTLE_START_POS_X, BATTLE_START_POS_Y, Orientation.LEFT);
                        tutorialOverlay.showArrowWithDelay (BATTLE_START_ARROW_DELAY);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_BATTLE_START);
                        break;
                    case (TutorialStep.BATTLE_MAIN):
                        area = new Rectangle ();
                        area.x = BATTLE_AREA_X;
                        area.y = BATTLE_AREA_Y;
                        area.width = BATTLE_AREA_WIDTH;
                        area.height = BATTLE_AREA_HEIGHT;
                        tutorialOverlay.hideArrow ();
                        break;
                    case (TutorialStep.BATTLE_WIN):
                        message = textsManager.getText ("tutorialBattleWin");
                        area = new Rectangle ();
                        area.x = BATTLE_AREA_X;
                        area.y = BATTLE_AREA_Y;
                        area.width = BATTLE_AREA_WIDTH;
                        area.height = BATTLE_AREA_HEIGHT;
                        tutorialOverlay.hideArrow ();
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_BATTLE_WIN);
                        break;

                    /////////////////////////////////////////////
                    //SCREEN_SHOT:
                    /////////////////////////////////////////////

                    case (TutorialStep.MOVE_CHARACTER):
                        message = textsManager.getText ("tutorialMoveCharacter");
                        area = new Rectangle ();
                        area.x = CHARACTER_MOVE_AREA_X;
                        area.y = CHARACTER_MOVE_AREA_Y;
                        area.width = CHARACTER_MOVE_AREA_WIDTH;
                        area.height = CHARACTER_MOVE_AREA_HEIGHT;
                        tutorialOverlay.positionArrow (CHARACTER_MOVE_BUTTON_POS_X, CHARACTER_MOVE_BUTTON_POS_Y);
                        break;
                    case (TutorialStep.CREATE_SCREEN_SHOT):
                        message = textsManager.getText ("tutorialCreateScreenshot");
                        var area1:Rectangle = new Rectangle ();
                        area1.x = CHARACTER_MOVE_AREA_X;
                        area1.y = CHARACTER_MOVE_AREA_Y;
                        area1.width = CHARACTER_MOVE_AREA_WIDTH;
                        area1.height = CHARACTER_MOVE_AREA_HEIGHT;
                        var area2:Rectangle = new Rectangle ();
                        area2.x = CREATE_SCREEN_SHOT_AREA_X;
                        area2.y = CREATE_SCREEN_SHOT_AREA_Y;
                        area2.width = CREATE_SCREEN_SHOT_AREA_WIDTH;
                        area2.height = CREATE_SCREEN_SHOT_AREA_HEIGHT;
                        areas.push (area1);
                        areas.push (area2);
                        tutorialOverlay.showHidingBackground (areas, false);
                        tutorialOverlay.positionArrow (CREATE_SCREEN_SHOT_POS_X, CREATE_SCREEN_SHOT_POS_Y, Orientation.LEFT);
                        SoundManager.instance.playVoice (Template.SND_VOICE_TUTOR_CREATE_SCREEN_SHOT);
                        break;

                    /////////////////////////////////////////////
                    //FINISH:
                    /////////////////////////////////////////////

                    case (TutorialStep.FINISH):
                        message = textsManager.getText ("tutorialFinish");
                        tutorialOverlay.showNextButton ();
                        tutorialOverlay.hide ();
                        break;
                }
                if (area) {
                    areas.push (area);
                    tutorialOverlay.showHidingBackground (areas);
                }
                tutorialOverlay.setText (message);
            }
            else {
                tutorialOverlay.hide ();
            }
        }

        private function onSaveTutorialStep (response:Object):void {
            //
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}

