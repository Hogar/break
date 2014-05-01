/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 28.01.14
 * Time: 5:16
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.infoPopUp {

    import breakdance.template.Template;

    public class InfoPopUpWithCharacter extends BaseInfoPopUp {

        public function InfoPopUpWithCharacter () {
            super (Template.createSymbol (Template.INFO_POPUP_WITH_CHARACTER));
            tf.selectable = true;
        }

    }
}