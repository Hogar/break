package breakdance.ui.popups.playerMusicPopUp 
{
	import breakdance.core.js.JsQueryResult;
	import breakdance.data.playerMusic.GroupCollection;
	import breakdance.data.playerMusic.TrackData;
	import breakdance.ui.commons.buttons.Button;
	import breakdance.ui.popups.basePopUps.TitleClosingPopUp;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import breakdance.template.Template;
	import flash.events.MouseEvent;
	import breakdance.core.js.JsApi;
	import breakdance.core.sound.SoundManager;
	import com.hogargames.debug.Tracer;
	import flash.utils.Timer;
	import breakdance.ui.popups.playerMusicPopUp.GroupTracks;
	import breakdance.data.playerMusic.GroupData;
	
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
		
		private var btnShuffle		: Button;
		private var tfNameTrack		: TextField;
		private var tfNameSource	: TextField;
		
		private var _listGroup		: Vector.<GroupTracks>;
		private var collectGroup	: Vector.<GroupData>
		private var _currentSource	: int;		
		private var _currentPlaySourceTrack	: int;				
		private var _pause 			: Boolean;
		private var _timer			: Timer;		
		
		
		public function PlayerMusicPopUp() 
		{
			super (Template.createSymbol (Template.PLAYER_MUSIC_POP_UP));	
			
			_currentPlaySourceTrack = -1;
			_currentSource = PlayerMusicPopUp.RADIO;			
			_timer = new Timer(200)
			_timer.addEventListener(TimerEvent.TIMER, onTimer);

			_listGroup = new Vector.<GroupTracks>;
			_listGroup.push(null);
			_listGroup.push( new GroupTracks(0,'моя музыка'));
			collectGroup = GroupCollection.instance.list;		   
			for (var i: int = 0; i < collectGroup.length; i++) {				
				var groupTrack: GroupTracks = new GroupTracks(collectGroup[i].groupId,collectGroup[i].groupName);
				_listGroup.push(groupTrack);
			}
			
		}		
		

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
			
            super.show ();
			
        }

        override public function setTexts ():void {

            tfTitle.text = textsManager.getText ("playerMusicTitle");
            tfNameSource.text = textsManager.getText ("playerMusicSource");			
			
		//	_listGroup = [2571232,333930,33836955,45025374,32115422,4539148];
            
        }

        override public function destroy ():void {
   /*
            if (btnGroup) {
                btnGroup.removeEventListener (MouseEvent.CLICK, clickListener);
                btnGroup.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                btnGroup.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                btnGroup.destroy ();
                btnGroup = null;
            }
     */

            super.destroy ();
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
            btnShuffle = new Button(getElement ("btnShuffle"));
            
            //tfReward.mouseEnabled = false;            
            //tfBucks.htmlText = "<b>" + String (fiveStepsAward.bucks) + "</b>";

            btnPrevSource.addEventListener (MouseEvent.CLICK, clickListener);
            btnPrevTrack.addEventListener (MouseEvent.CLICK, clickListener);
            btnNextSource.addEventListener (MouseEvent.CLICK, clickListener);
            btnNextTrack.addEventListener (MouseEvent.CLICK, clickListener);
            btnPlay.addEventListener (MouseEvent.CLICK, clickListener);
			btnStop.addEventListener (MouseEvent.CLICK, clickListener);

           // BreakdanceApp.instance.appUser.addEventListener (ChangeUserEvent.CHANGE_USER, changeUserListener);	
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////



/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
			Tracer.log('clickListener    _currentSource  = ' + _currentSource+'      '+event.currentTarget.name);
			if (_listGroup[_currentSource]) Tracer.log('clickListener    '+_listGroup[_currentSource].captionGroup)
            switch (event.currentTarget) {
                case btnPrevSource:
					Tracer.log('  btnPrevSource    ')
					//останавливаем музыку
					pauseSound();
					if (_currentSource != PlayerMusicPopUp.RADIO) 
						_listGroup[_currentSource].hideGroup();
                    _currentSource--;
				    if (_currentSource < 0) 
						_currentSource = _listGroup.length - 1;															
					changeState();					
					checkBtn();
					Tracer.log('  btnPrevSource    '+_currentSource)
                    break;
                case btnNextSource:
					Tracer.log('  btnNextSource    ')
					pauseSound();
					if (_currentSource != PlayerMusicPopUp.RADIO)
						_listGroup[_currentSource].hideGroup();
                    _currentSource++;
				    if (_currentSource >= _listGroup.length)
						_currentSource = 0;                    					
					changeState();
					checkBtn();
					Tracer.log('  btnNextSource    '+_currentSource)
                    break;					
                case btnPrevTrack:
					Tracer.log('  btnPrevTrack    '+_currentSource)
					if (_currentSource != PlayerMusicPopUp.RADIO) {						
						_listGroup[_currentSource].previousSongPlay();
						tfNameTrack.text = ' '+_listGroup[_currentSource].captionSong+' ';
						_timer.reset();
						_timer.start();
					}				
					checkBtn();
                    break;										
                case btnNextTrack:				
					Tracer.log('  btnNextTrack    '+_currentSource)
					if (_currentSource != PlayerMusicPopUp.RADIO){
						_listGroup[_currentSource].nextSongPlay();
						tfNameTrack.text = ' ' + _listGroup[_currentSource].captionSong + ' ';						
						_timer.reset();
						_timer.start();						
					}	
					checkBtn();
                    break;										
                case  btnPlay: 				
					_pause = false;					
					Tracer.log('  btnPlay    '+_currentSource)
					if (_currentSource ==  PlayerMusicPopUp.RADIO){
							Tracer.log('Радио');
							SoundManager.instance.playRadio ();
					}
					else {
						Tracer.log('btnPlay       play song ' + _listGroup[_currentSource].captionSong);						
						if (_currentPlaySourceTrack == _currentSource)
							_listGroup[_currentSource].pause = _pause;
						else{	
							_listGroup[_currentSource].playSong();
							_currentPlaySourceTrack = _currentSource;
							tfNameTrack.text = _listGroup[_currentSource].captionSong;
						}	
						_timer.reset();
						_timer.start();						
					}
					btnPlay.visible = false;
					btnStop.visible = true;
					checkBtn();
					Tracer.log('  btnPlay.visible    '+btnPlay.visible)
					break;
                case  btnStop: 
					Tracer.log('  btnStop    ')
					pauseSound();
					checkBtn();
					break;
					
            }
			
        }
		
		private function checkBtn():void {
			btnPlay.enable =  _listGroup[_currentSource].playBtnEnabled;
			btnNextTrack.enable =  _listGroup[_currentSource].nextBtnEnabled;
			btnPrevTrack.enable =  _listGroup[_currentSource].previousBtnEnabled;
		}
		
		private function pauseSound():void {
			_pause = true;
			btnPlay.visible = true;
			btnStop.visible = false;
			_timer.stop();
            SoundManager.instance.pauseSong(_pause);		
			if (_currentSource !=  PlayerMusicPopUp.RADIO){
				_listGroup[_currentSource].pause = _pause;
			}	
		}
		
		private function changeState():void {		
			
			if (_currentSource ==  PlayerMusicPopUp.RADIO){
				tfNameSource.text = textsManager.getText ("playerMusicSource") + 'радио';								
			}
			else{
				tfNameSource.text = textsManager.getText ("playerMusicSource") +_listGroup[_currentSource].captionGroup;			
				_listGroup[_currentSource].showGroup();	
			}		 
		}
		
		private function onTimer(ev:TimerEvent):void {
			tfNameTrack.text = circulationText(tfNameTrack.text);			
		}
		
		private function circulationText(str:String):String {
			return str.slice(1, str.length) + str.slice(0, 1);
		}
	
	}


}
