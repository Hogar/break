/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 25.10.13
 * Time: 10:44
 * To change this template use File | Settings | File Templates.
 */
package breakdance {

    import breakdance.battle.data.PlayerItemData;

    /**
     * Данные о пользователе. Используется для визуализации (аватарка, списки и т.д.)
     */
    public interface IPlayerData {

        function get name ():String;

        function get nickname ():String;

        function get level ():int;

        function get uid ():String;

        function get hairId ():int;

        function get faceId ():int;

        function get body ():PlayerItemData;

        function get head ():PlayerItemData;

        function get hands ():PlayerItemData;

        function get legs ():PlayerItemData;

        function get shoes ():PlayerItemData;

        function get music ():PlayerItemData;

        function get cover ():PlayerItemData;

        function get other ():PlayerItemData;
    }
}
