package breakdance.ui.screens.guessMoveGameScreen {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.template.Template;

    import com.hogargames.display.GraphicStorage;

    import flash.display.Sprite;
    import flash.text.TextField;

    public class GuessMovesListItem extends GraphicStorage implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var _danceMoveType:DanceMoveType;
        private var mcHit:Sprite;
        private var mcTrue:Sprite;
        private var mcFalse:Sprite;
        private var tf:TextField;
        private var _selectedAsTrue:Boolean;
        private const NORMAL_COLOR:uint = 16777215;
        private const SELECTED_AS_TRUE_COLOR:uint = 9619510;

        public function GuessMovesListItem () {
            super (Template.createSymbol (Template.GUESS_MOVE_LIST_ITEM));
            buttonMode = true;
            useHandCursor = true;
        }

        public function get danceMoveType ():DanceMoveType {
            return _danceMoveType;
        }

        public function set danceMoveType (danceMoveType:DanceMoveType):void {
            _danceMoveType = danceMoveType;
            setTexts ();

        }

        public function get selectedAsTrue ():Boolean {
            return _selectedAsTrue;
        }

        public function set selectedAsTrue (value:Boolean):void {
            _selectedAsTrue = value;
            tf.textColor = _selectedAsTrue ? (SELECTED_AS_TRUE_COLOR) : (NORMAL_COLOR);

        }

        public function trueMarker ():void {
            mcTrue.visible = true;
            mcFalse.visible = false;

        }

        public function falseMarker ():void {
            mcTrue.visible = false;
            mcFalse.visible = true;

        }

        public function noMarker ():void {
            mcTrue.visible = false;
            mcFalse.visible = false;

        }

        public function setTexts ():void {
            if (_danceMoveType) {
                tf.text = _danceMoveType.name;
            }

        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);

        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcHit = getElement ("mcHit");
            mcTrue = getElement ("mcTrue");
            mcFalse = getElement ("mcFalse");
            tf = getElement ("tf");
            mcTrue.mouseChildren = false;
            mcTrue.mouseEnabled = false;
            mcFalse.mouseChildren = false;
            mcFalse.mouseEnabled = false;
            noMarker ();
            textsManager.addTextContainer (this);

        }

    }
}
