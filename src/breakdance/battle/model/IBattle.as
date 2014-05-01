/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 22:22
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.model {

    /**
     * Интерфейс модели для представления (view).
     * Функции для работы с контроллером определяются в конкретной имплементации.
     */
    public interface IBattle {


        /**
         * Общее число раундов (без учёта доп. раундов).
         */
        function get numRounds ():int;

        /**
         * Максимальное кол-во танц движений в связке
         * @return
         */
        function get maxDanceMoves ():int;


        /**
         * Данные об игроке 1.
         */
        function get player1 ():BattlePlayer;

        /**
         * Данные об игроке 2.
         */
        function get player2 ():BattlePlayer;

        /**
         * Данные об игроке 2.
         */
        function get bet ():int;

        /**
         * Первый стек связок игрока. Не обязательно player1.
         */
        function get danceRoutinesStack1 ():DanceRoutinesStack;

        /**
         * Второй стек связок игрока. Не обязательно player2.
         */
        function get danceRoutinesStack2 ():DanceRoutinesStack;

        /**
         * Первый стек связок игрока для доп. раунда. Не обязательно player1.
         */
        function get additionalDanceRoutinesStack1 ():AdditionalDanceRoutinesStack;

        /**
         * Второй стек связок игрока для доп. раунда. Не обязательно player2.
         */
        function get additionalDanceRoutinesStack2 ():AdditionalDanceRoutinesStack;

        /**
         * Текущий раунд. Может быть больше макс кол-ва (дополнительный раунд при ничьей).
         * @see breakdance.battle.model.DanceRoutinesStack
         */
        function get currentRound ():int;

        /**
         * Номер текущего стека связок.
         *
         * @see breakdance.battle.model.DanceRoutinesStack
         */
        function get currentDanceRoutinesStack ():int;

        /**
         * Текущее танцевальное движение в текущем раунде текущей связки.
         * @see breakdance.battle.model.BattleDanceMove
         */
        function get currentDanceMove ():int;

        /**
         * Параметр, определяющий, что текущий раунд является дополнительным.
         */
        function get currentRoundIsAdditional ():Boolean;

/////////////////////////////////////////////
//ДРУГОЕ:
/////////////////////////////////////////////

        /**
         * Регистрирует объект прослушивателя события в объекте EventDispatcher, в результате чего прослушиватель будет получать уведомления о событиях.
         * @see flash.events.IEventDispatcher#addEventListener()
         */
        function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void

        /**
         * Удаляет прослушиватель из объекта EventDispatcher.
         * @see flash.events.IEventDispatcher#removeEventListener()
         */
        function removeEventListener (type:String, listener:Function, useCapture:Boolean = false):void

    }
}
