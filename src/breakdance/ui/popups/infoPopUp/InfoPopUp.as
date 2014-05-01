/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 19.07.13
 * Time: 11:04
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.infoPopUp {

    import breakdance.template.Template;

    import flash.display.MovieClip;

    public class InfoPopUp extends BaseInfoPopUp {

        private var currentSize:int;

        public static const SIZE_1:int = 1;
        public static const SIZE_2:int = 2;
        public static const SIZE_3:int = 3;
        public static const SIZE_4:int = 4;

        public function InfoPopUp () {
            currentSize = SIZE_1;
            super (Template.createSymbol (Template.INFO_POP_UP_1));
            tf.selectable = true;
        }

        public function setSize (size:int):void {
            if (currentSize != size) {
                var newMc:MovieClip;
                switch (size) {
                    case SIZE_1:
                        newMc = Template.createSymbol (Template.INFO_POP_UP_1);
                        break;
                    case SIZE_2:
                        newMc = Template.createSymbol (Template.INFO_POP_UP_2);
                        break;
                    case SIZE_3:
                        newMc = Template.createSymbol (Template.INFO_POP_UP_3);
                        break;
                    case SIZE_4:
                        newMc = Template.createSymbol (Template.INFO_POP_UP_4);
                        break;
                }
                if (newMc) {
                    initGraphic (newMc);
                }
            }
            currentSize = size;
        }


    }
}
