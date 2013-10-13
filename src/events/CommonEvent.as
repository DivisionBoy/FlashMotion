package events {
	
	import flash.events.Event;

	public class CommonEvent extends Event {
		
		public static const PRESS_MENU_BUTTON:String = "press_menu_button";
		public static const DOWN_DRAG_BAR:String = "down_drag_bar";
		public static const UP_DRAG_BAR:String = "up_drag_bar";
		public static const RESIZE_WIDTH:String = "resize_width";
		public static const SAVE_START:String = "save_start";
		public static const SAVE_END:String = "save_end";
		public static const CHANGE:String = "change";
		public static const ON_PRESS_ROTATE:String = "on_press_rotate";
		public static const ON_PRESS_DRAGGABLE:String = "on_press_draggable";
		public static const MOVE:String = "move";
		public static const STICKER_DOWN:String = "sticker_down";
		public static const BUTTON_EDIT_CLICK:String = "button_edit_click";
		public static const BUTTON_DELETE_CLICK:String = "button_delete_click";
		public static const CREATE_STECKER:String = "create_sticker";
		
		public static const MOUSE_DOWN:String = "mouse_down";
		//mouse over
		public static const MOUSE_OVER_DELETE:String = "mouse_over_delete";
		public static const MOUSE_OVER_BUFFER:String = "mouse_over_buffer";
		public static const MOUSE_OVER_COGWHEEL:String = "mouse_over_cogwheel";
		//mouse out
		public static const MOUSE_OUT_BUTTONLIST:String = "mouse_out_buttonlist";
		public static const MOUSE_OUT_ITEMLIST:String = "mouse_out_itemlist";
		//resourceManager_loadingComplete
		public static const LOAD_COMPLETE:String = "load_complete";
		//toggleButton
		public static const TOGGLE_UP:String = "toggle_up";
		public static const TOGGLE_DOWN:String = "toggle_down";
		//Button OK - CANCEL
		public static const BUTTON_OK:String = "button_ok";
		public static const BUTTON_CANCEL:String = "button_cancel";
		//EXIT
		public static const EXIT:String = "exit";
		//MINIMIZED
		public static const MINIMIZE:String = "minimize";
		//DELETE - ADD
		public static const DELETE:String = "delete";
		public static const DELETE_COMPLETE:String = "delete_complete";
		public static const ADD_COMPLETE:String = "add_complete";
		public static const EDIT_COMPLETE:String = "edit_complete";
		//public static const EDIT_BEFORE_EXIT:String = "edit_before_exit";
		public static const DELETE_SHELL:String = "delete_shell";
		//SQLiteManager
		public static const SUCCESS:String = "success";
		public static const CHECK_LOGIN_STEP_1:String = "check_login_step_1";
		public static const CHECK_LOGIN_STEP_2:String = "check_login_step_2";
		//CheckBox
		public static const TOGGLE_CHECKBOX_UP:String = "toggle_checkbox_up";
		public static const TOGGLE_CHECKBOX_DOWN:String = "toggle_checkbox_down";
		//SEARCH
		public static const MOUSE_OVER_SEARCH:String = "mouse_over_search";
		public static const MOUSE_DOWN_ITEM_SEARCH:String = "mouse_down_item_search";
		//PlayList
		public static const PLAYLIST_DOUBLE_CLICK:String = "playlist_double_click";
		public static const PLAYLIST_REMOVE:String = "playlist_remove";
		public static const PLAYLIST_CLOSE:String = "playlist_close";
		public static const BACK:String = "back";
		public static const DRAGBAR_PLAYLIST:String = "dragbar_playlist";
		public static const COMBOBOX_BUTTON:String =  "combobox_button";
		public static const COMBOBOX_CLOSE:String = "combobox_close";
		
		public function CommonEvent(type:String) {
			super(type, true, false);
			
		}
	}
}