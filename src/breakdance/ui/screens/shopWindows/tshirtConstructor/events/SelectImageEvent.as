/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.08.13
 * Time: 11:09
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.tshirtConstructor.events {

    import flash.events.Event;

    public class SelectImageEvent extends Event {

        private var _imageId:String;

        public static const SELECT_IMAGE:String = "select image";

        public function SelectImageEvent (imageId:String, type:String = SELECT_IMAGE, bubbles:Boolean = false, cancelable:Boolean = true) {
            this.imageId = imageId;
            super (type, bubbles, cancelable);
        }

        public function get imageId ():String {
            return _imageId;
        }

        public function set imageId (value:String):void {
            _imageId = value;
        }
    }
}
