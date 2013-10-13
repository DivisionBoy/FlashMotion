package components.state {
	
	import components.EditWindow;
	import components.StickerManager;
	
	/*
	DisplayObject - UI Components
	*/
	
	import controls.ui.DataGrid;
	import controls.ui.ComboBox;
	import controls.ui.SingleButtonAdv;
	import controls.ui.TwoChoiceButton;
	
	import events.EditWindowEvent;
	import events.CommonEvent;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.SQLiteSynch;

	public class StickerSetting extends SQLiteSynch {
		
		/*
		DisplayObject - UI Components
		*/
		
		private var dg:DataGrid;
		private var cb:ComboBox;
		private var tb:TwoChoiceButton;
		private var editWindow:EditWindow;
		private var cSticker:SingleButtonAdv;
		
		/*
		SQLite Params
		*/
		
		private var row:Object;
		
		/*
		Width / Height - DataGrid
		*/
		
		private var initWidth:Number;
		private var initHeight:Number;
		
		public function StickerSetting(initWidth:Number, initHeight:Number) {			
			this.initWidth = initWidth;
			this.initHeight = initHeight;	

			dg = new DataGrid();
			addChild(dg);
			dg.width = initWidth;
			dg.height = initHeight;
			dg.columnsWidth = ["365","130", "122", "73"];//ширина столбцов
			dg.columns = ["Message", "Time / Date", "Visible", "Edit / Delete"];//заголовки
			dg.color = ["0xD3D6D9", "0xC6C9CD"];//передает максимум два цвета, присваивает поочередно цвет итемам, если цвет один, то все итемы одного цвета.
			 
			for(var i:int = 0; i < getCurrentNumber(); i++){
				row = result.data[i];

				cb = new ComboBox(["Показать","Скрыть"],90);
				cb.selectedIndex = row.visible;
				
				tb = new TwoChoiceButton();
				tb.addEventListener(CommonEvent.BUTTON_EDIT_CLICK, editItem);
				tb.addEventListener(CommonEvent.BUTTON_DELETE_CLICK, deleteItem);
				cb.addEventListener(CommonEvent.CHANGE, changeCB);
				cb.addEventListener(CommonEvent.COMBOBOX_BUTTON, clickComboBox);//после нажатия на кнопку в комбобоксе, открывается список и блокируется датаГрид, чтобы не получить случайной ошибки
				cb.addEventListener(CommonEvent.COMBOBOX_CLOSE, closeComboBox);//после закрытия списка, функционал датаГрид разблокируется
				dg.addItem({Message:row.message, 
					"Time / Date":row.date, 
					Visible:cb, 
					"Edit / Delete":tb});
			}

			dg.updateScroller();

			cSticker = new SingleButtonAdv("Create Sticker");
			addChild(cSticker);
			cSticker.x = dg.x;
			cSticker.y = dg.y+dg.height+8;
			cSticker.addEventListener(MouseEvent.CLICK, clickCreateSticker);
		}
		
		protected function closeComboBox(event:CommonEvent):void {
			enabled();
			
		}
		
		protected function clickComboBox(event:CommonEvent):void {
			disabled();
		}
		
		protected function clickCreateSticker(event:MouseEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.CREATE_STECKER));
			
		}
		
		protected function deleteItem(event:CommonEvent):void {
			StickerManager.deleteSticker(dg.getItemIndex());
			dg.removeItem();
		}
		
		protected function editItem(event:Event):void {
			disabled();
			editWindow = new EditWindow(dg.getItemValue(0), 300, 250);//getItemValue(0) - 1 колонка; (1) - 2 колонка и т.д.
			addChild(editWindow);
			editWindow.addEventListener(EditWindowEvent.BUTTON_CANCEL, cancelEditWindow);
			editWindow.addEventListener(EditWindowEvent.BUTTON_OK, applyEditWindow);
			editWindow.addEventListener(EditWindowEvent.MOUSE_DOWN, applyPreview);
			editWindow.x = initWidth/2 + editWindow.width/2;
			editWindow.y = initHeight/2 - editWindow.height/2;
		}
		
		protected function applyPreview(event:EditWindowEvent):void{
			StickerManager.applyPreviewText(dg.getItemIndex(), editWindow.getMessage());
			
		}
		
		protected function applyEditWindow(event:EditWindowEvent):void{
			enabled();

			dg.setItemValue(0, editWindow.getMessage());// setItemValue( номер ячейки, что будет записано)
			editMessage(editWindow.getMessage(),getID(dg.getItemIndex()));
			StickerManager.applyEditText(dg.getItemIndex(), editWindow.getMessage());
			closeEditWindow();
		}
		
		protected function cancelEditWindow(event:EditWindowEvent):void{
			enabled();
			StickerManager.cancelEditWindowText(dg.getItemIndex(), editWindow.getMessage());

			closeEditWindow();
		}
		private function enabled():void {
			dg.mouseChildren = true;
			dg.mouseEnabled = true;
			
		}
		private function disabled():void {
			dg.mouseChildren = false;
			dg.mouseEnabled = false;
			
		}
		private function closeEditWindow():void{
			removeChild(editWindow);
			editWindow = null;
			
		}
		
		protected function changeCB(e:CommonEvent):void {
			StickerManager.visibleSticker(dg.getItemIndex(), e.currentTarget.selectedIndex);
			StickerManager.editVisibleSticker(e.currentTarget.selectedIndex, dg.getItemIndex());
		}
		
	}
}