/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.10.13
 * Time: 12:04
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socketServer.events {

    import breakdance.battle.data.BattleDanceMoveData;

    import flash.events.Event;

    public class ReceiveDanceRoutineEvent extends Event {

        private var _uid:String;
        private var _danceRoutine:Vector.<BattleDanceMoveData>;

        public static const RECEIVE_DANCE_ROUTINE:String = "receive dance routine";
        public static const RECEIVE_ADDITIONAL_DANCE_ROUTINE:String = "receive additional dance routine";

        public function ReceiveDanceRoutineEvent (type:String, danceRoutine:Vector.<BattleDanceMoveData>, uid:String) {
            this._danceRoutine = danceRoutine;
            this.uid = uid;
            super (type);
        }

        public function get danceRoutine ():Vector.<BattleDanceMoveData> {
            return _danceRoutine;
        }

        public function set danceRoutine (value:Vector.<BattleDanceMoveData>):void {
            _danceRoutine = value;
        }

        public function get uid ():String {
            return _uid;
        }

        public function set uid (value:String):void {
            _uid = value;
        }
    }
}
