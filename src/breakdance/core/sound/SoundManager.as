package breakdance.core.sound {

    import breakdance.BreakdanceApp;
    import breakdance.core.sound.events.SoundControllerEvent;
    import breakdance.core.sound.events.SoundManagerEvent;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.sounds.SoundData;
    import breakdance.data.sounds.SoundsDataCollection;
    import breakdance.template.Template;

    import com.hogargames.errors.SingletonError;

    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.media.Sound;
    import flash.net.SharedObject;
    import flash.net.URLRequest;
    import flash.utils.Timer;

    public class SoundManager extends EventDispatcher {

        private static var _instance:SoundManager;

        private var musicController:SoundController = new SoundController ();
        private var soundsController:SoundController = new SoundController ();
        private var soundStack:Array = [];
        private var clearSoundsTimer:Timer;

        public var sharedObject:SharedObject;

        public static const SAVED_DATA:String = "savedData";

        public function SoundManager (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
            sharedObject = SharedObject.getLocal (SAVED_DATA);
//            if (sharedObject.data.hasOwnProperty ("music")) {
//                musicController.mute = !sharedObject.data.music;
//            }
//            if (sharedObject.data.hasOwnProperty ("sound")) {
//                soundsController.enable = sharedObject.data.sound;
//            }

            var fps:int = 24;
            clearSoundsTimer = new Timer (1000 / fps);
            clearSoundsTimer.addEventListener (TimerEvent.TIMER, timerListener);
            clearSoundsTimer.start ();

            musicController.addEventListener(SoundControllerEvent.MUTE, musicManagerMuteListener);
            musicController.addEventListener(SoundControllerEvent.UNMUTE, musicManagerMuteListener);
        //    musicController.addEventListener(SoundControllerEvent.PAUSE, musicManagerPauseListener);
        //    musicController.addEventListener(SoundControllerEvent.RESUME, musicManagerPauseListener);

            soundsController.addEventListener(SoundControllerEvent.ENABLE, soundManagerEnableEvent);
            soundsController.addEventListener(SoundControllerEvent.DISABLE, soundManagerEnableEvent);

            musicController.mute = true;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public static function get instance ():SoundManager {
            if (!_instance) {
                _instance = new SoundManager (new SingletonKey ());
            }
            return _instance;
        }

        ///////////////////
        //MUSIC:
        ///////////////////

        public function playMusic (soundId:String, volumeCoefficient:Number = .6):void {
            SoundManager.instance.musicController.clear ();
            var sound:Sound = Template.createSymbol(soundId);
            SoundManager.instance.musicController.play (sound, -1, volumeCoefficient);
        }

        public function playRadio (volumeCoefficient:Number = .6):void {
            SoundManager.instance.musicController.clear ();
            var sound:Sound = new Sound ();
            var radioUrl:String = StaticData.instance.getSetting ("radio");
            try {				
                sound.load (new URLRequest (radioUrl));
                SoundManager.instance.musicController.play (sound, -1, volumeCoefficient);
				dispatchEvent(new SoundManagerEvent (SoundManagerEvent.CHANGE_MUSICSONG_CONTROLLER));
            }
            catch (error:Error) {
                //
            }
        }
		
		  public function get pauseMusic():Boolean {
			 return SoundManager.instance.musicController.pause;						 
		  }
		  
		  public function clearSong ():void {
			SoundManager.instance.musicController.clear ();
		  }
		
		  public function pauseSong (val:Boolean):void {
			SoundManager.instance.musicController.pause = val;
			dispatchEvent(new SoundManagerEvent (SoundManagerEvent.CHANGE_MUSICSONG_CONTROLLER));			
		  }
		  
		  public function playSong (songUrl:String, volumeCoefficient:Number = .6):void {
            SoundManager.instance.musicController.clear ();
            var sound:Sound = new Sound ();            
            try {
                sound.load (new URLRequest (songUrl));
                SoundManager.instance.musicController.play (sound, -1, volumeCoefficient);				
				dispatchEvent(new SoundManagerEvent (SoundManagerEvent.CHANGE_MUSICSONG_CONTROLLER));
            }
            catch (error:Error) {
                //
            }
        }

        public function playSound (soundId:String, volumeCoefficient:Number = 1, ignoreSoundStack:Boolean = false):void {
            if ((soundId != null) && (soundId != "")) {
                var soundData:SoundData = SoundsDataCollection.instance.getSoundData (soundId);
                if (soundData) {
                    volumeCoefficient = volumeCoefficient * soundData.volume;
                }
                if ((soundStack.indexOf (soundId) == -1) || ignoreSoundStack) {
                    var sound:Sound = Template.createSymbol (soundId);
                    SoundManager.instance.soundsController.play (sound, 0, volumeCoefficient);
                    soundStack.push (soundId);
                }
                else {
                    //trace ("sound " + soundId + " alredy played!!!");
                }
            }
        }

        public function playVoice (soundId:String, volumeCoefficient:Number = 1, ignoreSoundStack:Boolean = false):void {
            if ((soundId != null) && (soundId != "")) {
                soundId += "_" + TextsManager.instance.currentLanguage;
                SoundManager.instance.soundsController.clear ();
                playSound (soundId, volumeCoefficient, ignoreSoundStack);
            }
        }

        public function setParams (enableSound:Boolean, enableMusic:Boolean):void {
            soundsController.enable = enableSound;
            sharedObject.data.sound = enableSound;
            musicController.mute = !enableMusic;
            sharedObject.data.music = enableMusic;
        }

        public function get enableSound ():Boolean {
            return soundsController.enable;
        }

        public function set enableSound (value:Boolean):void {
            soundsController.enable = value;
            sharedObject.data.sound = value;
            BreakdanceApp.instance.appUser.saveUserSettings ();
        }

        public function get enableMusic ():Boolean {
            return !musicController.mute;
        }

        public function set enableMusic (value:Boolean):void {
            musicController.mute = !value;
            sharedObject.data.music = value;
            BreakdanceApp.instance.appUser.saveUserSettings ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private static function timerListener (event:TimerEvent):void {
            //updateSoundStack:
            if (instance.soundStack.length > 0) {
                instance.soundStack = [];
            }
        }

        private function soundManagerEnableEvent (event:SoundControllerEvent):void {
            dispatchEvent(new SoundManagerEvent (SoundManagerEvent.CHANGE_SOUND_CONTROLLER));
        }

        private function musicManagerMuteListener (event:SoundControllerEvent):void {
            dispatchEvent(new SoundManagerEvent (SoundManagerEvent.CHANGE_MUSIC_CONTROLLER));
        }
		
		private function musicManagerPauseListener (event:SoundControllerEvent):void {
            dispatchEvent(new SoundManagerEvent (SoundManagerEvent.CHANGE_MUSICSONG_CONTROLLER));
        }	

    }

}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}