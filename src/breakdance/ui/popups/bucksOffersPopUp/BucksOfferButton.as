/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.08.13
 * Time: 13:15
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.bucksOffersPopUp {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.bucksOffers.BucksOffer;
    import breakdance.ui.commons.buttons.ButtonWithText;

    import com.hogargames.utils.StringUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;

    public class BucksOfferButton extends ButtonWithText implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var _bucksOffer:BucksOffer;

        private var mcPlayerChoice:Sprite;
        private var tfPlayerChoice:TextField;
        private var mcBonus:Sprite;
        private var tfBonus:TextField;
        private var tfBucks:TextField;

        public function BucksOfferButton (mc:MovieClip) {
            super (mc);

            playerChoice = false;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get bucksOffer ():BucksOffer {
            return _bucksOffer;
        }

        public function set bucksOffer (value:BucksOffer):void {
            _bucksOffer = value;
            if (_bucksOffer) {
                tfBucks.htmlText = "<b>" + String (_bucksOffer.bucks) + "</b>";
                tfBonus.htmlText = "<b>" + String (_bucksOffer.bonus) + "</b>";
                mcBonus.visible = _bucksOffer.bonus > 0;
            }
            else {
                tfBucks.text = "";
                tfBonus.text = "";
                mcBonus.visible = false;
            }
            setCostText ();
        }

        public function get playerChoice ():Boolean {
            return mcPlayerChoice.visible;
        }

        public function set playerChoice (value:Boolean):void {
            mcPlayerChoice.visible = value;
        }

        public function setTexts ():void {
            tfPlayerChoice.text = textsManager.getText ("playerChoice");
            setCostText ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setCostText ():void {
            if (_bucksOffer) {
                var tfVoice:String = textsManager.getText ("voice");
                var suffix:String = "";
                if (textsManager.currentLanguage == TextsManager.RU) {
                    suffix = StringUtilities.getRussianSuffix2 (_bucksOffer.cost);
                }
                if (textsManager.currentLanguage == TextsManager.EN) {
                    suffix = StringUtilities.getEnglishSuffixForNumber (_bucksOffer.cost);
                }
                tfVoice = tfVoice.replace ("#1", suffix);
                text = "<b>" + _bucksOffer.cost + " " + tfVoice + "</b>";
            }
            else {
                text = "";
            }
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            mcPlayerChoice = getElement ("mcPlayerChoice");
            tfPlayerChoice = getElement ("tfPlayerChoice", mcPlayerChoice);
            mcBonus = getElement ("mcBonus");
            tfBonus = getElement ("tfBonus", mcBonus);
            tfBucks = getElement ("tfBucks");

            textsManager.addTextContainer (this);
        }

    }
}
