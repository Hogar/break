package breakdance.ui.commons.buttons 
{
	/**
	 * ...
	 * @author gray_crow
	 */

    import breakdance.core.sound.SoundManager;
    import breakdance.template.Template;

    import com.hogargames.display.buttons.Button;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
	
	public class ButtonPressed extends com.hogargames.display.buttons.ButtonPressed {
		
		
		public function ButtonPressed(mc:MovieClip) {
		
		    super (mc);
        }

        override protected function rollOverListener (event:MouseEvent):void {
            super.rollOverListener (event);
            if (enable) {
//                SoundManager.instance.playSound(Template.SND_BUTTON_OVER);
            }
        }

        override protected function mouseDownListener (event:MouseEvent):void {
            super.mouseDownListener (event);
            if (enable) {
                SoundManager.instance.playSound (Template.SND_BUTTON_DOWN);
            }
        }
		
		
	}

}