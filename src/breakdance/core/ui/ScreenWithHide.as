/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 02.10.13
 * Time: 13:04
 * To change this template use File | Settings | File Templates.
 */
package breakdance.core.ui {

    import breakdance.core.ui.events.ScreenEvent;

    import flash.display.MovieClip;

    public class ScreenWithHide extends Screen {

        public function ScreenWithHide (mc:MovieClip) {
            super (mc);
        }

        protected function hide ():void {
            dispatchEvent (new ScreenEvent (ScreenEvent.HIDE_SCREEN));
        }
    }
}
