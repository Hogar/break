/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.14
 * Time: 8:34
 * To change this template use File | Settings | File Templates.
 */
package breakdance.user.events {

    import flash.events.Event;

    public class ChangeUserEvent extends Event {

        public static const CHANGE_USER:String = "change user";
        public static const CHANGE_USER_FRIEND:String = "change user friend";

        public function ChangeUserEvent (type:String = CHANGE_USER) {
            super (type);
        }
    }
}
