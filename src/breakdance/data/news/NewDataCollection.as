/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 15.03.14
 * Time: 3:58
 * To change this template use File | Settings | File Templates.
 */
package breakdance.data.news {

    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;
    import breakdance.core.texts.TextData;

    import com.hogargames.errors.SingletonError;

    public class NewDataCollection {

        private var _listAsObject:Object;
        private var _list:Vector.<NewData>;
        private var _enabledList:Vector.<NewData>;

        private static var _instance:NewDataCollection;

        public function NewDataCollection (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
            _listAsObject = {};
            _list = new Vector.<NewData> ();
            _enabledList = new Vector.<NewData> ();
        }

        static public function get instance ():NewDataCollection {
            if (!_instance) {
                _instance = new NewDataCollection (new SingletonKey ());
            }

            return _instance;
        }

        public function init ():Boolean {
            var newData:NewData;
            var textData:TextData;
            var buttonTextData:TextData;

            var table:StaticTable = StaticData.instance.getTable ("news");

            for (var i:int = 0; i < table.rows.length; i++) {
                newData = new NewData (table.rows[i]);
                _list.push (newData);
                if (newData.enable) {
                    _enabledList.push (newData);
                }
                _listAsObject [newData.id] = newData;
            }

            //Добавляем тексты для уже созданных новостей:
            table = StaticData.instance.getTable ("news_title");
            for (i = 0; i < table.rows.length; i++) {
                textData = new TextData (table.rows[i]);
                newData = NewData (_listAsObject [textData.id]);
                if (newData) {
                    newData.textData = textData;
                }
            }

            _list.sort (sortByDate);
            _enabledList.sort (sortByDate);

            //Добавляем тексты кнопки для уже созданных новостей:
            table = StaticData.instance.getTable ("news_button_title");
            for (i = 0; i < table.rows.length; i++) {
                buttonTextData = new TextData (table.rows[i]);
                newData = NewData (_listAsObject [buttonTextData.id]);
                if (newData) {
                    newData.buttonTextData = buttonTextData;
                }
            }

            return true;
        }

        public function get enabledList ():Vector.<NewData> {
            return _enabledList;
        }

        public function get list ():Vector.<NewData> {
            return _list;
        }

        public function getNewData (id:String):NewData {
            var newData:NewData = _listAsObject [id];
            if (newData) {
                return newData;
            }
            else {
                var message:String = 'NewData "' + id + '" not found.';
//                trace (message);
                return null;
//                throw new Error (message);
            }
        }

        private function sortByDate (newData1:NewData, newData2:NewData):Number {
            var time1:Number;
            var time2:Number;
            if (newData1) {
                if (newData1.date) {
                    time1 = newData1.date.getTime ();
                }
            }
            if (newData2) {
                if (newData2.date) {
                    time2 = newData2.date.getTime ();
                }
            }
            if (time1 > time2) {
                return -1;
            }
            else if (time1 < time2) {
                return 1;
            }
            else {
                return 0;
            }
        }
    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}