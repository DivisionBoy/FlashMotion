package events {
 
	import flash.events.Event;
 
	public class OneNumberEvent extends Event {
 
		private var _val:Number;

		public static const SELECTED_TAB:String = "selected_tab"; 
		public static const CLICK_SLIDER_PIMP:String = "click_slider_pimp"; 
		public static const PLAYBACK_PERCENT:String = "playback_percent";
		public static const SET_VOLUME:String = "set_volume";
		public static const EDIT_BEFORE_EXIT:String = "edit_before_exit";
		public static const ID_STICK:String = "id_stick";
 		public static const SEARCH_ID_ITEM:String = "search_id_item";
		
		
		public function OneNumberEvent(type:String, val:Number) { 
			super(type, true, false);
 
			_val = val;
		}
 
		public function get value():Number {
			return _val;
		}
		
	}//class
}//package