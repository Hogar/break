package breakdance.ui.popups.playerMusicPopUp 
{
	
	import breakdance.data.playerMusic.TrackData;
	import breakdance.core.sound.SoundManager;
	import breakdance.ui.popups.playerMusicPopUp.events.ChangePlayerDataEvent;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import breakdance.core.js.JsApi;
	import breakdance.core.js.JsQueryResult;
	import com.hogargames.debug.Tracer;
	import breakdance.core.server.ServerTime;
	/**
	 * ...
	 * @author gray_crow
	 */
	public class GroupTracks extends EventDispatcher
	{
		private static const COUNT_TAKE_TRACK : int = 20;
		private static const SOUND_NONE : int = 0;
		private static const SOUND_PLAY : int = 1; 
		private static const SOUND_PAUSE : int = 2;
		
		private var _idGroup		: int; // 0 - моя музыка
		private var _nameGroup		: String;
		private var _listTrack		: Vector.<TrackData>;
		private var _currentTrack	: int;
		private var _currentName	: String;				
		private var _currentAutor	: String;				
		private var _maxCountTrack 	: int;
		private var isPlay 			: Boolean; // флаг нужно ли проигрывать музыку после завершения обновления группы
		private var _pause		 	: Boolean;
		private var _clear		 	: Boolean;
		private var _shuffle	 	: Boolean;
		private var timerTrack		: Timer;
		private var _startTimer		: Number;
		private var _residualTime	: Number;
		
		public function GroupTracks(id: int, nameGroup:String) 
		{			
			super();
			_idGroup = id;
			_nameGroup = nameGroup;
			_listTrack = new Vector.<TrackData> ();
			timerTrack  = new Timer(1000, 1);
			timerTrack.addEventListener(TimerEvent.TIMER_COMPLETE, onEndTimeTrack);
			_pause = true;
			_clear = true;
			_shuffle = false;
			_currentTrack = 0;
			_currentName = '';
			_maxCountTrack = 100000;	
		}				

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

 
		public function showGroup(shuffle:Boolean):void {
			_currentTrack = 0;
			_shuffle = shuffle; 
			timerTrack.reset();
			updateSong();
			clearSong();
		}	
		
		public function hideGroup():void {
			timerTrack.stop();
			_pause = true;
			clearSong();
			SoundManager.instance.pauseSong(_pause);		
		}	
		
		public function get captionSong():String {
			if ( _currentAutor==null ||_currentName== null || (_currentName == '' && _currentAutor == '' ))return '';
			var title:String = ' '+_currentName +' - ' + _currentAutor+' ';			
			while (title.length < 38) 
				title = ' ' + title + ' ';
			return title;
		}
		
		public function get hitSong():String {			
			if ( _currentAutor==null ||_currentName== null || (_currentName == '' && _currentAutor == '' )) return '';
			var title:String = _currentName +'<br>' + _currentAutor;			
			return title;
		}
		
		public function get captionGroup():String {
			return _nameGroup;			
		}
		
		public function get nextBtnEnabled():Boolean {
			return (_currentTrack < _maxCountTrack);
		}		
		
		public function get previousBtnEnabled():Boolean {
			return (_currentTrack >0);
		}
		
		public function get playBtnEnabled():Boolean {
			return (_maxCountTrack >0);
		}
		
		public function set pause(val:Boolean):void {
			_pause = val;
			playSong();
		}		

		public function nextSongPlay():void {
			if (_shuffle) _currentTrack = int(Math.random() * _listTrack.length+10);
			_currentTrack++;	
			_clear = true;
			playSong();
		}

		public function previousSongPlay():void {
			if (_shuffle) _currentTrack = int(Math.random() * _listTrack.length+10);
			_currentTrack--;	
			_clear = true;
			playSong();
		}
		
		public function playSong():void {
			Tracer.log('playSong   '+_currentTrack)
			if (_currentTrack < 0) _currentTrack = 0;
			if (_currentTrack < _listTrack.length) {
				showCurSongAndPlay();
				return;
			}	
			if ( _currentTrack < _maxCountTrack) {
				isPlay = true;
				updateSong();	
			}
			else {
				//проигрываем сначала
				_currentTrack = 0;
				showCurSongAndPlay();
			}	
		}
		
		public function clearSong():void {
			_clear = true;
			SoundManager.instance.clearSong();
		}	
		
		public function set shuffle(val:Boolean):void {
			//не перемешивать, а брать рандомно из того
			_shuffle = val;
		}
		
		public function destroy():void {
			
			if (timerTrack) {
				timerTrack.stop();	
				timerTrack.removeEventListener(TimerEvent.TIMER_COMPLETE, onEndTimeTrack);
			}
			while (_listTrack && _listTrack.length > 0) {				
				_listTrack.shift();
			}
			_listTrack = null;
		}

//////////////////////////////////
//PRIVATE:
//////////////////////////////////

		// подгрузка следующей группы песен
		private function updateSong():void {
			Tracer.log('updateSong    '+_listTrack.length +'  == '+_currentTrack +'  <  '+_maxCountTrack)
			if (_listTrack.length <= _currentTrack && _currentTrack < _maxCountTrack) {
				if (_idGroup==0) JsApi.instance.query (JsApi.AUDIO_LIST, onAudioList, [_listTrack.length, COUNT_TAKE_TRACK]);							 
				else JsApi.instance.query (JsApi.GET_GROUP_AUDIO, onAudioList, [_idGroup, _listTrack.length, COUNT_TAKE_TRACK]);							 
			}	
		}
		
		// прокрутить текущую композицию
		private function playCurrentSong():void {
			Tracer.log('playCurrentSong  ' + _currentTrack + '    ' + _listTrack.length + '   ' + _pause);
			
			//если пауза - показать текущую композицию
			if (_pause) {				
				SoundManager.instance.pauseSong(true);		
				Tracer.log('Stop   timerTrack.delay   ' +timerTrack.delay +'    _residualTime = '+_residualTime+'    _startTimer = '+_startTimer);
				_residualTime -= (ServerTime.instance.time -_startTimer);
				_startTimer = ServerTime.instance.time;
				timerTrack.stop();
				Tracer.log('Stop 222  timerTrack.delay   ' +timerTrack.delay +'    _residualTime = '+_residualTime+'    _startTimer = '+_startTimer);
			}
			else  {
				if (_clear) {												
					SoundManager.instance.playSong (_listTrack[_currentTrack].url);			
					//SoundManager.instance.pauseSong(false);					
					timerTrack.delay = _listTrack[_currentTrack].duration *1000;
					timerTrack.reset();
					timerTrack.start();
					_startTimer = ServerTime.instance.time;
					_residualTime = _listTrack[_currentTrack].duration * 1000; 
					dispatchEvent (new ChangePlayerDataEvent (ChangePlayerDataEvent.CHANGE_NAME_SONG));
					Tracer.log('Restart   timerTrack.delay   ' +timerTrack.delay +'   _startTimer = '+_startTimer);
					_clear = false;  // т.е. проигрывается текущая песня					
					
				}
				else {
					Tracer.log('Start   timerTrack.delay   ' +timerTrack.delay +'    timerTrack.currentCount = ' + timerTrack.currentCount);
					timerTrack.delay = _residualTime;// * 1000;
					timerTrack.reset();
					timerTrack.start();
					SoundManager.instance.pauseSong(false);		
				}
				Tracer.log('timerTrack.delay   ' +timerTrack.delay +'    timerTrack.currentCount = '+timerTrack.currentCount);
			}			
		}
		
		private function onAudioList(response:JsQueryResult):void {			
			 if (response && response.success) {
				var count: int = 0;
			    var resp:Object = response.data.response;                
                for each (var obj:Object in resp) {                    			
					if (obj is Object && !(obj is Number )) {
						var trackData:TrackData = new TrackData ();					
						trackData.aid = obj.aid;
						trackData.artist = obj.artist;
						trackData.duration = obj.duration;
						trackData.lyricsId = obj.lyrics_id;
						trackData.ownerId = obj.owner_id;
						trackData.title = obj.title; 
						trackData.url = obj.url;
					//	Tracer.log('_listTrack  '+trackData.aid+'  '+trackData.artist+'  '+ trackData.duration+'  '+trackData.lyricsId+'  '+trackData.ownerId+'  '+trackData.title+'  '+trackData.url )
						_listTrack.push (trackData);
						count++;
					}	
                }
            }   
			if (count < COUNT_TAKE_TRACK)				
				_maxCountTrack = _listTrack.length;
			Tracer.log('_maxCountTrack   '+_maxCountTrack);	
			if (isPlay == true)		showCurSongAndPlay();
        }		

		private function showCurSongAndPlay():void {			
			if (_currentTrack >= _listTrack.length) return;						
			_currentName = _listTrack[_currentTrack].title;
			_currentAutor = _listTrack[_currentTrack].artist;
			Tracer.log('showCurSongAndPlay   '+_idGroup+'       _currentName   '+_currentName)			
			playCurrentSong();
		}
		
		private function onEndTimeTrack(ev:TimerEvent):void {
			nextSongPlay();
		}
		
	}

}