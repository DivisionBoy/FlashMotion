package events {
	
	import flash.events.Event;
	
	public class PlayerEvent extends Event {
		
		private var _val:int;
		private var _val2:int;
		private var _val3:int;
		private var _val4:int;
		private var _val5:int;

		public static const UPDATE_TIME:String = "update_time";
		//
		
		public function PlayerEvent(type:String, val:int, val2:int, val3:int, val4:int, val5:uint) { 
			super(type, true, false);
			
			_val = val;
			_val2 = val2;
			_val3 = val3;
			_val4 = val4;
			_val5 = val5;
			
		}
		
		public function get value():int {
			return _val;
		}
		public function get value2():int {
			return _val2;
		}
		public function get value3():int {
			return _val3;
		}
		public function get value4():int {
			return _val4;
		}
		public function get value5():int {
			return _val5;
		}
		
	}//class
}//package