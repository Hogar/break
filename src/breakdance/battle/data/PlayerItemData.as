/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 24.10.13
 * Time: 21:34
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.data {

    /**
     * Данные о вещи игрока в бою.
     */
    public class PlayerItemData {

        private var _itemId:String;
        private var _color:String;

        private static const ITEM_ID:int = 0;
        private static const COLOR_ID:int = 1;
        private static const NO_COLOR:String = "no_color";

        public function PlayerItemData (itemId:String = "", color:String = ""):void {
            this.itemId = itemId;
            this.color = color;
        }

        public function get itemId ():String {
            return _itemId;
        }

        public function set itemId (value:String):void {
            _itemId = value;
        }

        public function get color ():String {
            return _color;
        }

        public function set color (value:String):void {
            if (value == NO_COLOR) {
                value = "";
            }
            _color = value;
        }

        /**
         * Кодирование в данные (для сервера).
         * @return Объект-данные.
         */
        public function asData ():Object {
            var arr:Array = [];
            arr [ITEM_ID] = _itemId;
            arr [COLOR_ID] = _color;
            return arr;
        }

        /**
         * Инициализация данными (с сервера).
         * @param data Объект-данные.
         */
        public function init (data:Object):void {
            var objAsArray:Array = data as Array;
            _itemId = String (objAsArray [ITEM_ID]);
            _color = String (objAsArray [COLOR_ID]);
        }

        public function toString ():String {
            var str:String;
            str = "[PlayerItemData: ";
            str += "itemId = " + _itemId + "; ";
            str += "color = " + _color;
            str += "]";
            return str;
        }

    }
}
