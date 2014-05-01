/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.12.13
 * Time: 18:29
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screenManager {

    import breakdance.BreakdanceApp;
    import breakdance.battle.BattleManager;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.screenManager.events.ScreenManagerEvent;

    import com.hogargames.errors.SingletonError;

    import flash.events.EventDispatcher;

    public class ScreenManager extends EventDispatcher {

        private var _currentScreenId:String = null;
        private var nextScreenId:String = null;

        private static var _instance:ScreenManager;

        public static const BATTLE_SCREEN:String = "battle screen";
        public static const HOME_SCREEN:String = "home screen";

        public static const BATTLE_LIST:String = "battle list";
        public static const RATING_SCREEN:String = "rating screen";
        public static const ACHIEVEMENTS_SCREEN:String = "achievements screen";
        public static const WORKS_SCREEN:String = "works screen";
        public static const TRAINING_SCREEN:String = "training screen";
        public static const DANCE_MOVES_SCREEN:String = "dance moves screen";
        public static const SHOP_SCREEN:String = "shop screen";
        public static const DRESS_ROOM_SCREEN:String = "dress room screen";

        public function ScreenManager (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public static function get instance ():ScreenManager {
            if (!_instance) {
                _instance = new ScreenManager (new SingletonKey ());
            }
            return _instance;
        }

        public function get currentScreenId ():String {
            return _currentScreenId;
        }

        public function set currentScreenId (value:String):void {
            _currentScreenId = value;
        }

        public function navigateTo (screenId:String):void {
//            trace ("navigateTo: " + screenId);
            if (screenId == _currentScreenId) {
                return;
            }
            if ((screenId == BATTLE_SCREEN) || ((screenId == BATTLE_LIST))) {
                if (!BreakdanceApp.instance.appUser.testReadyToBattle ()) {
                    return;
                }
            }
            if (_currentScreenId == BATTLE_SCREEN) {
                nextScreenId = screenId;
                PopUpManager.instance.leaveBattleScreenPopUp.show ();
            }
//            else if (currentScreenId == TRAINING_SCREEN) {
//                nextScreenId = screenId;
//                PopUpManager.instance.leaveMiniGameScreenPopUp.show ();
//            }
            else {
                _currentScreenId = screenId;
                nextScreenId = null;
                dispatchEvent (new ScreenManagerEvent (_currentScreenId, ScreenManagerEvent.NAVIGATE_TO));
            }
        }

        public function reInit (screenId:String):void {
            dispatchEvent (new ScreenManagerEvent (screenId, ScreenManagerEvent.REINIT));
        }

        public function acceptLeaveScreen ():void {
            if (nextScreenId) {
                if (_currentScreenId != BATTLE_SCREEN) {
                    _currentScreenId = nextScreenId;
                    nextScreenId = null;
                    dispatchEvent (new ScreenManagerEvent (_currentScreenId));
                }
            }
        }

        public function navigateBeforeBattle ():void {
            if (nextScreenId) {
                _currentScreenId = nextScreenId;
            }
            else {
                _currentScreenId = HOME_SCREEN;
            }
            BattleManager.instance.destroyCurrentBattle ();
            nextScreenId = null;
            dispatchEvent (new ScreenManagerEvent (_currentScreenId));
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}
