/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 29.10.13
 * Time: 19:56
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.pvpLogPanel {

    import breakdance.GlobalConstants;
    import breakdance.core.server.ServerQueryLogData;
    import breakdance.core.ui.overlay.OverlayManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.basePopUps.BasePopUp;
    import breakdance.ui.popups.pvpLogPanel.events.SelectPvpLogItemEvent;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    public class PvpLogPanelPopUp extends BasePopUp {

        private var mcHolder:Sprite;
        private var mcContainer:Sprite;
        private var pvpLogList:PvpLogList;
        private var btnClear:ButtonWithText;
        private var btnClose:ButtonWithText;
        private var mcFullDescription:Sprite;
        private var mcClose:Sprite;
        private var tfFullDescription:TextField;
        private var mcListening:Sprite;

        private var logs:Vector.<LogData> = new Vector.<LogData> ();

        private var currentLogData:LogData;

        private var TEST_REPEATS:Boolean = true;

        private static const CONTAINER_WIDTH:int = 245/* + 2 + 320*/;
        private static const CONTAINER_HEIGHT:int = 342;

        public function PvpLogPanelPopUp () {
            super (Template.createSymbol (Template.PVP_LOG_POP_UP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function addLog (shortMessage:String, fullMessage:String = "", requestType:String = RequestType.NO_TYPE, serverQueryLog:ServerQueryLogData = null, errorMessage:String = null):void {

            if (TEST_REPEATS) {
                //Проверка на повторы:
                for (var i:int = 0; i < logs.length; i++) {
                    var currentLog:LogData = logs [i];
                    var currentServerQueryLog:ServerQueryLogData = currentLog.serverQueryLog;
                    if (currentServerQueryLog) {
                        if (currentServerQueryLog.timestamp != -1) {
                            if (serverQueryLog && (serverQueryLog.timestamp == currentServerQueryLog.timestamp)) {
                                currentServerQueryLog.addRepeat (serverQueryLog);
                                return;
                            }
                        }
                    }
                }
            }

            var logData:LogData = new LogData ();
            logData.shortMessage = shortMessage;
            logData.fullMessage = fullMessage;
            logData.serverQueryLog = serverQueryLog;
            logData.requestType = requestType;
            logData.errorMessage = errorMessage;
            logs.push (logData);
            pvpLogList.init (logs);
        }

        /**
         * Отобразить начало прослушивания.
         */
        public function showStartListening ():void {
            mcListening.visible = true;
        }

        /**
         * Отобразить завершение прослушивания.
         */
        public function showStopListening ():void {
            mcListening.visible = false;
        }

        override public function show ():void {
//            clear ();
            OverlayManager.instance.addOverlay(this,OverlayManager.DEV_UI_PRIORITY);
        }

        override public function destroy ():void {
            if (btnClear) {
                btnClear.removeEventListener (MouseEvent.CLICK, clickListener);
                btnClear.destroy ();
                btnClear = null;
            }
            if (btnClose) {
                btnClose.removeEventListener (MouseEvent.CLICK, clickListener);
                btnClose.destroy ();
                btnClose = null;
            }
            if (mcHolder) {
                mcHolder.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);
            }
            removeEventListener (MouseEvent.MOUSE_DOWN, mouseUpListener);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcContainer = getElement ("mcContainer");
            mcHolder = getElement ("mcHolder", mcContainer);
            mcFullDescription = getElement ("mcFullDescription", mcContainer);
            mcListening = getElement ("mcListening", mcContainer);
            mcClose = getElement ("mcClose", mcFullDescription);
            tfFullDescription = getElement ("tf", mcFullDescription);
            pvpLogList = new PvpLogList (mcContainer ["mcPvpLogList"]);
            btnClear = new ButtonWithText (mcContainer ["btnClear"]);
            btnClose = new ButtonWithText (mcContainer ["btnClose"]);

            mcHolder.buttonMode = true;
            mcHolder.useHandCursor = true;
            mcClose.buttonMode = true;
            mcClose.useHandCursor = true;

            btnClear.text = "Очистить";
            btnClose.text = "Закрыть";
            tfFullDescription.text = "";

            mcFullDescription.visible = false;

            btnClear.addEventListener (MouseEvent.CLICK, clickListener);
            btnClose.addEventListener (MouseEvent.CLICK, clickListener);
            mcClose.addEventListener (MouseEvent.CLICK, clickListener);
            mcHolder.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);
            addEventListener (MouseEvent.MOUSE_UP, mouseUpListener);
            pvpLogList.addEventListener (SelectPvpLogItemEvent.SELECT_PVP_LOG, selectPvpLogItemListener);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function clear ():void {
            logs = new Vector.<LogData> ();
            pvpLogList.clear ();
        }

        private function setCurrentLogData (logData:LogData):void {
            if (currentLogData) {
                if (currentLogData.serverQueryLog) {
                    currentLogData.serverQueryLog.removeEventListener (Event.CHANGE, changeListener);
                }
            }
            currentLogData = logData;
            if (currentLogData) {
                if (currentLogData.serverQueryLog) {
                    currentLogData.serverQueryLog.addEventListener (Event.CHANGE, changeListener);
                }
                mcFullDescription.visible = true;
            }
            else {
                mcFullDescription.visible = false;
            }
            updateLogDataInfo ();
        }


        private function updateLogDataInfo ():void {
            if (currentLogData) {
                var message:String = currentLogData.shortMessage;
                message += "\n---\n\n";
                if (currentLogData.fullMessage) {
                    message += "<b>Лог:</b>\n";
                    message += currentLogData.fullMessage;
                    message += "\n---\n\n";
                }
                var serverQueryLog:ServerQueryLogData = currentLogData.serverQueryLog;
                if (serverQueryLog) {
                    message += "<b>Запрос</b>";
                    if (serverQueryLog.requestTime) {
                        message += " <font color='#666666'>[" + serverQueryLog.requestTime.toLocaleTimeString () + "]</font> ";
                    }
                    message += "<b>:</b>\n";
                    if (serverQueryLog.request) {
                        message += serverQueryLog.request;
                    }
                    message += "\n---\n\n";
                    message += "<b>Ответ</b>";
                    if (serverQueryLog.answerTime) {
                        message += " <font color='#666666'>[" + serverQueryLog.answerTime.toLocaleTimeString () + "]</font> ";
                    }
                    message += "<b>:</b>\n";
                    if (serverQueryLog.answer != null) {
                        message += serverQueryLog.answer;
                    }
                    else {
                        message += "Пока не пришёл...";
                    }
                    message += "\n---\n\n";
                    if (serverQueryLog.errorMessage != null) {
                        message += "<b>Ошибка:</b>\n";
                        message += serverQueryLog.errorMessage;
                        message += "\n---\n\n";
                    }
                    var repeats:Vector.<ServerQueryLogData> = serverQueryLog.repeats;
                    if (repeats.length > 0) {
                        message += "<b>Повторы:</b>\n";
                        for (var i:int = 0; i < repeats.length; i++) {
                            var repeatLogData:ServerQueryLogData = repeats [i];
                            if (repeatLogData) {
                                message += "Повтор <b>" + (i + 1) + "</b>:\n";
                                if (repeatLogData.requestTime && repeatLogData.request) {
                                    message += "Запрос <font color='#666666'>[" + repeatLogData.requestTime.toLocaleTimeString () + "]</font>:\n";
                                    message += repeatLogData.request + "\n";
                                }
                                if (repeatLogData.answerTime && repeatLogData.answer) {
                                    message += "Ответ <font color='#666666'>[" + repeatLogData.answerTime.toLocaleTimeString () + "]</font>:\n";
                                    message += repeatLogData.answer + "\n";
                                }
                                message += "-\n";
                            }
                        }
                        message += "---\n\n";
                    }
                }
                if (currentLogData.errorMessage) {
                    message += "<b>Ошибка:</b>\n";
                    message += currentLogData.errorMessage;
                    message += "\n---\n\n";
                }
                tfFullDescription.htmlText = message;
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btnClose:
                    hide ();
                    break;
                case btnClear:
                    clear ();
                    break;
                case mcClose:
                    mcFullDescription.visible = false;
                    break;
            }

        }

        private function mouseDownListener (event:MouseEvent):void {
            var rect:Rectangle = new Rectangle (0, 0, GlobalConstants.APP_WIDTH - CONTAINER_WIDTH, GlobalConstants.APP_HEIGHT - CONTAINER_HEIGHT);
            mcContainer.startDrag (false, rect);
        }

        private function mouseUpListener (event:MouseEvent):void {
            mcContainer.stopDrag ();
        }

        private function selectPvpLogItemListener (event:SelectPvpLogItemEvent):void {
            setCurrentLogData (event.logData);
        }

        private function changeListener (event:Event):void {
            updateLogDataInfo ();
        }
    }
}
