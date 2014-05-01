package breakdance.core.staticData {

    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.XMLLoader;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class StaticTableLoader {
        private var _tableName:String;

        private var _loader:XMLLoader;

        private var _completeCallback:Function;
        private var _errorCallback:Function;

        public function StaticTableLoader (url:String, completeCallback:Function, errorCallback:Function) {
            _completeCallback = completeCallback;
            _errorCallback = errorCallback;

            _loader = new XMLLoader (url + "?v=" + StaticData.ts, { onComplete: completeHandler, onError: errorHandler });
            _loader.load ();
        }

        private function completeHandler (event:LoaderEvent):void {
            parseXmlTable (_loader.content);
            _loader.dispose ();
            _loader = null;

            _completeCallback ();
        }

        private function errorHandler (event:LoaderEvent):void {
            _errorCallback ("Loading error (" + event.target + ")");
        }

        private function parseXmlTable (xml:XML):void {
            var tableId:String;
            var table:StaticTable;
            var tableNode:XML;

            tableId = xml.name ();
            if (!StaticData.instance._tableIndex[tableId])
                StaticData.instance._tableIndex[tableId] = new StaticTable (tableId);
            table = StaticData.instance._tableIndex[tableId];
            table.parseRows (xml);
        }

    }

}