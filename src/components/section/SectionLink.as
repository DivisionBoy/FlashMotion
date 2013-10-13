package components.section {
	import components.ComplexGraphicElement;
	
	import controls.CList;
	import controls.StaticField;
	import controls.ui.ItemList;
	import controls.ui.ScrollBox;
	import controls.ui.SingleButton;
	
	import events.ButtonEvent;
	import events.ParamsEvent;
	import events.SQLiteEvent;
	import events.CommonEvent;
	import events.ToolTipEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.Hint;

	public class SectionLink extends Sprite {
		
		public var cList:CList;	

		private var scroller:ScrollBox
		private var textFieldCGE:ComplexGraphicElement;
		private var staticField:StaticField;
		private var extendedLinkBTN:SingleButton;
		private var addLinkBTN:SingleButton;
		private var bg:ItemList;
		private var _initWidth:Number;
		private var _initHeight:Number;
		
		public function SectionLink(initWidth:Number, initHeight:Number){			

			_initWidth = initWidth;
			_initHeight = initHeight;
			textFieldCGE = new ComplexGraphicElement(initWidth, initWidth, 25, 0, 0, 0, 0, 0x454545);
			addChild(textFieldCGE);
			
			staticField = new StaticField("regular", "none", "none", "edit", 0xFFFFFF, 16);
			addChild(staticField);
			staticField.x = textFieldCGE.x - textFieldCGE.width
			staticField.width = textFieldCGE.width-30;
			staticField.y = textFieldCGE.y + textFieldCGE.height/2 - staticField.height/2;
			//
			extendedLinkBTN = new SingleButton("v");
			addChild(extendedLinkBTN);
			extendedLinkBTN.addEventListener(MouseEvent.CLICK, extendedLinkUp);
			extendedLinkBTN.x = -extendedLinkBTN.width-2;
			extendedLinkBTN.y = staticField.y+0.5; // выравнивание кнопок с текст филдом staticField

			addLinkBTN = new SingleButton(" + ");
			addChild(addLinkBTN);
			addLinkBTN.x = -(addLinkBTN.width + extendedLinkBTN.width+3);
			addLinkBTN.y = extendedLinkBTN.y;
			addLinkBTN.addEventListener(MouseEvent.CLICK, addLinkUp);
			//
			cList = new CList(initWidth, initHeight-textFieldCGE.height);	
			cList.addEventListener(ToolTipEvent.SEND_PARAM, setToolTip);
			cList.addEventListener(ToolTipEvent.REMOVE_TOOLTIP, removeToolTip);
			cList.addEventListener(ParamsEvent.SETUP_PARAM, received);
			cList.addEventListener(CommonEvent.DELETE, deleteItem);
			cList.addEventListener(CommonEvent.CHECK_LOGIN_STEP_1,checkLogin);
			cList.addEventListener(SQLiteEvent.SEND_MESSAGE_STEP_1, reciveError);		

		}
		//После всех операций вызывается в последнюю очередь, чтобы иметь актуальные параметры по завершению checkLogin
		public function convertScrollBox(initHeight:Number):void {
			scroller = new ScrollBox(cList, _initWidth, initHeight);
			addChild(scroller);
			scroller.y = textFieldCGE.y+textFieldCGE.height+1;
		}
		public function setItem(num:Number):void {
			scroller.setPosY(num);//отправляет координаты найденного итема для возможности прокрутки скролла на позицию итема.
			
		}
		public function editBaseList():void {
			cList.editBaseList();
			
		}
		protected function reciveError(e:SQLiteEvent):void {
		dispatchEvent(new SQLiteEvent(SQLiteEvent.SEND_MESSAGE_STEP_2, e.value));
			
		}
		
		protected function checkLogin(event:CommonEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.CHECK_LOGIN_STEP_2));
			
		}
		
		protected function deleteItem(event:CommonEvent):void {
			updateCListScroller();
			
		}
		
		protected function received(e:ParamsEvent):void {
			dispatchEvent(new ParamsEvent(ParamsEvent.SETUP_PARAM_UP,e.value1, e.value2, e.value3));
			
		}
		
		protected function removeToolTip(event:Event):void {
			Hint.hideToolTip();
			
		}
		
		protected function setToolTip(e:ToolTipEvent):void {
			Hint.showToolTip(100, 80, e.value);
		}
		
		protected function addLinkUp(e:MouseEvent):void {
			if(staticField.length > 0){
				cList.addButton(_initWidth, staticField.text, "");
				updateCListScroller();
			}
			
		}
		public function onRollOut(event:CommonEvent=null):void {
			if(bg != null){
				removeChild(bg);
				bg = null;
			}
			
		}

		protected function extendedLinkUp(event:MouseEvent):void {
			if(bg == null){
				bg = new ItemList("Расширенный режим");
				bg.addEventListener(ButtonEvent.PRESS_EXTENDED_BUTTON, onMouseUp);
				bg.addEventListener(CommonEvent.MOUSE_OUT_ITEMLIST, onRollOut);
				addChild(bg);
				bg.y = textFieldCGE.y + textFieldCGE.height;
			}
		}
		
		protected function onMouseUp(e:ButtonEvent):void {
			dispatchEvent(new ButtonEvent(ButtonEvent.PRESS_MENU_BUTTON, staticField.text));

		}

		public function scaleCList(initWidth:Number, initHeight:Number):void {
			_initWidth = initWidth;
			_initHeight = initHeight;
			cList.updateWidth(-initWidth, initHeight);
			textFieldCGE.updateXY(0, initWidth, 25, 0, 0, 0, 0, 0x454545);
			staticField.updateXY(30, initWidth);
			if(scroller != null)scroller.updateGraphic(initWidth, initHeight-textFieldCGE.height, cList.height);

		}

		public function nextEventMouseUp():void {
			cList.onMouseUp();
			
		}
		//обновление скроллера после добавления новых заметок
		public function updateCListScroller():void {
			scroller.updateGraphic(_initWidth, _initHeight-textFieldCGE.height, cList.height)
			
		}
		public function fullscreenHeight(initHeight:int):void {
			scroller.updateGraphic(_initWidth, initHeight-textFieldCGE.height, cList.height);
			
		}
	}
}