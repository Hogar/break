/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 29.10.13
 * Time: 20:03
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.pvpLogPanel {

    import breakdance.core.server.ServerQueryLogData;
    import breakdance.template.Template;

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;

    public class PvpLogListItem extends GraphicStorage {

        private var _logData:LogData;
        private var _id:int = -1;

        private var mcArrow:MovieClip;
        private var tf:TextField;
        private var tfId:TextField;
        private var tfTime:TextField;
        private var mcActive:Sprite;
        private var mcError:Sprite;
        private var mcLoading:Sprite;
        private var mcRepeatCount:MovieClip;
        private var tfRepeatCount:TextField;

        private static const SEND_FRAME:int = 1;
        private static const RECEIVE_FRAME:int = 2;

        public function PvpLogListItem () {
            super (Template.createSymbol (Template.PVP_LOG_LIST_ITEM));
            selected = false;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get selected ():Boolean {
            return mcActive.visible;
        }

        public function set selected (value:Boolean):void {
            mcActive.visible = value;
        }

        public function get id ():int {
            return _id;
        }

        public function set id (value:int):void {
            _id = value;
            tfId.htmlText = "<b>" + String (_id) + ".</b>";
        }

        public function get logData ():LogData {
            return _logData;
        }

        public function set logData (value:LogData):void {
            mcError.visible = false;
            mcLoading.visible = false;
            if (_logData) {
                if (_logData.serverQueryLog) {
                    _logData.serverQueryLog.removeEventListener (Event.CHANGE, changeListener);
                }
            }
            _logData = value;
            if (_logData) {
                if (_logData.serverQueryLog) {
                    _logData.serverQueryLog.addEventListener (Event.CHANGE, changeListener);
                }
                tf.htmlText = _logData.shortMessage;
                mcArrow.visible = true;

                mcError.visible = (_logData.errorMessage != null);

                if (_logData.requestType == RequestType.SEND) {
                    mcArrow.gotoAndStop (SEND_FRAME);
                }
                else if (_logData.requestType == RequestType.RECEIVE) {
                    mcArrow.gotoAndStop (RECEIVE_FRAME);
                }
                else {
                    mcArrow.visible = false;
                }
                tfTime.htmlText = "<b>" + _logData.time + "</b>";
            }
            else {
                tf.text = "";
                mcArrow.stop ();
                mcArrow.visible = false;
                tfTime.htmlText = "";
            }
            changeListener (null);
        }

        override public function destroy ():void {
            logData = null;
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            mcArrow = getElement ("mcArrow");
            tf = getElement ("tf");
            tfId = getElement ("tfId");
            tfTime = getElement ("tfTime");
            mcActive = getElement ("mcActive");
            mcError = getElement ("mcError");
            mcLoading = getElement ("mcLoading");
            mcRepeatCount = getElement ("mcRepeatCount");
            tfRepeatCount = getElement ("tf", mcRepeatCount);

            mcError.visible = false;
            mcLoading.visible = false;
            mcRepeatCount.visible = false;
            tfRepeatCount.text = "";

            tf.text = "";
            tfId.text = "";

            logData = logData;
            selected = selected;

            buttonMode = true;
            useHandCursor = true;
            mouseChildren = false;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function changeListener (event:Event):void {
            mcLoading.visible = false;
            if (_logData) {
                var serverQueryLog:ServerQueryLogData = _logData.serverQueryLog;
                if (serverQueryLog) {
                    if (serverQueryLog.errorMessage != null) {
                        mcError.visible = true;
                    }
                    if (serverQueryLog.answer == null) {
                        mcLoading.visible = true;
                    }
                    if (serverQueryLog.repeats.length > 0) {
                        mcRepeatCount.visible = true;
                        mcRepeatCount.gotoAndPlay (2);
                        tfRepeatCount.htmlText = "<b>" + String (serverQueryLog.repeats.length) + "</b>";
                    }
                    else {
                        mcRepeatCount.visible = false;
                    }
                }
            }
        }

    }
}
