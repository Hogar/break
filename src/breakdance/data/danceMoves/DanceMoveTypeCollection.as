package breakdance.data.danceMoves {

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;
    import breakdance.core.texts.TextData;

    import com.hogargames.debug.Tracer;
    import com.hogargames.errors.SingletonError;

    public class DanceMoveTypeCollection {
        private var _index:Object;
        private var _index2:Object;
        private var _list:Vector.<DanceMoveType>;

        private var _categoryIndex:Object;
        private var _categoryList:Vector.<DanceMoveCategory>;

        private static var _instance:DanceMoveTypeCollection;

        public function DanceMoveTypeCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }

            _index = {};
            _index2 = {};
            _list = new Vector.<DanceMoveType> ();

            _categoryIndex = {};
            _categoryList = new Vector.<DanceMoveCategory> ();
        }


        static public function get instance ():DanceMoveTypeCollection {
            if (!_instance) {
                _instance = new DanceMoveTypeCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function initCategories ():Boolean {
            var moveCategory:DanceMoveCategory;

            var table:StaticTable = StaticData.instance.getTable ("step_category_title");

            for (var i:int = 0; i < table.rows.length; i++) {
                moveCategory = new DanceMoveCategory (table.rows[i]);
                _categoryIndex[moveCategory.id] = moveCategory;
                _categoryList.push (moveCategory);
            }

            return true;
        }

        public function init ():Boolean {
            var danceMoveType:DanceMoveType;
            var textData:TextData;

            var table:StaticTable = StaticData.instance.getTable ("step");

            for (var i:int = 0; i < table.rows.length; i++) {
                danceMoveType = new DanceMoveType (i + 1, table.rows[i]);
                _index [danceMoveType.id] = danceMoveType;
                _index2 [danceMoveType.intId] = danceMoveType;
                _list.push (danceMoveType);
            }

            //Добавляем тексты для уже созданных типов танцевальных движений:
            table = StaticData.instance.getTable ("step_title");
            for (i = 0; i < table.rows.length; i++) {
                textData = new TextData (table.rows[i]);
                danceMoveType = DanceMoveType (_index [textData.id]);
                danceMoveType.textData = textData;
            }

            return true;
        }

        public function get categoryList ():Vector.<DanceMoveCategory> {
            return _categoryList;
        }

        public function getCategory (categoryId:String):DanceMoveCategory {
            return _categoryIndex [categoryId];
        }

        public function get list ():Vector.<DanceMoveType> {
            return _list;
        }

        public function getDanceMoveType (id:String):DanceMoveType {
            if (_index [id]) {
                return _index [id];
            }
            else {
                Tracer.log ('DanceMoveType "' + id + '" not found.');
                return null;
            }
        }

        public function getDanceMoveTypeByIntId (intId:int):DanceMoveType {
            if (_index2 [intId]) {
                return _index2 [intId];
            }
            else {
                Tracer.log ('DanceMoveType "' + intId + '" not found.');
                return null;
            }
        }

        public function getDanceMoveTypesOfSubtype (subType:String):Vector.<DanceMoveType> {
            var danceMovesTypes:Vector.<DanceMoveType> = new Vector.<DanceMoveType> ();
            for (var i:int = 0; i < _list.length; i++) {
                var danceMoveType:DanceMoveType = _list [i];
                if (danceMoveType.subType == subType) {
                    danceMovesTypes.push (danceMoveType);
                }
            }
            return danceMovesTypes;
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}