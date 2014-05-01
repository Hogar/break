/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 06.07.13
 * Time: 16:12
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.shop {

    import breakdance.core.staticData.StaticTableRow;
    import breakdance.core.texts.TextData;

    public class ShopItem {

        private var _id:String;
        private var _category:String;
        private var _coins:int;
        private var _bucks:int;
        private var _conditionType:String;
        private var _conditionValue:String;
        private var _bonusType:String;
        private var _bonusSubType:String;
        private var _bonusValue:int;

        private var _textData:TextData;

        public function ShopItem (row:StaticTableRow) {
            _id = row.getAsString ("id");
            _category = row.getAsString ("category");
            _coins = row.getAsInt ("coins");
            _bucks = row.getAsInt ("bucks");
            _conditionType = row.getAsString ("condition_type");
            _conditionValue = row.getAsString ("condition_value");
            var serverBonusType:String = row.getAsString ("bonus_type", false);
            if (serverBonusType == "client") {
                _bonusType = row.getAsString ("client_bonus_type", false);
            }
            else {
                _bonusType = serverBonusType;
            }
            _bonusSubType = row.getAsString ("client_bonus_sub_type", false);
            _bonusValue = row.getAsInt ("bonus_value", false);
        }

        public function get id ():String {
            return _id;
        }

        public function get category ():String {
            return _category;
        }

        public function get coins ():int {
            return _coins;
        }


        public function get bucks ():int {
            return _bucks;
        }

        public function get conditionType ():String {
            return _conditionType;
        }

        public function get conditionValue ():String {
            return _conditionValue;
        }

        public function get bonusType ():String {
            return _bonusType;
        }

        public function get bonusSubType ():String {
            return _bonusSubType;
        }

        public function get bonusValue ():int {
            return _bonusValue;
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
                             "category = " + category + "; " +
                             "coins = " + coins + "; " +
                             "conditionType = " + conditionType + "; " +
                             "conditionValue = " + conditionValue + "; " +
                             "bonusType = " + bonusType + "; " +
                             "bonusValue = " + bonusValue + "; " +
                             "textData = " + textData +
                             "]]";
            return str;
        }
    }
}
