/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.02.14
 * Time: 23:27
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.consumables {

    import breakdance.core.staticData.StaticTableRow;
    import breakdance.core.texts.TextData;

    import com.hogargames.utils.StringUtilities;

    public class Consumable {

        private var _id:String;
        private var _coins:int;
        private var _bucks:int;
        private var _bonuses:Vector.<ConsumableBonus> = new Vector.<ConsumableBonus> ();
        private var _time:int;

        private var _textData:TextData;

        public function Consumable (row:StaticTableRow) {
            _id = row.getAsString ("id");
            _coins = row.getAsInt ("coins");
            _bucks = row.getAsInt ("bucks");
            _time = row.getAsInt ("time", false, 0);
            _bonuses = new Vector.<ConsumableBonus> ();
            var consumablesBonus:ConsumableBonus = new ConsumableBonus (row.getAsString ("bonus_type"), row.getAsInt ("bonus_value"));
            _bonuses.push (consumablesBonus);
            var clientConsumablesBonus:String = row.getAsString ("client_bonus_type", false, "");
            if (!StringUtilities.isNotValueString (clientConsumablesBonus)) {
                var clientConsumablesBonusArr:Array = clientConsumablesBonus.split (";");
                for (var i:int = 0; i < clientConsumablesBonusArr.length; i++) {
                    var bonus:String = clientConsumablesBonusArr [i];
                    var bonusArr:Array = bonus.split (":");
                    if (bonusArr.length > 0) {
                        consumablesBonus = new ConsumableBonus (bonusArr [0]);
                        if (bonusArr.length > 1) {
                            consumablesBonus.value = bonusArr [1];
                        }
                        _bonuses.push (consumablesBonus);
                    }
                }
            }
        }

        public function get id ():String {
            return _id;
        }

        public function get coins ():int {
            return _coins;
        }

        public function get bucks ():int {
            return _bucks;
        }

        public function get bonuses ():Vector.<ConsumableBonus> {
            return _bonuses;
        }

        public function get time ():int {
            return _time;
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
            var str:String;
            str = "[Consumables: ";
            str += "id = " + id + "; ";
            str += "cost = " + coins + "; ";
            str += "bucks = " + bucks + "; ";
            str += "time = " + time + "; ";
            str += "textData = " + textData + "; ";
            str += "bonuses = [" + bonuses;
            str += "]]";
            return str;
        }
    }
}
