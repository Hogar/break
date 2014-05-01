package breakdance.core.staticData 
{
	/**
	 * ...
	 * @author Alexey Stashin
	 */
	public class StaticTable
	{
		private var _id:String;
		
		private var _rows:Vector.<StaticTableRow>;
		private var _rowIndex:Object;
		
		public function StaticTable(id:String) 
		{
			_id = id;
			_rows = new Vector.<StaticTableRow>();
			_rowIndex = { };
		}
		
		public function get rows():Vector.<StaticTableRow>
		{
			return _rows;
		}

		public function get id():String 
		{
			return _id;
		}
		
		public function get rowIndex():Object 
		{
			return _rowIndex;
		}
		
		internal function parseRows(tableNode:XML):void
		{
			var rowId:String;
			var row:StaticTableRow;
			var rowNode:XML;
			
			var idCol:String = "id";
			if (tableNode.hasOwnProperty("@id_col"))
				idCol = tableNode.attribute("id_col");
				
			for each(rowNode in tableNode.children())
			{
				rowId = rowNode[idCol];
				if(!_rowIndex[rowId])
				{
					row = new StaticTableRow(this,rowId);
					_rowIndex[rowId] = row;
					_rows.push(row);
				}
				else
					row = _rowIndex[rowId];
				
				row.parseColumns(rowNode);
				
			}
		}
		
	}

}