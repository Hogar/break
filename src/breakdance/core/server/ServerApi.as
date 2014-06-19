package breakdance.core.server {

    import com.hogargames.errors.SingletonError;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class ServerApi {

        static public const USER_GET				:String = 'user/get';
        static public const USER_GET_LIST			:String = 'user/getList'; // данные на юзера
        static public const USER_ADD				:String = 'user/add';
        static public const LEARN_STEP				:String = 'user/learnStep';
        static public const BUY_ITEM				:String = 'user/buyItem';
        static public const DELETE_USER				:String = 'user/delete';
        static public const SAVE_SETTINGS			:String = 'user/saveSettings';
        static public const SAVE_EQUIP_SLOT			:String = 'user/equipSlot';
        static public const SELL_ITEM				:String = 'user/sellItem';
        static public const ADD_USER_NEWS			:String = 'user/addNews';
        static public const REMOVE_USER_NEWS		:String = 'user/removeNews';
        static public const SAVE_USER_SCORES		:String = 'user/saveUserScores';
        static public const GET_TOP_USERS			:String = 'user/getTopUsers';
        static public const BATTLE_WIN				:String = 'user/battleWin';
        static public const BATTLE_DRAW				:String = 'user/battleDraw';
        static public const BATTLE_LOSE				:String = 'user/battleLose';
        static public const UPDATE_USER_APPEARANCE	:String = 'user/updateUserAppearance';
        static public const IMAGE_SAVE				:String = 'image/save';
        static public const SELL_BUCKS				:String = 'user/sellBucks';
        static public const TAKE_STAMINA			:String = 'user/takeStamina';
        static public const DAILY_AWARD_ACTION		:String = 'user/dailyAward';
        static public const SAVE_TUTORIAL_STEP		:String = 'user/saveTutorialStep';
        static public const BUY_CONSUMABLES			:String = 'user/buyConsumables';
        static public const APPLY_CONSUMABLES		:String = 'user/applyConsumables';
        static public const SAVE_MISSION			:String = 'user/saveMission';
        static public const GIVE_AWARD				:String = 'user/giveAward';    // получение награды
        static public const TAKE_CHIPS				:String = 'user/takeChips';
        static public const GIVE_CONSUMABLES		:String = 'user/giveConsumables';  //подарить бутылку
        static public const GIVE_COLLECTIONS		:String = 'user/giveCollections';   // послать билет в мягкий зал
        static public const SAVE_LOG				:String = 'user/saveLog';
        static public const GET_LOG_LIST			:String = 'user/getLogList';
        static public const BUY_CHIPS				:String = 'user/buyChips';
		
		static public const SAVE_EVENT				:String = 'user/saveEvent';  //принимает event_type и object_id и sender. и опционально user_id - если его нет, то записывает текущему юзеру
		static public const GET_EVENT_LIST			:String = 'user/getEventList';  //возвращает все ивенты. опционально user_id - если его нет, то записывает текущему юзеру
		static public const CHECK_EVENT_LIST		:String = 'user/checkEventList '; //помечает ивенты как прочитанные
		
		static public const SET_ACHIEVEMENT_ADD		:String = 'user/incrementAchievement'; // увеличивает на 1 прогресс achievemnt_id, озвращает новое состояние юзера user_id если не передать - то берется текущий юзер
		static public const SET_ACHIEVEMENT_VALUE	:String = 'user/setAchievement'; // value - устанавливает прогресс achievement_id у юзера user_id равным value озвращает новое состояние юзера
		
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

/* USER_GET_LIST
{"server_date":"2014-04-29 23:49:28 +06:00","server_time":1398793768,"response_code":1,"data":{"140678096":
	{"user": { "id":"140678096", "face_id":"4", "hair_id":"6", "level":"2", "energy":"100", "energy_spent":"100", "energy_max":"100", "stamina":"20", "stamina_max":"20", "battles":"6", "wins":"47", "row_wins":"4", "coins":"12018", "chips":"5", "award_day":"2", "modify_date":"2014-04-29 23:49:28", "award_date":"2014-04-29 20:36:35", "energy_date":"2014-04-29 23:49:25", "stamina_date":"2014-04-29 23:49:00", "create_date":"2013-11-06 17:17:08", "bucks":"1", "nickname":"140678096", "banned":"0", "chips_spent":"5", "draws":"0" }, 
				"user_scores_list":[ { "user_id":"140678096", "game_id":"0", "modify_date":"2013-11-06 02:26:03", "create_date":"2013-11-06 02:26:03", "scores":"3" } ],
				"user_item_list":[ { "user_id":"140678096", "item_id":"cap_gray", "modify_date":"2013-11-06 17:17:08", "create_date":"2013-11-06 17:17:08", "id":"2914", "color":"no_color" }, { "user_id":"140678096", "item_id":"elbow_l", "modify_date":"2013-11-06 17:17:08", "create_date":"2013-11-06 17:17:08", "id":"2915", "color":"no_color" }, { "user_id":"140678096", "item_id":"gold_helmet", "modify_date":"2013-11-06 19:10:51", "create_date":"2013-11-06 19:10:51", "id":"2949", "color":"no_color" }, { "user_id":"140678096", "item_id":"gumshoes_red", "modify_date":"2013-11-06 17:17:08", "create_date":"2013-11-06 17:17:08", "id":"2917", "color":"no_color" }, { "user_id":"140678096", "item_id":"headphones", "modify_date":"2013-11-06 19:11:00", "create_date":"2013-11-06 19:11:00", "id":"2950", "color":"no_color" }, { "user_id":"140678096", "item_id":"linoleum_chess", "modify_date":"2013-11-06 17:17:09", "create_date":"2013-11-06 17:17:09", "id":"2919", "color":"no_color" }, { "user_id":"140678096", "item_id":"singlet_gray", "modify_date":"2013-11-22 15:00:09", "create_date":"2013-11-22 15:00:09", "id":"4403", "color":"no_color" }, { "user_id":"140678096", "item_id":"singlet_red", "modify_date":"2013-11-06 17:17:08", "create_date":"2013-11-06 17:17:08", "id":"2913", "color":"no_color" }, { "user_id":"140678096", "item_id":"small_checked_shirt_red", "modify_date":"2013-11-06 19:11:15", "create_date":"2013-11-06 19:11:15", "id":"2951", "color":"no_color" }, { "user_id":"140678096", "item_id":"trousers_basic", "modify_date":"2013-11-06 17:17:08", "create_date":"2013-11-06 17:17:08", "id":"2916", "color":"no_color" }, { "user_id":"140678096", "item_id":"t_shirt_b222", "modify_date":"2014-04-27 22:47:09", "create_date":"2014-04-27 22:47:09", "id":"567513", "color":"green" }, { "user_id":"140678096", "item_id":"t_shirt_no_image", "modify_date":"2014-04-27 22:45:08", "create_date":"2014-04-27 22:45:08", "id":"567512", "color":"lightblue" }, { "user_id":"140678096", "item_id":"vesna_212_C4", "modify_date":"2013-11-06 17:17:09", "create_date":"2013-11-06 17:17:09", "id":"2918", "color":"no_color" } ],
				"user_slot_list":[]}},"error":""}
				
				*/
