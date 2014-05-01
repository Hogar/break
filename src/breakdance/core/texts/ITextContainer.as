/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 19.03.12
 * Time: 7:42
 * To change this template use File | Settings | File Templates.
 */
package breakdance.core.texts {

    /**
     * Интерфейс для контейнера, содержащего тексты.
     *
     * @see com.hogargames.app.texts.TextsManager
     */
    public interface ITextContainer {

        /**
         * Установка текстов.
         * Вызов этого метода обычно происходит при первой инициализации или смене языка
         * в <code>com.hogargames.app.texts.TextsManager</code> для всех добавленных объектов.
         *
         * @see com.hogargames.app.texts.TextsManager
         */
        function setTexts ():void

    }
}
