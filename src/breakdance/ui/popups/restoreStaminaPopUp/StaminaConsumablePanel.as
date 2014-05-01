/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.02.14
 * Time: 15:23
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.restoreStaminaPopUp {

    import breakdance.BreakdanceApp;
    import breakdance.Currency;
    import breakdance.battle.BattleManager;
    import breakdance.core.server.ServerApi;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.overlay.TransactionOverlay;
    import breakdance.data.consumables.Consumable;
    import breakdance.data.consumables.ConsumableBonus;
    import breakdance.data.consumables.ConsumableBonusType;
    import breakdance.ui.commons.buttons.ButtonWithCurrency;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.restoreStaminaPopUp.events.StaminaConsumableEvent;
    import breakdance.user.AppUser;
    import breakdance.user.UserPurchasedConsumable;
    import breakdance.user.events.ChangeUserEvent;

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class StaminaConsumablePanel extends GraphicStorage implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;
        private var appUser:AppUser;

        private var consumable:Consumable;

        private var mcStaminaConsumablePanel:Sprite;
        private var tfDescription:TextField;
        private var tfPurchased:TextField;
        private var mcIcon:MovieClip;
        private var btnBuy:ButtonWithCurrency;
        private var btnApply:ButtonWithText;

        public function StaminaConsumablePanel (mc:MovieClip) {
            appUser = BreakdanceApp.instance.appUser;
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function init (consumable:Consumable):void {
            this.consumable = consumable;
            setTexts ();
            testButton ();
        }

        public function  setTexts ():void {
            btnBuy.text = textsManager.getText ("buy");
            btnApply.text = textsManager.getText ("apply");

            tfDescription.text = "";
            tfPurchased.text = "";

            if (consumable) {
                var description:String = "";
                for (var i:int = 0; i < consumable.bonuses.length; i++) {
                    var bonus:ConsumableBonus = consumable.bonuses [i];
                    if (bonus) {
                        if (bonus.type == ConsumableBonusType.STAMINA) {
                            var restoreStaminaDescription:String = textsManager.getText ("addStamina");
                            restoreStaminaDescription = restoreStaminaDescription.replace ("#1", bonus.value);
                            description += restoreStaminaDescription + "\n";
                        }
                        else if (bonus.type == ConsumableBonusType.STABILITY) {
                            var addStabilityDescription:String = textsManager.getText ("stabilityBonus");
                            addStabilityDescription = addStabilityDescription.replace ("#1", bonus.value);
                            description += addStabilityDescription + "\n";
                        }
                        else if (bonus.type == ConsumableBonusType.NO_LOSS_STAMINA) {
                            var noLossStaminaDescription:String = textsManager.getText ("noLossStamina");
                            noLossStaminaDescription = noLossStaminaDescription.replace ("#1", consumable.time);
                            description += noLossStaminaDescription + "\n";
                        }
                    }
                }
                tfDescription.htmlText = description;
                var purchasedRestoreStaminaConsumableDescription:String = textsManager.getText ("purchasedConsumables");
                var count:int = 0;
                var purchasedConsumable:UserPurchasedConsumable = appUser.getUserPurchaseConsumable (consumable.id);
                if (purchasedConsumable) {
                    count = purchasedConsumable.count;
                }
                purchasedRestoreStaminaConsumableDescription = purchasedRestoreStaminaConsumableDescription.replace ("#1", count);
                tfPurchased.htmlText = purchasedRestoreStaminaConsumableDescription;
                if (consumable.coins > 0) {
                    btnBuy.setCurrency (consumable.coins, Currency.COINS);
                }
                if (consumable.bucks > 0) {
                    btnBuy.setCurrency (consumable.bucks, Currency.BUCKS);
                }
            }
        }

        override public function destroy ():void {
            if (btnBuy) {
                btnBuy.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnBuy.removeEventListener (MouseEvent.CLICK, clickListener);
                btnBuy.destroy ();
                btnBuy = null;
            }
            if (btnApply) {
                btnApply.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnApply.removeEventListener (MouseEvent.CLICK, clickListener);
                btnApply.destroy ();
                btnApply = null;
            }
            if (mcIcon) {
                mcIcon.removeEventListener (Event.ENTER_FRAME, enterFrameListener);
                mcIcon = null;
            }
            appUser.removeEventListener (ChangeUserEvent.CHANGE_USER, changeUserEvent);

            textsManager.removeTextContainer (this);

            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcIcon = getElement ("mcIcon");
            mcStaminaConsumablePanel = getElement ("mcStaminaConsumablePanel");
            tfDescription = getElement ("tfDescription", mcStaminaConsumablePanel);
            tfPurchased = getElement ("tfPurchased", mcStaminaConsumablePanel);
            btnBuy = new ButtonWithCurrency (getElement ("btnBuy", mcStaminaConsumablePanel));
            btnApply = new ButtonWithText (getElement ("btnApply", mcStaminaConsumablePanel));

            mcIcon.addEventListener (Event.ENTER_FRAME, enterFrameListener);

            btnBuy.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnApply.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnBuy.addEventListener (MouseEvent.CLICK, clickListener);
            btnApply.addEventListener (MouseEvent.CLICK, clickListener);

            appUser.addEventListener (ChangeUserEvent.CHANGE_USER, changeUserEvent);

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function testButton ():void {
        btnBuy.enable = false;
        btnApply.enable = false;
        if (consumable) {
            btnBuy.enable = ((appUser.coins >= consumable.coins) && (appUser.bucks >= consumable.bucks));
        }
        if (consumable) {
            var userPurchasedConsumable:UserPurchasedConsumable = appUser.getUserPurchaseConsumable (consumable.id);
            btnApply.enable = (userPurchasedConsumable && userPurchasedConsumable.count > 0);
        }
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function rollOverListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case (btnBuy):
                    mcIcon.gotoAndPlay ("buy");
                    break;
                case (btnApply):
                    mcIcon.gotoAndPlay ("apply");
                    break;
            }
        }

        private function clickListener (event:MouseEvent):void {
            mcIcon.gotoAndPlay (1);
            switch (event.currentTarget) {
                case (btnBuy):
                    mcIcon.gotoAndPlay ("buy");
                    if (consumable) {
                        TransactionOverlay.instance.show ();
                        ServerApi.instance.query (ServerApi.BUY_CONSUMABLES, {consumables_id:consumable.id, count:1}, onBuyConsumables);
//                        BreakdanceApp.mixpanel.track(
//                            'consumables',
//                            {'buy':consumable.id}
//                        );
                    }
                    break;
                case (btnApply):
                    if (consumable) {
                        TransactionOverlay.instance.show ();
                        ServerApi.instance.query (ServerApi.APPLY_CONSUMABLES, {consumables_id:consumable.id}, onApplyConsumables);
//                        BreakdanceApp.mixpanel.track(
//                            'consumables',
//                            {'use':consumable.id}
//                        );
                    }
                    break;
            }
        }

        private function enterFrameListener (event:Event):void {
            if (mcIcon.currentFrame == mcIcon.totalFrames) {
                mcIcon.stop ();
            }
        }

        private function changeUserEvent (event:ChangeUserEvent):void {
            testButton ();
            setTexts ();
        }

        private function onBuyConsumables (response:Object):void {
            TransactionOverlay.instance.hide ();
            if (consumable) {
                appUser.onBuyConsumable (response);
            }
            testButton ();
            setTexts ();
            dispatchEvent (new StaminaConsumableEvent (StaminaConsumableEvent.BUY_STAMINA_CONSUMABLE));
        }

        private function onApplyConsumables (response:Object):void {
            TransactionOverlay.instance.hide ();

            if (consumable) {
                appUser.onApplyConsumable (response);
                var addingStamina:int = 0;
                var noLessStamina:Boolean = false;
                for (var i:int = 0; i < consumable.bonuses.length; i++) {
                    var consumableBonus:ConsumableBonus = consumable.bonuses [i];
                    if (consumableBonus.type == ConsumableBonusType.STAMINA) {
                        addingStamina = consumableBonus.value;
                    }
                    if (consumableBonus.type == ConsumableBonusType.NO_LOSS_STAMINA) {
                        noLessStamina = true;
                    }
                }
                BattleManager.instance.addStaminaToCurrentBattle (addingStamina, noLessStamina, consumable.id);
            }
            testButton ();
            setTexts ();
            dispatchEvent (new StaminaConsumableEvent (StaminaConsumableEvent.USE_STAMINA_CONSUMABLE));
        }

    }
}
