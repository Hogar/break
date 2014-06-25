package breakdance.ui {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalConstants;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.server.ServerApi;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.events.BreakDanceAppEvent;
    import breakdance.template.Template;
    import breakdance.ui.commons.CharacterView;
    import breakdance.ui.popups.PopUpManager;
	import flash.geom.Point;

    import com.adobe.images.PNGEncoder;
    import com.greensock.loading.SWFLoader;
    import com.hogargames.debug.Tracer;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.geom.Matrix;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;

    public class AppBackground extends Sprite {

        private var textsManager:TextsManager = TextsManager.instance;

        private var _backgroundsContainer:Sprite = new Sprite ();
        private var _swfFile:SWFLoader;
        private var _template:DisplayObject;
        private var _bitmapIndex:Object;
        private var characterView:CharacterView;

        private static const SCREEN_SHOT_HEIGHT:int = 458;
        private static const SCREEN_SHOOT_MARGIN_Y:int = -55;
        private static const SCREEN_OFFSET_Y:int = 53;

        private static const TRAINING:String = "training";

        public function AppBackground () {

            _swfFile = Template.getSwf (Template.CHARACTER_SWF);
            _bitmapIndex = {};

            addChild (_backgroundsContainer);

            characterView = new CharacterView ();
            addChild (characterView);

            setBackground (TRAINING);

            BreakdanceApp.instance.appDispatcher.addEventListener (BreakDanceAppEvent.CREATE_SCREEN_SHOT, createScreenShootListener);

        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function setBackground (id:String):void {
            if (_template) {
                removeChild (_template);
            }

            if (_bitmapIndex [id] == null) {
                var symbolClass:Class = _swfFile.getClass (id);
                var bitmapData:BitmapData = new symbolClass ();

                _bitmapIndex[id] = new Bitmap (bitmapData);
            }

            _template = _bitmapIndex[id];
            _template.y = SCREEN_OFFSET_Y;
            _backgroundsContainer.addChild (_template);
        }
		
		public function get coordHitMusic():Point {			
			return characterView.musicContainerCoord;
		}		
		

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function createScreenShootListener (event:BreakDanceAppEvent):void {
            JsApi.instance.query (JsApi.GET_ALBUMS, onGetAlbums);
        }

        private function onGetAlbums (response:JsQueryResult):void {
            if (response.success) {
                var albumName:String = textsManager.getText ("albumName");
                var albumDescription:String = textsManager.getText ("albumDescription");
                var albums:Array = response.data.response as Array;
                if (albums) {
                    if (albums.length > 0) {
                        for (var i:int = 0; i < albums.length; i++) {
                            var albumData:Object = albums [i];
                            if (albumData.hasOwnProperty ("title")) {
                                if (albumData.title == albumName) {
                                    Tracer.log ("Нашли нужный альбом: aid = " + albumData.aid);
                                    getUploadUrl (albumData.aid);
                                    return;
                                }
                            }
                        }
                    }
                }
                JsApi.instance.query (JsApi.CREATE_ALBUM, onCreateAlbum, [albumName, albumDescription]);
            }
        }

        private function onCreateAlbum (response:JsQueryResult):void {
            if (response.success) {
                var aid:String = response.data.response.aid;
                Tracer.log ("Создали новый альбом: aid = " + aid);
                if (aid) {
                    getUploadUrl (aid);
                }
            }
        }

        private function getUploadUrl (aid:String):void {
            JsApi.instance.query (JsApi.GET_UPLOAD_URL, onGetUploadScreenShotUrl, [aid]);
        }

        private function onGetUploadScreenShotUrl (response:JsQueryResult):void {
            if (response.success) {
                TransactionOverlay.instance.show ();
                var uploadUrl:String = response.data.response.upload_url;
                if (uploadUrl) {
                    var header:URLRequestHeader = new URLRequestHeader ("Content-type", "application/octet-stream");
                    var serverUrl:String = GlobalConstants.SERVER_API_URL;
                    CONFIG::debug {
                        serverUrl = GlobalConstants.SERVER_API_DEV_URL;
                    }
                    var urlRequest:URLRequest = new URLRequest (serverUrl + ServerApi.IMAGE_SAVE + "?upload_url=" + escape (uploadUrl));
                    urlRequest.requestHeaders.push (header);
                    urlRequest.method = URLRequestMethod.POST;
                    urlRequest.data = createScreenShot ();

                    var urlLoader:URLLoader = new URLLoader ();
                    urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
                    urlLoader.addEventListener (Event.COMPLETE, completeListener);
                    urlLoader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
                    urlLoader.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);

                    Tracer.log ("Заливаем фото.");

                    urlLoader.load (urlRequest);
                }
            }
        }

        private function onSavePhoto (response:JsQueryResult):void {
            if (response.success) {
                Tracer.log ("Фото сохранено.");
                TransactionOverlay.instance.hide ();
                var title:String = textsManager.getText ("uploadPhotoTitle");
                var message:String = textsManager.getText ("uploadPhotoText");
                PopUpManager.instance.infoPopUp.showMessage (title, message);
            }
        }

        private function createScreenShot ():ByteArray {
            characterView.showScreenShootMode ();
            var bmpSource:BitmapData = new BitmapData (GlobalConstants.APP_WIDTH, SCREEN_SHOT_HEIGHT);
            var matrix:Matrix = new Matrix ();
            matrix.translate (0, SCREEN_SHOOT_MARGIN_Y);
            bmpSource.draw (this, matrix);
            var bmpStream:ByteArray = PNGEncoder.encode (bmpSource);
            characterView.hideScreenShootMode ();
            return bmpStream;
        }

        private function completeListener (event:Event):void {
            TransactionOverlay.instance.hide ();
            var response:Object;
            try {
                response = JSON.parse (event.currentTarget.data);
            }
            catch (error:Error) {
                Tracer.log ("Хреновый json. Ответ от сервера: " + event.currentTarget.data);
                return;
            }
            if (response.response_code == 1) {
                var result:Object = response.data;
                var albumId:String = result.aid;
                var server:String = result.server;
                var photosList:String = result.photos_list;
                var hash:String = result.hash;
                var caption:String = textsManager.getText ("uploadPhotoCaption");
                Tracer.log ("Сохраняем фото в альбом.");
                JsApi.instance.query (JsApi.SAVE_PHOTO, onSavePhoto, [albumId, server, photosList, hash, caption]);
            }
            else {
                Tracer.log ("Что-то фото не залилось. Ответ от сервера: " + event.currentTarget.data);
            }
        }

        private function ioErrorListener (event:IOErrorEvent):void {
			event.text
            Tracer.log ("Ошибка заливки фото!");
            TransactionOverlay.instance.hide ();
        }

        private function securityErrorListener (event:SecurityErrorEvent):void {
            Tracer.log ("Ошибка безопасности при заливки фото!");
            TransactionOverlay.instance.hide ();
        }

    }
}