package breakdance.ui.popups.playerMusicPopUp 
{
	
	import breakdance.data.playerMusic.TrackData;
	import breakdance.core.sound.SoundManager;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import breakdance.core.js.JsApi;
	import breakdance.core.js.JsQueryResult;
	import com.hogargames.debug.Tracer;
	
	/**
	 * ...
	 * @author gray_crow
	 */
	public class GroupTracks 
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
		private var _maxCountTrack 	: int;
		private var isPlay 			: Boolean; // флаг нужно ли проигрывать музыку после завершения обновления группы
		private var _pause		 	: Boolean;
		private var timerTrack		: Timer;
		
		public function GroupTracks(id: int, nameGroup:String) 
		{			
			_idGroup = id;
			_nameGroup = nameGroup;
			_listTrack = new Vector.<TrackData> ();
			timerTrack  = new Timer(1000, 1);
			timerTrack.addEventListener(TimerEvent.TIMER_COMPLETE, onEndTimeTrack);
			_pause = false;
			_currentTrack = 0;
			_currentName = '[пусто]';
			_maxCountTrack = 100000;	
		}				
			
		public function showGroup():void {
			_currentTrack = 0;
			timerTrack.reset();
			_currentName = _listTrack[_currentTrack].title +' - '+_listTrack[_currentTrack].artist;
			updateSong();
		}	
		
		public function hideGroup():void {
			timerTrack.stop();
			_pause = true;
			SoundManager.instance.pauseSong(_pause);		
		}	
		
		// подгрузка следующей группы песен
		public function updateSong():void {
			Tracer.log('updateSong    '+_listTrack.length +'  == '+_currentTrack +'  <  '+_maxCountTrack)
			if (_listTrack.length <= _currentTrack && _currentTrack < _maxCountTrack) {
				if (_idGroup==0) JsApi.instance.query (JsApi.AUDIO_LIST, onAudioList, [_listTrack.length, COUNT_TAKE_TRACK]);							 
				else JsApi.instance.query (JsApi.GET_GROUP_AUDIO, onAudioList, [_idGroup, _listTrack.length, COUNT_TAKE_TRACK]);							 
			}	
		}
		
		public function get captionSong():String {
			while (_currentName.length < 60) 
				_currentName = ' ' + _currentName + ' ';
			return _currentName;
		}
		
		public function get captionGroup():String {
			return 'Группа ' + _nameGroup;			
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
			SoundManager.instance.pauseSong(_pause);		
			if (_pause) timerTrack.start();
			else  timerTrack.stop();
		}
		
		public function playSong():void {
			
			if (_currentTrack < 0) _currentTrack = 0;
			if (_currentTrack >= _listTrack.length && _currentTrack < _maxCountTrack) {
				isPlay = true;
				updateSong();	
			}
			else {
				playCurrentSong();
			}		
		}
		
		public function nextSongPlay():void {
			_currentTrack++;	
			playSong();
		}

		public function previousSongPlay():void {
			_currentTrack--;	
			playSong();
		}
		
		// прокрутить текущую композицию
		private function playCurrentSong():void {
			Tracer.log('playCurrentSong  ' + _currentTrack + '    ' + _listTrack.length + '   ' + _pause);
			if (_currentTrack >= _listTrack.length) return;
				_currentName = _listTrack[_currentTrack].title +' - '+_listTrack[_currentTrack].artist;
			if (_pause == false){
				SoundManager.instance.playSong (_listTrack[_currentTrack].url);			
				timerTrack.delay = _listTrack[_currentTrack].duration *1000;
				timerTrack.reset();
				timerTrack.start();
				Tracer.log('timerTrack.delay   ' +timerTrack.delay );
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
				if (count < COUNT_TAKE_TRACK)				
					_maxCountTrack = _listTrack.length;
            }   
			if (isPlay == true)		playCurrentSong();
        }		

		
		private function onEndTimeTrack(ev:TimerEvent):void {
			_currentTrack++;
			nextSongPlay();
		}
		
	}

}