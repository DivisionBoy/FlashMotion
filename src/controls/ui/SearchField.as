package controls.ui {

	import controls.StaticField;
	import controls.ComboList;
	
	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class SearchField extends Sprite {

		public var txt:StaticField;
		private static var timer:Timer;
		private static var comboList:ComboList;
		private static var _stage:Stage;
		private var scroller:ScrollBoxMenu;
		private var cont:Sprite;
		private var heghtScrollBox:Number = 150;
		
		//CONSTRUCTOR
		public function SearchField(registr:Stage, initWidth:Number) {
			cont = new Sprite();
			addChild(cont);
			timer = new Timer(50, 1);
			timer.addEventListener(TimerEvent.TIMER, removeObject);
			_stage = registr;

			txt = new StaticField("search","none","none","edit");
			addChild(txt);
			txt.x = -initWidth+5;
			txt.width = initWidth-60;
			txt.addEventListener(FocusEvent.FOCUS_OUT, focusKill);
			txt.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, focusKill);
			txt.addEventListener(Event.CHANGE, changeText);
			txt.addEventListener(FocusEvent.FOCUS_IN, focusIn);
			txt.text = "Search ";

		}
		
		protected function onOut(event:MouseEvent):void{
			if(scroller != null){
				removeChild(scroller);
				scroller = null;
				mouseChildren = false;
				mouseEnabled = false;
				stage.focus = null;
				comboList.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			}
			
		}
		public function txtEnabled():void{
			mouseChildren = true;
			mouseEnabled = true;
			stage.focus = txt;
		}
		public function txtDisabled():void{ 
			mouseChildren = false;
			mouseEnabled = false;
		}
			
		private function focusKill(e:FocusEvent=null):void{
			if(scroller == null)txtDisabled()

			stage.focus = null;
			if(txt.text.length <= 0 ){
				txt.text = "Search ";
			}
		}
		private function removeObject(e:TimerEvent):void {
			timer.stop();

			if(scroller != null){
				removeChild(scroller);
				scroller = null;
				mouseChildren = false;
				mouseEnabled = false;
				stage.focus = null;
				comboList.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			}
			
		}

		private function changeText(e:Event):void{
			if(scroller != null){
				removeChild(scroller)
				scroller = null
				comboList.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			}
			
			comboList.j = 0;//сброс смещения элементов
			comboList.createElement(txt.text);//создание экземпляра и передача имени

			//если текстовое поле содержит меньше 1 символа, то элементы удоляются
			if(comboList.height < 150)heghtScrollBox = comboList.height;
			else
				heghtScrollBox = 150;
			scroller = new ScrollBoxMenu(comboList, heghtScrollBox);
			addChild(scroller);
			scroller.x = (txt.x + comboList.width)+15;
			scroller.y = 20;
			scroller.addEventListener(MouseEvent.ROLL_OUT, onOut);
			if(txt.text.length < 1){
				if(scroller != null){
					removeChild(scroller);
					scroller = null;
					comboList.removeEventListener(MouseEvent.ROLL_OUT, onOut);
				}
			}		
		}
		public static function setArray(arrLinkName:Array, arrTitleNum:Array):void{
			if(comboList != null)comboList = null;
			comboList = new ComboList(arrLinkName, arrTitleNum);
			comboList.addEventListener(CommonEvent.MOUSE_DOWN_ITEM_SEARCH, downItem);

		}
		
		protected static function downItem(event:CommonEvent):void{
			timer.start();
			
		}

		private function focusIn(e:FocusEvent):void {
			txt.mouseDown();
			if(txt.text.length < 1 || txt.text == "Search "){
				txt.text = "";
			}	
		}
		public function updateWidth(initWidth:Number):void {
			txt.updateXY(60, initWidth-5);
		}
		
	}//class
}//package