/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.14
 * Time: 16:07
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.bottomPanel.settingBlockButton {

    import breakdance.ui.panels.bottomPanel.TypeButton;

    import flash.display.MovieClip;

    public class NewsButton extends TypeButton {

        private var mcLetter:MovieClip;

        public function NewsButton (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function showNews ():void {
            mcLetter.visible = true;
        }

        public function hideNews ():void {
            mcLetter.visible = false;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcLetter = getElement ("mcLetter");
        }


    }
}
