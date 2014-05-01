/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.03.14
 * Time: 3:32
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.news {

    import breakdance.core.staticData.StaticTableRow;
    import breakdance.core.texts.TextData;

    import com.hogargames.utils.StringUtilities;

    public class NewData {

        private var _id:String;
        private var _enable:Boolean;
        private var _dateAsString:String;
        private var _date:Date;
        private var _thumb:String;
        private var _imageRu:String;
        private var _imageEn:String;
        private var _buttonEnable:Boolean;
        private var _buttonLinkType:String;
        private var _buttonLinkValue:String;
        private var _buttonX:int;
        private var _buttonY:int;

        private var _textData:TextData;
        private var _buttonTextData:TextData;

        public function NewData (row:StaticTableRow) {
            _id = row.getAsString ("id");
            _enable = StringUtilities.parseToBoolean (row.getAsString ("enable", false));
            _dateAsString = row.getAsString ("date", false);
            _date = new Date ();
            var dateArr:Array = _dateAsString.split (".");
            if (dateArr.length > 2) {
                var year:int = parseInt (dateArr [2]);
                _date.setFullYear (year);
            }
            if (dateArr.length > 1) {
                var mount:int = parseInt (dateArr [1]);
                _date.setMonth (mount - 1);
            }
            if (dateArr.length > 0) {
                var day:int = parseInt (dateArr [0]);
                _date.setDate (day);
            }
            _thumb = row.getAsString ("thumb", false);
            _imageRu = row.getAsString ("image_ru", false);
            _imageEn = row.getAsString ("image_en", false);
            _buttonLinkType = row.getAsString ("button_link_type", false);
            _buttonLinkValue = row.getAsString ("button_link_value", false);
            _buttonX = row.getAsInt ("button_x", false, 10);
            _buttonY = row.getAsInt ("button_y", false, 10);
            _buttonEnable = StringUtilities.parseToBoolean (row.getAsString ("button_enable", false));
        }

        public function get id ():String {
            return _id;
        }

        public function get enable ():Boolean {
            return _enable;
        }

        public function get dateAsString ():String {
            return _dateAsString;
        }

        public function get date ():Date {
            return _date;
        }

        public function get thumb ():String {
            return _thumb;
        }

        public function get imageRu ():String {
            return _imageRu;
        }

        public function get imageEn ():String {
            return _imageEn;
        }

        public function get buttonEnable ():Boolean {
            return _buttonEnable;
        }

        public function get buttonLinkType ():String {
            return _buttonLinkType;
        }

        public function get buttonLinkValue ():String {
            return _buttonLinkValue;
        }

        public function get buttonX ():int {
            return _buttonX;
        }

        public function get buttonY ():int {
            return _buttonY;
        }

        public function get textData ():TextData {
            return _textData;
        }

        public function set textData (value:TextData):void {
            _textData = value;
        }

        public function get buttonTextData ():TextData {
            return _buttonTextData;
        }

        public function set buttonTextData (value:TextData):void {
            _buttonTextData = value;
        }

        public function get text ():String {
            if (_textData) {
                return _textData.currentLanguageText;
            }
            else {
                return "---";
            }
        }

        public function get buttonText ():String {
            if (_textData) {
                return _buttonTextData.currentLanguageText;
            }
            else {
                return "---";
            }
        }

        public function toString ():String {
            var str:String = "[NewData:[" +
                             "id = " + id + "; " +
                             "enable = " + enable + "; " +
                             "date = " + dateAsString + "; " +
                             "thumb = " + thumb + "; " +
                             "imageRu = " + imageRu + "; " +
                             "imageEn = " + imageEn + "; " +
                             "buttonEnable = " + buttonEnable + "; " +
                             "buttonLinkType = " + buttonLinkType + "; " +
                             "buttonLinkValue = " + buttonLinkValue + "; " +
                             "buttonX = " + buttonX + "; " +
                             "buttonY = " + buttonY + "; " +
                             "textData = " + textData + "; " +
                             "buttonTextData = " + buttonTextData +
                             "]]";
            return str;
        }
    }
}
