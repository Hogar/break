package breakdance.ui.popups {

    import breakdance.BreakdanceApp;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.AvatarContainer;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.user.AppUser;
    import breakdance.user.FriendData;

    import flash.text.TextField;

    public class GuessMoveGameResultPopUp extends TwoTextButtonsPopUp {

        private var avatarContainer:AvatarContainer;
        private var tfBestOfFriends:TextField;
        private var tfName:TextField;
        private var tfName2:TextField;
        private var tfRecordTitle:TextField;
        private var tfRecord:TextField;

        private var trueAnswers:int = 0;
        private var falseAnswers:int = 0;

        public function GuessMoveGameResultPopUp () {
            super (Template.createSymbol (Template.GUESS_MOVE_GAME_RESULT_POP_UP));
//            lock ();
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            var txtTitle:String = null;
            var appUser:AppUser = BreakdanceApp.instance.appUser;
            var record:int = Math.max (appUser.guessMoveGameRecord, trueAnswers);
            var friendData:FriendData = appUser.getBestUserFriendsInGuessMoveGame ();
            var textsManager:TextsManager = TextsManager.instance;
            txtTitle = textsManager.getText ("result");
            var txtGuessMovementStatistic:* = textsManager.getText ("guessMovementStatistic");
            txtGuessMovementStatistic = txtGuessMovementStatistic.replace ("#1", trueAnswers);
            txtGuessMovementStatistic = txtGuessMovementStatistic.replace ("#2", falseAnswers);
            txtGuessMovementStatistic = txtGuessMovementStatistic.replace ("#3", record);
            if (friendData && (friendData.guessMoveGameRecord > record)) {
                tfName.text = friendData.name;
                tfName2.text = friendData.nickname;
                tfRecord.text = String (friendData.guessMoveGameRecord);
                avatarContainer.initByPlayerData (friendData);
            }
            else {
                if (appUser.installed) {
                    tfName.text = appUser.nickname;
                    tfName2.text = appUser.name;
                    tfRecord.text = String (appUser.guessMoveGameRecord);
                    avatarContainer.initByPlayerData (appUser.asBattlePlayerData ());
                }
                else {
                    tfName.text = "";
                    tfName2.text = "";
                    tfRecord.text = "";
                }
            }
            tf.htmlText = txtGuessMovementStatistic;
            tfTitle.htmlText = txtTitle;
            btn1.text = textsManager.getText ("retry");
            btn2.text = textsManager.getText ("complete");
            tfBestOfFriends.htmlText = textsManager.getText ("bestOfFriends");
            tfRecordTitle.text = textsManager.getText ("record");
            positionText ();
        }

        public function setResult (param1:int, param2:int):void {
            trueAnswers = param1;
            falseAnswers = param2;
            setTexts ();
        }

        override public function hide ():void {
            super.hide ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            avatarContainer = new AvatarContainer (mc ["mcAvatarContainer"]);
            tfBestOfFriends = getElement ("tfBestOfFriends");
            tfName = getElement ("tfName");
            tfName2 = getElement ("tfName2");
            tfRecordTitle = getElement ("tfRecordTitle");
            tfRecord = getElement ("tfRecord");
        }

        override protected function onClickFirstButton ():void {
            ScreenManager.instance.reInit (ScreenManager.TRAINING_SCREEN);
            hide ();
        }

        override protected function onClickSecondButton ():void {
            ScreenManager.instance.navigateTo (ScreenManager.HOME_SCREEN);
            hide ();
        }

    }
}
