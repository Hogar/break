/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.02.14
 * Time: 7:31
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.consumables {

    public class ConsumableBonus {

        public var type:String;
        public var value:int;

        public function ConsumableBonus (type:String = "", value:int = 0) {
            this.type = type;
            this.value = value;
        }

        public function toString ():String {
            var str:String;
            str = "[ConsumablesBonus: ";
            str += "type = " + type + "; ";
            str += "value = " + value;
            str += "]";
            return str;
        }
    }
}
