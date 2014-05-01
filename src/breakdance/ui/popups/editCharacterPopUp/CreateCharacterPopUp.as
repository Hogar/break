package breakdance.ui.popups.editCharacterPopUp {

    import breakdance.core.server.ServerApi;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.tutorial.TutorialOverlay;
    import breakdance.user.UserPurchasedItem;

    import com.hogargames.Orientation;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    public class CreateCharacterPopUp extends CharacterPopUp {

        private var tutorialOverlay:TutorialOverlay = TutorialOverlay.instance;

        private var btnCreate:ButtonWithText;

        public function CreateCharacterPopUp () {
            super (Template.createSymbol (Template.CREATE_CHAR_POPUP));
            tutorialOverlay = TutorialOverlay.instance;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            btnCreate.text = textsManager.getText ("create");
            tfTitle.htmlText = textsManager.getText ("createCharacter");
            super.setTexts ();
        }

        override public function show ():void {
            super.show ();
            tfName.text = textsManager.getText ("defaultName");
            var area:Rectangle = new Rectangle (120, 78, 570, 313);
            var showingAreas:Vector.<Rectangle> = new <Rectangle> [area];
            tutorialOverlay.show ();
            tutorialOverlay.showHidingBackground (showingAreas);
            tutorialOverlay.positionArrow (545, 120, Orientation.LEFT);
            tutorialOverlay.showArrow ();
            tutorialOverlay.hideNextButton ();
            tutorialOverlay.setText (null);
            changeListener (null);
        }

        override public function destroy ():void {
            if (btnCreate) {
                btnCreate.destroy ();
                btnCreate = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            btnCreate = new ButtonWithText (getElement ('btnCreate'));
            btnCreate.addEventListener (MouseEvent.CLICK, clickListener);
        }

        override protected function testName ():Boolean {
            var defaultNickname:String = textsManager.getText ("defaultName");

            return (
                (tfName.text.length >= minPlayerNameLength) &&
                (tfName.text != defaultNickname)
            );
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function onUserGetResponse (response:Object):void {
            if (response.response_code != 1) {
                return;
            }

            appUser.init (response, true);

            //Одеваем персонажа в дефолтную одежду:
            var startBody:String = StaticData.instance.getSetting ("start_body");
            var startHead:String = StaticData.instance.getSetting ("start_head");
            var startHands:String = StaticData.instance.getSetting ("start_hands");
            var startLegs:String = StaticData.instance.getSetting ("start_legs");
            var startShoes:String = StaticData.instance.getSetting ("start_shoes");
            var startMusic:String = StaticData.instance.getSetting ("start_music");
            var startCover:String = StaticData.instance.getSetting ("start_cover");

            var startBodyAsUserPurchasedItem:UserPurchasedItem = appUser.getUserPurchaseItemByItemIdAndColor (startBody);
            var startHeadAsUserPurchasedItem:UserPurchasedItem = appUser.getUserPurchaseItemByItemIdAndColor (startHead);
            var startHandsAsUserPurchasedItem:UserPurchasedItem = appUser.getUserPurchaseItemByItemIdAndColor (startHands);
            var startLegsAsUserPurchasedItem:UserPurchasedItem = appUser.getUserPurchaseItemByItemIdAndColor (startLegs);
            var startShoesAsUserPurchasedItem:UserPurchasedItem = appUser.getUserPurchaseItemByItemIdAndColor (startShoes);
            var startMusicAsUserPurchasedItem:UserPurchasedItem = appUser.getUserPurchaseItemByItemIdAndColor (startMusic);
            var startCoverAsUserPurchasedItem:UserPurchasedItem = appUser.getUserPurchaseItemByItemIdAndColor (startCover);

            appUser.character.dressingBody (startBodyAsUserPurchasedItem);
            appUser.character.dressingHead (startHeadAsUserPurchasedItem);
            appUser.character.dressingHands (startHandsAsUserPurchasedItem);
            appUser.character.dressingLegs (startLegsAsUserPurchasedItem);
            appUser.character.dressingShoes (startShoesAsUserPurchasedItem);

            appUser.character.dressingMusic (startMusicAsUserPurchasedItem);//Применение переносится в тутор?
            appUser.character.dressingCover (startCoverAsUserPurchasedItem);//Применение переносится в тутор?

            TransactionOverlay.instance.hide ();

//            destroy ();
            hide ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            btnCreate.enable = false;

            var hairstyleId:int = 1;
            var emotionId:int = 1;
            var i:int;
            for (i = 0; i < hairstyles.length; i++) {
                var currentHairstyleFaceItem:FaceItem = hairstyles [i];
                if (currentHairstyleFaceItem.selected) {
                    hairstyleId = currentHairstyleFaceItem.hairstyleId;
                }
            }
            for (i = 0; i < emotions.length; i++) {
                var currentEmotionFaceItem:FaceItem = emotions [i];
                if (currentEmotionFaceItem.selected) {
                    emotionId = currentEmotionFaceItem.emotionId;
                }
            }
            TransactionOverlay.instance.show ();
            var nickname:String = tfName.text;
            tfNameTaken.text = "";
            ServerApi.instance.query (ServerApi.USER_ADD, { hair_id: hairstyleId, face_id: emotionId, nickname:nickname}, onCreateResponse, null, null, false);
        }

        private function onCreateResponse (response:Object):void {
            if (response.response_code != 1) {
                tfNameTaken.text = textsManager.getText ("nameTaken");
                TransactionOverlay.instance.hide ();
                return;
            }

            appUser.installed = true;

            ServerApi.instance.query (ServerApi.USER_GET, {}, onUserGetResponse);
        }

        override protected function changeListener (event:Event):void {
            super.changeListener (event);
            btnCreate.enable = testName ();
            if (btnCreate.enable) {
                var area:Rectangle = new Rectangle (120, 78, 570, 413);
                var showingAreas:Vector.<Rectangle> = new <Rectangle> [area];
                tutorialOverlay.show ();
                tutorialOverlay.showHidingBackground (showingAreas);
                tutorialOverlay.hideArrow ();
                tutorialOverlay.hideNextButton ();
            }
            trace ("btnCreate.enable = " + btnCreate.enable);
        }

    }
}