/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 01.10.13
 * Time: 13:30
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.model {

    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemBonusType;
    import breakdance.data.shop.ShopItemCollection;

    public class BattleUtils {

        public function BattleUtils () {

        }

        /**
         * Получение стека связок заданного игрока.
         * @param battle Битва.
         * @param uid Id игрока.
         * @return Стек связок игрока.
         */
        public static function getDanceRoutineStack (battle:IBattle, uid:String):DanceRoutinesStack {
            var danceRoutinesStack1:DanceRoutinesStack = battle.danceRoutinesStack1;
            var danceRoutinesStack2:DanceRoutinesStack = battle.danceRoutinesStack2;
            if (danceRoutinesStack1 && (danceRoutinesStack1.uid == uid)) {
                            return danceRoutinesStack1;
            }
            else if (danceRoutinesStack2 && (danceRoutinesStack2.uid == uid)) {
                return danceRoutinesStack2;
            }
            else {
                return null;
            }
        }

        /**
         * Получение стека связок для доп. тура заданного игрока.
         * @param battle Битва.
         * @param uid Id игрока.
         * @return Стек связок игрока.
         */
        public static function getAdditionalDanceRoutineStack (battle:IBattle, uid:String):AdditionalDanceRoutinesStack {
            var additionalDanceRoutinesStack1:AdditionalDanceRoutinesStack = battle.additionalDanceRoutinesStack1;
            var additionalDanceRoutinesStack2:AdditionalDanceRoutinesStack = battle.additionalDanceRoutinesStack2;
            if (additionalDanceRoutinesStack1 && (additionalDanceRoutinesStack1.uid == uid)) {
                return additionalDanceRoutinesStack1;
            }
            else if (additionalDanceRoutinesStack2 && (additionalDanceRoutinesStack2.uid == uid)) {
                return additionalDanceRoutinesStack2;
            }
            else {
                return null;
            }
        }

        /**
         * Получение кол-ва добавленных заданным игроком связок.
         * @param battle Битва.
         * @param uid Id игрока.
         * @return Кол-во добавленных игроком связок.
         */
        public static function getDanceRoutinesCount (battle:IBattle, uid:String):int {
            var danceRoutinesCount:int = 0;
            var battlePlayerStack:DanceRoutinesStack = getDanceRoutineStack (battle, uid);
            if (battlePlayerStack && battlePlayerStack.stack) {
                danceRoutinesCount = battlePlayerStack.stack.length;
            }
            return danceRoutinesCount;
        }

        public static function getPlayerWasUsingOriginalMove (battle:IBattle, uid:String):Boolean {
            var battlePlayerStack:DanceRoutinesStack = getDanceRoutineStack (battle, uid);
            if (battlePlayerStack) {
                var danceRoutineStack:Vector.<Vector.<BattleDanceMove>> = battlePlayerStack.stack;
                if (danceRoutineStack) {
                    for (var i:int = 0; i < danceRoutineStack.length; i++) {
                        var danceRoutine:Vector.<BattleDanceMove> = danceRoutineStack [i];
                        for (var j:int = 0; j < danceRoutine.length; j++) {
                            var battleDanceMove:BattleDanceMove = danceRoutine [j];
                            if (battleDanceMove.getDanceMoveType ().subType == DanceMoveSubType.ORIGINAL) {
                                return true;
                            }
                        }
                    }
                }
            }
            return false;
        }

        //Получение игрока по uid'у игрока.
        public static function getBattlePlayer (battle:IBattle, uid:String):BattlePlayer {
            if (battle.player1.uid == uid) {
                return battle.player1;
            }
            else if (battle.player2.uid == uid) {
                return battle.player2;
            }
            else {
                return null;
            }
        }

        //Получение опонента по uid'у игрока.
        public static function getBattlePlayerOpponent (battle:IBattle, uid:String):BattlePlayer {
            if (battle.player1.uid == uid) {
                return battle.player2;
            }
            else if (battle.player2.uid == uid) {
                return battle.player1;
            }
            else {
                return null;
            }
        }

        //Получение бонусов движения по надетой одежде игрока.
        public static function getItemsBonus (danceMoveType:DanceMoveType, player:IBattlePlayer):int {
            if (player) {
                var itemsBonus:Number = 0;
                var bodyAsShopItem:ShopItem;
                var handsAsShopItem:ShopItem;
                var headAsShopItem:ShopItem;
                var legsAsShopItem:ShopItem;
                var shoesAsShopItem:ShopItem;
                var musicAsShopItem:ShopItem;
                var coverAsShopItem:ShopItem;
                var otherAsShopItem:ShopItem;

                if (player.body) {
                    bodyAsShopItem = ShopItemCollection.instance.getShopItem (player.body.itemId);
                }
                if (player.hands) {
                    handsAsShopItem = ShopItemCollection.instance.getShopItem (player.hands.itemId);
                }
                if (player.head) {
                    headAsShopItem = ShopItemCollection.instance.getShopItem (player.head.itemId);
                }
                if (player.legs) {
                    legsAsShopItem = ShopItemCollection.instance.getShopItem (player.legs.itemId);
                }
                if (player.other) {
                    otherAsShopItem = ShopItemCollection.instance.getShopItem (player.other.itemId);
                }
                if (player.shoes) {
                    shoesAsShopItem = ShopItemCollection.instance.getShopItem (player.shoes.itemId);
                }
                if (player.music) {
                    musicAsShopItem = ShopItemCollection.instance.getShopItem (player.music.itemId);
                }
                if (player.cover) {
                    coverAsShopItem = ShopItemCollection.instance.getShopItem (player.cover.itemId);
                }
                itemsBonus += getShopItemBonusForDanceMove (bodyAsShopItem, danceMoveType);
                itemsBonus += getShopItemBonusForDanceMove (handsAsShopItem, danceMoveType);
                itemsBonus += getShopItemBonusForDanceMove (headAsShopItem, danceMoveType);
                itemsBonus += getShopItemBonusForDanceMove (legsAsShopItem, danceMoveType);
                itemsBonus += getShopItemBonusForDanceMove (otherAsShopItem, danceMoveType);
                itemsBonus += getShopItemBonusForDanceMove (shoesAsShopItem, danceMoveType);
                itemsBonus += getShopItemBonusForDanceMove (musicAsShopItem, danceMoveType);
                itemsBonus += getShopItemBonusForDanceMove (coverAsShopItem, danceMoveType);
            }

            return itemsBonus;
        }

        /**
         * Расчёт бонуса одежды для танц движения.
         * @return Бонус.
         */
        public static function getShopItemBonusForDanceMove (shopItem:ShopItem, danceMoveType:DanceMoveType):Number {
            var bonus:int = 0;
            if (shopItem) {
                if (shopItem.bonusType == ShopItemBonusType.ALL_DANCE_MOVES_BONUS) {
                    bonus += shopItem.bonusValue;
                }
                else if (shopItem.bonusType == ShopItemBonusType.DANCE_MOVE_BONUS) {
                    var danceMoveId:String = shopItem.bonusSubType;
                    if (danceMoveType.id == danceMoveId) {
                        bonus += shopItem.bonusValue;
                    }
                }
                else if (shopItem.bonusType == ShopItemBonusType.CATEGORY_BONUS) {
                    var category:String = shopItem.bonusSubType;
                    if (danceMoveType.category == category) {
                        bonus += shopItem.bonusValue;
                    }
                }
            }
            return bonus;
        }
    }
}
