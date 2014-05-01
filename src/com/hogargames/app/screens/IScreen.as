/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 15.12.11
 * Time: 16:18
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.app.screens {

    /**
     * Интерфейс для экрана приложения.
     */
    public interface IScreen {

        /**
         * Метод вызываемый при открытии экрана.
         */
        function onShow ():void;

        /**
         * Метод вызываемый при закрытии экрана.
         */
        function onHide ():void;
    }
}
