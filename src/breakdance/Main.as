package breakdance {

    import breakdance.core.SWFProfiler;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.overlay.OverlayManager;
    import breakdance.events.LoadingStepEvent;
    import breakdance.socketServer.SocketServerManager;
    import breakdance.ui.commons.tooltip.TooltipOrientation;

    import com.greensock.plugins.ColorTransformPlugin;
    import com.greensock.plugins.RemoveTintPlugin;
    import com.greensock.plugins.TweenPlugin;
    import com.hogargames.debug.Tracer;
    import com.hogargames.debug.TracerTextField;

    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.system.Security;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    /**
     * Главный исполняющий класс.
     * прелоадер + инициализация приложения
     * @author Alexey Stashin
     */
    [SWF(width="810", height="675", frameRate="30", backgroundColor="#ffffff")]
    public class Main extends Sprite implements ITextContainer {

        [Embed(source="../../fla/embedded/preloader.swf", symbol="preloader")]
        public static const PreloaderTemplate:Class;

        private var _preloader:MovieClip;
        private var textsManager:TextsManager = TextsManager.instance;

        private var tfOutput:TracerTextField;
        private var tfVersion:TextField = new TextField ();

        CONFIG::debug {
            private var tfPosition:TextField = new TextField ();
        }

        private static const TF_OUTPUT_KEY_CODE:Number = 192;
        private static const TF_OUTPUT_MARGIN:Number = 5;
        private static const TF_VERSION_WIDTH:int = 160;

        public function Main () {
            super.tabEnabled = false;
            super.tabChildren = false;
            super.focusRect = false;

            if (stage) {
                addedToStageListener ();
            }
            else {
                addEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
            }
        }

        public function setTexts ():void {
            if (tfVersion) {
                var version:String = getVersion ();
                var connectionStatus:String;
//                if (PvPManager.instance.connected) {
//                    connectionStatus = textsManager.getUiText ("pvpConnected");
//                }
//                else {
//                    connectionStatus = textsManager.getUiText ("pvpNotConnected");
//                }
                connectionStatus = textsManager.getText ("server") + ": ";
//                connectionStatus = "pvp: ";
                if (SocketServerManager.instance.connected) {
                    connectionStatus += textsManager.getText ("online");
                }
                else {
                    connectionStatus += textsManager.getText ("offline");
                }
                var textFormat:TextFormat = tfVersion.getTextFormat ();
                textFormat.font = "Arial";
                textFormat.size = 11;
                textFormat.color = 0x999999;
//                textFormat.align = TextFormatAlign.RIGHT;
                textFormat.align = TextFormatAlign.LEFT;
                tfVersion.setTextFormat (textFormat);
                tfVersion.defaultTextFormat = textFormat;
                tfVersion.multiline = true;
                tfVersion.wordWrap = true;
                tfVersion.width = TF_VERSION_WIDTH;
                tfVersion.htmlText = version + " | " + connectionStatus;
                tfVersion.width = tfVersion.textWidth + 5;
                tfVersion.height = tfVersion.textHeight + 4;
                tfVersion.x = 12;
//                tfVersion.y = Math.round ((50 - tfVersion.height) / 2);
                tfVersion.y = 656;
            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function onInitComplete ():void {
            removeChild (_preloader);
            _preloader = null;

            OverlayManager.instance.addOverlay (tfOutput, OverlayManager.DEV_UI_PRIORITY);
            OverlayManager.instance.addOverlay (tfVersion, OverlayManager.DEV_UI_PRIORITY);


            SocketServerManager.instance.addEventListener (Event.CONNECT, connectListener);
            SocketServerManager.instance.addEventListener (Event.CLOSE, closeListener);

            tfVersion.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            tfVersion.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            CONFIG::debug {
                stage.addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveListener);
                OverlayManager.instance.addOverlay (tfPosition, OverlayManager.DEV_UI_PRIORITY);
            }

            textsManager.addTextContainer (this);

        }

        private function onError (message:String):void {
            trace ("Error: " + message);
            _preloader['tfStatus'].text = message;
        }

        private function onInitProgress (ratio:Number):void {
//            trace ("Loading: " + ratio);
            var percents:int = ratio * 100;
            _preloader['tfProgress'].text = percents + '%';
            _preloader['progress_bar'].gotoAndStop (percents);
        }

        private function positionTfOutput ():void {
            var _appWidth:Number;
            var _appHeight:Number;
            if (stage) {
                _appWidth = stage.stageWidth;
                _appHeight = stage.stageHeight;
            }
            else {
                _appWidth = GlobalConstants.APP_WIDTH;
                _appHeight = GlobalConstants.APP_HEIGHT;
            }
            tfOutput.x = TF_OUTPUT_MARGIN;
            tfOutput.y = TF_OUTPUT_MARGIN;
            tfOutput.width = _appWidth - TF_OUTPUT_MARGIN * 2;
            tfOutput.height = _appHeight - TF_OUTPUT_MARGIN * 2;
        }

        private function getVersion ():String {
            var version:String = "v. " + GlobalConstants.VERSION;
            CONFIG::debug {
                version += "d";
            }
//            version += " " + GlobalConstants.RELEASE_VERSION;
            return version;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function addedToStageListener (event:Event = null):void {
            removeEventListener (Event.ADDED_TO_STAGE, addedToStageListener);

            Security.allowDomain ("*");
            TweenPlugin.activate ([ColorTransformPlugin, RemoveTintPlugin]);

            //Создаём отладочное окно:
            tfOutput = new TracerTextField ();
            Tracer.doTrace = true;
            Tracer.addTracerOutput (tfOutput);

            _preloader = new PreloaderTemplate ();

            GlobalVariables.stage = stage;

            var flashVars:Object = LoaderInfo (this.root.loaderInfo).parameters;
            flashVars.api_id = "3704573";
            var app:BreakdanceApp = new BreakdanceApp (flashVars);
            addChild (app);

            SWFProfiler.init (stage, this);

            _preloader['tfProgress'].text = "0%";
            _preloader['progress_bar'].gotoAndStop (1);
            _preloader.addEventListener (Event.ENTER_FRAME, enterFrameListener);
            addChild (_preloader);

            BreakdanceApp.instance.appDispatcher.addEventListener (LoadingStepEvent.START_LOADING_STEP, startLoadingStepListener);
            BreakdanceApp.instance.init (onInitComplete, onError, onInitProgress);

            addChild (tfOutput);
            tfOutput.visible = false;
            Tracer.log ("v. " + GlobalConstants.VERSION);

            addChild (tfVersion);
//            tfVersion.mouseEnabled = false;
            tfVersion.x = 745;
            tfVersion.y = 654;
            var textFormat:TextFormat = tfVersion.getTextFormat ();
            textFormat.font = "Arial";
            textFormat.size = 10;
            textFormat.color = 0x999999;
            tfVersion.setTextFormat (textFormat);
            tfVersion.defaultTextFormat = textFormat;
            tfVersion.selectable = false;
            tfVersion.text = getVersion ();

            CONFIG::debug {
                tfPosition.textColor = 0xffffff;
                tfPosition.height = 24;
                addChild (tfPosition);
            }

            stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDownListener);
            stage.addEventListener (Event.RESIZE, resizeListener);
            stage.stageFocusRect = false;
            positionTfOutput ();
            tfOutput.addEventListener (KeyboardEvent.KEY_DOWN, keyDownListener);
        }

        private function keyDownListener (event:KeyboardEvent):void {
			trace('event.keyCode  '+event.keyCode)
         ///   if (event.ctrlKey && (event.keyCode == TF_OUTPUT_KEY_CODE)) {
		    if (event.keyCode == 87) {
			    if (tfOutput) {
                    tfOutput.visible = !tfOutput.visible;
                }
            }
        }

        private function resizeListener (event:Event):void {
            if (tfOutput) {
                positionTfOutput ();
            }
        }

        private function enterFrameListener (event:Event):void {
            if (_preloader.currentFrame == _preloader.totalFrames) {
                _preloader.removeEventListener (Event.ENTER_FRAME, enterFrameListener);
                _preloader.stop ();
            }
        }

        private function connectListener (event:Event):void {
            setTexts ();
        }

        private function closeListener (event:Event):void {
            setTexts ();
        }

        private function rollOverListener (event:MouseEvent):void {
            var updateDate:Date = GlobalConstants.VERSION_DATE;
            var year:String = String (updateDate.getFullYear ());
            var date:String = String (updateDate.getDate ());
            var month:int = updateDate.getMonth ();
            var monthAsString:String;
            var dateAsString:String;
            if (textsManager.currentLanguage == TextsManager.RU) {
                switch (month) {
                    case (0):
                        monthAsString = "января";
                        break;
                    case (1):
                        monthAsString = "февраля";
                        break;
                    case (2):
                        monthAsString = "марта";
                        break;
                    case (3):
                        monthAsString = "апреля";
                        break;
                    case (4):
                        monthAsString = "мая";
                        break;
                    case (5):
                        monthAsString = "июня";
                        break;
                    case (6):
                        monthAsString = "июля";
                        break;
                    case (7):
                        monthAsString = "августа";
                        break;
                    case (8):
                        monthAsString = "сентября";
                        break;
                    case (9):
                        monthAsString = "октября";
                        break;
                    case (10):
                        monthAsString = "ноября";
                        break;
                    case (11):
                        monthAsString = "декабря";
                        break;
                }
                dateAsString = "от " + date + " " + monthAsString + " " + year + "";
            }
            else if (textsManager.currentLanguage == TextsManager.EN) {
                dateAsString = "at " + updateDate.toDateString () + "";
            }
            var positionPoint:Point = this.localToGlobal (new Point (tfVersion.x + tfVersion.width / 2, tfVersion.y));
            BreakdanceApp.instance.showTooltipMessage (dateAsString, positionPoint, false, TooltipOrientation.TOP);
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }

        private function startLoadingStepListener (event:LoadingStepEvent):void {
            _preloader['tfStatus'].text = event.message;
        }

        CONFIG::debug {
            private function mouseMoveListener (event:MouseEvent):void {
                tfPosition.text = "POS: " + Math.round (event.stageX) + " : " + Math.round (event.stageY);
//                trace ("POSITION: " + tfPosition.text);
            }
        }
    }
}