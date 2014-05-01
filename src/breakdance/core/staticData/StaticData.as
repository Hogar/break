package breakdance.core.staticData {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalConstants;
    import breakdance.core.IAsyncInitObject;
    import breakdance.core.texts.TextsManager;
    import breakdance.events.LoadingStepEvent;

    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.XMLLoader;
    import com.hogargames.errors.SingletonError;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class StaticData implements IAsyncInitObject {

        public static var ts:String = "";

        internal var _tableIndex:Object = { };

        private var _completeCallback:Function;
        private var _errorCallback:Function;
        private var _progressCallback:Function;

        private var _loader:XMLLoader;
        private var _loadingTableList:Array = [];

        static private var _instance:StaticData;

        private static const DATE_FOLDER:String = "xml/";
        private static const DATA_FOLDER:String = "xml/data/";
        private static const DANCE_MOVES_FOLDER:String = "xml/dance_moves/";
        private static const TEXTS_FOLDER:String = "xml/texts/";

        public function StaticData (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }

            //init();
        }


        static public function get instance ():StaticData {
            if (!_instance) {
                _instance = new StaticData (new SingletonKey ());
            }

            return _instance;
        }

        public function getTable (id:String):StaticTable {
            if (!_tableIndex[id]) {
                throw new Error ('StaticData.getTable("' + id + '") Error: Unknown table');
            }

            return _tableIndex[id];
        }

        public function getSetting (id:String):String {
            var staticTable:StaticTable = getTable ("setting");
            var row:StaticTableRow;
            row = staticTable.rowIndex [id];
            var value:String = row.getAsString ("value", false, "");
            return value;
        }

        public function getAsString (tableId:String, rowId:String, columnId:String, required:Boolean = true, defaultValue:String = ""):String {
            var table:StaticTable = getTable (tableId);

            if (table == null) {
                if (required)
                    throw new Error ("StatiData. Unknown table '" + table.id + "'");
                else
                    return defaultValue;
            }

            var tableRow:StaticTableRow = table.rowIndex[rowId];

            if (tableRow == null) {
                if (required)
                    throw new Error ("StatiData. Missing row '" + rowId + "'");
                else
                    return defaultValue;
            }

            return tableRow.getAsString (columnId, required, defaultValue);
        }

        /* INTERFACE core.IAsyncInitObject */

        public function init (completeCallback:Function, errorCallback:Function, progressCallback:Function):void {
            _completeCallback = completeCallback;
            _errorCallback = errorCallback;
            _progressCallback = progressCallback;

            BreakdanceApp.instance.appDispatcher.dispatchEvent (new LoadingStepEvent (LoadingStepEvent.START_LOADING_STEP, "Загрузка XML"));

            _loader = new XMLLoader (
                    GlobalConstants.ASSETS_URL + DATE_FOLDER + "_date.xml?t=" + new Date ().getTime (),
                    {
                        onComplete: dateFileCompleteHandler,
                        onError: errorHandler
                    }
            );

            _loader.load ();
        }

        private function dateFileCompleteHandler (event:LoaderEvent):void {
            var xml:XML = _loader.content;
            ts = xml.ts;
            _loader = new XMLLoader (
                    GlobalConstants.ASSETS_URL + DATA_FOLDER + "_files.xml?v=" + ts,
                    {
                        onComplete: dataFileListCompleteHandler,
                        onError: errorHandler
                    }
            );
            _loader.load ();
        }

        private function dataFileListCompleteHandler (event:LoaderEvent):void {
            parseXmlFileList (GlobalConstants.ASSETS_URL + DATA_FOLDER, _loader.content);
            _loader.dispose ();
            _loader = null;

            _loader = new XMLLoader (
                    GlobalConstants.ASSETS_URL + DANCE_MOVES_FOLDER + "_files.xml?v=" + ts,
                    {
                        onComplete: movesFileListCompleteHandler,
                        onError: errorHandler
                    }
            );
            _loader.load ();
        }

        private function movesFileListCompleteHandler (event:LoaderEvent):void {
            parseXmlFileList (GlobalConstants.ASSETS_URL + DANCE_MOVES_FOLDER, _loader.content);
            _loader.dispose ();
            _loader = null;

            _loader = new XMLLoader (
                    GlobalConstants.ASSETS_URL + TEXTS_FOLDER + "_files.xml?v=" + ts,
                    {
                        onComplete: textsFileListCompleteHandler,
                        onError: errorHandler
                    }
            );
            _loader.load ();
        }

        private function textsFileListCompleteHandler (event:LoaderEvent):void {
            parseXmlFileList (GlobalConstants.ASSETS_URL + TEXTS_FOLDER, _loader.content);
            _loader.dispose ();
            _loader = null;

            loadNextTable ();
        }

        private function parseXmlFileList (folderName:String, xml:XML):void {
            var tableNode:XML;
            var name:String;
            for each(tableNode in xml.children ()) {
                name = tableNode.localName ();
                _loadingTableList.push (folderName + name + ".xml");
            }
        }

        private function loadNextTable ():void {
//            trace ("loadNextTable");
            if (_loadingTableList.length == 0) {
                TextsManager.instance.parseUiTexts ();
                _completeCallback ();
                return;
            }

            var tableName:String = _loadingTableList.pop ();
//            trace ("load " + tableName);
            new StaticTableLoader (tableName, loadNextTable, _errorCallback);
        }

        private function errorHandler (event:LoaderEvent):void {
            _errorCallback ("Loading error (" + event.target + ")");
        }

    }

}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}