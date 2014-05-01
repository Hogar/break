/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 11.10.11
 * Time: 11:54
 */

package com.hogargames.display.elements {

    import com.hogargames.debug.Tracer;
    import com.hogargames.display.ResizableContainer;
    import com.hogargames.utils.ResizeUtilities;

    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;

    /**
     * Отправляется, при загрузке изображения.
     *
     * @eventType flash.events.Event.COMPLETE
     */
    [Event(name="complete", type="flash.events.Event")]

    /**
     * Контейнер для загрузки и отображения изображения.
     */
    public class ImageContainer extends ResizableContainer {

        private var imageLoader:Loader = new Loader ();
        private var request:URLRequest = new URLRequest ();

        private var _doResize:Boolean = true;

        /**
         * @param width Ширина контейнера.
         * @param height Высота контейнера.
         * @param doResize Параметр, указывающий,
         * проводить ли масштабирование отображаемых изображений под размер контейнера.
         */
        public function ImageContainer (width:Number = 100, height:Number = 100, doResize:Boolean = true) {
            this.containerWidth = width;
            this.containerHeight = height;
            this.doResize = doResize;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Отображаемое изображение.
         */
        public function get bmp ():Bitmap {
            var _bmp:Bitmap;
            if (container.numChildren > 0) {
                var child:DisplayObject = container.getChildAt (0);
                if (child is Bitmap) {
                    _bmp = Bitmap (child);
                }
            }
            return _bmp;
        }

        /**
         * Параметр, указывающий, проводить ли масштабирование отображаемых изображений под размер контейнера.
         */
        public function get doResize ():Boolean {
            return _doResize;
        }

        public function set doResize (value:Boolean):void {
            _doResize = value;
        }

        /**
         * Загрузка изображения.
         * @param url Url-адрес изображения.
         */
        public function loadImage (url:String):void {
            Tracer.log ("LOAD IMAGE: " + url);
            request.url = url;
            imageLoader.contentLoaderInfo.addEventListener (Event.COMPLETE, completeListener);
            imageLoader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, IOErrorListener);
            imageLoader.contentLoaderInfo.addEventListener (HTTPStatusEvent.HTTP_STATUS, HTTPStatusListener);
            imageLoader.contentLoaderInfo.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
            imageLoader.load (request);
        }

        /**
         * Добавление изображения.
         * @param bmp Изображение.
         */
        public function addImage (bmp:Bitmap):void {
            Tracer.log ("ADD IMAGE: " + bmp + "[w = '" + bmp.width + "'; h = '" + bmp.height + "']");
            if (doResize) {
                ResizeUtilities.resizeObj (bmp, containerWidth, containerHeight, ResizeUtilities.MODE_SCALING);
            }
            clear ();
            container.addChild (bmp);
        }

        public function clear ():void {
            imageLoader.unload ();
            while (container.numChildren > 0) {
                var child:DisplayObject = container.getChildAt (0);
                if (child is Bitmap) {
                    Bitmap (child).bitmapData.dispose ();
                }
                container.removeChild (child);
            }
        }

        /**
         * Деактивация слушателей, остановка загрузки.
         */
        public function destroy ():void {
            imageLoader.unload ();
            imageLoader.contentLoaderInfo.removeEventListener (Event.COMPLETE, completeListener);
            imageLoader.contentLoaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, IOErrorListener);
            imageLoader.contentLoaderInfo.removeEventListener (HTTPStatusEvent.HTTP_STATUS, HTTPStatusListener);
            imageLoader.removeEventListener (IOErrorEvent.IO_ERROR, IOErrorListener);
            imageLoader.removeEventListener (HTTPStatusEvent.HTTP_STATUS, HTTPStatusListener);
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        /**
         * @inheritDoc
         */
        override protected function position ():void {
            super.position ();
            if (doResize && bmp) {
                ResizeUtilities.resizeObj (bmp, containerWidth, containerHeight, ResizeUtilities.MODE_SCALING);
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function completeListener (event:Event):void {
            Tracer.log ("1. COMPLETE LOAD IMAGE.");
            try {
                Tracer.log ("2. event.target.content = " + event.target.content);
                var bmp:Bitmap = event.target.content;
                Tracer.log ("3. COMPLETE LOAD IMAGE. bmp = " + bmp + "[w = '" + bmp.width + "'; h = '" + bmp.height + "']");
                addChildAt (bmp, 0);
                bmp.smoothing = true;
                addImage (bmp);
                dispatchEvent (new Event (Event.COMPLETE));
            }
            catch (error:Error) {
                Tracer.log ("ERROR!!!! " + error.message);
            }
        }

        private function IOErrorListener (event:IOErrorEvent):void {
            var message:String = 'ERROR: File "' + request.url + '" not found.';
            Tracer.log (message);
            throw (new Error (message));
        }

        private function HTTPStatusListener (event:HTTPStatusEvent):void {
            if (event.status != 0 && event.status != 200) {
                var message:String = 'ERROR: Bad http status (' + event.status + ') from "' + request.url + '"';
                Tracer.log (message);
                throw (new Error (message));
            }
        }

        private function securityErrorListener (event:SecurityErrorEvent):void {
            var message:String = 'ERROR: Security Error. File "' + request.url + '" not found.';
            Tracer.log (message);
            throw (new Error (message));
        }

    }
}
