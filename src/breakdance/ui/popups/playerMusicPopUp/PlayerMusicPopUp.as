package breakdance.ui.popups.playerMusicPopUp 
{
	import breakdance.core.js.JsQueryResult;
	import breakdance.data.playerMusic.GroupCollection;
	import breakdance.data.playerMusic.TrackData;
	import breakdance.ui.commons.buttons.Button;
	import breakdance.ui.commons.buttons.ButtonPressed;
	import breakdance.ui.popups.basePopUps.TitleClosingPopUp;
	import com.adobe.utils.StringUtil;
	import com.hogargames.display.GraphicStorage;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import breakdance.template.Template;
	import flash.events.MouseEvent;
	import breakdance.core.js.JsApi;
	import breakdance.core.sound.SoundManager;
	import com.hogargames.debug.Tracer;
	import flash.utils.Timer;
	import breakdance.ui.popups.playerMusicPopUp.GroupTracks;
	import breakdance.data.playerMusic.GroupData;
	import breakdance.ui.popups.playerMusicPopUp.events.ChangePlayerDataEvent;
	import breakdance.BreakdanceApp;
	import breakdance.core.sound.events.SoundManagerEvent;
	import breakdance.ui.commons.tooltip.TooltipOrientation;
	import breakdance.core.texts.TextsManager;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author gray_crow
	 */
	public class PlayerMusicPopUp  extends TitleClosingPopUp
	{
		private static const RADIO: int = 0;
		private static const VK_MY: int = 1;
		private static const VK_GR: int = 2;
		private static const COUNT_TAKE_TRACK : int = 100;
		
		
		private var btnPrevSource	: Button;
		private var btnPrevTrack	: Button;
		private var btnNextSource	: Button;
		private var btnNextTrack	: Button;		
		private var btnPlay			: Button;		
		private var btnStop			: Button;		
		
		private var btnShuffle		: ButtonPressed;
		private var tfNameTrack		: TextField;
		private var tfSource		: TextField;
		private var tfNameSource	: TextField;
		
		private var _listGroup		: Vector.<GroupTracks>;
		private var collectGroup	: Vector.<GroupData>;
		private var _currentSource	: int;		
		private var _lastSourceTrack: int;				
		private var _pause 			: Boolean;
		private var _timer			: Timer;		
		private var btnRu			:Button;
        private var btnEn			:Button;
		
		public function PlayerMusicPopUp() 
		{
			super (Template.createSymbol (Template.PLAYER_MUSIC_POP_UP));	
			
			_lastSourceTrack = -1;
			_currentSource = PlayerMusicPopUp.RADIO;			
			_timer = new Timer(150)
			_timer.addEventListener(TimerEvent.TIMER, onTimer);

			_listGroup = new Vector.<GroupTracks>;
			_listGroup.push(null);
			
			var groupTrack: GroupTracks = new GroupTracks(0, textsManager.getText ("playerMusicSourceMyMusic"))
			groupTrack.addEventListener(ChangePlayerDataEvent.CHANGE_NAME_SONG, onChangeNameTrack);
			_listGroup.push(groupTrack);
			
			collectGroup = GroupCollection.instance.list;		   
			for (var i: int = 0; i < collectGroup.length; i++) {				
				groupTrack = new GroupTracks(collectGroup[i].groupId,collectGroup[i].groupName);
				_listGroup.push(groupTrack);
				groupTrack.addEventListener(ChangePlayerDataEvent.CHANGE_NAME_SONG, onChangeNameTrack);
			}	
		}		
		

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
	
			if (tfNameTrack.text != '') {
				_timer.reset();
				_timer.start();
			}			
			var enable:Boolean = SoundManager.instance.enableMusic;
			if (enable == true) {
				pauseSound(false);
			}
			checkBtn();
		    super.show ();
        }
		
		override public function hide ():void {
			_timer.stop()
			super.hide();
		}

        override public function setTexts ():void {
			
            tfTitle.text = textsManager.getText ("playerMusicTitle");
            tfSource.text = textsManager.getText ("playerMusicSource");			
			if (_currentSource ==  PlayerMusicPopUp.RADIO){
				tfNameSource.text =  textsManager.getText ("playerMusicSourceRadio");								
			}	
        }

        override public function destroy ():void {
   
            while  (_listGroup && _listGroup.length>0) {
                _listGroup[0].removeEventListener (ChangePlayerDataEvent.CHANGE_NAME_SONG, onChangeNameTrack);
                _listGroup[0].destroy ();
				_listGroup.shift();
            }
			_listGroup = null;
			
			
			destroyButton (btnNextSource);
			destroyButton (btnNextTrack);
			destroyButton (btnPlay);
			destroyButton (btnPrevSource);
			destroyButton (btnPrevTrack);
			destroyButton (btnStop);
			destroyButton (btnRu);
			destroyButton (btnEn);

			if (btnShuffle) {
				btnShuffle.removeEventListener (MouseEvent.CLICK, clickListener);
				btnShuffle.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
				btnShuffle.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
				btnShuffle.destroy ();
			}	
			
            super.destroy ();
        }
		
		public function getNameTrack():String {
			var namesong:String = _listGroup[_currentSource].hitSong; 
			return namesong;			
		}


/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            btnPrevSource = new Button(getElement ("btnPrevS"));
            btnPrevTrack = new Button(getElement ("btnPrevT"));
			btnNextSource = new Button(getElement ("btnNextS"));
			btnNextTrack = new Button(getElement ("btnNextT"));
			btnPlay = new Button(getElement ("btnPlay"));
			btnStop = new Button(getElement ("btnStop"));
            tfNameTrack = getElement ("txtNameTrack");
            tfNameSource = getElement ("txtNameSource");
			tfSource = getElement ("txtSource");
		    btnRu = new Button (getElement("btnRu"));
		    btnEn = new Button (getElement("btnEn"));			
		    btnShuffle = new ButtonPressed(getElement ("btnShuffle"));
            initButton(btnPrevSource);
            initButton(btnPrevTrack);
            initButton(btnNextSource);
            initButton(btnNextTrack);
            initButton(btnPlay);
			initButton(btnStop);			
			initButton(btnRu);
			initButton(btnEn);
			
			btnShuffle.addEventListener (MouseEvent.CLICK, clickListener);
			btnShuffle.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            btnShuffle.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
			
			SoundManager.instance.addEventListener(SoundManagerEvent.CHANGE_MUSIC_CONTROLLER, musicManagerMuteListener);          	
        }

		
        override protected function onClickCloseButton ():void {
		    hide ();
        }
		
