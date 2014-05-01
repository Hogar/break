/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 16.01.14
 * Time: 7:10
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons.tooltip {

    public class TooltipData {

        public var tooltipText:String;
        public var priceCoins:int = 0;
        public var priceBucks:int = 0;
        public var priceText:String = null;
        public var afterPriceTooltipText:String = null;

        public function TooltipData (tooltipText:String, priceCoins:int = 0, priceBucks:int = 0, priceText:String = null, afterPriceTooltipText:String = null):void {
            this.tooltipText = tooltipText;
            this.priceCoins = priceCoins;
            this.priceBucks = priceBucks;
            this.priceText = priceText;
            this.afterPriceTooltipText = afterPriceTooltipText;
        }

        public function get isEmpty ():Boolean {
            return (!(tooltipText || (priceCoins != 0) || (priceBucks != 0) || afterPriceTooltipText));
        }

    }
}
