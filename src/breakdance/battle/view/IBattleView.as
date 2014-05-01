/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.09.13
 * Time: 12:19
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view {

    import breakdance.battle.controller.IBattleController;
    import breakdance.battle.model.IBattle;

    public interface IBattleView {

        /**
         * Установка модели боя.
         * @param battle Модель боя.
         */
        function set battle (battle:IBattle):void;

        /**
         * Установка контроллера боя.
         * @param controller Контроллер боя.
         */
        function set controller (controller:IBattleController):void;
    }
}
