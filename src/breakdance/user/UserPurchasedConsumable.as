/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.02.14
 * Time: 13:31
 * To change this template use File | Settings | File Templates.
 */
package breakdance.user {

    public class UserPurchasedConsumable {

        public var id:String;
        public var count:int;
        public var applyDate:Date;

        public function UserPurchasedConsumable (id:String = "", count:int = 0, applyDate:Date = null) {
            this.id = id;
            this.count = count;
            this.applyDate = applyDate;
        }
    }
}
