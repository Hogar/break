/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 03.03.14
 * Time: 23:58
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups {

    import breakdance.BreakdanceApp;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.basePopUps.TitleClosingPopUp;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.text.TextField;

    public class BeatStreetShopPopUp extends TitleClosingPopUp {

        private var tfDescription:TextField;
        private var tfInstruction:TextField;
        private var tfStep1:TextField;
        private var tfStep2:TextField;
        private var tfCode:TextField;
        private var tfStep3:TextField;
        private var tfBucks:TextField;
        private var mcBucks:MovieClip;
        private var mcBorder:MovieClip;

        private var btnCheckout:ButtonWithText;
        private var btnGetBucks:ButtonWithText;

        private var beatstreetshopUrl:String;
        private var beatstreetshopBonus:int;

        public function BeatStreetShopPopUp () {
            beatstreetshopUrl = StaticData.instance.getSetting ("beatstreetshop_url");
            beatstreetshopBonus = parseInt (StaticData.instance.getSetting ("beatstreetshop_bonus"));

            super (Template.createSymbol (Template.BEAT_STREET_SHOP_POP_UP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
//            CONFIG::mixpanel {
//                BreakdanceApp.mixpanel.track(
//                        'offer',
//                        {'BeatStreetShop':"open"}
//                );
//            }
            super.show ();
        }

        override public function setTexts ():void {
            var title:String = textsManager.getText ("beatStreetTitle");
            title = title.replace ("#1", beatstreetshopBonus);
            tfTitle.text = title;
            tfDescription.htmlText = textsManager.getText ("beatStreetText");
            tfInstruction.htmlText = textsManager.getText ("instruction");
            var step1text:String = textsManager.getText ("beatStreetStep1");
            step1text = step1text.replace ("#1", BreakdanceApp.instance.appUser.uid);
            tfStep1.htmlText = step1text;
            tfStep2.htmlText = textsManager.getText ("beatStreetStep2");
            tfStep3.htmlText = textsManager.getText ("beatStreetStep3");
            tfBucks.htmlText = "<b>" + String (beatstreetshopBonus) + "</b>";
            tfStep3.width = Math.floor (tfStep3.textWidth + 4);
            tfBucks.width = Math.floor (tfBucks.textWidth + 6);
            tfBucks.x = tfStep3.x + tfStep3.width;
            mcBucks.x = tfBucks.x + tfBucks.width;

            btnCheckout.text = textsManager.getText ("сheckout");
            btnGetBucks.text = textsManager.getText ("getBucks");
        }

        override public function destroy ():void {
            if (btnCheckout) {
                btnCheckout.removeEventListener (MouseEvent.CLICK, clickListener);
                btnCheckout.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnCheckout.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btnCheckout.destroy ();
                btnCheckout = null;
            }
            if (btnGetBucks) {
                btnGetBucks.removeEventListener (MouseEvent.CLICK, clickListener);
                btnGetBucks.destroy ();
                btnGetBucks = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            tfDescription = getElement ("tfDescription");
            tfInstruction = getElement ("tfInstruction");
            tfStep1 = getElement ("tfStep1");
            tfStep2 = getElement ("tfStep2");
            tfCode = getElement ("tfCode");
            tfStep3 = getElement ("tfStep3");
            tfBucks = getElement ("tfBucks");
            mcBucks = getElement ("mcBucks");
            mcBorder = getElement ("mcBorder");

            tfDescription.mouseEnabled = false;
            tfStep1.mouseEnabled = false;
            tfStep2.mouseEnabled = false;
            tfStep3.mouseEnabled = false;
            tfBucks.mouseEnabled = false;

            tfCode.maxChars = 10;
            tfCode.text = "";

            btnCheckout = new ButtonWithText (getElement ("btnCheckout"));
            btnGetBucks = new ButtonWithText (getElement ("btnGetBucks"));

            btnCheckout.addEventListener (MouseEvent.CLICK, clickListener);
            btnCheckout.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnCheckout.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            btnGetBucks.addEventListener (MouseEvent.CLICK, clickListener);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case btnCheckout:
                    CONFIG::mixpanel {
//                        BreakdanceApp.mixpanel.track(
//                            'offer',
//                            {'BeatStreetShop':"link"}
//                        );
                    }
                    navigateToURL (new URLRequest (beatstreetshopUrl), "_blank");
                    break;
                case btnGetBucks:
                    mcBorder.gotoAndPlay (1);
                    break;
            }
        }

        protected function rollOverListener (event:MouseEvent):void {
            var message:String;
            switch (event.currentTarget) {
                case btnCheckout:
                    message = TextsManager.instance.getText ("ttBreakBeatShop");
                    break;
            }
            if (message) {
                var positionPoint:Point = localToGlobal (new Point (event.currentTarget.x + event.currentTarget.width / 2, event.currentTarget.y + event.currentTarget.height));
                BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
            }
        }

    }
}
