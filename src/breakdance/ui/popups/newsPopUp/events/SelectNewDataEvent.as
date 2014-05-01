/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.03.14
 * Time: 19:12
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.newsPopUp.events {

    import breakdance.data.news.NewData;

    import flash.events.Event;

    public class SelectNewDataEvent extends Event {

        private var _newData:NewData;

        public static const SELECT_NEW_DATA:String = "select new";

        public function SelectNewDataEvent (type:String, newData:NewData) {
            this.newData = newData;
            super (type);
        }

        public function get newData ():NewData {
            return _newData;
        }

        public function set newData (value:NewData):void {
            _newData = value;
        }
    }
}
