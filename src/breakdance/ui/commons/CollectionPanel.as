/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.09.13
 * Time: 3:50
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.collections.CollectionType;

    import flash.display.MovieClip;
    import flash.text.TextField;

    public class CollectionPanel extends PanelWithIndicators implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var _collectionType:CollectionType;

        private var tfCollection:TextField;
        private var tfTitle:TextField;

        private static const NUM_INDICATORS:int = 5;

        public function CollectionPanel (mc:MovieClip) {
            super (mc, NUM_INDICATORS);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////


        public function get collectionType ():CollectionType {
            return _collectionType;
        }

        public function set collectionType (value:CollectionType):void {
            _collectionType = value;
            setTexts ();
        }

        public function setTexts ():void {
            tfCollection.htmlText = textsManager.getText ("collection");
            if (_collectionType) {
                setTitle (_collectionType.name);
            }
            else {
                setTitle ("");
            }
        }

        override public function destroy ():void {
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            tfCollection = getElement ("tfCollection");
            tfTitle = getElement ("tfTitle");

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setTitle (title:String):void {
            tfTitle.htmlText = "<b>" + title + "</b>";
        }
    }
}
