/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 19.07.13
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.infoPopUp {

    import breakdance.ui.popups.basePopUps.TextsClosingPopUp;

    import flash.display.MovieClip;

    public class BaseInfoPopUp extends TextsClosingPopUp implements IInfoPopUp {

        private var messages:Vector.<MessageData> = new Vector.<MessageData> ();

        public function BaseInfoPopUp (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function hide ():void {
            super.hide ();
            showNextMessage ();
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
//PUBLIC:
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
