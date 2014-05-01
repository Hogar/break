/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 29.10.13
 * Time: 21:38
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.pvpLogPanel.events {

    import breakdance.ui.popups.pvpLogPanel.LogData;

    import flash.events.Event;

    public class SelectPvpLogItemEvent extends Event {

        private var _logData:LogData;

        public static const SELECT_PVP_LOG:String = "select log data";

        public function SelectPvpLogItemEvent (logData:LogData) {
            this.logData = logData;
            super (SELECT_PVP_LOG);
        }


        public function get logData ():LogData {
            return _logData;
        }

        public function set logData (value:LogData):void {
            _logData = value;
        }
    }
}
