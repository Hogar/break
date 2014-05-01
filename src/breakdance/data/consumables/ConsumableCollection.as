/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.02.14
 * Time: 23:27
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.consumables {

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;
    import breakdance.core.texts.TextData;

    import com.hogargames.errors.SingletonError;

    public class ConsumableCollection {

        private var _listAsObject:Object;
        private var _list:Vector.<Consumable>;

        private static var _instance:ConsumableCollection;

        public function ConsumableCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
            _listAsObject = {};
            _list = new Vector.<Consumable> ();
        }

        static public function get instance ():ConsumableCollection {
            if (!_instance) {
                _instance = new ConsumableCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init ():Boolean {
            var consumable:Consumable;
            var textData:TextData;

            var table:StaticTable = StaticData.instance.getTable ("consumables");

            for (var i:int = 0; i < table.rows.length; i++) {
                consumable = new Consumable (table.rows[i]);
                _list.push (consumable);
                _listAsObject[consumable.id] = consumable;
            }

            //Добавляем тексты для уже созданных расходников:
            table = StaticData.instance.getTable ("consumables_title");
            for (i = 0; i < table.rows.length; i++) {
                textData = new TextData (table.rows[i]);
                consumable = Consumable (_listAsObject[textData.id]);
                if (consumable) {
                    consumable.textData = textData;
                }
            }

            return true;
        }

        public function getConsumable (id:String):Consumable {
            var consumable:Consumable = _listAsObject [id];
            if (consumable) {
                return consumable;
            }
            else {
                var message:String = 'Consumable "' + id + '" not found.';
//                trace (message);
//                return null;
                throw new Error (message);
            }
        }

    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}
