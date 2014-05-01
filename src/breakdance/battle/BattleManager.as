/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 03.09.13
 * Time: 15:12
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle {

    import breakdance.BreakdanceApp;
    import breakdance.battle.ai.BasicArtificialIntelligence;
    import breakdance.battle.controller.BattleController;
    import breakdance.battle.controller.LocalBattleController;
    import breakdance.battle.controller.PvPBattleController;
    import breakdance.battle.data.BattleData;
    import breakdance.battle.model.Battle;
    import breakdance.battle.view.BattleScreen;
    import breakdance.ui.popups.PopUpManager;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.user.AppUser;

    import com.hogargames.debug.Tracer;
    import com.hogargames.errors.SingletonError;

    /**
     * Менеджер битв.
     * Создаёт новые битвы, хранит состояние приложение (идёт сейчас битва или нет).
     */
    public class BattleManager {

        private static var _instance:BattleManager;

        private var currentBattle:Battle;
        private var currentController:BattleController;

        private var battleScreen:BattleScreen;
        private var _hasBattle:Boolean = false;

        public function BattleManager (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public static function get instance ():BattleManager {
            if (!_instance) {
                _instance = new BattleManager (new SingletonKey ());
            }
            return _instance;
        }

        /**
         * Установка view
         * @param battleScreen
         */
        public function setBattleScreen (battleScreen:BattleScreen):void {
            this.battleScreen = battleScreen;
        }

        public function addStaminaToCurrentBattle (addingStamina:int, noLessStamina:Boolean = false, staminaConsumableId:String = ""):void {
            if (currentController) {
                currentController.addStamina (addingStamina, BreakdanceApp.instance.appUser.uid, noLessStamina, staminaConsumableId);
            }
        }

        /**
         * Отмена текущей битвы (автопоражение).
         */
        public function cancelCurrentBattle ():void {
            if (currentController) {
                currentController.surrender ();
            }
        }

        /**
         * Завершение текущей битвы (автопоражение).
         */
        public function endCurrentBattle ():void {
//            destroyCurrentBattle ();
            _hasBattle = false;
        }

        /**
         * Удаление (очистка) текущей битвы (автопоражение).
         */
        public function destroyCurrentBattle ():void {
            if (currentBattle) {
                currentBattle = null;
            }
            if (currentController) {
                currentController.destroy ();
                currentController.battle = null;
                currentController = null;
            }
            battleScreen.battle = null;
            battleScreen.controller = null;
        }

        /**
         * Параметр, определяющий, идёт ли сейчас битва.
         */
        public function get hasBattle ():Boolean {
            return _hasBattle;
        }

        public function createLocalBattle (battleData:BattleData):void {
            var controller:LocalBattleController = new LocalBattleController ();
            //TODO:Добавить выбор контроллера ИИ.
            controller.aiController = new BasicArtificialIntelligence ();
            createBattle (battleData, controller);
        }

        public function createPvPBattle (battleData:BattleData):void {
            createBattle (battleData, new PvPBattleController ());
            PopUpManager.instance.sendInvitePopUp.hide ();
            PopUpManager.instance.acceptInvitePopUp.hide ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function createBattle (battleData:BattleData, controller:BattleController):void {
            destroyCurrentBattle ();
            var appUser:AppUser = BreakdanceApp.instance.appUser;
            if (appUser.testReadyToBattle ()) {
                if (battleData) {
                    if (battleData.bet <= appUser.coins) {
                        //Создаём модель боя:
                        var newBattle:Battle = new Battle (battleData);

                        //Создаём pvp-контроллер боя:
                        controller.battle = newBattle;

                        //Инициализируем представление боя:
                        var breakDanceApp:BreakdanceApp = BreakdanceApp.instance;
                        battleScreen.battle = newBattle;
                        battleScreen.controller = controller;

                        currentBattle = newBattle;
                        currentController = controller;

                        //Скрываем все попапы:
                        PopUpManager.instance.closeAllPopUps ();

                        //Переходим на экран боя:
                        ScreenManager.instance.navigateTo (ScreenManager.BATTLE_SCREEN);

                        //Начинаем бой:
                        controller.startBattle ();

                       _hasBattle = true;
                    }
                    else {
                        PopUpManager.instance.notEnoughCoinsPopUp.show ();
                    }
                }
                else {
                    trace ("Невозможно создать бой нулевыми данными!");
                }
            }
            else {
                Tracer.log ("Невозможно создать бой, т.к. у игрока не изучено ни одного движения!");
            }
        }

    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}