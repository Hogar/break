/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.07.13
 * Time: 23:10
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.basePopUps {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;

    import flash.display.MovieClip;
    import flash.text.TextField;

    public class TitleClosingPopUp extends ClosingPopUp implements ITextContainer {

        protected var textsManager:TextsManager = TextsManager.instance;

        protected var tfTitle:TextField;

        public function TitleClosingPopUp (mc:MovieClip) {
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

    }
}
