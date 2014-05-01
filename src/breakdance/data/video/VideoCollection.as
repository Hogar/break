package breakdance.data.video {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalConstants;
    import breakdance.core.IAsyncInitObject;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;
    import breakdance.events.LoadingStepEvent;

    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.VideoLoader;
    import com.hogargames.errors.SingletonError;

    public class VideoCollection implements IAsyncInitObject {

        private static var _instance:VideoCollection;

        private var _queue:LoaderMax;

        public static const STAND_DANCE_MOVE:String = "stand dance move";
        private static const STAND_DANCE_MOVE_URL:String = "standart-toprock.mov";

        public function VideoCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
        }

        public static function get instance ():VideoCollection {
            if (!_instance) {
                _instance = new VideoCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init (completeCallback:Function, errorCallback:Function, progressCallback:Function):void {
            _queue = new LoaderMax ({ skipFailed: false, onComplete: completeHandler, onError: errorHandler, onProgress: progressHandler });

            _queue.append (new VideoLoader (GlobalConstants.ASSETS_URL + 'video/' + STAND_DANCE_MOVE_URL, { noCache: false, name: STAND_DANCE_MOVE, autoPlay: false, autoDetachNetStream: false }));
            var danceMoveType:DanceMoveType;
            for (var i:int = 0; i < DanceMoveTypeCollection.instance.list.length; i++) {
                danceMoveType = DanceMoveTypeCollection.instance.list[i];
                _queue.append (new VideoLoader (GlobalConstants.ASSETS_URL + 'video/' + danceMoveType.video + '.mov', {noCache: false, name: danceMoveType.id, autoPlay: false, autoDetachNetStream: false }));
            }

            //start loading
            _queue.load ();

            BreakdanceApp.instance.appDispatcher.dispatchEvent (new LoadingStepEvent (LoadingStepEvent.START_LOADING_STEP, "Загрузка видео"));

            function completeHandler (event:LoaderEvent):void {
                BreakdanceApp.instance.appDispatcher.dispatchEvent (new LoadingStepEvent (LoadingStepEvent.START_LOADING_STEP, "Инициализация"));
                completeCallback ();
            }

            function errorHandler (event:LoaderEvent):void {
                errorCallback ("Loading error (" + event.target + ")");
            }

            function progressHandler (event:LoaderEvent):void {
                progressCallback (event.target.progress);
            }
        }

        public function getVideo (id:String):VideoLoader {
            return _queue.getLoader (id);
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}