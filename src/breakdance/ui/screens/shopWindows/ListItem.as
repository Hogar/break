/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 06.07.13
 * Time: 11:42
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows {

    import breakdance.BreakdanceApp;
    import breakdance.CurrencyColors;
    import breakdance.core.sound.SoundManager;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.danceMoves.DanceMoveCategory;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemBonusType;
    import breakdance.data.shop.ShopItemConditionType;
    import breakdance.template.Template;
    import breakdance.ui.commons.tooltip.TooltipData;
    import breakdance.user.AppUser;
    import breakdance.user.events.ChangeUserEvent;

    import com.greensock.TweenLite;
    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.StringUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class ListItem extends GraphicStorage {

        private var textsManager:TextsManager = TextsManager.instance;

        private var mcActiveBg:Sprite;

        private var _enable:Boolean;
        private var _newItemsSelection:Boolean = false;
        private var _selected:Boolean;

        private var mcLock:MovieClip;
        private var mcUnLock:MovieClip;
        private var mcItemContainer:Sprite;
        protected var itemViewContainer:Sprite;

        protected static const ITEM_VIEW_INDENT:int = 40;
        private static const TWEEN_TIME:Number = .3;
        protected static const TOOLTIP_INDENT_X:int = 37;
        protected static const TOOLTIP_INDENT_Y:int = 73;
        private static const SCALE_NORMAL:Number = .71;
        private static const SCALE_ACTIVE:Number = .87;


        public function ListItem () {
            super (Template.createSymbol (Template.SHOP_LIST_ITEM));

            enable = true;
            selected = false;
            newItemsSelection = false;

            if (mcActiveBg) {
                mcActiveBg.alpha = 0;
            }

            buttonMode = true;
            useHandCursor = true;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function  initGraphicElements ():void {
            super.initGraphicElements ();
            mcActiveBg = getElement ("mcActiveBg");
            mcLock = getElement ("mcLock");
            mcUnLock = getElement ("mcUnLock");
            mcItemContainer = getElement ("mcItemContainer");
            itemViewContainer = new Sprite ();
            mcItemContainer.addChild (itemViewContainer);
            itemViewContainer.scaleX = itemViewContainer.scaleY = SCALE_NORMAL;
            itemViewContainer.x = ITEM_VIEW_INDENT;
            itemViewContainer.y = ITEM_VIEW_INDENT;

            addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            addEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);
            BreakdanceApp.instance.appUser.addEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function destroy ():void {
            removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);
            BreakdanceApp.instance.appUser.removeEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);
            super.destroy ();
        }

        public function get enable ():Boolean {
            return _enable;
        }

        public function set enable (value:Boolean):void {
            _enable = value;
            if (_enable) {
                mcItemContainer.alpha = 1;
            }
            else {
                mcItemContainer.alpha = .5;
            }
            mcLock.visible = !_enable;
        }

        /**
         * Мигание магазина при появлении новых предметов.
         */
        public function get newItemsSelection ():Boolean {
            return _newItemsSelection;
        }

        public function set newItemsSelection (value:Boolean):void {
            _newItemsSelection = value;
            mcUnLock.visible = value;
            mcUnLock.gotoAndPlay (1);
        }

        public function get selected ():Boolean {
            return _selected;
        }

        public function set selected (value:Boolean):void {
            _selected = value;
//            mcActiveBg.visible = value;
            var toAlpha:int = _selected ? 1 : 0;
            var delay:Number = _selected ? 0 : TWEEN_TIME / 2;
            if (mcActiveBg.alpha != toAlpha) {
                TweenLite.killTweensOf (mcActiveBg);
                TweenLite.to (mcActiveBg, TWEEN_TIME, {alpha: toAlpha, delay: delay});
            }
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        protected function getConditionText (shopItem:ShopItem):String {
            var conditionText:String = "";
            if (shopItem) {
                var appUser:AppUser = BreakdanceApp.instance.appUser;
                switch (shopItem.conditionType) {
                    case (ShopItemConditionType.LEVEL):
                        if (appUser.level < parseInt (shopItem.conditionValue)) {
                            var ttNeedLevel:String = textsManager.getText ("ttNeedLevel");
                            ttNeedLevel = ttNeedLevel.replace ("#1", shopItem.conditionValue);
                            conditionText += ttNeedLevel + "\n";
                        }
                        break;
                    case (ShopItemConditionType.STEP):
                        var conditionValueAsArray:Array = shopItem.conditionValue.split (":");
                        var stepId:String = conditionValueAsArray [0];
                        var stepLevel:int = parseInt (conditionValueAsArray [1]);
                        if (appUser.getDanceMoveLevel (stepId) < stepLevel) {
                            var ttNeedStep:String = textsManager.getText ("ttNeedStep");
                            var danceMoveType:DanceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (stepId);
                            var danceMoveName:String = "";
                            if (danceMoveType) {
                                danceMoveName = danceMoveType.name;
                            }
                            ttNeedStep = ttNeedStep.replace ("#1", danceMoveName);
                            ttNeedStep = ttNeedStep.replace ("#2", stepLevel);
                            conditionText += ttNeedStep + "\n";
                        }
                        break;
                    case (ShopItemConditionType.WINS):
                        if (appUser.wins < parseInt (shopItem.conditionValue)) {
                            var ttNeedWins:String = textsManager.getText ("ttNeedWins");
                            ttNeedWins = ttNeedWins.replace ("#1", shopItem.conditionValue);
                            conditionText += ttNeedWins + "\n";
                        }
                        break;
                }
            }
            return conditionText;
        }

        protected function getBonusText (shopItem:ShopItem):String {
            var bonus:int = shopItem.bonusValue;
            var bonusAsString:String = String (bonus);
            if (bonus > 0) {
                bonusAsString = "+" + bonusAsString;
            }
            bonusAsString = "<font color='" + CurrencyColors.MASTERY_COLOR + "'>" + bonusAsString + "</font>";
            var bonusText:String = "";

            if (shopItem) {
                if (shopItem && (shopItem.bonusType == ShopItemBonusType.ALL_DANCE_MOVES_BONUS)) {
                    var txtAllDanceMovesBonus:String = textsManager.getText ("ttAllDanceMovesBonus");
                    txtAllDanceMovesBonus = txtAllDanceMovesBonus.replace ("#1", bonusAsString);
                    bonusText = txtAllDanceMovesBonus;
                }
                if (shopItem && (shopItem.bonusType == ShopItemBonusType.DANCE_MOVE_BONUS)) {
                    var danceMoveId:String = shopItem.bonusSubType;
                    var txtDanceMoveBonus:String = textsManager.getText ("ttDanceMoveBonus");
                    txtDanceMoveBonus = txtDanceMoveBonus.replace ("#1", bonusAsString);
                    var danceMoveType:DanceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (danceMoveId);
                    if (danceMoveType) {
                        txtDanceMoveBonus = txtDanceMoveBonus.replace ("#2", danceMoveType.name);
                    }
                    bonusText = txtDanceMoveBonus;
                }
                else if (shopItem && (shopItem.bonusType == ShopItemBonusType.CATEGORY_BONUS)) {
                    var txtCategoryBonus:String = textsManager.getText ("ttCategoryBonus");
                    txtCategoryBonus = txtCategoryBonus.replace ("#1", bonusAsString);
                    var categoryId:String = shopItem.bonusSubType;
                    var danceMoveCategory:DanceMoveCategory = DanceMoveTypeCollection.instance.getCategory (categoryId);
                    if (danceMoveCategory) {
                        txtCategoryBonus = txtCategoryBonus.replace ("#2", danceMoveCategory.name);
                    }
                    bonusText = txtCategoryBonus;
                }
                else if (shopItem && (shopItem.bonusType == ShopItemBonusType.ENERGY_TIME)) {
                    var txtEnergyBonus:String = textsManager.getText ("ttEnergyBonus");
                    txtEnergyBonus = txtEnergyBonus.replace ("#1", Math.abs (bonus));
                    var suffix:String = "";
                    if (textsManager.currentLanguage == TextsManager.RU) {
                        suffix = StringUtilities.getRussianSuffix1 (bonus);
                    }
                    if (textsManager.currentLanguage == TextsManager.EN) {
                        suffix = StringUtilities.getEnglishSuffixForNumber (bonus);
                    }
                    txtEnergyBonus = txtEnergyBonus.replace ("#2", suffix);
                    bonusText = txtEnergyBonus;
                }
            }
            return bonusText;
        }

        protected function testEnabled ():void {
            enable = true;
        }

        protected function showTooltip (shopItem:ShopItem):void {
            if (shopItem) {
                if (parent) {
                    var positionPoint:Point = parent.localToGlobal (new Point (this.x + TOOLTIP_INDENT_X, this.y + TOOLTIP_INDENT_Y));
                    BreakdanceApp.instance.showTooltip (getTooltipData (shopItem), positionPoint);
                }
            }
        }

        protected function getTooltipData (shopItem:ShopItem):TooltipData {
            if (shopItem) {
                var tooltipText:String = null;
                var priceCoins:int = shopItem.coins;
                var priceBucks:int = shopItem.bucks;
                var priceText:String;
                var afterPriceText:String = null;
                var additionalText:String = null;
                var bonusText:String = getBonusText (shopItem);
                if (!StringUtilities.isNotValueString (bonusText)) {
                    additionalText = bonusText;
                }
                var conditionText:String = getConditionText (shopItem);
                if (!StringUtilities.isNotValueString (conditionText)) {
                    if (bonusText) {
                        additionalText += "\n";
                    }
                    else {
                        additionalText = "";
                    }
                    additionalText += '<p align="center">' + textsManager.getText ("ttLine") + "</p>";
                    additionalText += "\n" + conditionText;
                }
                if ((priceCoins > 0) || (priceBucks > 0)) {
//                        priceText = textsManager.getText ("ttPrice");
                    priceText = null;
                    afterPriceText = additionalText;
                }
                else {
                    tooltipText = additionalText;
                }
            }
            return new TooltipData (tooltipText, priceCoins, priceBucks, priceText, afterPriceText);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        protected function rollOverListener (event:MouseEvent):void {
//            SoundManager.instance.playSound (Template.SND_BUTTON_OVER);
            if (enable) {
                TweenLite.to (itemViewContainer, TWEEN_TIME, {scaleX: SCALE_ACTIVE, scaleY: SCALE_ACTIVE});
            }
        }

        private function mouseDownListener (event:MouseEvent):void {
            SoundManager.instance.playSound (Template.SND_BUTTON_DOWN);
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
            TweenLite.to (itemViewContainer, TWEEN_TIME, {scaleX: SCALE_NORMAL, scaleY: SCALE_NORMAL});
        }

        private function changeUserListener (event:ChangeUserEvent):void {
            testEnabled ();
        }

    }
}
