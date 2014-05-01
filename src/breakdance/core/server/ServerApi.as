package breakdance.core.server {

    import com.hogargames.errors.SingletonError;

    /**
     * @author Alexey Stashin
     */
    public class ServerApi {

        static public const USER_GET:String = 'user/get';
        static public const USER_GET_LIST:String = 'user/getList';
        static public const USER_ADD:String = 'user/add';
        static public const LEARN_STEP:String = 'user/learnStep';
        static public const BUY_ITEM:String = 'user/buyItem';
        static public const DELETE_USER:String = 'user/delete';
        static public const SAVE_SETTINGS:String = 'user/saveSettings';
        static public const SAVE_EQUIP_SLOT:String = 'user/equipSlot';
        static public const SELL_ITEM:String = 'user/sellItem';
        static public const ADD_USER_NEWS:String = 'user/addNews';
        static public const REMOVE_USER_NEWS:String = 'user/removeNews';
        static public const SAVE_USER_SCORES:String = 'user/saveUserScores';
        static public const GET_TOP_USERS:String = 'user/getTopUsers';
        static public const BATTLE_WIN:String = 'user/battleWin';
        static public const BATTLE_DRAW:String = 'user/battleDraw';
        static public const BATTLE_LOSE:String = 'user/battleLose';
        static public const UPDATE_USER_APPEARANCE:String = 'user/updateUserAppearance';
        static public const IMAGE_SAVE:String = 'image/save';
        static public const SELL_BUCKS:String = 'user/sellBucks';
        static public const TAKE_STAMINA:String = 'user/takeStamina';
        static public const DAILY_AWARD_ACTION:String = 'user/dailyAward';
        static public const SAVE_TUTORIAL_STEP:String = 'user/saveTutorialStep';
        static public const BUY_CONSUMABLES:String = 'user/buyConsumables';
        static public const APPLY_CONSUMABLES:String = 'user/applyConsumables';
        static public const SAVE_MISSION:String = 'user/saveMission';
        static public const GIVE_AWARD:String = 'user/giveAward';
        static public const TAKE_CHIPS:String = 'user/takeChips';
        static public const GIVE_CONSUMABLES:String = 'user/giveConsumables';
        static public const GIVE_COLLECTIONS:String = 'user/giveCollections';
        static public const SAVE_LOG:String = 'user/saveLog';
        static public const GET_LOG_LIST:String = 'user/getLogList';
        static public const BUY_CHIPS:String = 'user/buyChips';

        static private var _instance:ServerApi;

        public function ServerApi (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
        }

        static public function get instance ():ServerApi {
            if (!_instance) {
                _instance = new ServerApi (new SingletonKey ());
            }
            return _instance;
        }

        public function query (method:String, params:Object, onComplete:Function, onError:Function = null, serverQueryLog:ServerQueryLogData = null, showErrorPopUp:Boolean = true):void {
            new ServerQuery (method, params, onComplete, onError, serverQueryLog, showErrorPopUp);
        }

    }

}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}
