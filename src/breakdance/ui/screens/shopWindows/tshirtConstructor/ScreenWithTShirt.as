/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.08.13
 * Time: 19:56
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.tshirtConstructor {

    import breakdance.core.texts.TextsManager;
    import breakdance.tutorial.TutorialManager;
    import breakdance.ui.commons.TshirtView;

    import com.hogargames.app.screens.IScreen;
    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class ScreenWithTShirt extends GraphicStorage implements IScreen {

        protected var textsManager:TextsManager = TextsManager.instance;

        protected var tshirt:TshirtView;

        private var mcTshirtPreviewContainer:Sprite;

        protected var tutorialManager:TutorialManager;

        private static const TSHIRT_X:Number = 10;
        private static const TSHIRT_Y:Number = 20;
        private static const TSHIRT_SCALE:Number = 2.6;

        public function ScreenWithTShirt (mc:MovieClip) {
            tutorialManager = TutorialManager.instance;
            super (mc);
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        public function onShow ():void {

        }

        public function onHide ():void {

        }

        public function setTshirtImage (image:String):void {
            tshirt.id = image;
        }

        public function setTshirtColor (color:String):void {
            tshirt.color = color;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            mcTshirtPreviewContainer = getElement ("mcTshirtPreviewContainer");
            tshirt = new TshirtView ();
            tshirt.x = TSHIRT_X;
            tshirt.y = TSHIRT_Y;
            tshirt.scaleX = tshirt.scaleY = TSHIRT_SCALE;
            mcTshirtPreviewContainer.addChild (tshirt);
        }
    }
}
