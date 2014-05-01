/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 02.02.13
 * Time: 10:00
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.utils {

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    /**
     * Утилиты для работы с DisplayObjectContainer.
     */
    public class DisplayObjectContainerUtilities {

        /**
         * Удаление всех детей и графики.
         * @param doc
         * @param clearGraphic Флаг, указывающий, удалять ли графику.
         */
        public static function clear (doc:DisplayObjectContainer, clearGraphic:Boolean = true):void {
            if (doc) {
                while (doc.numChildren > 0) {
                    doc.removeChildAt (0);
                }
                if (clearGraphic && (clearGraphic is Sprite)) {
                    Sprite (doc).graphics.clear ();
                }
            }
        }
    }
}
