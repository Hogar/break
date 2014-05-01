/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 09.07.13
 * Time: 10:48
 * To change this template use File | Settings | File Templates.
 */
package breakdance.core.texts {

    import breakdance.core.staticData.StaticTableRow;

    public class TextData {

        private var _id:String;
        private var testStorage:Object = {};

        public function TextData (row:StaticTableRow) {
            _id = row.getId ();
            testStorage = {};
            testStorage [TextsManager.RU] = row.getAsString (TextsManager.RU, false, "");
            testStorage [TextsManager.EN] = row.getAsString (TextsManager.EN, false, "");
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////


        public function get id ():String {
            return _id;
        }

        public function get currentLanguageText ():String {
            return getText (TextsManager.instance.currentLanguage);
        }

        public function getTextOfChosenLanguage (langId:String):String {
            return getText (langId);
        }

        public function toString ():String {
            var str:String = "[TextData:[" +
                             "text " + TextsManager.RU + " = " + getTextOfChosenLanguage (TextsManager.RU) + "; " +
                             "text " + TextsManager.EN + " = " + getTextOfChosenLanguage (TextsManager.EN) +
                             "]]";
            return str;
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function getText (lang:String):String {
            var text:String = testStorage [lang];
            if (!text) {
                text = "";
            }
            return text;
        }


    }
}
