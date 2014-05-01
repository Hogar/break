/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.08.13
 * Time: 12:31
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.bucksOffersPopUp {

    import breakdance.BreakdanceApp;
    import breakdance.core.js.JsApi;
    import breakdance.core.js.JsQueryResult;
    import breakdance.core.staticData.StaticData;
    import breakdance.data.bucksOffers.BucksOffer;
    import breakdance.data.bucksOffers.BucksOffersCollection;
    import breakdance.template.Template;
    import breakdance.ui.popups.basePopUps.TitleClosingPopUp;

    import flash.events.MouseEvent;

    public class BucksOffersPopUp extends TitleClosingPopUp {

        private var bucksOfferButtons:Vector.<BucksOfferButton> = new Vector.<BucksOfferButton> ();

        private var selectedOffer:BucksOffer;

        private static const NUM_DEALS:int = 6;

        public function BucksOffersPopUp () {
            super (Template.createSymbol (Template.BUCKS_OFFERS_POPUP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function setTexts ():void {
            tfTitle.text = textsManager.getText ("bank");
        }

        override public function destroy ():void {
            for (var i:int = 0; i < bucksOfferButtons.length; i++) {
                var bucksOfferButton:BucksOfferButton = bucksOfferButtons [i];
                bucksOfferButton.destroy ();
            }
            bucksOfferButtons = null;
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            var bucksOffers:Vector.<BucksOffer> = BucksOffersCollection.instance.list;
            var bucksDealPlayerChoice:int = parseInt (StaticData.instance.getSetting ("bucks_deal_player_choice"));

            bucksOfferButtons = new Vector.<BucksOfferButton> ();
            for (var i:int = 0; i < NUM_DEALS; i++) {
                var bucksOfferButton:BucksOfferButton = new BucksOfferButton (mc ["btnDeal" + (i + 1)]);
                if (bucksOffers.length > i) {
                    bucksOfferButton.bucksOffer = bucksOffers [i];
                    if (i == bucksDealPlayerChoice) {
                        bucksOfferButton.playerChoice = true;
                    }
                }
                else {
                    bucksOfferButton.visible = false;
                }
                bucksOfferButtons.push (bucksOfferButton);
                bucksOfferButton.addEventListener (MouseEvent.CLICK, clickListener);
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var button:BucksOfferButton = BucksOfferButton (event.currentTarget);
            selectedOffer = button.bucksOffer;
            if (selectedOffer) {
                JsApi.instance.query (JsApi.PLACE_ORDER, onPlaceOrder, [selectedOffer.id]);
            }
            trace ("select deal: " + button.bucksOffer.cost + " voices TO " + button.bucksOffer.bucks + " + " + button.bucksOffer.bonus);
        }

        private function onPlaceOrder (response:JsQueryResult):void {
            BreakdanceApp.instance.appUser.onSocialPlaceOrder (response, selectedOffer);
        }

    }
}
