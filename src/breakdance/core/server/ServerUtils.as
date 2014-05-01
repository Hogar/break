/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 06.11.13
 * Time: 13:04
 * To change this template use File | Settings | File Templates.
 */
package breakdance.core.server {

    import breakdance.IInitialPlayerData;
    import breakdance.MiniGames;
    import breakdance.battle.data.PlayerItemData;
    import breakdance.data.shop.ShopItemCategory;

    public class ServerUtils {

        public static function initInitialPlayer (playerData:IInitialPlayerData, playerObject:Object):void {
            var j:int;
            if (playerObject) {
                if (playerObject.hasOwnProperty ("user")) {
                    var userData:Object = playerObject.user;
                    if (userData.hasOwnProperty ("nickname")) {
                        playerData.nickname = userData.nickname;
                    }
                    if (userData.hasOwnProperty ("id")) {
                        playerData.uid = userData.id;
                    }
                    if (userData.hasOwnProperty ("level")) {
                        playerData.level = userData.level;
                    }
                    if (userData.hasOwnProperty ("face_id")) {
                        playerData.faceId = userData.face_id;
                    }
                    if (userData.hasOwnProperty ("hair_id")) {
                        playerData.hairId = userData.hair_id;
                    }
                }
                if (playerObject.hasOwnProperty ("user_scores_list")) {
                    var userScoresList:Object = playerObject.user_scores_list;
                    for (j = 0; j < userScoresList.length; j++) {
                        var userScoreObject:Object = userScoresList[j];
                        if (userScoreObject.hasOwnProperty ("game_id")) {
                            if (userScoreObject.game_id == MiniGames.GUESS_MOVE_GAME) {
                                if (userScoreObject.hasOwnProperty ("scores")) {
                                    playerData.guessMoveGameRecord = userScoreObject.scores;
                                }
                            }
                        }
                    }
                }
                var userItems:Object = {};
                var itemsIdArray:Array = [];
                if (playerObject.hasOwnProperty ("user_item_list")) {
                    var userItemsList:Object = playerObject.user_item_list;
                    for (j = 0; j < userItemsList.length; j++) {
                        var userItemObject:Object = userItemsList [j];
                        if (userItemObject.hasOwnProperty ("id"))
                        userItems [userItemObject.id] = userItemObject;
                        itemsIdArray.push (userItemObject.id);
                    }
                }
                if (playerObject.hasOwnProperty ("user_slot_list")) {
                    var userSlotList:Object = playerObject.user_slot_list;
                    for (j = 0; j < userSlotList.length; j++) {
                        var userSlotObject:Object = userSlotList [j];
                        if (
                            userSlotObject.hasOwnProperty ("slot_id") &&
                            userSlotObject.hasOwnProperty ("user_item_id")
                        ) {
                            var slotId:String = userSlotObject.slot_id;
                            var userItemId:String = userSlotObject.user_item_id;
                            var userItem:Object = userItems [userItemId];
                            if (userData && (userData != "false")) {
                                var str:String = "-У игрока " + userData.id + ' на ' + slotId + ' одета "' + userItemId + '"';
                            }
                            if (userItem) {
                                if (userItem.hasOwnProperty ("item_id") && userItem.hasOwnProperty ("color")) {
                                    var playerItemData:PlayerItemData = new PlayerItemData (userItem.item_id, userItem.color);
                                    str += ", т.е. '" + userItem.item_id + "'";
                                    setFriendItemData (playerData, slotId, playerItemData);
                                }
                                else {
                                    str += ", но описания шмотки не то:";
//                                    Tracer.log (userItem);
                                }
                            }
                            else {
                                str += ", но шмотки нет. Все шмотки: [" + itemsIdArray + "]";
                            }
//                            Tracer.log (str);
                        }
                    }
                }

            }
        }

        private static function setFriendItemData (playerData:IInitialPlayerData, slotId:String, playerItemData:PlayerItemData):void {
            switch (slotId) {
                case ShopItemCategory.T_SHIRTS:
                case ShopItemCategory.BODY:
                    playerData.body = playerItemData;
                    break;
                case ShopItemCategory.HEAD:
                    playerData.head = playerItemData;
                    break;
                case ShopItemCategory.HANDS:
                    playerData.hands = playerItemData;
                    break;
                case ShopItemCategory.LEGS:
                    playerData.legs = playerItemData;
                    break;
                case ShopItemCategory.SHOES:
                    playerData.shoes = playerItemData;
                    break;
                case ShopItemCategory.MUSIC:
                    playerData.music = playerItemData;
                    break;
                case ShopItemCategory.COVER:
                    playerData.cover = playerItemData;
                    break;
                case ShopItemCategory.OTHER:
                    playerData.other = playerItemData;
                    break;
            }
        }
    }
}
