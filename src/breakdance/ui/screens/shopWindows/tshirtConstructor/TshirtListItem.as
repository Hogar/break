/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.03.14
 * Time: 11:12
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.shopWindows.tshirtConstructor {

    import breakdance.BreakdanceApp;
    import breakdance.ui.screens.shopWindows.ShopListItem;
    import breakdance.user.AppUser;

    public class TshirtListItem extends ShopListItem {

        public function TshirtListItem () {

        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function testEnabled ():void {
            var appUser:AppUser = BreakdanceApp.instance.appUser;
            newItemsSelection = false;
            if (_shopItem) {
                enable = appUser.hasCurrencyForBuyItem (_shopItem) && appUser.metAdditionConditionsForBuyItem (_shopItem);
                var newItems:Vector.<String> = appUser.newItems;
                if (newItems) {
                    if (newItems.indexOf (_shopItem.id) != -1) {
                        newItemsSelection = true;
                    }
                }
            }
            else {
                enable = false;
            }
        }

    }
}
