/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.12.13
 * Time: 23:22
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.editCharacterPopUp {

    import breakdance.BreakdanceApp;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.ui.popups.basePopUps.BasePopUp;
    import breakdance.user.AppUser;

    import com.hogargames.utils.TextFieldUtilities;

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class CharacterPopUp extends BasePopUp implements ITextContainer {

        protected var textsManager:TextsManager = TextsManager.instance;

        protected var appUser:AppUser;

        protected var emotions:Vector.<FaceItem> = new Vector.<FaceItem>();
        protected var hairstyles:Vector.<FaceItem> = new Vector.<FaceItem>();

        protected var tfTitle:TextField;
        protected var tfNameTaken:TextField;
        protected var tfName:TextField;

        private var tfNameTitle:TextField;
        private var tfBboy:TextField;
        private var tfFace:TextField;
        private var tfHairstyle:TextField;

        protected var minPlayerNameLength:int;
        private var maxPlayerNameLength:int;

        private static const NUM_EMOTIONS:int = 6;
        private static const NUM_HAIRSTYLE:int = 6;

        public function CharacterPopUp (mc:MovieClip) {
            appUser = BreakdanceApp.instance.appUser;
            maxPlayerNameLength = parseInt (StaticData.instance.getSetting ("max_player_name_length"));
            minPlayerNameLength = parseInt (StaticData.instance.getSetting ("min_player_name_length"));
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
            super.show ();
            tfNameTaken.text = "";
        }

        public function setTexts ():void {
            tfNameTitle.text = textsManager.getText ("name");
            tfBboy.text = textsManager.getText ("b-boy");
//            tfNameTaken.text = textsManager.getText ("nameTaken");
            tfFace.text = textsManager.getText ("face");
            tfHairstyle.text = textsManager.getText ("hairstyle");
        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            tfTitle = getElement ('tfTitle');
            tfNameTitle = getElement ('tfNameTitle');
            tfBboy = getElement ('tfBboy');
            tfName = getElement ('tfName');
            tfNameTaken = getElement ('tfNameTaken');
            tfFace = getElement ('tfFace');
            tfHairstyle = getElement ('tfHairstyle');

            TextFieldUtilities.setBold (tfNameTitle);
            TextFieldUtilities.setBold (tfFace);
            TextFieldUtilities.setBold (tfHairstyle);


            tfName.maxChars = maxPlayerNameLength;
            tfName.addEventListener (Event.CHANGE, changeListener);
            tfName.addEventListener (FocusEvent.FOCUS_IN, focusInEvent);

            emotions = new Vector.<FaceItem> ();
            hairstyles = new Vector.<FaceItem> ();

            var i:int = 0;
            var faceItem:FaceItem;

            for (i = 0; i < NUM_EMOTIONS; i++) {
                faceItem = new FaceItem (getElement ("mcEmotion" + (i + 1)));
                faceItem.addEventListener (MouseEvent.CLICK, clickListener_emotions);
                faceItem.emotionId = (i + 1);
                emotions.push (faceItem);
            }
            for (i = 0; i < NUM_HAIRSTYLE; i++) {
                faceItem = new FaceItem (getElement ("mcHairstyle" + (i + 1)));
                faceItem.addEventListener (MouseEvent.CLICK, clickListener_hairstyles);
                faceItem.hairstyleId = (i + 1);
                hairstyles.push (faceItem);
            }

            if (emotions.length > 0) {
                selectEmotion (emotions [0]);
            }
            if (hairstyles.length > 0) {
                selectHairstyle (hairstyles [0]);
            }
        }

        override protected function initGraphic (mc:MovieClip):void {
            super.initGraphic (mc);
            textsManager.addTextContainer (this);
        }

        protected function testName ():Boolean {
            var defaultNickname:String = textsManager.getText ("defaultName");

            return (
                (tfName.text.length >= minPlayerNameLength) &&
                (tfName.text != appUser.nickname) &&
                (tfName.text != defaultNickname)
            );
        }

        protected function selectEmotion (faceItem:FaceItem):void {
            var emotionId:int = -1;
            var i:int;
            for (i = 0; i < emotions.length; i++) {
                var currentEmotionFaceItem:FaceItem = emotions [i];
                currentEmotionFaceItem.selected = (faceItem == currentEmotionFaceItem);
                if (faceItem == currentEmotionFaceItem) {
                    emotionId = currentEmotionFaceItem.emotionId;
                }
            }
            if (emotionId != -1) {
                for (i = 0; i < hairstyles.length; i++) {
                    var currentHairstyleFaceItem:FaceItem = hairstyles [i];
                    currentHairstyleFaceItem.emotionId = emotionId;
                }
            }
        }

        protected function selectHairstyle (faceItem:FaceItem):void {
            var hairstyleId:int = -1;
            var i:int;
            for (i = 0; i < hairstyles.length; i++) {
                var currentHairStyleFaceItem:FaceItem = hairstyles [i];
                currentHairStyleFaceItem.selected = (faceItem == currentHairStyleFaceItem);
                if (faceItem == currentHairStyleFaceItem) {
                    hairstyleId = currentHairStyleFaceItem.hairstyleId;
                }
            }
            if (hairstyleId != -1) {
                for (i = 0; i < emotions.length; i++) {
                    var currentEmotionFaceItem:FaceItem = emotions [i];
                    currentEmotionFaceItem.hairstyleId = hairstyleId;
                }
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener_emotions (event:MouseEvent):void {
            var faceItem:FaceItem = FaceItem (event.currentTarget);
            selectEmotion (faceItem);
        }

        private function clickListener_hairstyles (event:MouseEvent):void {
            var faceItem:FaceItem = FaceItem (event.currentTarget);
            selectHairstyle (faceItem);
        }

        protected function changeListener (event:Event):void {
            var defaultNickname:String = textsManager.getText ("defaultName");
            if (tfName.text != defaultNickname) {
                if (tfName.text && tfName.text.length < minPlayerNameLength) {
                    tfNameTaken.text = textsManager.getText ("nameShort");
                }
                else {
                    tfNameTaken.text = "";
                }
            }
        }

        protected function focusInEvent (event:FocusEvent):void {
            var defaultNickname:String = textsManager.getText ("defaultName");
            if (tfName.text == defaultNickname) {
                tfName.text = "";
            }
        }

    }
}