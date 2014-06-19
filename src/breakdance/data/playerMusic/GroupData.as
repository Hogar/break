package breakdance.data.playerMusic 
{
	import breakdance.core.staticData.StaticTableRow;
	/**
	 * ...
	 * @author gray_crow
	 */
	public class GroupData 
	{

		private var _id				: int;
		private var _groupId		: int;
		private var _groupName		: String;
		
		public function GroupData(row:StaticTableRow) {
			_id = row.getAsInt ("id");
			_groupId = row.getAsInt ("group_id");
			_groupName = row.getAsString ("group_name");
			
		}		
		
        public function get id ():int {
            return _id;
        }
		
        public function get groupId ():int {
            return _groupId;
        }
		
		public function get groupName ():String {
            return _groupName;
        }
	}

}