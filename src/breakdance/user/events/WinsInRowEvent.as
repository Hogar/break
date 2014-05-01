/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.03.14
 * Time: 10:52
 * To change this template use File | Settings | File Templates.
 */
package breakdance.user.events {

    import flash.events.Event;

    /**
     * Событие получение награды за несколько побед подряд.
     */
    public class WinsInRowEvent extends Event {

        public static const WINS_IN_ROW:String = "wins in row";

        public function WinsInRowEvent () {
            super (WINS_IN_ROW);
        }
    }
}
