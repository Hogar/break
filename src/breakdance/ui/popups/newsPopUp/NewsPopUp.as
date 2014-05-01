/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.03.14
 * Time: 4:48
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.newsPopUp {

    import breakdance.BreakdanceApp;
    import breakdance.core.server.ServerApi;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.news.ButtonLinkType;
    import breakdance.data.news.NewData;
    import breakdance.data.news.NewDataCollection;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.events.TutorialStepEvent;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.basePopUps.TitleClosingPopUp;
    import breakdance.ui.popups.newsPopUp.events.SelectNewDataEvent;
    import breakdance.ui.screenManager.ScreenManager;

    import com.greensock.TweenLite;
    import com.hogargames.utils.DisplayObjectContainerUtilities;
    import com.hogargames.utils.ResizeUtilities;
    import com.hogargames.utils.StringUtilities;

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    public class NewsPopUp extends TitleClosingPopUp {

        private var mcImageContainer:Sprite;
        private var mcProgress:MovieClip;
        private var mcBtnContainer:Sprite;
        private var btn:ButtonWithText;
        private var newsList:NewsList;

        private var loader:Loader;
        private var urlRequest:URLRequest;

        private var currentNewData:NewData;

        private var tutorialManager:TutorialManager;

        private static const IMAGE_WIDTH:int = 600;
        private static const IMAGE_HEIGHT:int = 350;

        public function NewsPopUp () {
            tutorialManager = TutorialManager.instance;
            super (Template.createSymbol (Template.NEWS_POP_UP));
        }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

        override public function show ():void {
            if (!BreakdanceApp.instance.appUser.installed) {
                return;
            }
            if (tutorialManager.currentStep != null) {
                return;
            }
            super.show ();
            var newData:NewData = BreakdanceApp.instance.appUser.getUnreadNewData ();
            if (newData) {
                newsList.selectNew (newData);
            }
            else {
                var news:Vector.<NewData> = NewDataCollection.instance.enabledList;
                if (news.length > 0) {
                    newsList.selectNew (news [0]);
                }
            }
        }

        override public function setTexts ():void {
            super.setTexts ();
            tfTitle.htmlText = textsManager.getText ("news");
            if (currentNewData) {
                btn.text = currentNewData.buttonText;
                loadNewData (currentNewData);
            }
            else {
                btn.text = "";
            }
        }

        override public function destroy ():void {
            if (newsList) {
                newsList.removeEventListener (SelectNewDataEvent.SELECT_NEW_DATA, selectNewDataListener);
                newsList.destroy ();
                newsList = null;
            }
            tutorialManager.removeEventListener (TutorialStepEvent.SET_TUTORIAL_STEP, setTutorialStepListener);
            super.destroy ();
        }

//////////////////////////////////
//PROTECTED:
//////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            newsList = new NewsList (mc ["mcNewsList"]);
            var mcImageContainerContainer:Sprite = getElement ("mcImageContainer");
            mcImageContainer = getElement ("mcImageContainer", mcImageContainerContainer);
            DisplayObjectContainerUtilities.clear (mcImageContainer);
            mcProgress = getElement ("mcProgress", mcImageContainerContainer);
            mcBtnContainer = getElement ("mcBtnContainer", mcImageContainerContainer);
            btn = new ButtonWithText (mcBtnContainer ["btn"]);
            btn.addEventListener (MouseEvent.CLICK, clickListener);
            mcBtnContainer.alpha = 0;

            newsList.addEventListener (SelectNewDataEvent.SELECT_NEW_DATA, selectNewDataListener);

            var allNews:Vector.<NewData> = NewDataCollection.instance.enabledList;
            var news:Vector.<NewData> = allNews.concat ();
            newsList.init (news);
        }

//////////////////////////////////
//PRIVATE:
//////////////////////////////////

        private function loadNewData (newData:NewData):void {
            if (newData) {
                if (textsManager.currentLanguage == TextsManager.RU) {
                    loadImage (newData.imageRu);
                }
                else if (textsManager.currentLanguage == TextsManager.EN) {
                    loadImage (newData.imageEn);
                }
            }
        }

        private function loadImage (url:String):void {
            if (!(StringUtilities.isNotValueString (url))) {
                //Деактивируем предыдущий лоадер:
                if (loader) {
                    removeLoaderInfoListeners (loader.contentLoaderInfo);
                    try {
                        loader.close ();
                    }
                    catch (error:Error) {
                        //
                    }
                    loader = null;
                }
                //Создаём лоадер, грузи превьюшку:

                for (var i:int = 0; i < mcImageContainer.numChildren; i++) {
                    var bmp:Bitmap = Bitmap (mcImageContainer.getChildAt (i));
                    TweenLite.to (bmp, TWEEN_TIME, {alpha:0, onComplete:removeBmp, onCompleteParams:[bmp]});
                }
                TweenLite.killTweensOf (mcBtnContainer);
                TweenLite.to (mcBtnContainer, TWEEN_TIME, {alpha:0});

                loader = new Loader ();
                loader.contentLoaderInfo.addEventListener (Event.COMPLETE, completeListener);
                loader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, progressListener);
                loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
                urlRequest = new URLRequest (url);
//                mcProgress.gotoAndStop (1);
                loader.load (urlRequest);
            }
        }

        private function removeBmp (bmp:Bitmap):void {
            if (mcImageContainer.contains (bmp)) {
                mcImageContainer.removeChild (bmp);
            }
        }

        private function removeLoaderInfoListeners (_loaderInfo:LoaderInfo):void {
            _loaderInfo.removeEventListener (Event.COMPLETE, completeListener);
            _loaderInfo.removeEventListener (ProgressEvent.PROGRESS, progressListener);
            _loaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorListener);
        }

