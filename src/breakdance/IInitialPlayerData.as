/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 06.11.13
 * Time: 12:58
 * To change this template use File | Settings | File Templates.
 */
package breakdance {

    import breakdance.battle.data.PlayerItemData;

    public interface IInitialPlayerData {

        function set name (value:String):void;

        function set nickname (value:String):void;

        function set level (value:int):void;

        function set uid (value:String):void;

        function set hairId (value:int):void;

        function set faceId (value:int):void;

        function set body (value:PlayerItemData):void;

        function set head (value:PlayerItemData):void;

        function set hands (value:PlayerItemData):void;

        function set legs (value:PlayerItemData):void;

        function set shoes (value:PlayerItemData):void;

        function set music (value:PlayerItemData):void;

        function set cover (value:PlayerItemData):void;

        function set other (value:PlayerItemData):void;

        function set guessMoveGameRecord (value:int):void;
    }
}
