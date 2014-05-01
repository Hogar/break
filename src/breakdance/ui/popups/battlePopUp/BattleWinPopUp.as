/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 06.09.13
 * Time: 22:59
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.battlePopUp {

    import breakdance.BreakdanceApp;
    import breakdance.battle.model.IBattle;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.staticData.StaticData;
    import breakdance.data.awards.Award;
    import breakdance.data.awards.AwardCollection;
    import breakdance.data.collections.CollectionType;
    import breakdance.data.collections.CollectionTypeCollection;
    import breakdance.events.BreakDanceAppEvent;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.commons.BattleBonusPanel;
    import breakdance.ui.commons.CoinsAwardAnimation;
    import breakdance.ui.commons.CollectionPanel;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.user.AppUser;
    import breakdance.user.UserCollectionData;
    import breakdance.user.events.ChangeUserEvent;
    import breakdance.user.events.GetCollectionItemEvent;
    import breakdance.user.events.WinsInRowEvent;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Point;
    import flash.text.TextField;

    public class BattleWinPopUp extends TwoTextButtonsPopUp implements IBattlePopUp {

        private var mcResult:MovieClip;
        private var collectionPanel:CollectionPanel;
        private var battleBonusPanel:BattleBonusPanel;
        private var _battle:IBattle;

        private var coins:int;

        private var mcCoins:Sprite;
        private var tfCoins:TextField;
        private var coinsAwardAnimation:CoinsAwardAnimation;

        private var appUser:AppUser;
        private var tutorialManager:TutorialManager;

        public function BattleWinPopUp () {
            tutorialManager = TutorialManager.instance;
            appUser = BreakdanceApp.instance.appUser;
            super (Template.createSymbol (Template.BATTLE_WIN_POPUP));
            useShowAnimation = false;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            super.setTexts ();
            tf.htmlText = "<i>" + textsManager.getText ("reward") + "</i>";
            tfTitle.htmlText = textsManager.getText ("victoryTitle");
            btn1.text = textsManager.getText ("share");
            btn2.text = textsManager.getText ("complete");
        }

        override public function show ():void {
         	super.show ();
            mcResult.gotoAndPlay (1);

            if (tutorialManager.currentStep == TutorialStep.BATTLE_MAIN) {
                tutorialManager.completeStep (TutorialStep.BATTLE_MAIN);
            }
//            updateBonusPanel ();

            if (coins > 0) {
                mcCoins.visible = true;
                tfCoins.text = String (coins);
                coinsAwardAnimation.showCoins (coins);
            }
            else {
                mcCoins.visible = false;
            }
        }

        override public function hide ():void {
         	super.hide ();
            if (tutorialManager.currentStep == TutorialStep.BATTLE_WIN) {
                tutorialManager.completeStep (TutorialStep.BATTLE_WIN);
            }
        }

        public function set battle (value:IBattle):void {
            _battle = value;
        }

        public function setCoins (value:int):void {
            coins = value;
        }

        override public function destroy ():void {
            if (battleBonusPanel) {
                battleBonusPanel.destroy ();
                battleBonusPanel = null;
            }
            if (collectionPanel) {
                collectionPanel.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                collectionPanel.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                collectionPanel.destroy ();
                collectionPanel = null;
            }
            appUser.removeEventListener (WinsInRowEvent.WINS_IN_ROW, winsInRowListener);
            appUser.removeEventListener (GetCollectionItemEvent.GET_COLLECTION_ITEM, getCollectionItemListener);
            appUser.removeEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            collectionPanel = new CollectionPanel (mc ["mcCollectionPanel"]);
            battleBonusPanel = new BattleBonusPanel (mc ["mcBattleBonusPanel"]);
            mcCoins = getElement ("mcCoins");
            tfCoins = getElement ("tfCoins", mcCoins);
            mcResult = getElement ("mcResult");
            coinsAwardAnimation = new CoinsAwardAnimation (mc ["mcCoinsAward"]);

            collectionPanel.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            collectionPanel.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            appUser.addEventListener (WinsInRowEvent.WINS_IN_ROW, winsInRowListener);
            appUser.addEventListener (GetCollectionItemEvent.GET_COLLECTION_ITEM, getCollectionItemListener);
            appUser.addEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);
        }

        override protected function onClickFirstButton ():void {
            var txtWinBattle:String = textsManager.getText ("winBattle");
            if (_battle && _battle.player1 && _battle.player2) {
                txtWinBattle = txtWinBattle.replace ("#1", _battle.player1.nickname.toUpperCase ());
                txtWinBattle = txtWinBattle.replace ("#2", _battle.player2.nickname.toUpperCase ());
                JsApi.instance.query (JsApi.WRITE_WALL, onWriteWall, [txtWinBattle]);
            }
            ScreenManager.instance.navigateBeforeBattle ();
            hide ();
        }

        override protected function onClickSecondButton ():void {
            ScreenManager.instance.navigateBeforeBattle ();
            hide ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////


        private function updateBonusPanel ():void {
            var numWinsInRow:int = parseInt (StaticData.instance.getSetting ("num_wins_in_row"));
            battleBonusPanel.setValue (appUser.winsInRow);
            if (appUser.winsInRow == numWinsInRow) {
                battleBonusPanel.showUnlock ();
            }
            else {
                battleBonusPanel.showLock ();
            }
            var awardId:String = StaticData.instance.getSetting ("award_wins_in_row");
            var award:Award = AwardCollection.instance.getAward (awardId);
            battleBonusPanel.setBonusValue (award.bucks);
        }

        private function onWriteWall (response:JsQueryResult):void {
            //
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function changeUserListener (event:ChangeUserEvent):void {
            updateBonusPanel ();
        }

        private function winsInRowListener (event:WinsInRowEvent):void {
            var numWinsInRow:int = parseInt (StaticData.instance.getSetting ("num_wins_in_row"));
            battleBonusPanel.setValue (numWinsInRow);
            battleBonusPanel.showUnlock ();
        }

        private function getCollectionItemListener (event:GetCollectionItemEvent):void {
            var collectionType:CollectionType = CollectionTypeCollection.instance.getCollectionType (event.collectionTypeId);
            if (collectionType) {
                collectionPanel.collectionType = collectionType;
                collectionPanel.setValue (event.amount);
            }
            else {
                collectionPanel.collectionType = null;
                collectionPanel.setValue (0);
            }
        }

        private function rollOverListener (event:MouseEvent):void {
            var userCollections:Vector.<UserCollectionData> = appUser.userCollections;
            if (userCollections) {
                var positionPoint:Point = mc.localToGlobal (new Point (collectionPanel.x + collectionPanel.width / 2, collectionPanel.y + collectionPanel.height));
                var message:String = "";
                for (var i:int = 0; i < userCollections.length; i++) {
                    var userCollectionData:UserCollectionData = userCollections [i];
                    var collectionType:CollectionType = CollectionTypeCollection.instance.getCollectionType (userCollectionData.id);
                    if (collectionType) {
                        message += collectionType.name + " - " + userCollectionData.count;
                        if (i != userCollections.length - 1) {
                            message += "\n";
                        }
                    }
                }
                BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
            }
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }

    }
}
