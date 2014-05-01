/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.11.13
 * Time: 9:09
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.basePopUps {

    import breakdance.GlobalConstants;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;

    import flash.display.MovieClip;
    import flash.text.TextField;

    public class TitlePopUp extends BasePopUp implements ITextContainer {

        protected var textsManager:TextsManager = TextsManager.instance;

        protected var tfTitle:TextField;

        public function TitlePopUp (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function setTexts ():void {

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

            tfTitle = getElement ("tfTitle");
            tfTitle.text = "";
        }

        override protected function initGraphic (mc:MovieClip):void {
            super.initGraphic (mc);
            textsManager.addTextContainer (this);
        }

        protected function lock ():void {
            graphics.beginFill (0x00ff00, 0);
            graphics.drawRect (0, 0, GlobalConstants.APP_WIDTH, GlobalConstants.APP_HEIGHT);
            graphics.endFill ();
        }

    }
}
