/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.08.13
 * Time: 11:32
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import breakdance.template.Template;
    import breakdance.ui.screens.shopWindows.tshirtConstructor.TshirtColor;

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;

    public class TshirtView extends GraphicStorage {

        private var _id:String;
        private var _color:String;

        public function TshirtView () {
            super (Template.createSymbol (Template.T_SHIRT));
            id = null;
            color = TshirtColor.WHITE;
        }


        public function get id ():String {
            return _id;
        }

        public function set id (value:String):void {
            _id = value;
            if (_id) {
                mc.gotoAndStop (_id);
                visible = true;
                color = color;
            }
            else {
                mc.gotoAndStop (1);
                visible = false;
            }
        }

        public function get color ():String {
            return _color;
        }

        public function set color (value:String):void {
            _color = value;
            var child:MovieClip = MovieClip (mc.getChildAt (0));
            if (_color == "") {
                _color = TshirtColor.WHITE;
            }
            if (_color) {
                child.gotoAndStop (_color);
            }
            else {
                child.gotoAndStop (TshirtColor.WHITE);
            }
        }
    }
}
