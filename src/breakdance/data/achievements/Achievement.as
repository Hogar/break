package breakdance.data.achievements 
{
	import breakdance.core.staticData.StaticTableRow;
	import breakdance.core.texts.TextData;
	/**
	 * ...
	 * @author gray_crow
	 */
	public class Achievement 
	{	
		public static const MAX_COUNT_LEVEL :  int = 5;
		
        private var _id:String;
        private var _name:String;        
        
		private var _listTasks:Vector.<int>;  //задания 
		private var _listAwards:Vector.<String>;  //  награда за задания
		
		private var _textDataTitle:TextData;
		private var _textDataCaption:Vector.<TextData>;
				
		// id	phase1	phase2..5	award1_id	... award5_id
        public function Achievement (row:StaticTableRow) {
            _id = row.getAsString ("id");
			_textDataCaption = new Vector.<TextData>;
            _listTasks = new Vector.<int>;
			_listAwards = new Vector.<String>;			
			for (var i: int = 0; i < MAX_COUNT_LEVEL; i++ ) {
				var phase: int = row.getAsInt ("phase"+(i+1));
				if (phase>0){
					_listTasks.push(phase);
					_listAwards.push(row.getAsString ("award"+(i+1)+"_id"));
				}					
			}
        }

        public function get id ():String {
            return _id;
        }

		public function get countTask():int {
            return _listTasks.length;
        }
		
        public function getTasks (ind: int):int {
            return _listTasks[ind];
        }

        public function getAwards (ind:int):String {
            return _listAwards[ind];
        }
		
		public function get textDataTitle ():String {
            if (_textDataTitle) {
                return _textDataTitle.currentLanguageText;
            }
            else {
                return "---";
            }
        }
		
		public function getTextDataCaption(n: int):String {
			if (_textDataCaption &&_textDataCaption.length>0 && _textDataCaption[n]) {
                return _textDataCaption[n].currentLanguageText;
            }
            else {
                return "---";
            }            
        }
		
        public function textData (title:TextData):void {
            _textDataTitle = title;			
        }
		
			
        public function textCaption (listCaption: Vector.<TextData>):void {			
            _textDataCaption = listCaption;
        }
		
		// максиммум к следующему возможному уровню
		public function nextMaxValue(curlevel: int):int {			
			return _listTasks[curlevel];
			
		}
				
		public function get maxValue():int {
            return getTasks(_listTasks.length - 1);
        }
		
		public function get countLevel():int {
			return _listTasks.length;
		}
    }
}	