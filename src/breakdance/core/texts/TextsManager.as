/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.06.13
 * Time: 10:41
 * To change this template use File | Settings | File Templates.
 */
package breakdance.core.texts {

    import breakdance.BreakdanceApp;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.staticData.StaticTable;
    import breakdance.core.staticData.StaticTableRow;

    import com.hogargames.debug.Tracer;
    import com.hogargames.errors.SingletonError;

    import flash.net.SharedObject;

    public class TextsManager {

        private static var _instance:TextsManager;

        //getting:
        private var _currentLanguage:String = RU;
        private var textContainers:Vector.<ITextContainer> = new Vector.<ITextContainer> ();

        private var textsDataStorage:Object;

        public var sharedObject:SharedObject;

        public static const RU:String = "ru";
        public static const EN:String = "en";

        public static const SAVED_DATA:String = "savedData";

        /**
         * @throws com.hogargames.errors.SingletonError Класс является синглтоном.
         *
         * @see com.hogargames.errors.SingletonError
         */
        public function TextsManager (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
            sharedObject = SharedObject.getLocal (SAVED_DATA);
//            if (sharedObject.data.hasOwnProperty ("lang")) {
//                _currentLanguage = sharedObject.data.lang;
//            }
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public static function get instance ():TextsManager {
            if (!_instance) {
                _instance = new TextsManager (new SingletonKey ());
            }
            return _instance;
        }

        public function parseUiTexts ():void {
            textsDataStorage = {};
            parseTexts (StaticData.instance.getTable ("ui_texts"), textsDataStorage)
        }

        /**
         * Текущий выбранный язык.
         */
        public function get currentLanguage ():String {
            return _currentLanguage;
        }

        public function setCurrentLanguage (language:String, saveOnServer:Boolean = false):void {
            _currentLanguage = language;
            changeTextContainersTexts ();
            sharedObject.data.lang = language;
            if (saveOnServer) {
                BreakdanceApp.instance.appUser.saveUserSettings ();
            }
        }

        /**
         * Получение текста для ui.
         * @param textId Id'шник текста.
         * @return Текст.
         */
        public function getText (textId:String):String {
            var textsStorage:TextData = textsDataStorage [textId];
            if (textsStorage) {
                return textsStorage.getTextOfChosenLanguage (_currentLanguage);
            }
            else {
                Tracer.log ('Текст "' + textId + '" не найден!');
                return ("[" + textId + "]");
            }
        }

        /**
         * Добавление объекта <code>ITextContainer</code> в хранилище объектов для групповой обработки.
         * Под групповой обработкой подразумевается массовый вызов метода <code>setTexts()</code> у всех объектов,
         * добавленных в хранилище при изменении языка.
         * @param textContainer Объект для добавления в хранилище.
         */
        public function addTextContainer (textContainer:ITextContainer):void {
            if (textContainers.indexOf (textContainer) == -1) {
                textContainers.push (textContainer);
            }
            textContainer.setTexts ();
        }

        /**
         * Удаление объекта <code>ITextContainer</code> из хранилища объектов для групповой обработки.
         * Под групповой обработкой подразумевается массовый вызов метода <code>setTexts()</code> у всех объектов,
         * добавленных в хранилище при изменении языка.
         * @param textContainer Объект для удаления из хранилища.
         */
        public function removeTextContainer (textContainer:ITextContainer):void {
            var index:int = textContainers.indexOf (textContainer);
            if (index != -1) {
                textContainers.splice (index, 1);
            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private static function parseTexts (table:StaticTable, textsStorage:Object):void {
            for (var i:int = 0; i < table.rows.length; i++) {
                var row:StaticTableRow = table.rows [i];
                var rowId:String = row.getId ();
                textsStorage [rowId] = new TextData (row);
            }
        }

        private function changeTextContainersTexts ():void {
            for (var i:int = 0; i < textContainers.length; i++) {
                textContainers [i].setTexts ();
            }
        }

    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}