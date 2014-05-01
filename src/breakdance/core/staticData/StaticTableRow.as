package breakdance.core.staticData 
{
	/**
	 * ...
	 * @author Alexey Stashin
	 */
	public class StaticTableRow
	{
		private var _table:StaticTable;
		
		private var _id:String;
		
		internal var _data:Object;
		
		public function StaticTableRow(table:StaticTable, id:String) 
		{
			_table = table;
			_id = id;
			_data = { id:id };
		}
		
		public function getId():String
		{
			return _id;
		}

		public function getAsString(cellId:String, required:Boolean = true, defaultValue:String = ""):String
		{
			if (!_data[cellId])
			{
				if(required)
					throw new Error("StaticTableRow. Missing cell '" + cellId + "' in '" + _id + "' row, '" + _table.id + "' table" );
				else
					return defaultValue;
			}
			
			return _data[cellId];
		}
		
		public function getAsInt(cellId:String, required:Boolean = true, defaultValue:int = 0):int
		{
			if (!_data[cellId])
			{
				if(required)
					throw new Error("StaticTableRow. Missing cell '" + cellId + "' in '" + _id + "' row, '" + _table.id + "' table" );
				else
					return defaultValue;
			}
			
			return parseInt(_data[cellId]);
		}
		
		public function getAsNumber(cellId:String, required:Boolean = true, defaultValue:Number = 0):Number
		{
			if (!_data[cellId])
			{
				if(required)
					throw new Error("StaticTableRow. Missing cell '" + cellId + "' in '" + _id + "' row, '" + _table.id + "' table" );
				else
					return defaultValue;
			}
			
			var str:String = _data[cellId];
			str = str.replace(",", ".");
			
			return parseFloat(str);
		}
		
		internal function parseColumns(rowNode:XML):void
		{
			var columnNode:XML;
			for each(columnNode in rowNode.children())
			{
				_data[columnNode.name()] = columnNode.toString();
			}
		}
		
	}

}