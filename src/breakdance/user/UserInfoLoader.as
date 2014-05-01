package breakdance.user {

    import breakdance.BreakdanceApp;
    import breakdance.core.IAsyncInitObject;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.server.ServerApi;
    import breakdance.core.server.ServerUtils;
    import breakdance.core.staticData.StaticData;
    import breakdance.ui.popups.PopUpManager;

    import com.hogargames.debug.Tracer;

    import flash.utils.Dictionary;

    public class UserInfoLoader implements IAsyncInitObject {

        private var appUser:AppUser;

        private var _completeCallback:Function;
        private var _errorCallback:Function;

        public function UserInfoLoader () {

        }

        public function init (completeCallback:Function, errorCallback:Function, progressCallback:Function):void {
            appUser = BreakdanceApp.instance.appUser;

            _completeCallback = completeCallback;
            _errorCallback = errorCallback;

            JsApi.instance.query (JsApi.GET_USER, onGetUser, [appUser.uid]);
        }

        public function destroy ():void {
            _completeCallback = null;
            _errorCallback = null;
        }

        private function onGetUser (response:JsQueryResult):void {
            appUser.onSocialGetUser (response);
            JsApi.instance.query (JsApi.GET_APP_FRIENDS, onGetAppFriends, [appUser.uid]);
        }

        private function onGetAppFriends (response:JsQueryResult):void {
            appUser.onSocialGetAppFriends (response);
            JsApi.instance.query (JsApi.GET_AlL_FRIENDS, onGetAllFriends, [appUser.uid]);
        }

        private function onGetAllFriends (response:JsQueryResult):void {
            appUser.onSocialGetAllFriends (response);
            ServerApi.instance.query (ServerApi.USER_GET, {}, onGetUserComplete, onError);
        }

        private function onError (message:String):void {
            if (_errorCallback != null) {
                Tracer.log ("onError: " + message);
                _errorCallback (message);
            }
            destroy ();
        }

        private function onGetUserComplete (response:Object):void {
            if (!response.data) {
                appUser.installed = false;
                if (response.error == "Message: json_encode(): Invalid UTF-8 sequence in argument") {
                    ServerApi.instance.query (ServerApi.DELETE_USER, {}, onDeleteUser, onError);
                    return;
                }
                PopUpManager.instance.languagePopUp.show ();
            }
            else {
                appUser.installed = true;
                appUser.init (response);
            }

            getList ();
        }

        private function getList ():void {
            var uids:Array = [];
            var userFriends:Vector.<FriendData> = appUser.userAppFriends;
            var uidsAsString:String = "";
            for (var i:int = 0; i < userFriends.length; i++) {
                uids.push (userFriends [i].uid);
                uidsAsString += userFriends [i].uid;
                if (i < userFriends.length - 1) {
                    uidsAsString += ",";
                }
            }
            ServerApi.instance.query (ServerApi.USER_GET_LIST, {uids: uidsAsString}, onGetFriendsComplete, onError);
        }

        private function onDeleteUser (response:Object):void {
            if (response.response_code == 1) {
                PopUpManager.instance.languagePopUp.show ();
                getList ();
            }
        }

        private function onGetFriendsComplete (response:Object):void {
            if (!response.data) {
                //
            }
            else {
                var data:Object = response.data;
                var friendsAsDictionary:Dictionary = new Dictionary ();
                for (var prop:String in data) {
                    friendsAsDictionary [prop] = data [prop];
                }
                var userFriends:Vector.<FriendData> = appUser.userAppFriends;
                var i:int;
                for (i = 0; i < userFriends.length; i++) {
                    var friendData:FriendData = userFriends [i];
                    if (friendsAsDictionary [friendData.uid]) {
                        var userObject:Object = friendsAsDictionary [friendData.uid];
                        if (userObject) {
                            ServerUtils.initInitialPlayer (friendData, userObject);
                        }
                    }
                }
            }

            var userMissions:Vector.<String> = appUser.userMissions;
            if (userMissions.indexOf (UserMissions.FRIENDS_MISSION) == -1) {
                var numFriends:int = parseInt (StaticData.instance.getSetting ("5_steps_num_friends"));
                Tracer.log (
                        "appUser.userAppFriends.length (" + appUser.userAppFriends.length + ") " +
                        ">= numFriends (" + numFriends + ") = " +
                        (appUser.userAppFriends.length >= numFriends)
                );
                if (appUser.userAppFriends.length >= numFriends) {
                    ServerApi.instance.query (ServerApi.SAVE_MISSION, {mission_id:UserMissions.FRIENDS_MISSION}, onSaveMission);
                    return;
                }
            }
            complete ();
        }

        private function onSaveMission (response:Object):void {
            complete ();
        }

        private function complete ():void {
            if (_completeCallback != null) {
                _completeCallback ();
            }
            destroy ();
        }

    }
}