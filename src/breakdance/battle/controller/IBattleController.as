/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.09.13
 * Time: 22:19
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.controller {

    import breakdance.battle.data.BattleDanceMoveData;

    public interface IBattleController {

        /**
         * Сдаться.
         */
        function surrender ():void;

        /**
         * Запуск начала боя.
         */
        function startBattle ():void

        /**
         * Остановка боя по окончанию времени боя.
         */
        function timeIsUp ():void

        /**
         * Добавление в стек вязок игрока новой связки танцевальных движений.
         * @param danceRoutine Связка.
         * @param uid Id игрока, выполняющего связку.
         */
        function addDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>, uid:String):void;


        /**
         * Добавление в стек вязок игрока связки танцевальных движений для дополнительного раунда.
         * @param danceRoutine Связка для доп. раунда.
         * @param uid Id игрока, выполняющего связку.
         */
        function addAdditionalDanceRoutine (danceRoutine:Vector.<BattleDanceMoveData>, uid:String):void;

        /**
         * Добавление выносливости в бою (принятие энергетика).
         * @param addingStamina Кол-во добавляемых очков выносливости.
         * @param uid Id игрока, пополняющего выносливость.
         * @param noLessStamina Установка свойства "нет потери выносливости в бою"
         * @param staminaConsumableId Id энергетика, который пополнил выносливость.
         */
        function addStamina (addingStamina:int, uid:String, noLessStamina:Boolean = false, staminaConsumableId:String = ""):void;

        /**
         * Обработка текущего танц. движения в бою, установка счётчиков на следующее танц. движение.
         */
        function processNextDanceMove ():void;

        function get type ():String;

    }
}
