package breakdance.ui.screens.guessMoveGameScreen.events
{

    import breakdance.data.danceMoves.*;

    import flash.events.*;

    public class SelectDanceMoveTypeEvent extends Event
    {
        private var _danceMoveType:DanceMoveType;
        public static const SELECT_DANCE_MOVE_TYPE:String = "select dance move type";

        public function SelectDanceMoveTypeEvent(param1:DanceMoveType)
        {
            this.danceMoveType = param1;
            super(SELECT_DANCE_MOVE_TYPE);
            return;
        }// end function

        public function get danceMoveType() : DanceMoveType
        {
            return this._danceMoveType;
        }// end function

        public function set danceMoveType(param1:DanceMoveType) : void
        {
            this._danceMoveType = param1;
            return;
        }// end function

    }
}
