/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.14
 * Time: 23:18
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.settingsPanel {

    import breakdance.BreakdanceApp;
    import breakdance.core.sound.SoundManager;
    import breakdance.core.sound.events.SoundManagerEvent;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.Button;

    import com.hogargames.display.GraphicStorage;

    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class SettingsPanel extends GraphicStorage implements ITextContainer {

        private var mcPanel:MovieClip;

        private var btnMusicOn:Button;
        private var btnMusicOff:Button;
        private var btnSoundOn:Button;
        private var btnSoundOff:Button;
        private var btnRu:Button;
        private var btnEn:Button;

        private var languageButtons:Vector.<Button>;

        private var _isShowed:Boolean;

        private var textsManager:TextsManager;

        private static const HIDE_FRAME:String = "hide";
        private static const SHOW_FRAME:String = "show";

        public function SettingsPanel () {
            textsManager = TextsManager.instance;
            super (Template.createSymbol (Template.SETTINGS_PANEL));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function show ():void {
            _isShowed = true;
            mc.gotoAndPlay (SHOW_FRAME);
            mouseEnabled = true;
            mouseChildren = true;
        }

        public function hide ():void {
            _isShowed = false;
            mc.gotoAndPlay (HIDE_FRAME);
            mouseEnabled = false;
            mouseChildren = false;
        }

        public function get isShowed ():Boolean {
            return _isShowed;
        }

        public function setTexts ():void {
            if (TextsManager.instance.currentLanguage == TextsManager.RU) {
                selectLanguageButton (btnRu);
            }
            else {
                selectLanguageButton (btnEn);
            }
        }

        override public function destroy ():void {
            destroyButton (btnMusicOn);
            destroyButton (btnMusicOff);
            destroyButton (btnSoundOn);
            destroyButton (btnSoundOff);
            destroyButton (btnRu);
            destroyButton (btnEn);

            btnMusicOn = null;
            btnMusicOff = null;
            btnSoundOn = null;
            btnSoundOff = null;
            btnRu = null;
            btnEn = null;

            languageButtons = null;

            SoundManager.instance.removeEventListener (SoundManagerEvent.CHANGE_SOUND_CONTROLLER, changeSoundControllerListener);
            SoundManager.instance.removeEventListener (SoundManagerEvent.CHANGE_MUSIC_CONTROLLER, changeMusicControllerListener);

            TextsManager.instance.removeTextContainer (this);

            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcPanel = getElement ("mcPanel");
            btnMusicOn = new Button (mcPanel ["btnMusicOn"]);
            btnMusicOff = new Button (mcPanel ["btnMusicOff"]);
            btnSoundOn = new Button (mcPanel ["btnSoundOn"]);
            btnSoundOff = new Button (mcPanel ["btnSoundOff"]);
            btnRu = new Button (mcPanel ["btnRu"]);
            btnEn = new Button (mcPanel ["btnEn"]);

            initButton (btnMusicOn);
            initButton (btnMusicOff);
            initButton (btnSoundOn);
            initButton (btnSoundOff);
            initButton (btnRu);
            initButton (btnEn);

            languageButtons = new Vector.<Button> ();
            languageButtons.push (btnRu);
            languageButtons.push (btnEn);

            //скрываем панельку:
            mc.stop ();
            _isShowed = false;

            SoundManager.instance.addEventListener(SoundManagerEvent.CHANGE_SOUND_CONTROLLER, changeSoundControllerListener);
            SoundManager.instance.addEventListener(SoundManagerEvent.CHANGE_MUSIC_CONTROLLER, changeMusicControllerListener);

            changeSoundControllerListener (null);
            changeMusicControllerListener (null);

            mouseEnabled = false;
            mouseChildren = false;

            TextsManager.instance.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function initButton (btn:Button):void {
            if (btn) {
                btn.addEventListener (MouseEvent.CLICK, clickListener);
                btn.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btn.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            }
        }

        private function destroyButton (button:Button):void {
            if (button) {
                button.removeEventListener (MouseEvent.CLICK, clickListener);
                button.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                button.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                button.destroy ();
            }
        }

        private function getTooltipPositionByButton (button:Button):Point {
            var buttonParent:DisplayObjectContainer = button.parent;
            var positionPoint:Point;
            if (buttonParent) {
                positionPoint = buttonParent.localToGlobal (new Point (button.x + button.width / 2, button.y + button.height));
            }
            return positionPoint;
        }

        private function selectLanguageButton (button:Button):void {
            for (var i:int = 0; i < languageButtons.length; i++) {
                var currentLanguageButton:Button = languageButtons [i];
                currentLanguageButton.visible = !(currentLanguageButton == button);
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            switch (event.currentTarget) {
                case (btnRu):
                    textsManager.setCurrentLanguage (TextsManager.RU, true);
                    break;
                case (btnEn):
                    textsManager.setCurrentLanguage (TextsManager.EN, true);
                    break;
                case btnSoundOn:
                    SoundManager.instance.enableSound = true;
                    break;
                case btnSoundOff:
                    SoundManager.instance.enableSound = false;
                    break;
                case btnMusicOn:
                    SoundManager.instance.enableMusic = true;
                    break;
                case btnMusicOff:
                    SoundManager.instance.enableMusic = false;
                    break;
            }
        }

        private function rollOverListener (event:MouseEvent):void {
            var tooltipText:String;
            switch (event.currentTarget) {
                case btnSoundOn:
                    tooltipText = textsManager.getText ("ttSoundOn");
                    break;
                case btnSoundOff:
                    tooltipText = textsManager.getText ("ttSoundOff");
                    break;
                case btnMusicOn:
                    tooltipText = textsManager.getText ("ttMusicOn");
                    break;
                case btnMusicOff:
                    tooltipText = textsManager.getText ("ttMusicOff");
                    break;
                case btnRu:
                    tooltipText = textsManager.getText ("ttRussian");
                    break;
                case btnEn:
                    tooltipText = textsManager.getText ("ttEnglish");
                    break;
            }
            if (tooltipText) {
                var positionPoint:Point = getTooltipPositionByButton (Button (event.currentTarget));
                BreakdanceApp.instance.showTooltipMessage (tooltipText, positionPoint);
            }
        }
        
        private function changeMusicControllerListener (event:SoundManagerEvent):void {
            var enable:Boolean = SoundManager.instance.enableMusic;
            btnMusicOn.visible = !enable;
            btnMusicOff.visible = enable;
        }

        private function changeSoundControllerListener (event:SoundManagerEvent):void {
            var enable:Boolean = SoundManager.instance.enableSound;
            btnSoundOn.visible = !enable;
            btnSoundOff.visible = enable;
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }

    }
}
