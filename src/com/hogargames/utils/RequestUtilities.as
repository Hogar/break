/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 27.03.12
 * Time: 12:27
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.utils {

    import flash.display.Stage;
    import flash.system.Security;

    /**
     * Утилиты для работы с запросами.
     */
    public class RequestUtilities {

        /**
         * Преобразование url-адреса в случайный url-адресс для защиты запроса от кеширования.
         * @param url Url-адрес.
         * @return Модифицированный url-адрес.
         */
        public static function modifyUrlForNoCache (url:String):String {
            if (Security.sandboxType == Security.REMOTE) {
                return (url + "?t=" + new Date ().getTime ().toString ());
            }
            else {
                return url;
            }
        }

        /**
         * Проверка запуска флешки из указанных доменов.
         * @param urls Массив url-адресов доменов.
         * @param stage
         * @return Возвращает <code>true</code>, если флешка запущёна из указанного в списке домена.
         *
         * @example Пример использования метода <code>isUrl</code> для блокировки приложения, запущеного в неразрешённом домене:
         * <listing version="3.0">
         * var sitelockUrls:Array /~~of Strings~~/ = new Array ();
         * sitelockUrls.push ("games.bigfishgames.com");
         * sitelockUrls.push ("bigfishgames.com");
         * sitelockUrls.push ("bigfishgames.de");
         * sitelockUrls.push ("bigfishgames.fr");
         * sitelockUrls.push ("bigfishgames.es");
         * sitelockUrls.push ("bigfishgames.mx");
         * sitelockUrls.push ("bigfishgames.jp");
         * sitelockUrls.push ("hogargames.com");
         * if (RequestUtilities.isUrl (sitelockUrls, stage)) {
         *     //запускаем приложение.
         * }
         * else {
         *     //блокируем работу приложения.
         * }
         * </listing>
         */
        public static function isUrl (urls:Array, stage:Stage):Boolean {
            var url:String = stage.loaderInfo.loaderURL;
            var urlStart:Number = url.indexOf ("://") + 3;
            var urlEnd:Number = url.indexOf ("/", urlStart);
            var domain:String = url.substring (urlStart, urlEnd);
            var LastDot:Number = domain.lastIndexOf (".") - 1;
            var domEnd:Number = domain.lastIndexOf (".", LastDot) + 1;
            domain = domain.substring (domEnd, domain.length);

            for (var i:int = 0; i < urls.length; i++) {
                if (domain == urls[i]) {
                    return true;
                }
            }
            return false;
        }
    }
}
