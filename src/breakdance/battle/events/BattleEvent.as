/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 14:20
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.events {

    import flash.events.Event;

    public class BattleEvent extends Event {

        public static const START_BATTLE:String = "start battle";//Бой был начат.
        public static const START_ADDITIONAL_ROUND:String = "start additional round";//Бой был начат.
        public static const READY_TO_NEXT_MOVE:String = "ready to next";//Для обработки стало доступно следующее танц. движение.
        public static const PROCESS_FAILURE:String = "process failure";//Отказ обработки следующего танц. движения.

        public function BattleEvent (type:String) {
            super (type);
        }
    }
}
