/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 05.09.13
 * Time: 5:32
 * To change this template use File | Settings | File Templates.
 */
package breakdance.socketServer {

    /**
     * Тип действий, которые происходят во время PvP боя.
     */
    public class PvPBattleActionType {

        public static const INVITE_SEND:String = "invite send";
        public static const INVITE_ACCEPT:String = "invite accept";
        public static const DANCE_ROUTINE:String = "dance routine";//Обмен связками (наборами танц. движений) между игроками в процессе боя.
        public static const ADDITIONAL_DANCE_ROUTINE:String = "additional dance routine";//Обмен связками (наборами танц. движений) между игроками в процессе боя.
        public static const ADD_STAMINA:String = "add stamina";//Добавление выносливости игроку во время боя.
        public static const CANCEL_BATTLE:String = "cancel battle";//Отмена боя.
        public static const END_BATTLE:String = "end battle";//Завершение боя.

    }
}
