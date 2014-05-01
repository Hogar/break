/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.02.14
 * Time: 15:19
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.restoreStaminaPopUp {

    import breakdance.battle.BattleManager;
    import breakdance.data.consumables.ConsumableCollection;
    import breakdance.data.consumables.RestoreStaminaConsumable;
    import breakdance.template.Template;
    import breakdance.ui.popups.basePopUps.TitleClosingPopUp;
    import breakdance.ui.popups.restoreStaminaPopUp.events.StaminaConsumableEvent;

    public class RestoreStaminaPopUp extends TitleClosingPopUp {

        private var staminaConsumablePanel1:StaminaConsumablePanel;
        private var staminaConsumablePanel2:StaminaConsumablePanel;

        public function RestoreStaminaPopUp () {
            super (Template.createSymbol(Template.RESTORE_STAMINA_POP_UP));
        }

        override public function setTexts ():void {
            super.setTexts ();
            tfTitle.text = textsManager.getText ("restoreStamina");
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            staminaConsumablePanel1 = new StaminaConsumablePanel (getElement ("mcStaminaConsumablePanel1"));
            staminaConsumablePanel2 = new StaminaConsumablePanel (getElement ("mcStaminaConsumablePanel2"));

            staminaConsumablePanel1.init (ConsumableCollection.instance.getConsumable (RestoreStaminaConsumable.WATER_BOTTLE));
            staminaConsumablePanel2.init (ConsumableCollection.instance.getConsumable (RestoreStaminaConsumable.DRINK_BANK));

            staminaConsumablePanel1.addEventListener (StaminaConsumableEvent.USE_STAMINA_CONSUMABLE, useStaminaConsumableListener);
        }

        private function useStaminaConsumableListener (event:StaminaConsumableEvent):void {
            if (BattleManager.instance.hasBattle) {
                hide ();
            }
        }
    }
}