//////////////////////////////////
//LISTENERS:
//////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            if (currentNewData) {
                if (currentNewData.buttonLinkType == ButtonLinkType.URL) {
                    navigateToURL (new URLRequest (currentNewData.buttonLinkValue), "_blank");
                }
                else if (currentNewData.buttonLinkType == ButtonLinkType.GAME_WINDOW) {
                    ScreenManager.instance.navigateTo (currentNewData.buttonLinkValue);
                    hide ();
                }
            }
        }

        private function selectNewDataListener (event:SelectNewDataEvent):void {
            currentNewData = event.newData;
            if (currentNewData) {
                if (BreakdanceApp.instance.appUser.readNews.indexOf (currentNewData.id) == -1) {
                    BreakdanceApp.instance.appUser.addNew (currentNewData.id);
                    ServerApi.instance.query (ServerApi.ADD_USER_NEWS, {item_id:currentNewData.id}, onAddUserNewsResponse);
                }
            }
            setTexts ();
        }

        private function onAddUserNewsResponse (response:Object):void {
            //
        }

        private function progressListener (event:ProgressEvent):void {
            var percent:int = event.bytesLoaded / event.bytesTotal * 100;
//            mcProgress.gotoAndStop (percent);
        }

        private function completeListener (event:Event):void {
            var _loaderInfo:LoaderInfo = LoaderInfo (event.currentTarget);
            removeLoaderInfoListeners (_loaderInfo);

            var bmp:Bitmap = Bitmap (_loaderInfo.content);
            if ((bmp.bitmapData.width != IMAGE_WIDTH) || (bmp.bitmapData.height != IMAGE_HEIGHT)) {
                bmp.smoothing = true;
                ResizeUtilities.resizeObj (bmp, IMAGE_WIDTH, IMAGE_HEIGHT, ResizeUtilities.MODE_SCALING);
            }
            mcImageContainer.addChild (bmp);
            bmp.alpha = 0;
            TweenLite.to (bmp, TWEEN_TIME, {alpha:1});

            TweenLite.killTweensOf (mcBtnContainer);
            mcBtnContainer.alpha = 0;
            TweenLite.to (mcBtnContainer, TWEEN_TIME, {alpha:1});

            if (currentNewData) {
                mcBtnContainer.x = currentNewData.buttonX;
                mcBtnContainer.y = currentNewData.buttonY;
                mcBtnContainer.visible = currentNewData.buttonEnable;
            }
        }

        private function ioErrorListener (event:IOErrorEvent):void {
            var _loaderInfo:LoaderInfo = LoaderInfo (event.currentTarget);
            removeLoaderInfoListeners (_loaderInfo);
            trace ("Не удалось загрузить картинку " + urlRequest.url);
        }

        private function setTutorialStepListener (event:TutorialStepEvent):void {
            if (isShowed) {
                if (tutorialManager.currentStep != null) {
                    hide ();
                }
            }
        }

    }
}
