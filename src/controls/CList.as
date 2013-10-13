package controls {

	import controls.ui.SearchField;
	
	import events.OneNumberEvent;
	import events.ParamsEvent;
	import events.SQLiteEvent;
	import events.SQLiteResultNumberEvent;
	import events.CommonEvent;
	import events.ToolTipEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.System;
	
	/*import gs.TweenLite;
	import gs.easing.Expo;*/
	
	import model.SQLiteManager;
	
	public class CList extends SQLiteManager {//CList наследует модель класса SQLiteManager
		
		private const ITEM_HEIGHT:int = 20;
		
		private var nonWordChars:Array = ['www.', 'https', '//', ":", 'http'];
		private var validAll:RegExp = new RegExp("(http?://)?(https?://)?(www\\.)?([a-zA-Z0-9_%]*)\\b\\.[a-z]{2,4}(\\.[a-z]{2})?((/[a-zA-Z0-9_%]*)+)?(\\.[a-z]*)?(:\\d{1,5})?","g"); //!/\www./
		private var validHttp:RegExp = new RegExp("(http?://)?(https?://)","g");
		private var row:Object;
		private const ITEM_SPACING:int = 7;
		private var arrTitle:Array;

		private var cListView:CListView;
		private var _grabY:Number;
		private var _initWidth:Number;
		private var _initHeight:Number;
		private var i:int = 0;
		private var targetLink:DisplayObject;
		private var targetItemNum:int;
		private var update:Boolean = false;
		private var arrLink:Array;
		private var trueLink:Boolean;
		private var arrDescription:Array;
		private var IDlink:int;
		private static var _num:Number;
		private var _nameItemLst:String;
		private var _descriptionItem:String;
		private var _currentItem:Object;
		private var index2:int;
		private var index1:int;
		private var itemCount:int;
		private var arrID:Array;
		private var infoLoad:Number;
		private var trueNameItemList:String;
		private var HighestID:int;
		private var moveItem:Boolean;
		private var h_cumulate:int = 0;
		private var move:Boolean = true;

		
		public function CList(initWidth:Number, initHeight:Number) {
			_initWidth = initWidth;
			_initHeight = initHeight;

			this.addEventListener(CommonEvent.SUCCESS,init);
			this.addEventListener(SQLiteResultNumberEvent.RESULT_NUMBER, getIDLink);
			this.addEventListener(SQLiteResultNumberEvent.RESULT_LAST_NUMBER, getLastIDLink);
			this.addEventListener(SQLiteEvent.ERROR_MESSAGE, initError);
			this.addEventListener(CommonEvent.ADD_COMPLETE, addItemComplete);
			this.addEventListener(CommonEvent.EDIT_COMPLETE, editItemComplete);
			
		}
		
		protected function getLastIDLink(e:SQLiteResultNumberEvent):void {
			HighestID = e.value;
			arrID.push(HighestID)//добавляет в массив текущий ID элемента, для редактирования базы, при перемещении элементов
		}		
			
		protected function getIDLink(e:SQLiteResultNumberEvent):void {
			IDlink = e.value;

		}
		
		protected function initError(e:SQLiteEvent):void {
			this.dispatchEvent(new SQLiteEvent(SQLiteEvent.SEND_MESSAGE_STEP_1, e.value));
			
		}
		public function addButton(initWidth:int, nameItemList:String, descriptionItem:String):void {
			_initWidth = initWidth;
			_nameItemLst = nameItemList;
			_descriptionItem = descriptionItem;

			addItem(_nameItemLst, descriptionItem);
			
		}
		protected function addItemComplete(event:CommonEvent):void {
			var validLinkAll:int = _nameItemLst.search(validAll);

			getLastRows(i);//получить наивысший ID
			
			trueNameItemList = _nameItemLst;

			if(validLinkAll >= 0){
				trueLink = true;
				for (var g:int = 0; g < nonWordChars.length; g++) {
					_nameItemLst = _nameItemLst.split(nonWordChars[g]).join("");	
				}
			}else{
				trueLink = false;
			}
			cListView = new CListView(_initWidth, _nameItemLst, i);

			arrLink.push(_nameItemLst)
			arrDescription.push(_descriptionItem)
			arrTitle.push(cListView);
			
			cListView.setDes(_descriptionItem);
			cListView.setTitle(_nameItemLst);
			cListView.setFullTitle(trueNameItemList);

			cListView.fillButton.addEventListener(MouseEvent.CLICK, fillButtonClick);
			cListView.addEventListener(Event.ADDED, _alignWithY);
			cListView.addEventListener(Event.REMOVED, _alignWithY);
			cListView.addEventListener(MouseEvent.ROLL_OVER, getTarget);
			cListView.addEventListener(MouseEvent.ROLL_OUT, mouseOutCList);
			//
			cListView.listButtonDelete.addEventListener(MouseEvent.CLICK, mouseUpDelete);
			cListView.listButtonDelete.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownDelete);
			cListView.listButtonBuffer.addEventListener(MouseEvent.CLICK, mouseUpBuffer);
			cListView.listButtonEdit.addEventListener(MouseEvent.CLICK, mouseUpEdit);
			cListView.listButtonEdit.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownEdit);
			cListView/*.fillButton*/.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addChild(cListView);
			i++;
		}
		
		protected function mouseDownEdit(event:MouseEvent):void {
			move = false;
			
		}
		
		protected function mouseDownDelete(event:MouseEvent):void {
			move = false;
			
		}
		protected function mouseUpBuffer(e:MouseEvent):void{
			System.setClipboard(_currentItem.getFullTitle());
			
		}
		
		protected function mouseUpEdit(event:MouseEvent):void{
			dispatchEvent(new ParamsEvent(ParamsEvent.SETUP_PARAM,_currentItem.getFullTitle(), _currentItem.getDes(), IDlink));
			
		}
		
		protected function mouseOutCList(event:MouseEvent):void{
			dispatchEvent(new ToolTipEvent(ToolTipEvent.REMOVE_TOOLTIP,null));

		}
		protected function _alignWithY(e:Event):void{
			for (var i:uint = uint.MIN_VALUE; i < this.arrTitle.length; i++){
				
				this.arrTitle[i].y = i === 0
					? i
					: this.arrTitle[i - 1].y + this.arrTitle[i - 1].height - this.ITEM_SPACING;
				//
				if(update==true)arrTitle[i].setNumber(i)
			}
		}
		protected function mouseUpDelete(e:MouseEvent):void {
			remove(IDlink);
			update = true;

			this.arrTitle.splice(targetItemNum, 1);
			this.arrLink.splice(targetItemNum, 1);
			this.arrDescription.splice(targetItemNum, 1);
			this.arrID.splice(targetItemNum, 1);

			removeChild(targetLink);
			dispatchEvent(new CommonEvent(CommonEvent.DELETE));
			i--
	
		}
		private function unBlock(e:CommonEvent):void {
			//this.mouseChildren = true;
			//this.mouseEnabled = true;
		}

		private function init(e:CommonEvent):void {
			arrTitle = new Array();
			arrLink = new Array();
			arrDescription = new Array();
			arrID = new Array();

			for(i=0; i < numRows; i++){
				row = result.data[i];
				trueNameItemList = row.title;
				var validLinkAll:int = row.title.search(validAll);
				if(validLinkAll >= 0){
					trueLink = true;
					for (var g:int = 0; g < nonWordChars.length; g++) {
						row.title = row.title.split(nonWordChars[g]).join("");	
					}
				}else{
					trueLink = false;
				}
				
				cListView = new CListView(_initWidth, row.title, i);
				cListView.y  = h_cumulate;

				arrTitle.push(cListView);
				arrLink.push(row.title);
				arrDescription.push(row.description);
				arrID.push(row.id);
				
				cListView.setDes(row.description);
				cListView.setTitle(row.title);
				cListView.setFullTitle(trueNameItemList);
				cListView.setID(row.id);

				cListView.addEventListener(Event.REMOVED, _alignWithY);
				cListView.fillButton.addEventListener(MouseEvent.CLICK, fillButtonClick);
				cListView.addEventListener(MouseEvent.ROLL_OVER, getTarget);
				cListView.listButtonDelete.addEventListener(MouseEvent.CLICK, mouseUpDelete);
				cListView.listButtonDelete.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownDelete);
				cListView.addEventListener(MouseEvent.ROLL_OUT, mouseOutCList);
				cListView.listButtonEdit.addEventListener(MouseEvent.CLICK, mouseUpEdit);
				cListView.listButtonEdit.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownEdit);
				cListView.listButtonBuffer.addEventListener(MouseEvent.CLICK, mouseUpBuffer);
				cListView.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				addChild(cListView);
				
				h_cumulate += ITEM_HEIGHT+4;

			}
			
			SearchField.setArray(arrLink, arrTitle);

			this.dispatchEvent(new CommonEvent(CommonEvent.CHECK_LOGIN_STEP_1));
		}
		public static function setColor(num:Number):void {
			_num = num;
			
		}
		public function onMouseUp():void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove)
			move = true;
			update = true;
			if(_num >= 0){
				//устанавливает цвета у всех ссылок по дифолту
				for each (var key:Object in arrTitle) {
					key.noneColor();
				}
				arrTitle[_num].selectColor();
				_num = -1;
			}
			//if(moveItem)sortItems();

		}
		protected function getTarget(e:MouseEvent):void {
			
			targetLink = e.currentTarget as DisplayObject;
			targetItemNum = this.arrTitle.indexOf(targetLink);

			getRows(targetItemNum);//создает новый стайтмент и вызывает слушатель Result

			dispatchEvent(new ToolTipEvent(ToolTipEvent.SEND_PARAM, e.currentTarget.getDes()));

		}
		
		public function replaceLinkText(title:String, des:String):void {
			var str:String = title;
			var validLinkAll:int = str.search(validAll);
			if(validLinkAll >= 0){
				for (var g:int = 0; g < nonWordChars.length; g++) {
					str = str.split(nonWordChars[g]).join("");	
				}
			}else{
				
			}
			this.arrLink.splice(targetItemNum, 1, str);
			this.arrDescription.splice(targetItemNum, 1, des);
			//
			arrTitle[targetItemNum].replaceLinkText(str);
		}
		public function updateWidth(initWidth:Number, initHeight:Number):void {
			for each (var key:Object in arrTitle) {
				key.width = initWidth;
			}
		}
		public function setupEdit(title:String, des:String, id:int):void {
			arrTitle[targetItemNum].setTitle(title);
			arrTitle[targetItemNum].setFullTitle(title);
			arrTitle[targetItemNum].setDes(des);
			edit(title, des, id);
		}
		protected function editItemComplete(event:CommonEvent=null):void{
			if(itemCount < arrTitle.length){
				editMove(arrTitle[itemCount].getFullTitle(), arrTitle[itemCount].getDes(), arrID[itemCount]);			
				dispatchEvent(new CommonEvent(CommonEvent.SAVE_START));
				itemCount++
			}else{
				dispatchEvent(new CommonEvent(CommonEvent.SAVE_END));
			}	
		}
		public function editBaseList():void {
			editItemComplete();
			
		}
		private function fillButtonClick(e:MouseEvent):void {
			var httpCheck:String;
			itemCount = 0;
			var s:String = arrTitle[targetItemNum].getFullTitle();
			var validLinkAll:int = s.search(validAll);
			var validLinkHttp:int = s.search(validHttp);

			if(index1 != index2){//если числовые переменные не равны, значит было совершено перетаскивание элемента и он изменил свой индекс
				infoLoad = 130 / arrTitle.length;
				dispatchEvent(new OneNumberEvent(OneNumberEvent.EDIT_BEFORE_EXIT, infoLoad));
			}

			if(validLinkAll >= 0 && !moveItem){
				validLinkHttp >= 0 ? httpCheck = "" : httpCheck = "http://";		
				var request:URLRequest = new URLRequest(""+httpCheck+""+s);

				try {
					navigateToURL(request, '_blank');
				} catch (e:Error) {
					//trace("Error");
				}
			}

		}

		private function mouseDown(e:MouseEvent):void {
			targetLink = e.currentTarget as DisplayObject;
			targetItemNum = this.arrTitle.indexOf(targetLink);

			_currentItem = arrTitle[targetItemNum];

			setChildIndex(arrTitle[targetItemNum],numChildren - 1);

			_grabY = e.currentTarget.mouseY;
			if(move)stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			index1 = targetItemNum;
			index2 = targetItemNum;

		}

		private function onFinishState():void{
			moveItem = false;
		}
		/*private function sortItems():void {
			for (var i:int = 0; i < arrTitle.length; i++) {
				TweenLite.to( arrTitle[i], 0.5, { x:0, y:(arrTitle[i].height - ITEM_SPACING) * i, ease:Expo.easeInOut, onComplete:onFinishState } );
			}
		}*/
		protected function onMouseMove(e:MouseEvent):void {
			moveItem = true;//при движении мыши, после отпускания кнопки, блокируется случайный вызов ссылок
			
			_currentItem.y = Math.min(Math.max(0, this.mouseY - _grabY), this.height);
			
			arrTitle.sortOn( 'y', Array.NUMERIC);
			
			for (var i:int = 0; i < arrTitle.length; i++) {
				arrTitle[i].setNumber(i);
			}
			index2 = _currentItem.getCount();//получает текущую позицию при перетаскивании итема	
		}
		
	}//class
}//package
