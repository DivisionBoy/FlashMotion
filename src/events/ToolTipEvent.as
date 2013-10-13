package events {
	
	import flash.events.Event;
	
	public class ToolTipEvent extends Event {
		
		private var _val:String;
		
		public static const SEND_PARAM:String = "send_param";
		public static const REMOVE_TOOLTIP:String = "remove_tooltip";
		
		public function ToolTipEvent(type:String, val:String) { 
			super(type, true, false);
			
			_val = val;

		}
		
		public function get value():String {
			return _val;
		}

	}//class
}//package