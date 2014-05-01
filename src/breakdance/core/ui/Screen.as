package breakdance.core.ui {

    import com.hogargames.app.screens.IScreen;
    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class Screen extends GraphicStorage implements IScreen {

        public function Screen (mc:MovieClip) {
            super (mc);
        }

        public function onShow ():void {

        }

        public function onHide ():void {

        }

    }

}