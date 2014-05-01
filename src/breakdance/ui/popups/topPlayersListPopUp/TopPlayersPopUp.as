/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.10.13
 * Time: 19:28
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.topPlayersListPopUp {

    import breakdance.BreakdanceApp;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.server.ServerApi;
    import breakdance.core.server.ServerUtils;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.ui.events.ScreenEvent;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.basePopUps.TitleClosingPopUp;
    import breakdance.user.AppUser;
    import breakdance.user.FriendData;

    import flash.events.MouseEvent;

    public class TopPlayersPopUp extends TitleClosingPopUp {

        private var topPlayerList:TopPlayersList;

        private var btnTab1:ButtonWithText;
        private var btnTab2:ButtonWithText;

        private var tabs:Vector.<ButtonWithText>;
        private var selectedTab:ButtonWithText;

        private var btnDay:ButtonWithText;
        private var btnWeek:ButtonWithText;
        private var btnAllTime:ButtonWithText;

        private var timeTabs:Vector.<ButtonWithText>;
        private var selectedTimeTab:ButtonWithText;

        private var btnFriends:ButtonWithText;

        private var maxTopListItems:int;

        private var players:Vector.<TopPlayerData>;
        private var playersAsObject:Object;

        private static const POINTS_TYPE_MINI_GAME:String = "minigame points";

        public function TopPlayersPopUp () {
            super (Template.createSymbol (Template.TOP_PLAYERS_POP_UP));
            maxTopListItems = parseInt (StaticData.instance.getSetting ("max_top_list_items"));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function init (players:Vector.<TopPlayerData>):void {
            topPlayerList.init (players);
        }

        override public function show ():void {
            super.show ();

//            CONFIG::debug {
//                initFakeList ();
//            }

            selectTab (tabs [0]);
            selectTimeTab (timeTabs [0]);
            btnFriends.selected = false;
            reinit ();
        }

        CONFIG::debug {
            //FOR TEST+++
            private function initFakeList ():void {
                //Формируем список игроков:
                var players:Vector.<TopPlayerData> = new Vector.<TopPlayerData> ();
                for (var i:int = 0; i < 3 + Math.random () * 40; i++) {
                    var playerData:TopPlayerData = TopPlayerData.createFakeBattlePlayer ();
                    players.push (playerData);
                }
                init (players);
            }
            //FOR TEST---
        }


        override public function setTexts ():void {
            tfTitle.text = textsManager.getText ("topPlayers");
            btnTab1.text = textsManager.getText ("minigame");
            btnTab2.text = textsManager.getText ("wins");
            btnDay.text = textsManager.getText ("day");
            btnWeek.text = textsManager.getText ("week");
            btnAllTime.text = textsManager.getText ("allTime");
            btnFriends.text = textsManager.getText ("myFriends");
        }

        override public function destroy ():void {
            if (btnTab1) {
                btnTab1.removeEventListener (MouseEvent.CLICK, clickListener_tabs);
                btnTab1.destroy ();
                btnTab1 = null;
            }
            if (btnTab2) {
                btnTab2.removeEventListener (MouseEvent.CLICK, clickListener_tabs);
                btnTab2.destroy ();
                btnTab2 = null;
            }
            if (btnDay) {
                btnDay.removeEventListener (MouseEvent.CLICK, clickListener_timeTabs);
                btnDay.destroy ();
                btnDay = null;
            }
            if (btnWeek) {
                btnWeek.removeEventListener (MouseEvent.CLICK, clickListener_timeTabs);
                btnWeek.destroy ();
                btnWeek = null;
            }
            if (btnAllTime) {
                btnAllTime.removeEventListener (MouseEvent.CLICK, clickListener_timeTabs);
                btnAllTime.destroy ();
                btnAllTime = null;
            }
            if (btnFriends) {
                btnFriends.removeEventListener (MouseEvent.CLICK, clickListener);
                btnFriends.destroy ();
                btnFriends = null;
            }
            btnTab1 = null;
            btnTab2 = null;
            btnDay = null;
            btnWeek = null;
            btnAllTime = null;
            btnFriends = null;
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            topPlayerList = new TopPlayersList (mc ["mcTopPlayerList"]);

            btnTab1 = new ButtonWithText (mc ["btnTab1"]);
            btnTab2 = new ButtonWithText (mc ["btnTab2"]);

            btnDay = new ButtonWithText (mc ["btnDay"]);
            btnWeek = new ButtonWithText (mc ["btnWeek"]);
            btnAllTime = new ButtonWithText (mc ["btnAllTime"]);

            btnFriends = new ButtonWithText (mc ["btnFriends"], false);

            tabs = new Vector.<ButtonWithText> ();
            tabs.push (btnTab1);
            tabs.push (btnTab2);

            timeTabs = new Vector.<ButtonWithText> ();
            timeTabs.push (btnDay);
            timeTabs.push (btnWeek);
            timeTabs.push (btnAllTime);

            btnTab1.addEventListener (MouseEvent.CLICK, clickListener_tabs);
            btnTab2.addEventListener (MouseEvent.CLICK, clickListener_tabs);

            btnDay.addEventListener (MouseEvent.CLICK, clickListener_timeTabs);
            btnWeek.addEventListener (MouseEvent.CLICK, clickListener_timeTabs);
            btnAllTime.addEventListener (MouseEvent.CLICK, clickListener_timeTabs);

            btnFriends.addEventListener (MouseEvent.CLICK, clickListener);

            btnTab2.enable = false;
        }

        override protected function onClickCloseButton ():void {
            dispatchEvent (new ScreenEvent (ScreenEvent.HIDE_SCREEN));
            super.onClickCloseButton ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function selectTab (tab:ButtonWithText):void {
            for (var i:int = 0; i < tabs.length; i++) {
                var currentTab:ButtonWithText = tabs [i];
                if (currentTab == tab) {
                    currentTab.selected = true;
                    selectedTab = currentTab;
                }
                else {
                    currentTab.selected = false;
                }
            }
        }

        private function selectTimeTab (timeTab:ButtonWithText):void {
            for (var i:int = 0; i < timeTabs.length; i++) {
                var currentTimeTab:ButtonWithText = timeTabs [i];
                if (currentTimeTab == timeTab) {
                    currentTimeTab.selected = true;
                    selectedTimeTab = currentTimeTab;
                }
                else {
                    currentTimeTab.selected = false;
                }
            }
        }

        private function initFriends (pointsType:String):void {
            var players:Vector.<TopPlayerData> = new Vector.<TopPlayerData> ();
            var userFriends:Vector.<FriendData> = BreakdanceApp.instance.appUser.userAppFriends;
            var numPlayers:int = Math.min (maxTopListItems, userFriends.length);
            var playerData:TopPlayerData = new TopPlayerData ();
            var appUser:AppUser = BreakdanceApp.instance.appUser;

            playerData.uid = appUser.uid;
            playerData.name = appUser.name;
            playerData.nickname = appUser.nickname;
            playerData.hairId = appUser.character.hairId;
            playerData.faceId = appUser.character.faceId;
            playerData.head = appUser.character.head;
            playerData.hands = appUser.character.hands;
            playerData.body = appUser.character.body;
            playerData.legs = appUser.character.legs;
            playerData.shoes = appUser.character.shoes;
            playerData.other = appUser.character.other;
            if (pointsType == POINTS_TYPE_MINI_GAME) {
                playerData.points = appUser.guessMoveGameRecord;
            }

            players.push (playerData);

            for (var i:int = 0; i < numPlayers; i++) {
                playerData = new TopPlayerData ();
                var friendData:FriendData = userFriends [i];
                playerData.uid = friendData.uid;
                playerData.name = friendData.name;
                playerData.nickname = friendData.nickname;
                playerData.hairId = friendData.hairId;
                playerData.faceId = friendData.faceId;
                playerData.head = friendData.head;
                playerData.hands = friendData.hands;
                playerData.body = friendData.body;
                playerData.legs = friendData.legs;
                playerData.shoes = friendData.shoes;
                playerData.music = friendData.music;
                playerData.cover = friendData.cover;
                playerData.other = friendData.other;
                if (pointsType == POINTS_TYPE_MINI_GAME) {
                    playerData.points = friendData.guessMoveGameRecord;
                }
                players.push (playerData);
            }
            players.sort (sortByPoints);
            init (players);
        }

        private function sortByPoints (topPlayerData1:TopPlayerData, topPlayerData2:TopPlayerData):int {
            if (topPlayerData1.points < topPlayerData2.points) {
                return 1;
            }
            else if (topPlayerData1.points > topPlayerData2.points) {
                return -1;
            }
            else {
                return 0;
            }
        }

        private function reinit ():void {
            topPlayerList.clear ();
            if (selectedTab == btnTab1) {
                if (btnFriends.selected) {
                    initFriends (POINTS_TYPE_MINI_GAME);
                }
                else {
                    var amount:int = maxTopListItems;
                    var days:int = 1;
                    switch (selectedTimeTab) {
                        case (btnDay):
                            days = 1;
                            break;
                        case (btnWeek):
                            days = 7;
                            break;
                        case (btnAllTime):
                            days = 999;
                            break;
                    }
                    TransactionOverlay.instance.show ();
                    ServerApi.instance.query (ServerApi.GET_TOP_USERS, {amount:amount, days:days}, onResponse);
                }
            }
            else {
                topPlayerList.clear ();
            }
        }


/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            btnFriends.selected = !btnFriends.selected;
            reinit ();
        }

        private function clickListener_tabs (event:MouseEvent):void {
            var tab:ButtonWithText = ButtonWithText (event.currentTarget);
            selectTab (tab);
            reinit ();
        }

        private function clickListener_timeTabs (event:MouseEvent):void {
            var timeTab:ButtonWithText = ButtonWithText (event.currentTarget);
            selectTimeTab (timeTab);
            reinit ();
        }

        private function onResponse (response:Object):void {
            players = new Vector.<TopPlayerData> ();
            playersAsObject = [];
//            Tracer.log ("Ответ:");
//            Tracer.traceObject (response);
            var data:Array = response.data;
            var numPlayers:int = Math.min (maxTopListItems, data.length);
            var uids:String = "";
            for (var i:int = 0; i < numPlayers; i++) {
                var playerObject:Object = data [i];
                var topPlayerData:TopPlayerData = new TopPlayerData ();
                ServerUtils.initInitialPlayer (topPlayerData, playerObject);
                topPlayerData.points = topPlayerData.guessMoveGameRecord;
                playersAsObject [topPlayerData.uid] = topPlayerData;
                players.push (topPlayerData);
                uids += topPlayerData.uid;
                if (i < numPlayers - 1) {
                    uids += ",";
                }
            }
            init (players);
            TransactionOverlay.instance.hide ();
            JsApi.instance.query (JsApi.GET_USER, onGetUser, [uids]);
        }

        private function onGetUser (response:JsQueryResult):void {
            if (!response || !response.success) {
                return;
            }

            var users:Array = response.data.response;
            for (var i:int = 0; i < users.length; i++) {
                var userData:Object = users [i];
                var uid:String = userData.uid;
                var topPlayerData:TopPlayerData = playersAsObject [uid];
                if (topPlayerData) {
                    topPlayerData.name = userData.first_name + " " + userData.last_name;
                }
            }
            init (players);
        }

    }
}
