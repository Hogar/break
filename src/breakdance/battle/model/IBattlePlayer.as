/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 22:42
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.model {

    import breakdance.IPlayerData;
    import breakdance.battle.data.BattleDanceMoveData;

    /**
     * Интерфейс для модели игрока, участвующего в бою. Определяет только get-методы.
     */
    public interface IBattlePlayer extends IPlayerData {
        
        function get availableMoves ():Vector.<BattleDanceMoveData>;

        /**
         * Кол-во фишек.
         */
        function get chips ():int;

        /**
         * Текущеее значение выносливости.
         */
        function get stamina ():int;

        /**
         * Стартовое значение выносливости (на начало боя).
         */
        function get startStamina ():int;

        /**
         * Не теряет выносливости в бою.
         */
        function get noLossStamina ():Boolean;

        /**
         * Максимальное значение выносливости.
         */
        function get maxStamina ():int;

        /**
         * Очки мастерства.
         */
        function get points ():int;

        /**
         * Регистрирует объект прослушивателя события в объекте EventDispatcher, в результате чего прослушиватель будет получать уведомления о событиях.
         * @see flash.events.IEventDispatcher#addEventListener()
         */
        function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void

        /**
         * Удаляет прослушиватель из объекта EventDispatcher.
         * @see flash.events.IEventDispatcher#removeEventListener()
         */
        function removeEventListener (type:String, listener:Function, useCapture:Boolean = false):void
        
    }
   
}
