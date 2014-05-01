/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.09.13
 * Time: 11:31
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;

    public class BattleBonusPanel extends PanelWithIndicators implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var tf:TextField;
        private var mcLock:Sprite;
        private var mcUnLock:MovieClip;
        private var mcCoins:Sprite;
        private var tfCoins:TextField;

        private static const NUM_INDICATORS:int = 10;
        private static const COINS_LOCK_ALPHA:Number = .5;

        public function BattleBonusPanel (mc:MovieClip) {
            super (mc, NUM_INDICATORS);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function setTexts ():void {
            tf.htmlText = textsManager.getText ("battleBonusTitle");
        }

        public function setBonusValue (value:int):void {
            tfCoins.text = String (value);
        }

        public function showLock ():void {
            mcLock.visible = true;
            mcUnLock.visible = false;
            mcUnLock.gotoAndStop (1);
            mcCoins.alpha = COINS_LOCK_ALPHA;
        }

        public function showUnlock ():void {
            mcLock.visible = false;
            mcUnLock.visible = true;
            mcUnLock.gotoAndPlay (1);
            mcCoins.alpha = 1;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            tf = getElement ("tf");
            mcLock = getElement ("mcLock");
            mcUnLock = getElement ("mcUnLock");
            mcCoins = getElement ("mcCoins");
            tfCoins = getElement ("tfCoins", mcCoins);


            textsManager.addTextContainer (this);
        }
    }
}
