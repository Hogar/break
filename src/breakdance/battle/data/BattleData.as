/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.07.13
 * Time: 23:13
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.data {

    import breakdance.BreakdanceApp;
    import breakdance.user.AppUser;

    import com.hogargames.utils.StringUtilities;

    /**
     * Данные о бое.
     */
    public class BattleData {

        public var turns:int;
        public var bet:int;
        public var player1:BattlePlayerData;
        public var player2:BattlePlayerData;

        private static const TURNS_ID:int = 0;
        private static const BET_ID:int = 1;
        private static const PLAYER_1_ID:int = 2;
        private static const PLAYER_2_ID:int = 3;

        public function BattleData () {

        }

        /**
         * Кодирование в данные (для сервера).
         * @return Объект-данные.
         */
        public function asData ():Object {
            var arr:Array = [];
            arr [TURNS_ID] = turns;
            arr [BET_ID] = bet;
            if (player1) {
                arr [PLAYER_1_ID] = player1.asData ();
            }
            else {
                arr [PLAYER_1_ID] = "";
            }
            if (player2) {
                arr [PLAYER_2_ID] = player2.asData ();
            }
            else {
                arr [PLAYER_2_ID] = "";
            }
            return arr;
        }

        /**
         * Инициализация данными (с сервера).
         * @param data Объект-данные.
         */
        public function init (data:Object):void {
            if (data) {
                var dataAsArray:Array = data as Array;
                turns = dataAsArray [TURNS_ID];
                bet = dataAsArray [BET_ID];
                player1 = null;
                player2 = null;
                if (!StringUtilities.isNotValueString (dataAsArray [PLAYER_1_ID])) {
                    player1 = new BattlePlayerData ();
                    player1.init (dataAsArray [PLAYER_1_ID]);
                }
                if (!StringUtilities.isNotValueString (dataAsArray [PLAYER_2_ID])) {
                    player2 = new BattlePlayerData ();
                    player2.init (dataAsArray [PLAYER_2_ID]);
                }
            }
        }

        public function get opponentId ():String {
            var _opponentId:String;
            var appUser:AppUser = BreakdanceApp.instance.appUser;
            if (player1 && (player1.uid != appUser.uid)) {
                _opponentId = player1.uid;
            }
            if (!_opponentId && player2 && (player2.uid != appUser.uid)) {
                _opponentId = player2.uid;
            }
            return _opponentId;
        }

        public function toString ():String {
            var str:String;
            str = "[BattleData: ";
            str += "turns = " + turns + "; ";
            str += "bet = " + bet + "; ";
            str += "player1 = " + player1 + "; ";
            str += "player2 = " + player2;
            str += "]";
            return str;
        }

    }
}
