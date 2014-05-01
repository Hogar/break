package breakdance.core.js {

    import com.hogargames.errors.SingletonError;

    import flash.events.EventDispatcher;
    import flash.external.ExternalInterface;

    public class JsApi extends EventDispatcher {

        static private var _instance:JsApi;

        static public const GET_USER:String = "social.getUser";
        static public const GET_AlL_FRIENDS:String = "social.getAllFriends";
        static public const GET_APP_FRIENDS:String = "social.getAppFriends";
        static public const PLACE_ORDER:String = 'social.placeOrder';
        static public const GET_ALBUMS:String = 'social.getAlbums';
        static public const CREATE_ALBUM:String = 'social.createAlbum';
        static public const GET_UPLOAD_URL:String = 'social.getServer';
        static public const SAVE_PHOTO:String = 'social.savePhoto';
        static public const INVITE_FRIENDS:String = 'social.inviteFriends';
        static public const WRITE_WALL:String = 'social.writeWall';
        static public const IS_MEMBER:String = 'social.isMember';
        static public const IS_INSTALLED:String = 'social.isInstalled';
        static public const ADD_LEFT:String = 'social.addLeft';

        public function JsApi (key:SingletonKey = null) {
            // Singlton
            if (!key) {
                throw new SingletonError ();
            }

            if (ExternalInterface.available) {
                ExternalInterface.addCallback ('sendFromJS', jsonDataCallBack);
            }
        }

        static public function get instance ():JsApi {
            if (JsApi._instance == null) {
                JsApi._instance = new JsApi (new SingletonKey ());
            }
            return JsApi._instance;
        }

        private function jsonDataCallBack (data:String):void {
            dispatchEvent (new JsApiEvent (data));
        }


        public function query (type:String, callBack:Function, params:Array = null):void {
            var query:JsQuery = new JsQuery (type, callBack, params);
            query.go ();
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}
