/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 02.01.14
 * Time: 19:50
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.battlePopUp {

    import breakdance.battle.model.IBattle;

    public interface IBattlePopUp {

        function set battle (value:IBattle):void;
        function show ():void;

    }
}
