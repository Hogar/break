/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.07.13
 * Time: 12:45
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.danceMovesWindow {

    import breakdance.BreakdanceApp;
    import breakdance.core.server.ServerApi;
    import breakdance.core.sound.SoundManager;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.awards.Award;
    import breakdance.data.awards.AwardCollection;
    import breakdance.data.danceMoves.DanceMoveCategory;
    import breakdance.data.danceMoves.DanceMoveLevel;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.data.shop.ShopItemConditionType;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.commons.CoinsAwardAnimation;
    import breakdance.ui.commons.ItemsAwardAnimation;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.screens.ClosingScreen;
    import breakdance.ui.screens.danceMovesWindow.events.SelectDanceMove;
    import breakdance.user.AppUser;
    import breakdance.user.UserDanceMove;
    import breakdance.user.UserLevel;
    import breakdance.user.UserLevelCollection;
    import breakdance.user.events.ChangeUserEvent;

    import com.hogargames.app.screens.IScreen;
    import com.hogargames.utils.StringUtilities;

    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class DanceMovesWindow extends ClosingScreen implements IScreen, ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var danceMoviesList:DanceMoviesList;
        private var video:DanceMoveVideo;
        private var coinsAward:CoinsAwardAnimation;
        private var itemsAward:ItemsAwardAnimation;

        private var tfTitle:TextField;

        private var tabs:Vector.<DanceMovesCategoryTab>;

        private var userDanceMoveForLearning:UserDanceMove;

        private var appUser:AppUser;
        private var tutorialManager:TutorialManager;

        private static const NUM_CATEGORY_TABS:int = 5;

        public function DanceMovesWindow () {
            appUser = BreakdanceApp.instance.appUser;
            tutorialManager = TutorialManager.instance;
            super (Template.createSymbol (Template.DANCE_MOVIES_WINDOWS));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function setTexts ():void {
            tfTitle.text = textsManager.getText ("danceMovies");
        }

        override public function onShow ():void {
            super.onShow ();
            danceMoviesList.clear ();

            selectTab (tabs [0]);
        }

        override public function onHide ():void {
            super.onHide ();
            selectTab (null);
        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);
            if (tabs) {
                for (var i:int = 0; i < tabs.length; i++) {
                    var tab:DanceMovesCategoryTab = tabs [i];
                    tab.destroy ();
                }
                tabs = null;
            }
            if (danceMoviesList) {
                danceMoviesList.removeEventListener (SelectDanceMove.SELECT_DANCE_MOVIE, selectDanceMovieListener);
                danceMoviesList.destroy ();
                danceMoviesList = null;
            }
            if (video) {
                video.destroy ();
                video = null;
            }
            if (coinsAward) {
                coinsAward.destroy ();
                coinsAward = null;
            }
            if (itemsAward) {
                itemsAward.destroy ();
                itemsAward = null;
            }
            appUser.removeEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            danceMoviesList = new DanceMoviesList (mc ["mcDanceMoviesList"]);
            video = new DanceMoveVideo (mc ["mcVideo"]);
            video.hide ();
            coinsAward = new CoinsAwardAnimation (mc ["mcCoinsAward"]);
            itemsAward = new ItemsAwardAnimation (mc ["mcItemsAward"]);
            coinsAward.hide ();
            itemsAward.hide ();

            tfTitle = getElement ("tfTitle");

            //создаём табы:
            tabs = new Vector.<DanceMovesCategoryTab> ();
            var categoryList:Vector.<DanceMoveCategory> = DanceMoveTypeCollection.instance.categoryList;
            var numCategories:int = categoryList.length;
            for (var i:int = 0; i < NUM_CATEGORY_TABS; i++) {
                var tab:DanceMovesCategoryTab = new DanceMovesCategoryTab (mc ["btnTab_" + (i + 1)]);
                if (i < numCategories) {
                    tab.danceMoveCategory = categoryList [i];
                    tab.addEventListener (MouseEvent.CLICK, clickListener);
                    tabs.push (tab);
                }
                else {
                    tab.visible = false;
                }
            }

            appUser.addEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);
            danceMoviesList.addEventListener (SelectDanceMove.SELECT_DANCE_MOVIE, selectDanceMovieListener);

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function selectTab (tab:DanceMovesCategoryTab):void {
            var danceMoveCategory:DanceMoveCategory;
            if (tab) {
                danceMoveCategory = tab.danceMoveCategory;
            }
            if (danceMoveCategory) {
                var userDanceMovies:Vector.<UserDanceMove> = appUser.getUserDanceMoviesByCategory (danceMoveCategory.id);
                if (
                        (tutorialManager.currentStep == TutorialStep.TRAINING_MOVE_1) ||
                        (tutorialManager.currentStep == TutorialStep.TRAINING_MOVE_2) ||
                        (tutorialManager.currentStep == TutorialStep.TRAINING_MOVE_3)
                ) {
                    danceMoviesList.lockMouseWheel ();
                }
                else {
                    danceMoviesList.unLockMouseWheel ();
                }
                danceMoviesList.init (userDanceMovies);
            }
            else {
                danceMoviesList.clear ();
            }
            for (var i:int = 0; i < tabs.length; i++) {
                var currentTab:DanceMovesCategoryTab = tabs [i];
                currentTab.selected = (currentTab == tab);
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        override protected function clickListener_btnClose (event:MouseEvent):void {
            super.clickListener_btnClose (event);
            if (tutorialManager.currentStep == TutorialStep.TRAINING_CLOSE) {
                tutorialManager.completeStep (TutorialStep.TRAINING_CLOSE);
            }
        }

        private function clickListener (event:MouseEvent):void {
            var tab:DanceMovesCategoryTab = DanceMovesCategoryTab (event.currentTarget);
            selectTab (tab);
            var danceMoveType:DanceMoveType;
            if (tutorialManager.currentStep == TutorialStep.TRAINING_SELECT_CATEGORY_2) {
                danceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (TutorialManager.DANCE_MOVE_2);
                if (danceMoveType && tab) {
                    if (danceMoveType.category == tab.danceMoveCategory.id) {
                        tutorialManager.completeStep (TutorialStep.TRAINING_SELECT_CATEGORY_2);
                    }
                }
            }
            if (tutorialManager.currentStep == TutorialStep.TRAINING_SELECT_CATEGORY_3) {
                danceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (TutorialManager.DANCE_MOVE_3);
                if (danceMoveType && tab) {
                    if (danceMoveType.category == tab.danceMoveCategory.id) {
                        tutorialManager.completeStep (TutorialStep.TRAINING_SELECT_CATEGORY_3);
                    }
                }
            }
        }

        private function selectDanceMovieListener (event:SelectDanceMove):void {
            var userDanceMove:UserDanceMove = event.userDanceMove;
            if (userDanceMove) {
                userDanceMoveForLearning = userDanceMove;
                var energyForTrainDanceMove:int = parseInt (StaticData.instance.getSetting ("energy_for_train_dance_move"));

                var title:String;
                var message:String;

                if (appUser.energy >= energyForTrainDanceMove) {
                    var learnDanceMovie:Boolean = true;
                    var nextDanceMoveLevel:DanceMoveLevel;
                    var previousEnergySpent:int = 0;
                    var danceMoveType:DanceMoveType = userDanceMove.type;
                    var nextUserLevel:UserLevel = UserLevelCollection.instance.getUserLevel (appUser.level + 1);
//                    trace (
//                            "appUser.energySpent (" + appUser.energySpent + ") <= " +
//                            "(currentUserLevel.energyRequired (" + nextUserLevel.energyRequired + ") - energyForTrainDanceMove (" + energyForTrainDanceMove + ")) " +
//                            "(" + (nextUserLevel.energyRequired - energyForTrainDanceMove) + ") = " +
//                           Boolean (appUser.energySpent >= (nextUserLevel.energyRequired))
//                    );
                    if (nextUserLevel && (appUser.energySpent >= (nextUserLevel.energyRequired))) {
                        title = textsManager.getText ("maxEnergySpentTitle");
                        message = textsManager.getText ("maxEnergySpentText");
                        PopUpManager.instance.infoPopUp.showMessage (title, message);
                        learnDanceMovie = false;
                    }
                    else {
                        if (danceMoveType) {
                            var currentDanceMoveLevel:DanceMoveLevel = danceMoveType.getLevel (userDanceMove.level);
                            if (currentDanceMoveLevel) {
                                previousEnergySpent = currentDanceMoveLevel.energyRequired;
                            }
                            nextDanceMoveLevel = danceMoveType.getLevel (userDanceMove.level + 1);
                        }
                        if (nextDanceMoveLevel) {
                            if (userDanceMove.energySpent == (nextDanceMoveLevel.energyRequired - previousEnergySpent - energyForTrainDanceMove)) {
                                if (nextDanceMoveLevel.coins > appUser.coins) {
//                                    trace ("Надо " + nextDanceMoveLevel.coins + " монет, а у нас только " + appUser.coins + ". Показываем окно покупки монет.");
                                    PopUpManager.instance.notEnoughBucksPopUp.show ();
                                    learnDanceMovie = false;
                                }
                                else if (nextDanceMoveLevel.bucks > appUser.bucks) {
//                                    trace ("Надо " + nextDanceMoveLevel.bucks + " баксов, а у нас только " + appUser.bucks + ". Показываем окно покупки баксов.");
                                    PopUpManager.instance.notEnoughCoinsPopUp.show ();
                                    learnDanceMovie = false;
                                }
                            }
                        }
                        else {
                            //Вывести сообщение, что движение уже изучено до максимума?
                            learnDanceMovie = false;
                        }
                    }

                    if (learnDanceMovie) {
                        TransactionOverlay.instance.show ();
                        ServerApi.instance.query (ServerApi.LEARN_STEP, {step_id: userDanceMoveForLearning.type.id, energy_spent: energyForTrainDanceMove}, onResponse);
                    }
                }
                else {
                    title = textsManager.getText ("notEnoughEnergyTitle");
                    message = textsManager.getText ("notEnoughEnergyText");
                    PopUpManager.instance.infoPopUp.showMessage (title, message);
                }
            }
        }

        private function onResponse (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (response.response_code == 1) {
                var newCoins:int;
                var newUnlockedItem:Vector.<String> = new Vector.<String> ();
                var newItem:String = "";

                var previousUserCoins:int = appUser.coins;
                var previousUserDanceMovieLevel:int;
                var isFirstTraining:Boolean;
                if (userDanceMoveForLearning) {
                    previousUserDanceMovieLevel = userDanceMoveForLearning.level;
                    isFirstTraining = ((userDanceMoveForLearning.level == 0) && (userDanceMoveForLearning.energySpent == 0));
                }
                appUser.init (response);
                if (userDanceMoveForLearning) {
                    var currentUserDanceMovieLevel:int = appUser.getDanceMoveLevel (userDanceMoveForLearning.type.id);
//                    trace ("isFirstTraining = " + isFirstTraining);
                    if (isFirstTraining || (currentUserDanceMovieLevel > previousUserDanceMovieLevel)) {
                        video.show (userDanceMoveForLearning.type);
                    }
                    var shopItems:Vector.<ShopItem> = ShopItemCollection.instance.list;
                    for (var i:int = 0; i < shopItems.length; i++) {
                        var shopItem:ShopItem = shopItems [i];
                        if (shopItem.conditionType == ShopItemConditionType.STEP) {
                            var conditionValueAsArray:Array = shopItem.conditionValue.split (":");
                            var stepId:String = conditionValueAsArray [0];
                            var stepLevel:int = parseInt (conditionValueAsArray [1]);
                            if (
                                    userDanceMoveForLearning.type.id == stepId &&
                                    userDanceMoveForLearning.energySpent == 0 &&
                                    currentUserDanceMovieLevel == stepLevel
                            ) {
                                var newItems:Vector.<String> = appUser.newItems;
                                newUnlockedItem.push (shopItem.id);
                                if (newItems.indexOf (shopItem.id) == -1) {
                                    appUser.addNewItem (shopItem.id);
                                    ServerApi.instance.query (ServerApi.ADD_USER_NEWS, {item_id:shopItem.id}, onAddUserNewsResponse);
                                }
                                else {
//                                    trace ("да такая штука уже есть у меня.");
                                }
                            }
                        }
                    }
                    if (currentUserDanceMovieLevel > previousUserDanceMovieLevel) {
                        SoundManager.instance.playSound(Template.SND_BREAK_BEAT);
                        var danceMoveType:DanceMoveType = userDanceMoveForLearning.type;
                        if (danceMoveType) {
                            var danceMovieLevel:DanceMoveLevel = danceMoveType.getLevel (currentUserDanceMovieLevel);
                            if (danceMovieLevel) {
                                var awardId:String = danceMovieLevel.awardId;
                                if (!StringUtilities.isNotValueString (awardId)) {
                                    var award:Award = AwardCollection.instance.getAward (awardId);
                                    var itemId:String = award.itemId;
                                    if (
                                        !StringUtilities.isNotValueString (itemId) &&
                                        appUser.itemIsPurchased (itemId)
                                    ) {
                                        newItem = itemId;
                                    }
                                }
                            }
                        }

                        newCoins = appUser.coins - previousUserCoins;
                        coinsAward.showCoins (newCoins);
                        itemsAward.showItems (newUnlockedItem, newItem);

                        var tutorialManager:TutorialManager = TutorialManager.instance;
                        if (tutorialManager.currentStep == TutorialStep.TRAINING_MOVE_1) {
                            if (danceMoveType.id == TutorialManager.DANCE_MOVE_1) {
                                if (currentUserDanceMovieLevel == 1) {
                                    tutorialManager.completeStep (TutorialStep.TRAINING_MOVE_1);
                                }
                            }
                        }
                        if (tutorialManager.currentStep == TutorialStep.TRAINING_MOVE_2) {
                            if (danceMoveType.id == TutorialManager.DANCE_MOVE_2) {
                                if (currentUserDanceMovieLevel == 1) {
                                    tutorialManager.completeStep (TutorialStep.TRAINING_MOVE_2);
                                }
                            }
                        }
                        if (tutorialManager.currentStep == TutorialStep.TRAINING_MOVE_3) {
                            if (danceMoveType.id == TutorialManager.DANCE_MOVE_3) {
                                if (currentUserDanceMovieLevel == 1) {
                                    tutorialManager.completeStep (TutorialStep.TRAINING_MOVE_3);
                                }
                            }
                        }

                    }
                }

                danceMoviesList.updateInfo ();
            }

            userDanceMoveForLearning = null;
            previousUserDanceMovieLevel = -1;
        }

        private function changeUserListener (event:ChangeUserEvent):void {
            danceMoviesList.updateInfo ();
        }

        private function onAddUserNewsResponse (response:Object):void {
            //
        }

    }
}
