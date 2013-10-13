package events {
	
	import flash.events.Event;
	
	public class SQLiteResultNumberEvent extends Event {
		
		private var _val:int;
		
		//SQLiteManager
		public static const RESULT_NUMBER:String = "result_number";
		public static const RESULT_LAST_NUMBER:String = "result_last_number";
		//
		
		public function SQLiteResultNumberEvent(type:String, val:int) { 
			super(type, true, false);
			
			_val = val;

		}
		
		public function get value():int {
			return _val;
		}

	}//class
}//package