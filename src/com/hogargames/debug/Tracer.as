package com.hogargames.debug {

    import flash.errors.IllegalOperationError;

    /**
     * Класс для вывода отладочных сообщений в объектах-отладчиках.
     *
     * <p>Класс использует только статические переменные и методы.
     * Создание экземпляров этого класса не возможно.</p>
     */
    public class Tracer {

        /**
         * Указыет, вызывать ли метод <code>trace()</code>
         * при вызове метода <code>log()</code>.
         *
         * @see #log()
         */
        public static var doTrace:Boolean = false;
        private static var outputs:Vector.<ITracerOutput> = new Vector.<ITracerOutput> ();
        private static var tracerNodeTxt:String = "";

        /**
         * @throws flash.errors.IllegalOperationError
         * Создание экземпляров этого класса не возможно.
         */
        function Tracer () {
            throw new IllegalOperationError ();
        }

        /**
         * Добавление объекта-отладчика.
         */
        static public function addTracerOutput (tracerOutput:ITracerOutput):void {
            if (tracerOutput) {
                outputs.push (tracerOutput);
            }
        }

        /**
         * Вывод сообщения во всех объектах-отладчиках,
         * которые были добавлены при помощи метода <code>addTracerOutput()</code>.
         * <p>Если переменная <code>doTrace = true</code>, то сообщение также выводится
         * при помощи метода <code>trace()</code>.</p>
         */
        static public function log (message:*):void {
            var _message:String = String (message);
            if (doTrace) {
                trace ("[Tracer]:" + _message);
            }
            var _date:Date = new Date ();
            var _timeStamp:String = "[" + _date.toLocaleTimeString () + "] ";
            _message = _timeStamp + _message;
            for each (var traceOutput:ITracerOutput in outputs) {
                traceOutput.log (_message + "\r\n");
            }
        }

        /**
         * Вывод подробного представления объекта (со всеми его свойствами).
         */
        static public function traceObject (obj:Object):void {
            tracerNodeTxt = "";
            traceObj (obj);
        }

        static private function traceObj (obj:Object):void {
            var startTracerNodeTxt:String = tracerNodeTxt;
            for (var prop:String in obj) {
                tracerNodeTxt = startTracerNodeTxt;
                if (obj [prop] is String || obj [prop] is Number) {
                    Tracer.log (tracerNodeTxt + "[" + prop + "] = " + obj [prop]);
                }
                else if (String (obj [prop]) == "") {
                    Tracer.log (tracerNodeTxt + "[" + prop + "] = []");
                }
                else {
                    tracerNodeTxt = tracerNodeTxt + "[" + prop + "]";
                    //Tracer.log (tracerNodeTxt + "[" + prop + "]:");
                    traceObj (obj [prop]);
                }
            }
        }
    }
}