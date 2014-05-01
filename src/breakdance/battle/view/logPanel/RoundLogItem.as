/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 30.09.13
 * Time: 9:11
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;

    /**
     * Лог, отображающий текущий раунд.
     */
    public class RoundLogItem extends LogItem implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;
        private var _round:int = 1;
        private var _additionalRound:Boolean;

        public function RoundLogItem () {
            super ();
            bold = true;
        }

        public function setTexts ():void {
            var textRound:String = textsManager.getText ("round");
            if (_additionalRound) {
                 textRound = textsManager.getText ("additionalRound");
            }
            textRound = textRound.replace ("#1", _round + 1);
            if (_round == -1) {
                textRound = "";
            }
            caption = textRound;
        }

        public function get round ():int {
            return _round;
        }

        public function set round (value:int):void {
            _round = value;
            setTexts ();
        }

        public function get additionalRound ():Boolean {
            return _additionalRound;
        }

        public function set additionalRound (value:Boolean):void {
            _additionalRound = value;
            setTexts ();
        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);
            super.destroy ();
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            textsManager.addTextContainer (this);
        }
    }
}
