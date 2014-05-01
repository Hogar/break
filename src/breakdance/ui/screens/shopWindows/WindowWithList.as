/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.08.13
 * Time: 10:36
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows {

    import breakdance.BreakdanceApp;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.ui.commons.buttons.Button;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.screens.ClosingScreen;
    import breakdance.user.CharacterMode;

    import com.hogargames.app.screens.IScreen;

    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;

    /**
     * Это окно с табами товаров, используется для отображения товаров в магазине и в гардеробе.
     */
    public class WindowWithList extends ClosingScreen implements IScreen, ITextContainer {

        protected var textsManager:TextsManager = TextsManager.instance;

        protected var btnTabTshirts:TabButton;
        protected var btnTabBody:TabButton;
        protected var btnTabHead:TabButton;
        protected var btnTabHands:TabButton;
        protected var btnTabLegs:TabButton;
        protected var btnTabShoes:TabButton;
        protected var btnTabMusic:TabButton;
        protected var btnTabCover:TabButton;
        protected var btnTabOther:TabButton;

        protected var currentTab:TabButton;

        protected var tabs:Vector.<TabButton>;

        protected var tfTitle:TextField;

        protected var btnApply:ButtonWithText;//Кнопка "купить" или кнопка "одеть"/"снять"
        protected var btnSell:ButtonWithText;

        protected var tutorialManager:TutorialManager;

        protected static const BUTTON_INDENT_X_FOR_TOOLTIP:int = 13;
        protected static const BUTTON_INDENT_Y_FOR_TOOLTIP:int = 25;

        public function WindowWithList () {
            tutorialManager = TutorialManager.instance;
            super (Template.createSymbol (Template.SHOP_WINDOW));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function setTexts ():void {

        }

        override public function onShow ():void {
            super.onShow ();
            BreakdanceApp.instance.appUser.character.mode = CharacterMode.FITTING;

            selectTab (btnTabTshirts);

            setTexts ();
        }

        override public function onHide ():void {
            super.onHide ();
            BreakdanceApp.instance.appUser.character.mode = CharacterMode.DRESSING;
        }

        override public function destroy ():void {
            destroyTab (btnTabTshirts);
            destroyTab (btnTabBody);
            destroyTab (btnTabHead);
            destroyTab (btnTabHands);
            destroyTab (btnTabLegs);
            destroyTab (btnTabShoes);
            destroyTab (btnTabMusic);
            destroyTab (btnTabCover);
            destroyTab (btnTabOther);

            btnTabTshirts = null;
            btnTabBody = null;
            btnTabHead = null;
            btnTabHands = null;
            btnTabLegs = null;
            btnTabShoes = null;
            btnTabMusic = null;
            btnTabCover = null;
            btnTabOther = null;

            if (btnApply) {
                btnApply.destroy ();
                btnApply = null;
            }
            if (btnSell) {
                btnSell.destroy ();
                btnSell = null;
            }

            textsManager.removeTextContainer (this);
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            btnTabTshirts = new TabButton (mc ["btnTabTshirts"]);
            btnTabBody = new TabButton (mc ["btnTabBody"]);
            btnTabHead = new TabButton (mc ["btnTabHead"]);
            btnTabHands = new TabButton (mc ["btnTabHands"]);
            btnTabLegs = new TabButton (mc ["btnTabLegs"]);
            btnTabShoes = new TabButton (mc ["btnTabShoes"]);
            btnTabMusic = new TabButton (mc ["btnTabMusic"]);
            btnTabCover = new TabButton (mc ["btnTabCover"]);
            btnTabOther = new TabButton (mc ["btnTabFeatures"]);

            tabs = new Vector.<TabButton> ();
            tabs.push (btnTabTshirts);
            tabs.push (btnTabBody);
            tabs.push (btnTabHead);
            tabs.push (btnTabHands);
            tabs.push (btnTabLegs);
            tabs.push (btnTabShoes);
            tabs.push (btnTabMusic);
            tabs.push (btnTabCover);
            tabs.push (btnTabOther);

            addListenersToTab (btnTabTshirts);
            addListenersToTab (btnTabBody);
            addListenersToTab (btnTabHead);
            addListenersToTab (btnTabHands);
            addListenersToTab (btnTabLegs);
            addListenersToTab (btnTabShoes);
            addListenersToTab (btnTabMusic);
            addListenersToTab (btnTabCover);
            addListenersToTab (btnTabOther);

            btnApply = new ButtonWithText (mc ["btnApply"]);
            btnApply.addEventListener (MouseEvent.CLICK, clickListener_apply);

            btnSell = new ButtonWithText (mc ["btnSell"]);

            tfTitle = getElement ("tfTitle");

            textsManager.addTextContainer (this);
        }

        protected function selectTab (tab:TabButton):void {
            if (tab) {
                if (tab.newItemsSelection) {
                    tab.newItemsSelection = false;
                }
            }
            currentTab = tab;
        }

        protected function getTabByCategory (category:String):TabButton {
            var tab:TabButton;
            switch (category) {
                case ShopItemCategory.T_SHIRTS:
                    tab = btnTabTshirts;
                    break;
                case ShopItemCategory.BODY:
                    tab = btnTabBody;
                    break;
                case ShopItemCategory.HEAD:
                    tab = btnTabHead;
                    break;
                case ShopItemCategory.HANDS:
                    tab = btnTabHands;
                    break;
                case ShopItemCategory.LEGS:
                    tab = btnTabLegs;
                    break;
                case ShopItemCategory.SHOES:
                    tab = btnTabShoes;
                    break;
                case ShopItemCategory.MUSIC:
                    tab = btnTabMusic;
                    break;
                case ShopItemCategory.COVER:
                    tab = btnTabCover;
                    break;
                case ShopItemCategory.OTHER:
                    tab = btnTabOther;
                    break;
            }
            return tab;
        }

        protected function getCategoryByTab (tab:TabButton):String {
            var category:String;
            switch (tab) {
                case btnTabTshirts:
                    category = ShopItemCategory.T_SHIRTS;
                    break;
                case btnTabBody:
                    category = ShopItemCategory.BODY;
                    break;
                case btnTabHead:
                    category = ShopItemCategory.HEAD;
                    break;
                case btnTabHands:
                    category = ShopItemCategory.HANDS;
                    break;
                case btnTabLegs:
                    category = ShopItemCategory.LEGS;
                    break;
                case btnTabShoes:
                    category = ShopItemCategory.SHOES;
                    break;
                case btnTabMusic:
                    category = ShopItemCategory.MUSIC;
                    break;
                case btnTabCover:
                    category = ShopItemCategory.COVER;
                    break;
                case btnTabOther:
                    category = ShopItemCategory.OTHER;
                    break;
            }
            return category;
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private static function testItemForCategory (itemId:String, category:String):Boolean {
            var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (itemId);
            if (shopItem) {
                return (shopItem.category == category);
            }
            else {
                return false;
            }
        }

        private function addListenersToTab (btn:Button):void {
            if (btn) {
                btn.addEventListener (MouseEvent.CLICK, clickListener_tab);
                btn.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btn.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            }
        }

        private function destroyTab (btn:Button):void {
            if (btn) {
                btn.removeEventListener (MouseEvent.CLICK, clickListener_tab);
                btn.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btn.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btn.destroy ();
            }
        }

        private function getTooltipPositionByButton (button:Button):Point {
            var positionPoint:Point = localToGlobal (
                new Point (
                        button.x + BUTTON_INDENT_X_FOR_TOOLTIP,
                        button.y + BUTTON_INDENT_Y_FOR_TOOLTIP
                )
            );
            return positionPoint;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        protected function clickListener_apply (event:MouseEvent):void {

        }

        private function rollOverListener (event:MouseEvent):void {
            var tooltipText:String;
            switch (event.currentTarget) {
                case btnTabTshirts:
                    tooltipText = textsManager.getText ("ttTabTshirts");
                    break;
                case btnTabBody:
                    tooltipText = textsManager.getText ("ttTabBody");
                    break;
                case btnTabHead:
                    tooltipText = textsManager.getText ("ttTabHead");
                    break;
                case btnTabHands:
                    tooltipText = textsManager.getText ("ttTabHands");
                    break;
                case btnTabLegs:
                    tooltipText = textsManager.getText ("ttTabLegs");
                    break;
                case btnTabShoes:
                    tooltipText = textsManager.getText ("ttTabShoes");
                    break;
                case btnTabMusic:
                    tooltipText = textsManager.getText ("ttTabMusic");
                    break;
                case btnTabCover:
                    tooltipText = textsManager.getText ("ttTabCover");
                    break;
                case btnTabOther:
                    tooltipText = textsManager.getText ("ttTabFeatures");
                    break;
            }
            if (tooltipText) {
                var positionPoint:Point = getTooltipPositionByButton (TabButton (event.currentTarget));
                BreakdanceApp.instance.showTooltipMessage (tooltipText, positionPoint);
            }
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }

        private function clickListener_tab (event:MouseEvent):void {
            var tab:TabButton = TabButton (event.currentTarget);
            selectTab (tab);
            if (tab) {
                var category:String = getCategoryByTab (tab);
                var itemId:String;
                if (tutorialManager.currentStep == TutorialStep.SHOP_SELECT_CATEGORY_2) {
                    itemId = TutorialManager.SHOP_ITEM_2;
                    if (testItemForCategory (itemId, category)) {
                        tutorialManager.completeStep (TutorialStep.SHOP_SELECT_CATEGORY_2);
                    }
                }
                if (tutorialManager.currentStep == TutorialStep.SHOP_SELECT_CATEGORY_3) {
                    itemId = TutorialManager.SHOP_ITEM_3;
                    if (testItemForCategory (itemId, category)) {
                        tutorialManager.completeStep (TutorialStep.SHOP_SELECT_CATEGORY_3);
                    }
                }
                if (tutorialManager.currentStep == TutorialStep.DRESS_ROOM_SELECT_CATEGORY_1) {
                    itemId = TutorialManager.DRESS_ROOM_ITEM_1;
                    if (testItemForCategory (itemId, category)) {
                        tutorialManager.completeStep (TutorialStep.DRESS_ROOM_SELECT_CATEGORY_1);
                    }
                }
                if (tutorialManager.currentStep == TutorialStep.DRESS_ROOM_SELECT_CATEGORY_2) {
                    itemId = TutorialManager.DRESS_ROOM_ITEM_2;
                    if (testItemForCategory (itemId, category)) {
                        tutorialManager.completeStep (TutorialStep.DRESS_ROOM_SELECT_CATEGORY_2);
                    }
                }
            }
        }

    }
}