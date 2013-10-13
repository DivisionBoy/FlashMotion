package events {
	
	import flash.events.Event;

	public class EditWindowEvent extends Event {
			
		public static const CHANGE:String = "change";
	
		public static const MOUSE_DOWN:String = "mouse_down";
		//Button OK - CANCEL
		public static const BUTTON_OK:String = "button_ok";
		public static const BUTTON_CANCEL:String = "button_cancel";

		public function EditWindowEvent(type:String) {
			super(type, false/*true*/, false);
			
		}
	}
}