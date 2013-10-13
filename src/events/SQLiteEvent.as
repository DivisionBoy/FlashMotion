package events {
	
	import flash.events.Event;
	
	public class SQLiteEvent extends Event {
		
		private var _val:String;
		
		//SQLiteManager
		public static const ERROR_MESSAGE:String = "error_message";
		public static const SEND_MESSAGE_STEP_1:String = "send_message_step_1";
		public static const SEND_MESSAGE_STEP_2:String = "send_message_step_2";
		//
		
		public function SQLiteEvent(type:String, val:String) { 
			super(type, true, false);
			
			_val = val;

		}
		
		public function get value():String {
			return _val;
		}

	}//class
}//package