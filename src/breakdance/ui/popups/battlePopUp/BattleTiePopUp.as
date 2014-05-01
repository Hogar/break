/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.09.13
 * Time: 13:48
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.battlePopUp {

    import breakdance.BreakdanceApp;
    import breakdance.battle.model.IBattle;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.data.collections.CollectionType;
    import breakdance.data.collections.CollectionTypeCollection;
    import breakdance.template.Template;
    import breakdance.ui.commons.CollectionPanel;
    import breakdance.ui.popups.basePopUps.TwoTextButtonsPopUp;
    import breakdance.ui.screenManager.ScreenManager;
    import breakdance.user.AppUser;
    import breakdance.user.UserCollectionData;
    import breakdance.user.events.GetCollectionItemEvent;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class BattleTiePopUp extends TwoTextButtonsPopUp implements IBattlePopUp {

        private var mcResult:MovieClip;
        private var collectionPanel:CollectionPanel;
        private var _battle:IBattle;

        private var appUser:AppUser;

        public function BattleTiePopUp () {
            appUser = BreakdanceApp.instance.appUser;
            super (Template.createSymbol (Template.BATTLE_TIE_POPUP));
            useShowAnimation = false;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            super.setTexts ();
            tf.htmlText = textsManager.getText ("tie");
            tfTitle.htmlText = textsManager.getText ("tieTitle");
            btn1.text = textsManager.getText ("share");
            btn2.text = textsManager.getText ("complete");
        }


        override public function show ():void {
            super.show ();
            mcResult.gotoAndPlay (1);
        }

        override public function hide ():void {
            super.hide ();
        }

        public function set battle (value:IBattle):void {
            _battle = value;
        }

        override public function destroy ():void {
            if (collectionPanel) {
                collectionPanel.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                collectionPanel.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                collectionPanel.destroy ();
                collectionPanel = null;
            }
            appUser.removeEventListener (GetCollectionItemEvent.GET_COLLECTION_ITEM, getCollectionItemListener);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            collectionPanel = new CollectionPanel (mc ["mcCollectionPanel"]);
            mcResult = getElement ("mcResult");

            appUser.addEventListener (GetCollectionItemEvent.GET_COLLECTION_ITEM, getCollectionItemListener);

            collectionPanel.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            collectionPanel.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
        }

        override protected function onClickFirstButton ():void {
            var txtTieBattle:String = textsManager.getText ("tieBattle");
            if (_battle && _battle.player1 && _battle.player2) {
                txtTieBattle = txtTieBattle.replace ("#1", _battle.player1.nickname.toUpperCase ());
                txtTieBattle = txtTieBattle.replace ("#2", _battle.player2.nickname.toUpperCase ());
                JsApi.instance.query (JsApi.WRITE_WALL, onWriteWall, [txtTieBattle]);
            }
            ScreenManager.instance.navigateBeforeBattle ();
            hide ();
        }

        private function onWriteWall (response:JsQueryResult):void {
            //
        }

        private function getCollectionItemListener (event:GetCollectionItemEvent):void {
            var collectionType:CollectionType = CollectionTypeCollection.instance.getCollectionType (event.collectionTypeId);
            if (collectionType) {
                collectionPanel.collectionType = collectionType;
                collectionPanel.setValue (event.amount);
            }
            else {
                collectionPanel.collectionType = null;
                collectionPanel.setValue (0);
            }
        }

        private function rollOverListener (event:MouseEvent):void {
            var userCollections:Vector.<UserCollectionData> = appUser.userCollections;
            if (userCollections) {
                var positionPoint:Point = mc.localToGlobal (new Point (collectionPanel.x + collectionPanel.width / 2, collectionPanel.y + collectionPanel.height));
                var message:String = "";
                for (var i:int = 0; i < userCollections.length; i++) {
                    var userCollectionData:UserCollectionData = userCollections [i];
                    var collectionType:CollectionType = CollectionTypeCollection.instance.getCollectionType (userCollectionData.id);
                    if (collectionType) {
                        message += collectionType.name + " - " + userCollectionData.count;
                        if (i != userCollections.length - 1) {
                            message += "\n";
                        }
                    }
                }
                BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
            }
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }

        override protected function onClickSecondButton ():void {
            ScreenManager.instance.navigateBeforeBattle ();
            hide ();
        }

    }
}
