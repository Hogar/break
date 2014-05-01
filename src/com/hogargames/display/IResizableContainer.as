/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 21.01.12
 * Time: 4:11
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.display {

    /**
     * Интерфейс для объекта, содержащего контейнер.
     */
    public interface IResizableContainer {

        function get containerHeight ():Number;

        function set containerHeight (value:Number):void;

        function get containerWidth ():Number;

        function set containerWidth (value:Number):void;
    }
}
