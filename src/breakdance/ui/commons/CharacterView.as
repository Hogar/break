/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 14.07.13
 * Time: 2:20
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalConstants;
    import breakdance.battle.data.PlayerItemData;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.events.BreakDanceAppEvent;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.user.AppUser;
    import breakdance.user.FriendData;
    import breakdance.user.events.ChangeUserEvent;

    import com.greensock.TweenLite;
    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.MovieClipUtilities;

    import flash.display.FrameLabel;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    public class CharacterView extends GraphicStorage {

        private var mcCharacterContainer:MovieClip;
        private var mcCharacterContainer2:MovieClip;
        private var mcCharacterPartsContainer:MovieClip;
        private var mcCharacterParts:MovieClip;
        private var mcMan:MovieClip;
        private var mcEmotions:MovieClip;
        private var mcHairstyles:MovieClip;
        private var mcBody:MovieClip;
        private var mcHead:MovieClip;
        private var mcHands:MovieClip;
        private var mcLegs:MovieClip;
        private var mcShoes:MovieClip;
        private var mcMusicContainer:MovieClip;
        private var mcMusic:MovieClip;
        private var mcCoverContainer:MovieClip;
        private var mcCover:MovieClip;
        private var mcOther:MovieClip;
        private var mcScreenShotInfo:MovieClip;
        private var tfName:TextField;
        private var tfLevel:TextField;
        private var tshirt:TshirtView;

        private var startMovingY:Number;
        private var startMovingScale:Number;

        private var doReposition:Boolean = false;

        private var numShowAnimationFrame:int;

        private var tutorialManager:TutorialManager = TutorialManager.instance;
        private var textsManager:TextsManager = TextsManager.instance;
        private var appUser:AppUser;

        private static const FRAME_DEFAULT:String = "default";
        private static const T_SHIRT_X:int = 57;
        private static const T_SHIRT_Y:int = 67;
        private static const INDENT:int = 100;
        private static const MARGIN_X:int = 100;
        private static const CHARACTER_WIDTH:int = 120;
        private static const MAX_DELTA:int = 200;
        private static const MAX_SCALE:Number = 2.5;
        private static const TWEEN_TIME:Number = .2;
        private static const SHOW_FRAME:String = "show";
        private static const HIDE_FRAME:String = "hide";

        public function CharacterView () {
            appUser = BreakdanceApp.instance.appUser;
            super (Template.createSymbol (Template.CHARACTER));
            if (stage){
                addedToStageListener (null);
            }
            else {
                addEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
            }

            graphics.beginFill (0x00ff00, 0);
            graphics.drawRect (0, 0, GlobalConstants.APP_WIDTH, GlobalConstants.APP_HEIGHT);
            graphics.endFill ();
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function showScreenShootMode ():void {
            var currentFriendData:FriendData = appUser.currentFriendData;
            if (currentFriendData) {
                tfName.text = currentFriendData.name;
                tfLevel.text = textsManager.getText ("level_2") + " " + currentFriendData.level;
            }
            else {
                tfName.text = appUser.name;
                tfLevel.text = textsManager.getText ("level_2") + " " + appUser.level;
            }
            mcScreenShotInfo.visible = true;
        }

        public function hideScreenShootMode ():void {
            mcScreenShotInfo.visible = false;
        }

        override public function destroy ():void {
            if (tshirt) {
                tshirt.destroy ();
            }
            appUser.removeEventListener (ChangeUserEvent.CHANGE_USER_FRIEND, changeUserFriendListener);
            appUser.character.removeEventListener(Event.CHANGE, changeListener);
            if (mcCharacterContainer) {
                mcCharacterContainer.removeEventListener (Event.ENTER_FRAME, enterFrameListener);
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            mcCharacterContainer = getElement ("mcCharacterContainer");
            mcCharacterContainer2 = getElement ("mcCharacterContainer", mcCharacterContainer);
            mcCharacterPartsContainer = getElement ("mcCharacterPartsContainer", mcCharacterContainer2);
            mcCharacterParts = getElement ("mcCharacterParts", mcCharacterPartsContainer);
            mcMan = getElement ("mcMan", mcCharacterParts);
            var mcManHead:Sprite = getElement ("mcHead", mcMan);
            mcEmotions = getElement ("mcEmotions", mcManHead);
            mcHairstyles = getElement ("mcHairstyles", mcManHead);
            mcBody = getElement ("mcBody", mcCharacterParts);
            mcHead = getElement ("mcHead", mcCharacterParts);
            mcHands = getElement ("mcHands", mcCharacterParts);
            mcLegs = getElement ("mcLegs", mcCharacterParts);
            mcShoes = getElement ("mcShoes", mcCharacterParts);
            mcMusicContainer = getElement ("mcMusicContainer");
            mcMusic = getElement ("mcMusic", mcMusicContainer);
            mcCoverContainer = getElement ("mcCoverContainer");
            mcCover = getElement ("mcCover", mcCoverContainer);
            mcOther = getElement ("mcOther", mcCharacterParts);
            mcScreenShotInfo = getElement ("mcScreenShotInfo");
            tfName = getElement ("tfName", mcScreenShotInfo);
            tfLevel = getElement ("tfLevel", mcScreenShotInfo);

            mcMan.stop ();
            mcBody.stop ();
            mcHead.stop ();
            mcHands.stop ();
            mcLegs.stop ();
            mcShoes.stop ();
            mcMusic.stop ();
            mcCover.stop ();
            mcOther.stop ();

            tshirt = new TshirtView ();
            tshirt.x = T_SHIRT_X;
            tshirt.y = T_SHIRT_Y;
            mcCharacterParts.addChildAt (tshirt, mcCharacterParts.getChildIndex (mcBody));
            mcCharacterParts.buttonMode = true;
            mcCharacterParts.useHandCursor = true;

            mcCharacterParts.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);
            mcCharacterParts.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            mcCharacterParts.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);

            appUser.addEventListener (ChangeUserEvent.CHANGE_USER_FRIEND, changeUserFriendListener);
            appUser.character.addEventListener (Event.CHANGE, changeListener);

            var labels:Array = mcCharacterContainer2.currentLabels;
            for (var i:int = 0; i < labels.length; i++) {
                var label:FrameLabel = labels [i];
                if (label.name == SHOW_FRAME) {
                    numShowAnimationFrame = label.frame;
                }
            }

            mcCharacterContainer2.addEventListener (Event.ENTER_FRAME, enterFrameListener);

            changeListener (null);

            hideScreenShootMode ();
            showCharacter ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setState (userPurchaseItem:PlayerItemData, container:MovieClip):void {
            if (!userPurchaseItem) {
                container.gotoAndStop (FRAME_DEFAULT);
            }
            else {
                if (!MovieClipUtilities.gotoAndStop (container, userPurchaseItem.itemId)) {
                    container.gotoAndStop (FRAME_DEFAULT);
                }
            }
        }

        private function startReposition ():void {
            doReposition = true;
            if (tutorialManager.currentStep == TutorialStep.MOVE_CHARACTER) {
                tutorialManager.completeStep (TutorialStep.MOVE_CHARACTER);
            }
            var bounds:Rectangle = new Rectangle (INDENT + MARGIN_X, mcCharacterContainer.y, GlobalConstants.APP_WIDTH - INDENT * 2 - MARGIN_X - CHARACTER_WIDTH, 0);
            mcCharacterContainer.startDrag (false, bounds);
            stage.addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveListener);
        }

        private function stopReposition ():void {
            if (doReposition) {
                BreakdanceApp.instance.appDispatcher.dispatchEvent (new BreakDanceAppEvent (BreakDanceAppEvent.END_CHARACTER_MOVING));
            }
            doReposition = false;
            mcCharacterContainer.stopDrag ();
            stage.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveListener);
        }

        private function showCharacter ():void {
            mcCharacterContainer2.gotoAndPlay (SHOW_FRAME);
            mcMusicContainer.gotoAndPlay (SHOW_FRAME);
            mcCoverContainer.gotoAndPlay (SHOW_FRAME);
        }

        private function hideCharacter ():void {
            mcCharacterContainer2.gotoAndPlay (HIDE_FRAME);
            mcMusicContainer.gotoAndPlay (HIDE_FRAME);
            mcCoverContainer.gotoAndPlay (HIDE_FRAME);
        }

        private function setCharacterView ():void {
            var currentFriendData:FriendData = appUser.currentFriendData;
            var headItem:PlayerItemData;
            var bodyItem:PlayerItemData;
            var handsItem:PlayerItemData;
            var otherItem:PlayerItemData;
            var legsItem:PlayerItemData;
            var shoesItem:PlayerItemData;
            var musicItem:PlayerItemData;
            var coverItem:PlayerItemData;
            var faceId:int;
            var hairId:int;
            if (currentFriendData) {
                headItem = currentFriendData.head;
                bodyItem = currentFriendData.body;
                handsItem = currentFriendData.hands;
                otherItem = currentFriendData.other;
                legsItem = currentFriendData.legs;
                shoesItem = currentFriendData.shoes;
                musicItem = currentFriendData.music;
                coverItem = currentFriendData.cover;
                faceId = currentFriendData.faceId;
                hairId = currentFriendData.hairId;
            }
            else {
                headItem = appUser.character.head;
                bodyItem = appUser.character.body;
                handsItem = appUser.character.hands;
                otherItem = appUser.character.other;
                legsItem = appUser.character.legs;
                shoesItem = appUser.character.shoes;
                musicItem = appUser.character.music;
                coverItem = appUser.character.cover;
                faceId = appUser.character.faceId;
                hairId = appUser.character.hairId;
            }
            if (bodyItem) {
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (bodyItem.itemId);
                if (shopItem) {
                    if (shopItem.category == ShopItemCategory.T_SHIRTS) {
                        mcBody.visible = false;
                        tshirt.visible = true;
                        tshirt.id = bodyItem.itemId;
                        tshirt.color = bodyItem.color;
                    }
                    if (shopItem.category == ShopItemCategory.BODY) {
                        mcBody.visible = true;
                        tshirt.visible = false;
                        setState (bodyItem, mcBody);
                    }
                }
                else {
                    mcBody.visible = true;
                    tshirt.visible = false;
                    setState (null, mcBody);
                }
            }
            else {
                mcBody.visible = true;
                tshirt.visible = false;
                setState (null, mcBody);
            }

            setState (headItem, mcHead);
            setState (handsItem, mcHands);
            setState (otherItem, mcOther);
            setState (legsItem, mcLegs);
            setState (shoesItem, mcShoes);
            setState (musicItem, mcMusic);
            setState (coverItem, mcCover);
            mcEmotions.gotoAndStop (faceId);
            mcHairstyles.gotoAndStop (hairId);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function addedToStageListener (event:Event):void {
            removeEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
            stage.addEventListener (Event.DEACTIVATE, deactivateListener);
            stage.addEventListener (MouseEvent.MOUSE_UP, mouseUpListener);
        }

        private function deactivateListener (event:Event):void {
            stopReposition ();
        }

        private function mouseDownListener (event:MouseEvent):void {
            startMovingY = event.stageY;
            startMovingScale = mcCharacterContainer2.scaleX;
            startReposition ();
        }

        private function rollOverListener (event:MouseEvent):void {
            var message:String = textsManager.getText ("ttMoveCharacter");
            BreakdanceApp.instance.showTooltipMessage (message);
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }

        private function mouseUpListener (event:MouseEvent):void {
            stopReposition ();
        }

        private function mouseMoveListener (event:MouseEvent):void {
            var percent:Number = 0;
            var minMovingY:Number = startMovingY - MAX_DELTA * ((startMovingScale - 1) / (MAX_SCALE - 1));
            var delta:Number = event.stageY - minMovingY;
            if (delta > 0) {
                percent = Math.min (1, delta / MAX_DELTA);
                var toScale:Number = Math.min (MAX_SCALE, Math.max (1, 1 + (MAX_SCALE - 1) * percent));
                TweenLite.to (mcCharacterContainer2, TWEEN_TIME, {scaleX:toScale, scaleY:toScale});
            }
        }

        private function changeUserFriendListener (event:ChangeUserEvent):void {
//            setCharacterView ();
            hideCharacter ();
        }

        private function changeListener (event:Event):void {
            setCharacterView ();
        }

        private function enterFrameListener (event:Event):void {
            if (event.currentTarget.currentFrame == numShowAnimationFrame - 1) {
                setCharacterView ();
                showCharacter ();
            }
        }
    }
}
