/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.03.14
 * Time: 11:24
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.tshirtConstructor {

    import breakdance.ui.screens.shopWindows.ShopList;
    import breakdance.ui.screens.shopWindows.ShopListItem;

    import flash.display.MovieClip;

    public class TshirtList extends ShopList {

        public function TshirtList (mc:MovieClip) {
            super (mc);
        }

        override protected function createNewItem ():ShopListItem {
            return new TshirtListItem ();
        }

    }
}
