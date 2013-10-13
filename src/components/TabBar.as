package components {
	import controls.StaticField;
	import controls.ui.SingleButtonAdv;
	import controls.ui.TabButton;
	
	import events.OneNumberEvent;
	import events.CommonEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	public class TabBar extends Sprite {
		
		private var element:TabButton;
		private var w_cumulate:Number = 0;
		private var bg:SquareGraphic;
		private var currentElement:Object;
		private var arr:Array = new Array();
		private var arrSort:Array = new Array();
		private var currentElementNum:int;
		private var buttonLength:Number = 0;
		private var shadow:DropShadowFilter;
		private var btnOk:SingleButtonAdv;
		
		public function TabBar(initWidth:Number, initHeight:Number) {
			super();
			bg = new SquareGraphic(initWidth+10, initHeight-60, 0xCCCCCC);
			addChild(bg);
			bg.y = 25;
			shadow = new DropShadowFilter(1, -90, 0,1,10,10,1,2);
			bg.filters = [shadow];
			btnOk = new SingleButtonAdv("Ok");
			addChild(btnOk);
			btnOk.x = initWidth - btnOk.width;
			btnOk.y = initHeight - btnOk.HEIGHT - 10;
			btnOk.addEventListener(MouseEvent.CLICK, clickOk);
		}
		
		protected function clickOk(event:MouseEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.BUTTON_OK));
		}
		public function addElement(...rest):void {
			
			buttonLength = rest.length;
			for(var i:int = 0; i < rest.length; i++){
				element = new TabButton(rest[i]);
				addChildAt(element, getChildIndex(bg));
				if(i<1)element.selectTab()+setChildIndex(element, numChildren -1 );
				arr.push(element);
				element.x = w_cumulate;
				w_cumulate += element.width;
				element.addEventListener(MouseEvent.CLICK, tabClick);

			}
			
		}
		public function setSelectTab():void {
			//element[].selectTab()
			
		}
		protected function tabClick(e:MouseEvent):void {
			overwriteArray();

			currentElement = e.currentTarget as DisplayObject;
			currentElementNum = arr.indexOf(currentElement);
			
			setChildIndex(currentElement as DisplayObject, numChildren -1 );
			
			currentElement.mouseChildren = false;
			currentElement.mouseEnabled = false;
			
			arrSort.splice(currentElementNum, 1);

			e.currentTarget.selectTab();
			unSelect();
			dispatchEvent(new OneNumberEvent(OneNumberEvent.SELECTED_TAB, currentElementNum));
		}
		
		private function unSelect():void {
			for(var i:int = 0; i < arrSort.length; i++){
				arrSort[i].unSelectTab();
				
				arrSort[i].mouseChildren = true;
				arrSort[i].mouseEnabled = true;
				setChildIndex(arrSort[i], getChildIndex(bg) );
				arrSort.splice(i--, 1);
				
			}
			
		}
		private function overwriteArray():void{
			for(var i:int = 0; i < buttonLength; i++){
				arrSort.push(arr[i])
				
			}
		}
		private function createElement(titleTab:String, i:int):Sprite {
			var sp:Sprite = new Sprite();

			return sp;
		}	
	}
		
}