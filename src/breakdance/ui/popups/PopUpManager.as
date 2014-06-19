/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.07.13
 * Time: 9:39
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

	import breakdance.ui.popups.achievementPopUp.AchievementListPopUp;
    import breakdance.ui.popups.basePopUps.BasePopUp;
    import breakdance.ui.popups.battleListPopUp.BattleListPopUp;
    import breakdance.ui.popups.battlePopUp.BattleDefeatPopUp;
    import breakdance.ui.popups.battlePopUp.BattleTiePopUp;
    import breakdance.ui.popups.battlePopUp.BattleWinPopUp;
    import breakdance.ui.popups.bucksOffersPopUp.BucksOffersPopUp;
    import breakdance.ui.popups.dailyAwardPopUp.DailyAwardPopUp;
    import breakdance.ui.popups.editCharacterPopUp.CreateCharacterPopUp;
    import breakdance.ui.popups.editCharacterPopUp.EditCharacterPopUp;
    import breakdance.ui.popups.infoPopUp.IInfoPopUp;
    import breakdance.ui.popups.infoPopUp.InfoPopUpWithCharacter2;
    import breakdance.ui.popups.newLevelPopUp.NewLevelPopUp;
    import breakdance.ui.popups.newsPopUp.NewsPopUp;
	import breakdance.ui.popups.playerMusicPopUp.PlayerMusicPopUp;
    import breakdance.ui.popups.pvpLogPanel.PvpLogPanelPopUp;
    import breakdance.ui.popups.restoreStaminaPopUp.RestoreStaminaPopUp;
    import breakdance.ui.popups.topPlayersListPopUp.TopPlayersPopUp;

    import com.hogargames.errors.SingletonError;

    public class PopUpManager {

        static private var _instance:PopUpManager;

        public var deleteUserPopUp:DeleteUserPopUp;
        public var infoPopUp:IInfoPopUp;
        public var giftPopUp:GiftPopUp;
        public var errorPopUp:IInfoPopUp;
        public var battleListPopUp:BattleListPopUp;
        public var createCharacterPopUp:CreateCharacterPopUp;
        public var editCharacterPopUp:EditCharacterPopUp;
        public var bucksOffersPopUp:BucksOffersPopUp;
        public var acceptInvitePopUp:AcceptInvitePopUp;
        public var battleWinPopUp:BattleWinPopUp;
        public var battleTiePopUp:BattleTiePopUp;
        public var battleDefeatPopUp:BattleDefeatPopUp;
        public var sendInvitePopUp:SendInvitePopUp;
        public var languagePopUp:LanguagePopUp;
        public var topPlayersPopUp:TopPlayersPopUp;
		public var achievementPopUp:AchievementListPopUp;
        public var pvpLogPanelPopUp:PvpLogPanelPopUp;
        public var guessMoveGameResultPopUp:GuessMoveGameResultPopUp;
        public var leaveBattleScreenPopUp:LeaveBattleScreenPopUp;
        public var leaveMiniGameScreenPopUp:LeaveMiniGameScreenPopUp;
        public var newLevelPopUp:NewLevelPopUp;
		public var takeAchievementPopUp:TakeAchievementPopUp;		
        public var bucksToCoinsPopUp:BucksToCoinsPopUp;
        public var notEnoughCoinsPopUp:NotEnoughCoinsPopUp;
        public var notEnoughBucksPopUp:NotEnoughBucksPopUp;
        public var dailyAwardPopUp:DailyAwardPopUp;
        public var addTutorialPopUp:AddTutorialPopUp;
        public var restoreStaminaPopUp:RestoreStaminaPopUp;
        public var savePhotoPopUp:SavePhotoPopUp;
        public var beatStreetShopPopUp:BeatStreetShopPopUp;
        public var fiveStepsPopUp:FiveStepsPopUp;
        public var newsPopUp:NewsPopUp;
		public var playerMusicPopUp:PlayerMusicPopUp;

        private var allPopUps:Vector.<BasePopUp>;

        public function PopUpManager (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
            deleteUserPopUp = new DeleteUserPopUp ();
            infoPopUp = new InfoPopUpWithCharacter2 ();
            giftPopUp = new GiftPopUp ();
            errorPopUp = new ErrorPopUp ();
            battleListPopUp = new BattleListPopUp ();
            createCharacterPopUp = new CreateCharacterPopUp ();
            editCharacterPopUp = new EditCharacterPopUp ();
            bucksOffersPopUp = new BucksOffersPopUp ();
            acceptInvitePopUp = new AcceptInvitePopUp ();
            battleWinPopUp = new BattleWinPopUp ();
            battleTiePopUp = new BattleTiePopUp ();
            battleDefeatPopUp = new BattleDefeatPopUp ();
            sendInvitePopUp = new SendInvitePopUp ();
            languagePopUp = new LanguagePopUp ();
            topPlayersPopUp = new TopPlayersPopUp ();
			achievementPopUp = new AchievementListPopUp ();
            pvpLogPanelPopUp = new PvpLogPanelPopUp ();
            guessMoveGameResultPopUp = new GuessMoveGameResultPopUp ();
            leaveBattleScreenPopUp = new LeaveBattleScreenPopUp ();
            leaveMiniGameScreenPopUp = new LeaveMiniGameScreenPopUp ();
            newLevelPopUp = new NewLevelPopUp ();
			takeAchievementPopUp = new TakeAchievementPopUp();
            bucksToCoinsPopUp = new BucksToCoinsPopUp ();
            notEnoughCoinsPopUp = new NotEnoughCoinsPopUp ();
            notEnoughBucksPopUp = new NotEnoughBucksPopUp ();
            dailyAwardPopUp = new DailyAwardPopUp ();
            addTutorialPopUp = new AddTutorialPopUp ();
            restoreStaminaPopUp = new RestoreStaminaPopUp ();
            savePhotoPopUp = new SavePhotoPopUp ();
            beatStreetShopPopUp = new BeatStreetShopPopUp ();
            fiveStepsPopUp = new FiveStepsPopUp ();			
            newsPopUp = new NewsPopUp ();
			playerMusicPopUp = new PlayerMusicPopUp();

            allPopUps = new Vector.<BasePopUp> ();

            allPopUps.push (deleteUserPopUp);
            allPopUps.push (infoPopUp);
            allPopUps.push (giftPopUp);
            allPopUps.push (battleListPopUp);
            allPopUps.push (createCharacterPopUp);
            allPopUps.push (editCharacterPopUp);
            allPopUps.push (bucksOffersPopUp);
            allPopUps.push (acceptInvitePopUp);
            allPopUps.push (battleWinPopUp);
            allPopUps.push (battleTiePopUp);
            allPopUps.push (battleDefeatPopUp);
            allPopUps.push (sendInvitePopUp);
            allPopUps.push (languagePopUp);
            allPopUps.push (topPlayersPopUp);
			allPopUps.push (achievementPopUp);
//            allPopUps.push (pvpLogPanelPopUp);
            allPopUps.push (guessMoveGameResultPopUp);
            allPopUps.push (leaveBattleScreenPopUp);
            allPopUps.push (leaveMiniGameScreenPopUp);
            allPopUps.push (newLevelPopUp);
			allPopUps.push (takeAchievementPopUp);			
            allPopUps.push (bucksToCoinsPopUp);
            allPopUps.push (notEnoughCoinsPopUp);
            allPopUps.push (notEnoughBucksPopUp);
            allPopUps.push (dailyAwardPopUp);
            allPopUps.push (addTutorialPopUp);
            allPopUps.push (restoreStaminaPopUp);
            allPopUps.push (savePhotoPopUp);
            allPopUps.push (beatStreetShopPopUp);
            allPopUps.push (fiveStepsPopUp);
            allPopUps.push (newsPopUp);
			allPopUps.push (playerMusicPopUp);
			
        }


        public static function get instance ():PopUpManager {
            if (!_instance) {
                _instance = new PopUpManager (new SingletonKey ());
            }
            return _instance;
        }

        public function closeAllPopUps ():void {
            infoPopUp.clearMessages ();
            acceptInvitePopUp.clearInvites ();
            for (var i:int = 0; i < allPopUps.length; i++) {
                allPopUps [i].hide ();
            }
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}
