/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 14.08.13
 * Time: 14:22
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import breakdance.IPlayerData;
    import breakdance.data.shop.ShopItem;
    import breakdance.data.shop.ShopItemCategory;
    import breakdance.data.shop.ShopItemCollection;
    import breakdance.template.Template;

    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.MovieClipUtilities;
    import com.hogargames.utils.NumericalUtilities;
    import com.hogargames.utils.StringUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class Avatar extends GraphicStorage {

        private var _faceId:int;
        private var _hairId:int;

        private var mcFace:Sprite;
        private var mcHairstyles:MovieClip;
        private var mcEmotions:MovieClip;
        private var mcHead:MovieClip;
        private var mcOther:MovieClip;
        private var mcBody:MovieClip;
        private var tshirt:TshirtView;

        private static const MAX_NUM_EMOTIONS:int = 6;
        private static const MAX_NUM_HEIR_STYLES:int = 6;
        private static const DEFAULT_FRAME:String = "default";
        private static const T_SHIRT_X:int = -38;
        private static const T_SHIRT_Y:int = 37;

        public function Avatar () {
            super (Template.createSymbol (Template.AVATAR));
            faceId = 1;
            hairId = 1;
            setBody (null, null);
            setHead (null);
            setOther (null);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function initByPlayerData (player:IPlayerData):void {
            if (player) {
                faceId = player.faceId;
                hairId = player.hairId;
                if (player.body) {
                    setBody (player.body.itemId, player.body.color);
                }
                else {
                    setBody (null, null);
                }
                if (player.head) {
                    setHead (player.head.itemId);
                }
                else {
                    setHead (null);
                }
                if (player.other) {
                    setOther (player.other.itemId);
                }
                else {
                    setOther (null);
                }
            }
        }

        public function get faceId ():int {
            return _faceId;
        }

        public function set faceId (value:int):void {
            value = NumericalUtilities.correctValue (value, 1, MAX_NUM_EMOTIONS);
            _faceId = value;
            mcEmotions.gotoAndStop (_faceId);
        }

        public function get hairId ():int {
            return _hairId;
        }

        public function set hairId (value:int):void {
            value = NumericalUtilities.correctValue (value, 1, MAX_NUM_HEIR_STYLES);
            _hairId = value;
            mcHairstyles.gotoAndStop (_hairId);
        }

        public function setBody (itemId:String, color:String):void {
            if (!StringUtilities.isNotValueString (itemId)) {
                var shopItem:ShopItem = ShopItemCollection.instance.getShopItem (itemId);
                if (shopItem.category == ShopItemCategory.T_SHIRTS) {
                    mcBody.visible = false;
                    tshirt.visible = true;
                    tshirt.id = itemId;
                    tshirt.color = color;
                }
                if (shopItem.category == ShopItemCategory.BODY) {
                    mcBody.visible = true;
                    tshirt.visible = false;
                    setState (itemId, mcBody);
                }
            }
            else {
                tshirt.visible = false;
                setState (null, mcBody);
            }
        }

        public function setHead (itemId:String):void {
            setState (itemId, mcHead);
        }

        public function setOther (itemId:String):void {
            setState (itemId, mcOther);
        }

        override public function destroy ():void {
            if (tshirt) {
                tshirt.destroy ();
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setState (itemId:String, container:MovieClip):void {
            if (StringUtilities.isNotValueString (itemId)) {
                container.visible = false;
                container.gotoAndStop (DEFAULT_FRAME);
            }
            else {
                container.visible = true;
                if (!MovieClipUtilities.gotoAndStop (container, itemId)) {
                    container.gotoAndStop (DEFAULT_FRAME);
                }
            }
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            mcFace = getElement ("mcFace");
            mcEmotions = getElement ("mcEmotions", mcFace);
            mcHairstyles = getElement ("mcHairstyles", mcFace);
            mcHead = getElement ("mcHead");
            mcOther = getElement ("mcOther");
            mcBody = getElement ("mcBody");

            tshirt = new TshirtView ();
            tshirt.x = T_SHIRT_X;
            tshirt.y = T_SHIRT_Y;
            mc.addChild (tshirt);
        }

    }
}
