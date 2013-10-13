package controls.ui {
	import components.ComplexGraphicElement;
	import components.GradientFillGraphics;
	import components.TriangleGraphic;
	
	import controls.ComboListView;
	import controls.SingleField;
	
	import events.CommonEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import model.Hint;
	
	public class ComboBox extends Sprite {

		private var contBtn:Sprite;
		
		private var bg:ComplexGraphicElement;
		private var comboBtnUp:ComplexGraphicElement;
		private var line:GradientFillGraphics;
		private var comboBtnDown:GradientFillGraphics;
		private var arrFonts:Array = new Array();
		private var listView:ComboListView;
		private var num:int = -1;
		private var comboList:Sprite;
		private var scroller:ScrollBoxMenu;
		public var label:String;
		private var txt:SingleField;
		private var _width:Number = 90;
		private var _height:Number = 18;
		private var sizeValue:String;
		private var arr:Array;
		private var scrollHeight:int;
		private var targetItem:Object;
		private var targetItemNum:int;
		private var arrObject:Array = new Array();

		public function ComboBox(arr:Array=null, initWidth:Number = 180) {
			contBtn = new Sprite();
			comboList = new Sprite();
			this.arr = arr;
			_width = initWidth;

			addChild(contBtn);
			bg = new ComplexGraphicElement(_width,_width, _height, 5, 0, 5, 0, 0xFFFFFF);
			addChild(bg);
			bg.x = bg.width

			comboBtnUp = new ComplexGraphicElement(10,10, _height, 0, 5, 0, 5, 0xFFFFFF);
			contBtn.addChild(comboBtnUp);
			
			comboBtnUp.addEventListener(MouseEvent.MOUSE_UP, comboClick);
			comboBtnUp.addEventListener(MouseEvent.ROLL_OVER, comboRollOver);
			comboBtnUp.addEventListener(MouseEvent.ROLL_OUT, comboRollOut);
			comboBtnDown = new GradientFillGraphics(10,10, 18,[0xFFFFFF, 0xADADAD, 0xADADAD], "round", 0, 5, 0, 5); 
			contBtn.addChild(comboBtnDown);
			comboBtnDown.visible = false;
			comboBtnDown.mouseEnabled = false;
			txt = new SingleField("regular", "none", 11); 
			addChild(txt);
			txt.width = bg.width-1;
			txt.x = bg.x - txt.width;
			txt.height = 18;
			if(sizeValue+"" != "NaN")txt.text = sizeValue+"";

			var triangle:TriangleGraphic = new TriangleGraphic("fill", 0x262626);
			contBtn.addChild(triangle);
			triangle.y = 13;
			triangle.x = -3;
			triangle.rotation = 180;

			contBtn.x = bg.x + comboBtnUp.width;
			//
			if(arr != null){
				for(var i:int = 0; i < arr.length; i++){
					num++;
					arrFonts.push(arr[i]);
					listView = new ComboListView(arr[i],_width);
					arrObject.push(listView)
					listView.addEventListener(MouseEvent.CLICK, listClick);
					comboList.addChild(listView);
					listView.y = listView.height*num;
				}
			}
			if(arrFonts[0] != null)txt.text = arrFonts[0];
		}
		public function setValue(num:String):void {
			sizeValue = num;
			if(sizeValue!= null && txt != null)txt.text = sizeValue+"";
		}
		public override function set width(value:Number):void{
			_width = value;
			
		}
		public function getWidth():Number{
			return _width+10;
		}
		public function getHeight():Number{
			return _height;
		}
		public function set selectedIndex(value:Number):void {
			if(arrFonts[value] != null)txt.text = arrFonts[value];
			
		}
		public function get selectedIndex():Number {
			return targetItemNum;
		}

		protected function initStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, initStage);

		}
		
		protected function stageClick(e:MouseEvent):void {

			if(scroller.maskObject.hitTestPoint(stage.mouseX, stage.mouseY) == false)removeList();
			
		}
		public function addItem(str:String, widthItem:Number = 180):void {
			num++;
			arrFonts.push(str);
			listView = new ComboListView(str,widthItem);
			listView.addEventListener(MouseEvent.CLICK, listClick);
			comboList.addChild(listView);
			listView.y = listView.height*num;
			
			arrObject.push(listView)
			
		}

		protected function listClick(e:MouseEvent):void {
			targetItem = e.currentTarget as DisplayObject;
			targetItemNum = arrObject.indexOf(targetItem);
			
			label = e.currentTarget.txt.text;
			txt.text = label
			dispatchEvent(new CommonEvent(CommonEvent.CHANGE));

			removeList();
			
		}
		private function removeList():void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageClick);
			stage.removeChild(scroller);
			scroller = null;
			comboBtnUp.mouseChildren = true;
			comboBtnUp.mouseEnabled = true;
			dispatchEvent(new CommonEvent(CommonEvent.COMBOBOX_CLOSE));
			
		}
		protected function comboRollOut(event:MouseEvent):void {
			comboBtnDown.visible = false;
			
		}
		
		protected function comboRollOver(event:MouseEvent):void {
			comboBtnDown.visible = true;
			
		}
		
		protected function comboClick(e:MouseEvent):void {
			if(comboList.height > 250){
				scrollHeight = 250;
			}else{
				scrollHeight = comboList.height;
			}
			comboBtnUp.mouseChildren = false;
			comboBtnUp.mouseEnabled = false;
			scroller = new ScrollBoxMenu(comboList, scrollHeight);

			var pt:Point = new Point(e.target.x, e.target.y+25);
			pt = e.target.parent.localToGlobal(pt);
			stage.addChild(scroller);
			scroller.x = pt.x;
			scroller.y = pt.y;
			dispatchEvent(new CommonEvent(CommonEvent.COMBOBOX_BUTTON));

			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageClick);
		}		
		
	}
}