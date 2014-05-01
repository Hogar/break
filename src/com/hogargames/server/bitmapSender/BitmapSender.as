/**
 * @author Hogar modified sample at:
 * http://actionscript-blog.imaginationdev.com/5/save-jpg-jpeg-png-bmp-image-action-script-3/
 *
 */

package com.hogargames.server.bitmapSender {

    import com.adobe.images.JPGEncoder;
    import com.adobe.images.PNGEncoder;
    import com.hogargames.server.bitmapSender.events.BitmapSenderEvent;

    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.net.FileReference;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;

    public class BitmapSender extends EventDispatcher {

        //Initialization
        private var serverUniqueFileName:String;

        //Need to change the name to your sepcified server
        private var serverPath:String;
        private var filePath:String;
        private var downloadURL:URLRequest;
        private var fileType:String = FILE_TYPE_JPG;

        public static const FILE_TYPE_JPG:String = ".jpg";
        public static const FILE_TYPE_PNG:String = ".png";

        private const DEFAULT_PHOTO_NAME:String = "photo";


        // Call this function On Button Save
        public function BitmapSender (serverPath:String = "http://hogargames.com/photoTest/", filePath:String = "jpg_encoder_download.php") {
            this.serverPath = serverPath;
            this.filePath = filePath;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function doImage (object:Sprite, fileType:String = FILE_TYPE_JPG, quality:Number = 80):void {
            serverUniqueFileName = getUniqueFileName (DEFAULT_PHOTO_NAME);
            var byteArray:ByteArray;
            if (fileType == FILE_TYPE_JPG) {
                byteArray = createJPG (object, quality);
            }
            else if (fileType == FILE_TYPE_PNG) {
                byteArray = createPng (object);
            }
            if (byteArray) {
                sendPhoto (byteArray, fileType);
            }
        }

        public function sendPhoto (byteArray:ByteArray, fileType:String = FILE_TYPE_JPG, fileName:String = null):void {
            if (!fileName) {
                fileName = DEFAULT_PHOTO_NAME;
            }
            this.fileType = fileType;
            serverUniqueFileName = getUniqueFileName (fileName);
            var header:URLRequestHeader = new URLRequestHeader ("Content-type", "application/octet-stream");
            var urlRequest:URLRequest = new URLRequest (serverPath + filePath + "?name=" + serverUniqueFileName);

            urlRequest.requestHeaders.push (header);
            urlRequest.method = URLRequestMethod.POST;
            urlRequest.data = byteArray;


            var urlLoader:URLLoader = new URLLoader ();
            urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
            urlLoader.addEventListener (Event.COMPLETE, completeListener_uploadImage);
            urlLoader.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener_uploadImage);
            urlLoader.load (urlRequest);
        }

        public function downloadUploadedPhoto ():void {
            trace ("file to download " + serverPath + serverUniqueFileName);
            downloadURL = new URLRequest ();
            downloadURL.url = serverPath + serverUniqueFileName;

            var file:FileReference = new FileReference ();
            file.addEventListener (Event.SELECT, selectListener_saveImage);
            file.addEventListener (Event.COMPLETE, completeListener_saveImage);
            file.addEventListener (Event.CANCEL, cancelListener_saveImage);
            file.download (downloadURL, serverUniqueFileName + fileType);
        }


/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private static function getUniqueFileName (fileName:String):String {
            var date:Date = new Date ();
            return fileName + date.getTime ();
        }

        private static function createJPG (mc:Sprite, quality:Number):ByteArray {
            var jpgSource:BitmapData = new BitmapData (mc.width, mc.height);
            jpgSource.draw (mc);
            trace ("quality = " + quality);
            var jpgEncoder:JPGEncoder = new JPGEncoder (quality);
            var jpgStream:ByteArray = jpgEncoder.encode (jpgSource);
            return jpgStream;
        }

        private static function createPng (object:Sprite):ByteArray {
            var bmpSource:BitmapData = new BitmapData (object.width, object.height);
            bmpSource.draw (object);
            var bmpStream:ByteArray = PNGEncoder.encode (bmpSource);
            return bmpStream;
        }

        //Удаляем файл на сервере после загрузки:
        private function deleteServerFile (fileName:String):void {
            var header:URLRequestHeader = new URLRequestHeader ("Content-type", "application/octet-stream");
            var jpgURLRequest:URLRequest = new URLRequest (serverPath + filePath + "?delname=" + fileName);
            jpgURLRequest.requestHeaders.push (header);
            jpgURLRequest.method = URLRequestMethod.POST;
            var jpgURLLoader:URLLoader = new URLLoader ();
            jpgURLLoader.dataFormat = URLLoaderDataFormat.VARIABLES;


            jpgURLLoader.addEventListener (Event.COMPLETE, completeListener_deleteServerFile);
            jpgURLLoader.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener_deleteServerFile);

            jpgURLLoader.load (jpgURLRequest);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function completeListener_uploadImage (evt:Event):void {
            var write:String = evt.target.data.write;
            trace ("completeListener_uploadImage:" + evt.target.data);
            if (write == "save") {
                dispatchEvent (new BitmapSenderEvent (BitmapSenderEvent.UPLOADING_COMPLETE));
            }
        }

        private function ioErrorListener_uploadImage (event:Event):void {
            trace ("ioErrorListener uploadImage");
            dispatchEvent (new Event (Event.COMPLETE));
        }


        private function completeListener_saveImage (event:Event):void {
            deleteServerFile (serverUniqueFileName);
        }

        private function selectListener_saveImage (event:Event):void {
            var file:FileReference = FileReference (event.target);
            trace ("selectHandler: name=" + file.name + " URL=" + downloadURL.url);
        }


        private function cancelListener_saveImage (event:Event):void {
            deleteServerFile (serverUniqueFileName);
        }

        private function completeListener_deleteServerFile (event:Event):void {
            var write:String = event.target.data.write;
            trace ('DeleteFileWrite ' + write);
            dispatchEvent (new Event (Event.COMPLETE));
        }

        private function ioErrorListener_deleteServerFile (event:Event):void {
            trace ("ioErrorListener deleteServerFile");
            dispatchEvent (new BitmapSenderEvent (BitmapSenderEvent.LOADING_COMPLETE));
            dispatchEvent (new Event (Event.COMPLETE));
        }

    }

}