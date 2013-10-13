package events {
	import flash.events.Event;

	public class ParamsEvent extends Event {
		
		private var _val1:String;
		private var _val2:String;
		private var _val3:int;
		
		public static const SETUP_PARAM:String = "setup_param";
		public static const SETUP_PARAM_UP:String = "setup_param_up";
		public static const PLAYLIST_INFO:String = "playlist_info";
		
		public function ParamsEvent(type:String, val1:String, val2:String, val3:int) {
			super(type, true, false);
			
			_val1 = val1;
			_val2 = val2;
			_val3 = val3;
			
		}
		
		public function get value1():String {
			return _val1;
		}
		public function get value2():String {
			return _val2;
		}
		public function get value3():int {
			return _val3;
		}
	}
}