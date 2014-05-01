/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.12.13
 * Time: 9:38
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socketServer.events {

    import breakdance.battle.model.UserBattleResultInfo;

    import flash.events.Event;

    public class ReceiveBattleResultEvent extends Event {

        private var _uid:String;
        private var _userBattleResultInfo:UserBattleResultInfo;

        public static const RECEIVE_BATTLE_RESULT:String = "receive battle result";

        public function ReceiveBattleResultEvent (userBattleResultInfo:UserBattleResultInfo, uid:String) {
            this.userBattleResultInfo = userBattleResultInfo;
            this.uid = uid;
            super (RECEIVE_BATTLE_RESULT);
        }

        public function get userBattleResultInfo ():UserBattleResultInfo {
            return _userBattleResultInfo;
        }

        public function set userBattleResultInfo (value:UserBattleResultInfo):void {
            _userBattleResultInfo = value;
        }

        public function get uid ():String {
            return _uid;
        }

        public function set uid (value:String):void {
            _uid = value;
        }
    }
}
