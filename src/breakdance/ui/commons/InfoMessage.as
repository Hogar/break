/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 02.10.13
 * Time: 16:13
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.commons {

    import breakdance.template.Template;

    import flash.display.DisplayObjectContainer;
    import flash.events.Event;

    public class InfoMessage extends BaseInfoMessage {

        public function InfoMessage (message:String) {
            super (Template.createSymbol (Template.INFO_MESSAGE));
            setMessage (message);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function destroy ():void {
            mc.stop ();
            var mcParent:DisplayObjectContainer = parent;
            if (mcParent) {
                if (mcParent.contains (this)) {
                    mcParent.removeChild (this);
                }
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        override protected function enterFrameListener (event:Event):void {
            super.enterFrameListener (event);
            if (mc.currentFrame == mc.totalFrames) {
                destroy ();
            }
        }

    }
}
