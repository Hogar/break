package com.hogargames.debug {

    /**
     * Интерфейс для объекта-отладчика, выводящего сообщения.
     */
    public interface ITracerOutput {

        /**
         * Вывод сообщения.
         */
        function log (message:String):ITracerOutput;

    }
}