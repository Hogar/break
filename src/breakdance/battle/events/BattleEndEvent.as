/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 14:28
 * To change this template use File | Settings | File Templates.
 */

package breakdance.battle.events {

    import breakdance.battle.model.UserBattleResultInfo;

    import flash.events.Event;

    public class BattleEndEvent extends Event {

        private var _userBattleResultInfo:UserBattleResultInfo;

        public static const END_BATTLE:String = "end battle";

        public function BattleEndEvent (userBattleResultInfo:UserBattleResultInfo, type:String = END_BATTLE) {
            this.userBattleResultInfo = userBattleResultInfo;
            super (type);
        }

        public function get userBattleResultInfo ():UserBattleResultInfo {
            return _userBattleResultInfo;
        }

        public function set userBattleResultInfo (value:UserBattleResultInfo):void {
            _userBattleResultInfo = value;
        }
    }
}
