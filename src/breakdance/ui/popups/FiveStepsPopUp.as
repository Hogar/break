/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 06.03.14
 * Time: 4:16
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.BreakdanceApp;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.server.ServerApi;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.awards.Award;
    import breakdance.data.awards.AwardCollection;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.basePopUps.TitleClosingPopUp;
    import breakdance.user.FiveStepManager;
    import breakdance.user.UserMissions;
    import breakdance.user.events.ChangeUserEvent;

    import com.greensock.TweenLite;
    import com.hogargames.utils.NumericalUtilities;

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.text.TextField;

    public class FiveStepsPopUp extends TitleClosingPopUp {

        public var animationCount:int = 1;//Для анимации прогрессбаров.

        private var btnInstall:ButtonWithText;
        private var btnGroup:ButtonWithText;
        private var btnBookmarks:ButtonWithText;
        private var btnRePost:ButtonWithText;
        private var btnFriends:ButtonWithText;

        private var tfReward:TextField;
        private var tfBucks:TextField;
        private var tfCompleted:TextField;
        private var mcProgressBar:MovieClip;
        private var tfPercents:TextField;
        private var btnGetReward:ButtonWithText;

        private var fiveStepsAward:Award;

        public function FiveStepsPopUp () {
            var fiveStepsAwardId:String = StaticData.instance.getSetting ("award_5_steps");

            fiveStepsAward = AwardCollection.instance.getAward (fiveStepsAwardId);

            super (Template.createSymbol (Template.FIVE_STEPS_POP_UP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
            super.show ();
            FiveStepManager.instance.testSteps ();
            testButtons ();
        }

        override public function setTexts ():void {
            tfTitle.text = textsManager.getText ("5steps");

            btnInstall.text = textsManager.getText ("installStep");
            btnGroup.text = textsManager.getText ("groupStep");
            btnBookmarks.text = textsManager.getText ("bookmarksStep");
            btnRePost.text = textsManager.getText ("repostStep");
            btnFriends.text = textsManager.getText ("friendsStep");

            tfReward.text = textsManager.getText ("reward2");
            tfCompleted.text = textsManager.getText ("completed");
            btnGetReward.text = textsManager.getText ("getReward");
        }

        override public function destroy ():void {
            if (btnInstall) {
                btnInstall.destroy ();
                btnInstall = null;
            }
            if (btnGroup) {
                btnGroup.removeEventListener (MouseEvent.CLICK, clickListener);
                btnGroup.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnGroup.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btnGroup.destroy ();
                btnGroup = null;
            }
            if (btnBookmarks) {
                btnBookmarks.removeEventListener (MouseEvent.CLICK, clickListener);
                btnBookmarks.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnBookmarks.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btnBookmarks.destroy ();
                btnBookmarks = null;
            }
            if (btnRePost) {
                btnRePost.removeEventListener (MouseEvent.CLICK, clickListener);
                btnRePost.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnRePost.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btnRePost.destroy ();
                btnRePost = null;
            }
            if (btnFriends) {
                btnFriends.removeEventListener (MouseEvent.CLICK, clickListener);
                btnFriends.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnFriends.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btnFriends.destroy ();
                btnFriends = null;
            }
            if (btnGetReward) {
                btnGetReward.removeEventListener (MouseEvent.CLICK, clickListener);
                btnFriends.destroy ();
                btnFriends = null;
            }

            BreakdanceApp.instance.appUser.removeEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);

            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            btnInstall = new ButtonWithText (getElement ("btnInstall"));
            btnGroup = new ButtonWithText (getElement ("btnGroup"));
            btnBookmarks = new ButtonWithText (getElement ("btnBookmarks"));
            btnRePost = new ButtonWithText (getElement ("btnRePost"));
            btnFriends = new ButtonWithText (getElement ("btnFriends"));

            tfReward = getElement ("tfReward");
            tfBucks = getElement ("tfBucks");
            tfCompleted = getElement ("tfCompleted");
            mcProgressBar = getElement ("mcProgressBar");
            tfPercents = getElement ("tf", mcProgressBar);
            btnGetReward = new ButtonWithText (getElement ("btnGetReward"));

            tfReward.mouseEnabled = false;
            tfPercents.mouseEnabled = false;
            tfBucks.mouseEnabled = false;

            tfBucks.htmlText = "<b>" + String (fiveStepsAward.bucks) + "</b>";

            setPercent (20);

            btnGroup.addEventListener (MouseEvent.CLICK, clickListener);
            btnBookmarks.addEventListener (MouseEvent.CLICK, clickListener);
            btnRePost.addEventListener (MouseEvent.CLICK, clickListener);
            btnFriends.addEventListener (MouseEvent.CLICK, clickListener);
            btnGetReward.addEventListener (MouseEvent.CLICK, clickListener);

            btnGroup.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnBookmarks.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnRePost.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnFriends.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);

            btnGroup.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            btnBookmarks.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            btnRePost.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            btnFriends.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            BreakdanceApp.instance.appUser.addEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function testButtons ():void {
            btnInstall.enable = false;

            var userMissions:Vector.<String> = BreakdanceApp.instance.appUser.userMissions;

            btnGroup.enable = (userMissions.indexOf (UserMissions.ENTER_GROUP_MISSION) == -1);
            btnBookmarks.enable = (userMissions.indexOf (UserMissions.BOOKMARK_MISSION) == -1);
            btnRePost.enable = (userMissions.indexOf (UserMissions.RE_POST_MISSION) == -1);
            btnFriends.enable = (userMissions.indexOf (UserMissions.FRIENDS_MISSION) == -1);

            const PERCENTS_FOR_STEP:int = 20;
            var percentOfComplete:int = PERCENTS_FOR_STEP;
            if (userMissions.indexOf (UserMissions.ENTER_GROUP_MISSION) != -1) {
                percentOfComplete += PERCENTS_FOR_STEP;
            }
            if (userMissions.indexOf (UserMissions.BOOKMARK_MISSION) != -1) {
                percentOfComplete += PERCENTS_FOR_STEP;
            }
            if (userMissions.indexOf (UserMissions.RE_POST_MISSION) != -1) {
                percentOfComplete += PERCENTS_FOR_STEP;
            }
            if (userMissions.indexOf (UserMissions.FRIENDS_MISSION) != -1) {
                percentOfComplete += PERCENTS_FOR_STEP;
            }

            setPercent (percentOfComplete);

            var hasAward:Boolean = (BreakdanceApp.instance.appUser.userAwards.indexOf (fiveStepsAward.id) != -1);

            btnGetReward.enable = !hasAward && (percentOfComplete == 100);
        }

        private function setPercent (percent:int):void {
            percent = NumericalUtilities.correctValue (percent, 0, 100);
            tfPercents.htmlText = "<b>" + percent + "%</b>";
            percent = NumericalUtilities.correctValue (percent, 1, 100);
            animationCount = mcProgressBar.currentFrame;
            TweenLite.to (this, TWEEN_TIME, {animationCount:percent, onUpdate:onAnimationUpdate});
        }

        private function onAnimationUpdate ():void {
            mcProgressBar.gotoAndStop (animationCount);
            tfPercents.htmlText = "<b>" + animationCount + "%</b>";
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btnBookmarks:
                    JsApi.instance.query (JsApi.ADD_LEFT, onAddLeft);
                    break;
                case btnGroup:
                    var officialGroupUrl:String = StaticData.instance.getSetting ("official_group_url");
                    navigateToURL (new URLRequest (officialGroupUrl), "_blank");
                    break;
                case btnRePost:
                    JsApi.instance.query (JsApi.WRITE_WALL, onWriteWall, [textsManager.getText ("rePostMessage")]);
                    break;
                case btnFriends:
                    JsApi.instance.query (JsApi.INVITE_FRIENDS, onInviteFriend);
                    break;
                case  btnGetReward:   // получение награды
                    TransactionOverlay.instance.show ();
                    ServerApi.instance.query (ServerApi.GIVE_AWARD, {award_id:fiveStepsAward.id}, onGiveAward);
                    break;
            }
        }

        private function rollOverListener (event:MouseEvent):void {
            var displayObject:DisplayObject = DisplayObject (event.currentTarget);
            var tooltipText:String;
            switch (event.currentTarget) {
                case btnBookmarks:
                    tooltipText = textsManager.getText ("ttBookmarksStep");
                    break;
                case btnGroup:
                    tooltipText = textsManager.getText ("ttGroupStep");
                    break;
                case btnRePost:
                    tooltipText = textsManager.getText ("ttRepostStep");
                    break;
                case btnFriends:
                    tooltipText = textsManager.getText ("ttFriendsStep");
                    break;
            }
            if (tooltipText) {
                var positionPoint:Point = localToGlobal (new Point (displayObject.x + displayObject.width / 2, displayObject.y + displayObject.height));
                BreakdanceApp.instance.showTooltipMessage (tooltipText, positionPoint);
            }
        }

        private function onWriteWall (response:JsQueryResult):void {
            ServerApi.instance.query (ServerApi.SAVE_MISSION, {mission_id:UserMissions.RE_POST_MISSION}, onSaveMission_re_post);
        }

        private function onSaveMission_re_post (response:Object):void {
            BreakdanceApp.instance.appUser.onSaveMission (response);
        }

        private function onInviteFriend (response:JsQueryResult):void {
            //
        }

        private function onAddLeft (response:JsQueryResult):void {
            hide ();
        }

        private function onGiveAward (response:Object):void {
            TransactionOverlay.instance.hide ();
            BreakdanceApp.instance.appUser.onGiveAward (response);
            hide ();
        }

		private function onGiveAchievement (response:Object):void {
            TransactionOverlay.instance.hide ();
            BreakdanceApp.instance.appUser.onGiveAchievement (response);
            hide ();
        }
		
        private function changeUserListener (event:ChangeUserEvent):void {
            testButtons ();
        }

    }
}
