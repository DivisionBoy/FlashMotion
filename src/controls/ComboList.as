package controls {
	
	import events.OneNumberEvent;
	import events.CommonEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ComboList extends Sprite {

		public var j:int = 0; //смещение элементов по приростании j параметра
		private var sp:Sprite;
		private var arr:Array;
		private var listView:ComboListView;
		
		
		private var arrLink:Array = new Array();
		private var _arrNum:Array = new Array();
		private var _arrPosY:Array = new Array();
		private var arrObject:Array = new Array();
		
		//CONSTRUCTOR
		public function ComboList(arr:Array, arrNum:Array) {	
			//arrNum массив с DisplayObject всех линков в arrObject сортировка найденных линков
			_arrNum = arrNum;
			arrLink = arr;
				
		}
		
		protected function onOut(event:MouseEvent):void{
			dispatchEvent(new CommonEvent(CommonEvent.MOUSE_OVER_SEARCH));
			
		}
		
		public function createElement(text:String):void {
			if(sp != null)removeChild(sp);
			sp = new Sprite();
			addChild(sp);
			_arrPosY.length = 0;
			arrObject.length = 0;
			for(var i:int = 0; i < arrLink.length; i++){
				//если введенный в поле поиска символ совпадает с текущими данными то данные добавляются в новый массив arr
				if (arrLink[i].toString().toLowerCase().indexOf(text.toLowerCase()) != -1) { 
					arr = new Array();
					//заполнение нового массива из найденных данных
					arr.push(arrLink[i]);				
					//вызов метода для отправки полученных даных с целью создания списка элементов из найденных данных
					newArray(arr, _arrNum[i].y, j++, i);
				}
			}
		}
		private function newArray(arr:Array, arrNumYq:Number, num:int, numPress:uint):void {
			//создание экземпляра listView и передача имени элемента
			listView = new ComboListView(arr+"");
			_arrPosY.push(arrNumYq);
			arrObject.push(listView);
			listView.name = numPress +"";
			listView.addEventListener(MouseEvent.MOUSE_UP, mouseUp);			
			listView.y = listView.height*num;
			
			sp.addChild(listView);

		}
		
		private function mouseUp(e:MouseEvent):void {
			var targetLink:DisplayObject = e.currentTarget as DisplayObject;
			var targetItemNum:Number = this.arrObject.indexOf(targetLink);

			dispatchEvent(new OneNumberEvent(OneNumberEvent.SEARCH_ID_ITEM, _arrPosY[targetItemNum]));//отправляет координаты найденного итема

			//подкрашивает найденный линк
			CList.setColor(e.currentTarget.name)

			dispatchEvent(new CommonEvent(CommonEvent.MOUSE_DOWN_ITEM_SEARCH));
		}
		
	}//class
}//package