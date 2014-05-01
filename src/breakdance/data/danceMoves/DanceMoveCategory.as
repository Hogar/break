package breakdance.data.danceMoves {

    import breakdance.core.staticData.StaticTableRow;
    import breakdance.core.texts.TextData;

    public class DanceMoveCategory {

        private var _id:String;
        private var textData:TextData;

        //NOTE: можно было упростить эту конструкцию и хранить сразу коллекцию textData, но пока оставим, т.к., возможно, добавится новый функционал.
        public function DanceMoveCategory (row:StaticTableRow) {
            _id = row.getId ();
            textData = new TextData (row);
        }

        public function get id ():String {
            return _id;
        }

        public function get name ():String {
            return textData.currentLanguageText;
        }
    }
}