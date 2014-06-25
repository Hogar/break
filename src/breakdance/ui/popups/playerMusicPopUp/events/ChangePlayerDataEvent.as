/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.03.14
 * Time: 19:12
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.playerMusicPopUp.events {

    import breakdance.data.news.NewData;

    import flash.events.Event;

    public class ChangePlayerDataEvent extends Event {

        public static const CHANGE_NAME_SONG:String = "change name song";

		//private var _namesong:String;
		
        public function ChangePlayerDataEvent (type:String) {
            super (type);		
        }
		
    }
}
