/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 23.01.14
 * Time: 18:57
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.DisplayObjectContainerUtilities;
    import com.hogargames.utils.StringUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;

    public class ItemsAwardAnimation extends GraphicStorage {

        private var unlockItemView:ItemView;
        private var newItemView:ItemView;

        public function ItemsAwardAnimation (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function showItems (unlockedItemId:Vector.<String>, newItemId:String):void {
            if (unlockedItemId.length > 0) {
                unlockItemView.showItem (unlockedItemId [0]);
                unlockItemView.visible = true;
            }
            else {
                unlockItemView.visible = false;
            }

            if (!StringUtilities.isNotValueString (newItemId)) {
                newItemView.showItem (newItemId);
                newItemView.visible = true;
            }
            else {
                newItemView.visible = false;
            }
        }

        public function hide ():void {
            unlockItemView.visible = false;
            newItemView.visible = false;
            mc.visible = false;
            mc.gotoAndStop (1);
        }

        override public function destroy ():void {
            if (unlockItemView) {
                unlockItemView.destroy ();
            }
            if (newItemView) {
                newItemView.destroy ();
            }
            unlockItemView.destroy ();
            newItemView.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            var mcUnlockedItemContainer:Sprite = mc ["mcUnlockedItemContainer"];
            unlockItemView = new ItemView ();
            DisplayObjectContainerUtilities.clear (mcUnlockedItemContainer);
            mcUnlockedItemContainer.addChild (unlockItemView);

            var mcNewItemContainer:Sprite = mc ["mcNewItemContainer"];
            newItemView = new ItemView ();
            DisplayObjectContainerUtilities.clear (mcNewItemContainer);
            mcNewItemContainer.addChild (newItemView);

            mouseEnabled = false;
            mouseChildren = false;

            addEventListener (Event.ENTER_FRAME, enterFrameListener);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function enterFrameListener (event:Event):void {
            removeEventListener (Event.ENTER_FRAME, enterFrameListener);
            super.destroy ();
        }

    }
}
