/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.09.13
 * Time: 14:01
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.events {

    import flash.events.Event;

    /**
     * Событие установки очков полученных за танц. движение.
     */
    public class BattleDanceMoveEvent extends Event {

        public static const SET_POINTS:String = "set points";

        public function BattleDanceMoveEvent (type:String = SET_POINTS) {
            super (type);
        }
    }
}
