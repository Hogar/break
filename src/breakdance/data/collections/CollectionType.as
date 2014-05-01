/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.03.14
 * Time: 2:44
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.collections {

    import breakdance.core.staticData.StaticTableRow;
    import breakdance.core.texts.TextData;

    public class CollectionType {

        private var _id:String;
        private var _chance:int;

        private var _textData:TextData;

        public function CollectionType (row:StaticTableRow) {
            _id = row.getAsString ("id");
            _chance = row.getAsInt ("chance", false);
        }

        public function get id ():String {
            return _id;
        }

        public function get chance ():int {
            return _chance;
        }

        public function get textData ():TextData {
            return _textData;
        }

        public function set textData (value:TextData):void {
            _textData = value;
        }

        public function get name ():String {
            if (_textData) {
                return _textData.currentLanguageText;
            }
            else {
                return "---";
            }
        }

        public function toString ():String {
            var str:String = "[ShopItem:[" +
                             "id = " + id + "; " +
                             "chance = " + chance + "; " +
                             "textData = " + textData +
                             "]]";
            return str;
        }
    }
}
