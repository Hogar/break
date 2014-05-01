/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 28.09.13
 * Time: 12:50
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.data {

    import breakdance.CurrencyColors;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.danceMoves.DanceMoveType;

    public class BattleDataUtils {

        /**
         * Получение вектора движений с указанным подтипом.
         * @param danceMoves Вектор движений.
         * @param subType Подтип.
         * @return Вектор движений с указанным подтипом.
         */
        public static function getDanceMovesOfSubType (danceMoves:Vector.<BattleDanceMoveData>, subType:String):Vector.<BattleDanceMoveData> {
            var newDanceMoves:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
            for (var i:int = 0; i < danceMoves.length; i++) {
                var danceMoveData:BattleDanceMoveData = danceMoves [i];
                var danceMoveType:DanceMoveType = danceMoveData.getDanceMoveType ();
                if (danceMoveType.subType == subType) {
                    newDanceMoves.push (danceMoveData);
                }
            }
            return newDanceMoves;
        }

        /**
         * Получение вектора движений с учётом доступной выносливости.
         * @param danceMoves Вектор движений.
         * @param availableStamina Доступная выносливость.
         * @return Вектор движений, которые можно исполнить с оставшейся выносливостью.
         */
        public static function getDanceMovesByAvailableStamina (danceMoves:Vector.<BattleDanceMoveData>, availableStamina:int):Vector.<BattleDanceMoveData> {
            var newDanceMoves:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
            for (var i:int = 0; i < danceMoves.length; i++) {
                var danceMoveData:BattleDanceMoveData = danceMoves [i];
                var danceMoveType:DanceMoveType = danceMoveData.getDanceMoveType ();
                if (danceMoveType.stamina <= availableStamina) {
                    newDanceMoves.push (danceMoveData);
                }
            }
            return newDanceMoves;
        }

        /**
         * Получение вектора движений для продолжения указанного предыдущего движения в связке.
         * @param danceMoves Вектор движений.
         * @param previousBattleDanceMove Предыдщее движение в связке.
         * @return Вектор движений для продолжения предыдущего движения в связке.
         */
        public static function getDanceMovesForPrevMove (danceMoves:Vector.<BattleDanceMoveData>, previousBattleDanceMove:BattleDanceMoveData):Vector.<BattleDanceMoveData> {
            var newDanceMoves:Vector.<BattleDanceMoveData> = new Vector.<BattleDanceMoveData> ();
            if (previousBattleDanceMove) {
                var danceMoveType:DanceMoveType = previousBattleDanceMove.getDanceMoveType ();
                var availableTransitionMoves:Vector.<String> = danceMoveType.getAvailableTransitionMoves (previousBattleDanceMove.level);
                for (var i:int = 0; i < danceMoves.length; i++) {
                    var danceMoveData:BattleDanceMoveData = danceMoves [i];
                    if (availableTransitionMoves.indexOf (danceMoveData.type) != -1) {
                        newDanceMoves.push (danceMoveData);
                    }
                }
            }
            return newDanceMoves;
        }

        /**
         * Получение строки с описанием движения.
         * @param danceMoveName
         * @param level
         * @param stamina
         * @param points
         * @param positiveBonusPoints Сумма положительных бонусов
         * @param negativeBonusPoints Сумма отрицательных бонусов
         * @return
         */
        public static function getDanceMoveDescription (level:int, stamina:int, points:int, stability:int, positiveBonusPoints:int = 0, negativeBonusPoints:int = 0):String {
            var message:String = "";
            var textsManager:TextsManager = TextsManager.instance;
            var tfStamina:String = textsManager.getText ("ttStamina");
            var txtLevel:String = textsManager.getText ("level");
            var positiveBonusAsString:String = "";
            var negativeBonusAsString:String = "";
            if (positiveBonusPoints != 0) {
                positiveBonusAsString = "+" + positiveBonusPoints;
            }
            if (negativeBonusPoints != 0) {
                negativeBonusAsString = "−" + negativeBonusPoints;
            }
            message += "<b>";
            message += "<font color='" + CurrencyColors.MASTERY_COLOR + "'>" + points + "</font>";
            message += " " + "<font color='" + CurrencyColors.NEGATIVE_BONUS_COLOR + "'>" + negativeBonusAsString + "</font>";
            message += " " + "<font color='" + CurrencyColors.POSITIVE_BONUS_COLOR + "'>" + positiveBonusAsString + "</font>";
            message += "</b>";
            message += "<font color='#ffffff'>";
            message += "\n";
            message += "<b>" + stability + "% </b>(<b>" + level + "</b> " + txtLevel + ")";
            message += "\n";
            message += tfStamina + " ";
            message += "</font>";
            message += " " + "<font color='" + CurrencyColors.STAMINA_COLOR + "'><b>" + stamina + "</b></font>";
            return message;
        }
    }
}