/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

		private function changeSource(val:int):void {
			var ps:Boolean = _pause;
			pauseSound(true);	
			if (_currentSource !=  PlayerMusicPopUp.RADIO){
				_listGroup[_currentSource].hideGroup();			
			}
			_currentSource += val;			
			if (_currentSource >= _listGroup.length)
				_currentSource = 0;                    					
			changeState();
			checkBtn();			
			if (ps == false) {
				// запускаем сразу плеер
				pauseSound(false);			
			}
		}

		private function musicManagerMuteListener(ev:Event):void {
			pauseSound(SoundManager.instance.enableMusic);				
		}
		
				
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

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
			Tracer.log('clickListener    _currentSource  = ' + _currentSource+'      '+event.currentTarget.name);
		    switch (event.currentTarget) {
                case btnPrevSource:
					changeSource(-1);
					Tracer.log('  btnPrevSource    '+_currentSource)
                    break;
                case btnNextSource:
					changeSource(1);				
					Tracer.log('  btnNextSource    '+_currentSource)
                    break;					
                case btnPrevTrack:
					Tracer.log('  btnPrevTrack    '+_currentSource)
					if (_currentSource != PlayerMusicPopUp.RADIO) {						
						_listGroup[_currentSource].previousSongPlay();
						tfNameTrack.text = _listGroup[_currentSource].captionSong;
						_timer.reset();
						_timer.start();
					}				
					checkBtn();
                    break;										
                case btnNextTrack:				
					Tracer.log('  btnNextTrack    '+_currentSource)
					if (_currentSource != PlayerMusicPopUp.RADIO){
						_listGroup[_currentSource].nextSongPlay();
						tfNameTrack.text = _listGroup[_currentSource].captionSong ;						
						_timer.reset();
						_timer.start();						
					}	
					checkBtn();
                    break;										
                case  btnPlay: 												
					Tracer.log('  btnPlay    ' + _currentSource)
					pauseSound(false);	
					break;
                case  btnStop: 					
					Tracer.log('  btnStop    ')
					pauseSound(true);
					checkBtn();
					break;
				case btnShuffle:
					Tracer.log('  btnShuffle    ')
					_listGroup[_currentSource].shuffle = btnShuffle.pressed;
					checkBtn();
					break;
                case (btnRu):
                    textsManager.setCurrentLanguage (TextsManager.RU, true);
                    break;
                case (btnEn):
                    textsManager.setCurrentLanguage (TextsManager.EN, true);
                    break;					
            }
			
        }
		
		
        private function rollOverListener (event:MouseEvent):void {
            var tooltipText:String;
            switch (event.currentTarget) {
                case btnPrevSource:
                    tooltipText = textsManager.getText ("pmBtnHitPrevSource");
                    break;
                case btnNextSource:
                    tooltipText = textsManager.getText ("pmBtnHitNextSource");
                    break;
                case btnPrevTrack:
                    tooltipText = textsManager.getText ("pmBtnHitPrevTrack");
                    break;
                case btnNextTrack:
                    tooltipText = textsManager.getText ("pmBtnHitNextTrack");
                    break;
                case btnPlay:
                    tooltipText = textsManager.getText ("pmBtnHitPlay");
                    break;
                case btnStop:
                    tooltipText = textsManager.getText ("pmBtnHitStop");
                    break;
                case btnShuffle:
                    tooltipText = textsManager.getText ("pmBtnHitShuffle");
                    break;       				
                case btnRu:
                    tooltipText = textsManager.getText ("ttRussian");
                    break;
                case btnEn:
                    tooltipText = textsManager.getText ("ttEnglish");
                    break;
            }
            if (tooltipText) {
                var positionPoint:Point = getTooltipPositionByButton (Sprite (event.currentTarget));
				Tracer.log('positionPoint   '+positionPoint+'           tooltipText  '+tooltipText)
                BreakdanceApp.instance.showTooltipMessage (tooltipText, positionPoint);
            }
        }
		
		private function getTooltipPositionByButton (button:Sprite):Point {
            var buttonParent:DisplayObjectContainer = button.parent;
            var positionPoint:Point;
            if (buttonParent) {
                positionPoint = buttonParent.localToGlobal (new Point (button.x + button.width / 2, button.y + button.height));
            }
            return positionPoint;
        }
		
		
		private function checkBtn():void {			
			btnShuffle.visible = (_currentSource != PlayerMusicPopUp.RADIO);
			btnPlay.enable =  (_currentSource == PlayerMusicPopUp.RADIO) || _listGroup[_currentSource].playBtnEnabled;
			btnNextTrack.enable = 	(_currentSource != PlayerMusicPopUp.RADIO) && _listGroup[_currentSource].nextBtnEnabled;
			btnPrevTrack.enable =  (_currentSource != PlayerMusicPopUp.RADIO) &&_listGroup[_currentSource].previousBtnEnabled;
			btnPrevSource.enable = (_currentSource > 0);
			btnNextSource.enable = (_currentSource < _listGroup.length - 1);
		
		}
		
		private function pauseSound(val:Boolean):void {
			Tracer.log(' pauseSound   '+val +'     _lastSourceTrack  =  '+_lastSourceTrack+'    _currentSource '+_currentSource)
			_pause = val;
			btnPlay.visible = _pause;
			btnStop.visible = !_pause;
			
			//если до этого играло радио - оно должно продолжить играть, если не было переключений между источниками
			if (_currentSource ==  PlayerMusicPopUp.RADIO) {
				if (_pause == false && _lastSourceTrack != _currentSource) {
					Tracer.log('  SoundManager.instance.playRadio ();  ')
					SoundManager.instance.playRadio ();
					_lastSourceTrack = _currentSource;
					return;
				}
				SoundManager.instance.pauseSong(_pause);
				return;
			}
			
			_listGroup[_currentSource].pause = _pause;
			_lastSourceTrack = _currentSource;
		}
		
		private function changeState():void {		
			
			if (_currentSource ==  PlayerMusicPopUp.RADIO){
				tfNameSource.text =  textsManager.getText ("playerMusicSourceRadio");								
				tfNameTrack.text = ' ';
			}
			else{
				tfNameSource.text = _listGroup[_currentSource].captionGroup;			
				_listGroup[_currentSource].showGroup(btnShuffle.pressed);	
				tfNameTrack.text = '';
			}		 
		}
		
		private function onChangeNameTrack(ev:ChangePlayerDataEvent):void {			
			tfNameTrack.text = _listGroup[_currentSource].captionSong;				       
			var positionPoint:Point = BreakdanceApp.instance.background.coordHitMusic;
			Tracer.log('PMPU : onChangeNameTrack  :  hitSong   ' + _listGroup[_currentSource].hitSong+'      '+positionPoint )
			BreakdanceApp.instance.showTooltipMessageSong (_listGroup[_currentSource].hitSong, positionPoint, false, TooltipOrientation.TOP, 5);			
		}
		
		private function onTimer(ev:TimerEvent):void {
			if (tfNameTrack.text.length == 0) return;
			tfNameTrack.text = circulationText(tfNameTrack.text);			
		}
		
		private function circulationText(str:String):String {
			return str.slice(1, str.length) + str.slice(0, 1);
		}
	
	}


}
