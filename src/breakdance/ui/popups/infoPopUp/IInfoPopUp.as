/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 28.01.14
 * Time: 6:02
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.infoPopUp {

    public interface IInfoPopUp {

        function showMessage (title:String, text:String):void;
        function clearMessages ():void;


    }
}
