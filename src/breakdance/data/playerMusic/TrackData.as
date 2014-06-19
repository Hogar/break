package breakdance.data.playerMusic 
{
	/**
	 * ...
	 * @author gray_crow
	 */
	public class TrackData 
	{

		private var _aid:String;
        private var _artist:String;
        private var _duration:int;
        private var _lyrics_id:String;
        private var _owner_id:int;
        private var _title:String;
		private var _url:String;        
            
		public function TrackData() 
		{
			
		}
		
		public function get aid ():String {
            return _aid;
        }

        public function set aid (value:String):void {
            _aid = value;
        }		
				
		public function get artist ():String {
            return _artist;
        }

        public function set artist (value:String):void {
            _artist = value;
        }		
				
		public function get duration ():int {
            return _duration;
        }

        public function set duration (value:int):void {
            _duration = value;
        }
		
		public function get lyricsId ():String {
            return _lyrics_id;
        }

        public function set lyricsId (value:String):void {
            _lyrics_id = value;
        }		
				
		public function get ownerId ():int {
            return _owner_id;
        }

        public function set ownerId(value:int):void {
            _owner_id = value;
        }
		
		public function get title ():String {
            return _title;
        }

        public function set title(value:String):void {
            _title = value;
        }	

		public function get url():String {
            return _url;
        }

        public function set url(value:String):void {
            _url = value;
        }	
		
		
//  283158957   Twin Twin  167  156765980  5781649  Moustache (Евровидение 2014. Франция)  http://cs9-15v4.vk.me/p23/6301f17c9fe1b6.mp3?extra=6Avww1-R7ygCf1CCYIQ63-fogfh5DPRw33FHve3XbSU_qVcRxkred2G09jsd-JPFO2iwU4MGKIuSrOKFKot9YmrnwS49NiuW
//  283155191   Molly  182  164109516  5781649  Children Of The Universe (Евровидение 2014, Великобритания)   http://cs9-7v4.vk.me/p7/ad8769e7e7c843.mp3?extra=GEFcIuKHJVDKqMEIfHo1X5e74QdiJskty4yQzqMhkyPxYkyg8_bgCxdDCwurTZaIy5-EyG--6JrD1KBw841SS-UcDqy463nA
//Tracer.log('_listTrack  '+trackData.aid+'  '+trackData.artist+'  '+ trackData.duration+'  '+trackData.lyricsId+'  '+trackData.ownerId+'  '+trackData.title+'  '+trackData.url )
     
	}

}
