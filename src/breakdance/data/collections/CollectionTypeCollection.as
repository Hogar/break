/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.03.14
 * Time: 2:43
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.collections {

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;
    import breakdance.core.texts.TextData;

    import com.hogargames.errors.SingletonError;

    public class CollectionTypeCollection {

        private var _listAsObject:Object;
        private var _list:Vector.<CollectionType>;

        private static var _instance:CollectionTypeCollection;

        public function CollectionTypeCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
            _listAsObject = {};
            _list = new Vector.<CollectionType> ();
        }

        static public function get instance ():CollectionTypeCollection {
            if (!_instance) {
                _instance = new CollectionTypeCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init ():Boolean {
            var collectionType:CollectionType;
            var textData:TextData;

            var table:StaticTable = StaticData.instance.getTable ("collections");

            for (var i:int = 0; i < table.rows.length; i++) {
                collectionType = new CollectionType (table.rows[i]);
                _list.push (collectionType);
                _listAsObject [collectionType.id] = collectionType;
            }

            //Добавляем тексты для уже созданных коллекций:
            table = StaticData.instance.getTable ("collections_title");
            for (i = 0; i < table.rows.length; i++) {
                textData = new TextData (table.rows[i]);
                collectionType = CollectionType (_listAsObject[textData.id]);
                if (collectionType) {
                    collectionType.textData = textData;
                }
            }

            return true;
        }

        public function get list ():Vector.<CollectionType> {
            return _list;
        }

        public function getCollectionType (id:String):CollectionType {
            var collectionType:CollectionType = _listAsObject [id];
            if (collectionType) {
                return collectionType;
            }
            else {
                var message:String = 'Collection "' + id + '" not found.';
                //                trace (message);
                return null;
                //                throw new Error (message);
            }
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}