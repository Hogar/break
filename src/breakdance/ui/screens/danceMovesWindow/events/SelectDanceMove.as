/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 19.07.13
 * Time: 9:37
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.danceMovesWindow.events {

    import breakdance.user.UserDanceMove;

    import flash.events.Event;

    public class SelectDanceMove extends Event {

        private var _userDanceMove:UserDanceMove;

        public static const SELECT_DANCE_MOVIE:String = "select dance movie";

        public function SelectDanceMove (userDanceMove:UserDanceMove, type:String = SELECT_DANCE_MOVIE, bubbles:Boolean = false, cancelable:Boolean = true) {
            this.userDanceMove = userDanceMove;
            super (type, bubbles, cancelable);
        }

        public function get userDanceMove ():UserDanceMove {
            return _userDanceMove;
        }

        public function set userDanceMove (value:UserDanceMove):void {
            _userDanceMove = value;
        }
    }
}
