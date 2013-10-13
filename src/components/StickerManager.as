package components {

	import controls.ui.ItemList;
	
	import events.ButtonEvent;
	import events.EditWindowEvent;
	import events.CommonEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.SQLiteSynch;
	
	public class StickerManager extends SQLiteSynch{
		
		private static var arrMonth:Array = new Array("01","02","03","04","05","06","07","08","09","10","11","12")
		private static var minutes:String;
		private static var date:Date;
		private static var sticker:Sticker;
		private static var _stage:Stage;
		private static var arrSticker:Array = new Array();
		private static var currentStickerObject:DisplayObject;
		private static var targetStickerNum:int;
		private static var currentX:Number;
		private static var currentY:Number;
		private static var grabStickerX:Number;
		private static var grabStickerY:Number;
		private static var _chosenItem:Number;
		private static var _message:String;
		private static var _mainBG:Object;
		private static var mainMenu:ItemList;
		private static var editWindow:EditWindow;
		private static var currentDate:String;
		
		//CONSTRUCTOR
		public function StickerManager(){
			super();
		}
		
		public static function init(stage:Stage, mainBG:Object):void {
			_stage = stage;
			_mainBG = mainBG;
			
			initSQL();
			
			for(var i:int=0; i < numRows; i++){
				var row:Object = result.data[i];
				sticker =  new Sticker(row.url, row.message, row.textX, row.textY, row.textWidth, row.textHeight, row.textRotation);
				_stage.addChild(sticker);
				sticker.x = row.stickerX;
				sticker.y = row.stickerY;
				if(row.visible == 0){
					sticker.visible = true;
				}else{
					sticker.visible = false;
				}
				sticker.addEventListener(CommonEvent.STICKER_DOWN, stickerDown);
				sticker.addEventListener(MouseEvent.RIGHT_MOUSE_UP, listMenu);
				arrSticker.push(sticker);

			}
			
		}
		
		protected static function listMenu(e:MouseEvent):void {
			currentStickerObject = e.currentTarget as DisplayObject;
			targetStickerNum = arrSticker.indexOf(currentStickerObject);

			_message = e.currentTarget.getMessage();
			if(mainMenu == null){
				showMenu();
			}else{
				_stage.removeChild(mainMenu);
				mainMenu = null;
				showMenu();	
			}
		}
		
		private static function showMenu():void {
			mainMenu = new ItemList("редактировать", "скрыть", "удалить");
			_stage.addChild(mainMenu);
			mainMenu.addEventListener(ButtonEvent.PRESS_EXTENDED_BUTTON, onPressMainMenu);
			mainMenu.addEventListener(CommonEvent.MOUSE_OUT_ITEMLIST, onRollOut);
			mainMenu.x = _stage.mouseX;
			mainMenu.y = _stage.mouseY;
			
		}

		public static function visibleSticker(num:int, num2:int):void {
			if(num2 == 0 )arrSticker[num].visible = true;
			else arrSticker[num].visible = false;
		}
		protected static function stickerDown(e:CommonEvent):void {
			
			currentStickerObject = e.currentTarget as DisplayObject;
			targetStickerNum = arrSticker.indexOf(currentStickerObject);
			currentX = currentStickerObject.x;
			currentY = currentStickerObject.y;
			grabStickerX = currentStickerObject.mouseX;
			grabStickerY = currentStickerObject.mouseY;
			_stage.setChildIndex(currentStickerObject, _stage.numChildren-1);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, stickerMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stickerUp);
			
		}
		public static function createSticker(chosenItem:Number, message:String):void {
			_chosenItem = chosenItem;
			_message = message;
			sticker = new Sticker(
				ManagerStickXML.getXML().stick.original[_chosenItem], 
				_message, 
				ManagerStickXML.getXML().stick[_chosenItem].@x, 
				ManagerStickXML.getXML().stick[_chosenItem].@y,
				ManagerStickXML.getXML().stick[_chosenItem].@width,
				ManagerStickXML.getXML().stick[_chosenItem].@height,
				ManagerStickXML.getXML().stick[_chosenItem].@rotation );

			_stage.addEventListener(MouseEvent.MOUSE_MOVE, stickerTempMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stickerTempUp);
			sticker.addEventListener(CommonEvent.STICKER_DOWN, stickerDown);
			sticker.addEventListener(MouseEvent.RIGHT_MOUSE_UP, listMenu);
			
		}
		protected static function onPressMainMenu(e:ButtonEvent):void {
			if(e.value=="0")editSticker();
			if(e.value=="1")hideSticker();
			if(e.value == "2")deleteSticker(targetStickerNum);
			_stage.removeChild(mainMenu);
			mainMenu = null;
			
		}

		public static function deleteSticker(targetItem:Number):void{
			_stage.removeChild(arrSticker[targetItem]);
			arrSticker[targetItem] = null;
			arrSticker.splice(targetItem,1);
			remove(getID(targetItem));
			
		}
		public static function editVisibleSticker(selectedIndex:int, targetItem:int):void {
			editVisible(selectedIndex, getID(targetItem));
			
		}
		private static function hideSticker():void {
			arrSticker[targetStickerNum].visible = false;
			editVisible(1, getID(targetStickerNum));//0 - показать; 1 - скрыть 
		}
		
		private static function editSticker():void {
			editWindow = new EditWindow(_message, 300, 250);
			_stage.addChild(editWindow);
			editWindow.addEventListener(EditWindowEvent.BUTTON_CANCEL, cancelEditWindow);
			editWindow.addEventListener(EditWindowEvent.BUTTON_OK, applyEditWindow);
			editWindow.addEventListener(EditWindowEvent.MOUSE_DOWN, applyPreview);
			arrSticker[targetStickerNum].x < 350 ? editWindow.x = (arrSticker[targetStickerNum].x + editWindow.width + arrSticker[targetStickerNum].width) : editWindow.x = arrSticker[targetStickerNum].x + getX(targetStickerNum);
			editWindow.y = arrSticker[targetStickerNum].y + getY(targetStickerNum);
			for(var i:int = 0; i < arrSticker.length; i++){
				arrSticker[i].mouseEnabled = false;
				arrSticker[i].mouseChildren = false;
			}
		}
		
		protected static function applyPreview(event:EditWindowEvent):void{	
			arrSticker[targetStickerNum].setMessage(editWindow.getMessage())
			
		}
		public static function applyPreviewText(targetItem:Number, message:String):void {		
			arrSticker[targetItem].setMessage(message);
		}
		
		protected static function applyEditWindow(event:EditWindowEvent):void{
			editMessage(editWindow.getMessage(), getID(targetStickerNum));
			closeEditWindow();
		}
		
		protected static function cancelEditWindow(event:EditWindowEvent):void{
			arrSticker[targetStickerNum].setMessage(editWindow.getMessage());
			closeEditWindow();
		}
		public static function cancelEditWindowText(targetItem:Number, message:String):void {
			arrSticker[targetItem].setMessage(message);
			
		}
	
		public static function applyEditText(targetItem:Number, message:String):void {
			arrSticker[targetItem].setMessage(message);
			
		}
		private static function closeEditWindow():void{
			_stage.removeChild(editWindow);
			editWindow = null;
			for(var i:int = 0; i < arrSticker.length; i++){
				arrSticker[i].mouseEnabled = true;
				arrSticker[i].mouseChildren = true;
			}
			
		}
		
		protected static function onRollOut(event:CommonEvent):void{
			if(mainMenu != null){
				_stage.removeChild(mainMenu);
				mainMenu = null;
			}		
		}
		protected static function stickerTempUp(event:MouseEvent):void{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, stickerTempMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stickerTempUp);
			if(_mainBG.hitTestObject(sticker)){
				_stage.removeChild(sticker);
				sticker = null;
			}else if(sticker.stage != null){
				arrSticker.push(sticker);
				addItem(ManagerStickXML.getXML().stick.original[_chosenItem],
					_message,
					getDate(),
					0,
					sticker.x, 
					sticker.y, 
					ManagerStickXML.getXML().stick[_chosenItem].@x, 
					ManagerStickXML.getXML().stick[_chosenItem].@y,
					ManagerStickXML.getXML().stick[_chosenItem].@width,
					ManagerStickXML.getXML().stick[_chosenItem].@height,
					ManagerStickXML.getXML().stick[_chosenItem].@rotation);
			}
			
		}
		
		private static function getDate():String {
			date = new Date();
			currentDate = date.getHours()+":"+getMinutes()+" / "+date.getDate()+":"+arrMonth[date.getMonth()]+":"+date.getFullYear();
			return currentDate;
		}
		private static function getMinutes():String {
			date.getMinutes() < 10 ? minutes = "0"+date.getMinutes() : minutes = date.getMinutes()+"";
			return minutes;
		}
		protected static function stickerTempMove(event:MouseEvent):void {
			sticker.x = _stage.mouseX - sticker.width/2;
			sticker.y = _stage.mouseY - sticker.height/2;
			if(sticker.stage == null && sticker.width != 0)_stage.addChild(sticker);

			if(_mainBG.hitTestObject(sticker)){
				sticker.alpha = 0.7;
			}else{
				sticker.alpha = 1;
			}
			
		}
		protected static function stickerUp(event:MouseEvent):void {
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, stickerMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stickerUp);
			if(currentStickerObject.x != currentX || currentStickerObject.y != currentY)editCoordinate(currentStickerObject.x, currentStickerObject.y, getID(targetStickerNum));
		}
		
		protected static function stickerMove(e:MouseEvent):void {
			currentStickerObject.x = _stage.mouseX - grabStickerX;
			currentStickerObject.y = _stage.mouseY - grabStickerY;
			
			e.updateAfterEvent();
		}

	}
}