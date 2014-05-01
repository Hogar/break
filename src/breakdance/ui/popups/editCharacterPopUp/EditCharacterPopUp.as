/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.12.13
 * Time: 3:29
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.editCharacterPopUp {

    import breakdance.core.server.ServerApi;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.Button;
    import breakdance.ui.commons.buttons.ButtonWithText;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class EditCharacterPopUp extends CharacterPopUp {

        private var btnClose:Button;
        private var btnChange:ButtonWithText;

        private var mcCost:Sprite;
        private var tfCost:TextField;

        private var changeNamePrice:int;

        public function EditCharacterPopUp () {

            changeNamePrice = parseInt (StaticData.instance.getSetting ("change_character_price"));

            super (Template.createSymbol (Template.EDIT_CHARACTER_POPUP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            btnChange.text = textsManager.getText ("edit");
            tfTitle.htmlText = textsManager.getText ("editCharacter");

            mcCost.visible = (changeNamePrice > 0);
            var txtFor:String = textsManager.getText ("for");
            txtFor = txtFor.replace ("#1", changeNamePrice);
            tfCost.text = txtFor;

            super.setTexts ();
        }

        override public function show ():void {
            super.show ();
            tfName.text = appUser.nickname;
            var faceId:int = appUser.character.faceId;
            var hairId:int = appUser.character.hairId;
            if (faceId == 0) {
                faceId = 1;
            }
            if (hairId == 0) {
                hairId = 1;
            }
            selectEmotion (emotions [faceId - 1]);
            selectHairstyle (hairstyles [hairId - 1]);
            changeListener (null);
        }

        override public function destroy ():void {
            if (btnClose) {
                btnClose.destroy ();
                btnClose = null;
            }
            if (btnChange) {
                btnChange.destroy ();
                btnChange = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            mcCost = getElement ("mcCost");
            tfCost = getElement ("tf", mcCost);

            btnClose = new Button (getElement ('btnClose'));
            btnClose.addEventListener (MouseEvent.CLICK, clickListener);
            btnChange = new ButtonWithText (getElement ('btnChange'));
            btnChange.addEventListener (MouseEvent.CLICK, clickListener);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case (btnClose):
                    hide ();
                    break;
                case (btnChange):
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
                    ServerApi.instance.query (ServerApi.UPDATE_USER_APPEARANCE, { hair_id: hairstyleId, face_id: emotionId, nickname:nickname}, onUpdateUserAppearance, null, null, false);
                    break;
            }
        }

        private function onUpdateUserAppearance (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (response.response_code != 1) {
                tfNameTaken.text = textsManager.getText ("nameTaken");
                TransactionOverlay.instance.hide ();
                return;
            }
            else {
                response.data.nickname = tfName.text;
                appUser.onResponseWithUpdateUserData (response);
                hide ();
            }
        }

        override protected function changeListener (event:Event):void {
            super.changeListener (event);
            btnChange.enable = testName () && (changeNamePrice <= appUser.bucks);
        }

    }
}