/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 24.01.14
 * Time: 14:08
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.events {

    import flash.events.Event;

    public class ChangeBattlePlayerEvent extends Event {

        public static const CHANGE_BATTLE_PLAYER:String = "change battle player";

        public function ChangeBattlePlayerEvent (type:String = CHANGE_BATTLE_PLAYER) {
            super (type);
        }
    }
}
