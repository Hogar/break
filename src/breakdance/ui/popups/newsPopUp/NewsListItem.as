/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.03.14
 * Time: 16:47
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.newsPopUp {

    import breakdance.data.news.NewData;
    import breakdance.template.Template;

    import com.greensock.TweenLite;
    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.ResizeUtilities;
    import com.hogargames.utils.StringUtilities;

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;

    public class NewsListItem extends GraphicStorage {

        private var mcBorder:Sprite;
        private var mcImageContainer:Sprite;

        private var _newData:NewData;
        private var _selected:Boolean;

        private var loader:Loader;
        private var urlRequest:URLRequest;

        private static const THUMB_WIDTH:int = 58;
        private static const THUMB_HEIGHT:int = 58;

        private static const TWEEN_TIME:Number = .3;

        public function NewsListItem () {
            super (Template.createSymbol (Template.NEWS_LIST_ITEM));
        }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

        public function get newData ():NewData {
            return _newData;
        }

        public function set newData (value:NewData):void {
            _newData = value;
            if (_newData) {
                loadImage (_newData.thumb);
            }
        }

        public function get selected ():Boolean {
            return _selected;
        }

        public function set selected (value:Boolean):void {
            _selected = value;
            var toAlpha:Number = value ? 1 : 0;
            TweenLite.to (mcBorder, TWEEN_TIME, {alpha:toAlpha});
        }

//////////////////////////////////
//PROTECTED:
//////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            mcBorder = getElement ("mcBorder");
            mcImageContainer = getElement ("mcImageContainer");

            mcBorder.alpha = 0;

            mc.buttonMode = true;
            mc.useHandCursor = true;
        }

//////////////////////////////////
//PRIVATE:
//////////////////////////////////

        private function loadImage (url:String):void {
            if (!(StringUtilities.isNotValueString (url))) {
                //Деактивируем предыдущий лоадер:
                if (loader) {
                    loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, completeListener);
                    loader.contentLoaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
                    try {
                        loader.close ();
                    }
                    catch (error:Error) {
                        //
                    }
                    loader = null;
                }
                //Создаём лоадер, грузи превьюшку:
                loader = new Loader ();
                loader.contentLoaderInfo.addEventListener (Event.COMPLETE, completeListener);
                loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
                urlRequest = new URLRequest (url);
                loader.load (urlRequest);
            }
        }

//////////////////////////////////
//LISTENERS:
//////////////////////////////////

        private function completeListener (event:Event):void {
            var _loaderInfo:LoaderInfo = LoaderInfo (event.currentTarget);
            _loaderInfo.removeEventListener (Event.COMPLETE, completeListener);
            _loaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
            var bmp:Bitmap = Bitmap (_loaderInfo.content);
			while(mcImageContainer.numChildren>0)
				mcImageContainer.removeChildAt(0);
            if ((bmp.bitmapData.width != THUMB_WIDTH) || (bmp.bitmapData.height != THUMB_HEIGHT)) {
                bmp.smoothing = true;
                ResizeUtilities.resizeObj (bmp, THUMB_WIDTH, THUMB_HEIGHT, ResizeUtilities.MODE_SCALING);
            }
            mcImageContainer.addChild (bmp);
        }

        private function ioErrorListener (event:IOErrorEvent):void {
            var _loaderInfo:LoaderInfo = LoaderInfo (event.currentTarget);
            _loaderInfo.removeEventListener (Event.COMPLETE, completeListener);
            _loaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
            trace ("Не удалось загрузить картинку " + urlRequest.url);
        }

    }
}
