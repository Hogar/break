/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 28.01.14
 * Time: 5:53
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.infoPopUp {

    import breakdance.template.Template;
    import breakdance.ui.popups.basePopUps.OneTextButtonPopUp;

    public class InfoPopUpWithCharacter2 extends OneTextButtonPopUp implements IInfoPopUp {

        private var messages:Vector.<MessageData> = new Vector.<MessageData> ();

        public function InfoPopUpWithCharacter2 () {
            super (Template.createSymbol (Template.ONE_BUTTON_CHARACTER_POPUP));
        }

        override public function setTexts ():void {
            super.setTexts ();
            btn1.text = textsManager.getText ("okay");
        }

        public function showMessage (title:String, text:String):void {
            var messageData:MessageData = new MessageData (title, text);
            messages.push (messageData);
            if (!isShowed) {
                showNextMessage ();
            }
        }

        public function clearMessages ():void {
            messages = new Vector.<MessageData> ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function onClickFirstButton ():void {
            hide ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function showNextMessage ():void {
            if (messages.length > 0) {
                var messageData:MessageData = messages.pop ();
                showData (messageData);
            }
        }

        private function showData (messageData:MessageData):void {
            setTitle (messageData.title);
            setText (messageData.text);
            show ();
        }

        private function setTitle (str:String):void {
            tfTitle.htmlText = str;
        }

        private function setText (str:String):void {
            tf.htmlText = str;
            positionText ();
        }
    }
}
