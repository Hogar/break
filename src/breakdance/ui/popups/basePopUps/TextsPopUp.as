/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.11.13
 * Time: 9:21
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.basePopUps {

    import flash.display.MovieClip;
    import flash.text.TextField;

    public class TextsPopUp extends TitlePopUp {

        protected var tf:TextField;

        protected var tfStartY:int;
        protected var tfStartHeight:Number;

        public function TextsPopUp (mc:MovieClip) {
            super (mc);
        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            tf = getElement ("tf");
            tfStartY = tf.y;
            tfStartHeight = tf.height;
            tf.text = "";
        }

        protected function positionText ():void {
            tf.height = Math.min (tfStartHeight, tf.textHeight + 4);
            tf.y = Math.round (tfStartY + (tfStartHeight - tf.height) / 2);
        }

    }
}
