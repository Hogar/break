/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 21.01.12
 * Time: 3:13
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.errors {

    /**
     * Исключение отправляемое при попытке реализции абстрактного класса.
     */
    public class AbstractClassRealizationError extends Error {

        /**
         * @param className Название абстрактного класса.
         * @param id Ссылочный номер, связываемый с конкретным сообщением об ошибке.
         */
        public function AbstractClassRealizationError (className:String = "", id:int = 0) {
            super ('"' + className + '" class cannot be instantiated! It is abstract class.', id);
        }

    }
}
