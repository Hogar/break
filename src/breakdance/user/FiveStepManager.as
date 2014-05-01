/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.03.14
 * Time: 0:55
 * To change this template use File | Settings | File Templates.
 */
package breakdance.user {

    import breakdance.BreakdanceApp;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.server.ServerApi;
    import breakdance.core.ui.overlay.TransactionOverlay;

    import com.hogargames.errors.SingletonError;
    import com.hogargames.utils.StringUtilities;

    public class FiveStepManager {

        private static var _instance:FiveStepManager;

        private var appUser:AppUser;

        public function FiveStepManager (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
            appUser = BreakdanceApp.instance.appUser;
        }

        public static function get instance ():FiveStepManager {
            if (!_instance) {
                _instance = new FiveStepManager (new SingletonKey ());
            }
            return _instance;
        }

        public function testSteps ():void {
            TransactionOverlay.instance.show ();
            testGroupStep ();
        }

        private function testGroupStep ():void {
            var userMissions:Vector.<String> = appUser.userMissions;
            if (userMissions.indexOf (UserMissions.ENTER_GROUP_MISSION) == -1) {
                JsApi.instance.query (JsApi.IS_MEMBER, onIsMember, [appUser.uid]);
            }
            else {
                testBookmarkStep ();
            }
        }

        private function onIsMember (response:JsQueryResult):void {
            if (StringUtilities.parseToBoolean (response.data.response)) {
                ServerApi.instance.query (ServerApi.SAVE_MISSION, {mission_id:UserMissions.ENTER_GROUP_MISSION}, onSaveMission_enter_group);
            }
            else {
                testBookmarkStep ();
            }
        }

        private function onSaveMission_enter_group (response:Object):void {
            appUser.onSaveMission (response);
            testBookmarkStep ();
        }

        private function testBookmarkStep ():void {
            var userMissions:Vector.<String> = appUser.userMissions;
            if (userMissions.indexOf (UserMissions.BOOKMARK_MISSION) == -1) {
                JsApi.instance.query (JsApi.IS_INSTALLED, onIsInstalled, [appUser.uid]);
            }
            else {
                complete ();
            }
        }

        private function onIsInstalled (response:JsQueryResult):void {
            if (response.data.response == "256") {
                ServerApi.instance.query (ServerApi.SAVE_MISSION, {mission_id:UserMissions.BOOKMARK_MISSION}, onSaveMission_bookmark);
            }
            else {
                complete ();
            }
        }

        private function onSaveMission_bookmark (response:Object):void {
            appUser.onSaveMission (response);
            complete ();
        }

        private function complete ():void {
            TransactionOverlay.instance.hide ();
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}