package controls {
	import components.SquareGraphic;
	
	import controls.ui.ListButton;
	
	import events.CommonEvent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class CListView extends Sprite {
		private var txt:TextField;
		
		private var txtAlign:TextFormat = new TextFormat();		
		
		public var listButtonDelete:ListButton;
		public var listButtonEdit:ListButton;
		public var listButtonBuffer:ListButton;
		
		private var maskButton:SquareGraphic;
		public var contentButton:Sprite; 
		public var fillButton:SquareGraphic;
		private var numberList:NumberList;
		private var newColor:Boolean = false;
		private static var ct:ColorTransform;
		private var _initWidth:int;
		private var num:Number;
		private var desTemp:String;
		private var titleTemp:String;
		private var fullTitleTemp:String;
		private var id:int;
		
		public function CListView(initWidth:int, titleName:String, offset:int) {
			var sp:Sprite = new Sprite();
			addChild(sp)
			_initWidth = initWidth;
			ct = new ColorTransform();

			contentButton = new Sprite();
			
			numberList = new NumberList();
			addChild(numberList);
			numberList.createList(offset+1+"", 0);
			numberList.x = -initWidth;
			maskButton = new SquareGraphic(50,20);
			contentButton.addChild(maskButton);
			maskButton.x = -50;
			contentButton.mask = maskButton;
			contentButton.x = -15;
			fillButton = new SquareGraphic(-initWidth+40,20, 0xCCCCCC);
			addChild(fillButton);
			fillButton.x = -15;
			fillButton.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			fillButton.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			//
			txt = new TextField();
			addChild(txt);
			txt.x = -initWidth+25
		
			txtAlign.align = TextFormatAlign.LEFT;
			txtAlign.font = "Verdana";
			txtAlign.size = 12;

			txt.defaultTextFormat = txtAlign;
			txt.width = initWidth-45
			txt.height = 20;
			txt.selectable = false;
			txt.mouseEnabled = false
			addChild(contentButton)
			//DELETE
			listButtonDelete = new ListButton("delete");
			contentButton.addChild(listButtonDelete);
			listButtonDelete.y = -11;
			listButtonDelete.x = -5;
			listButtonDelete.name = offset+"";
			listButtonDelete.addEventListener(CommonEvent.MOUSE_OVER_DELETE, onOverDelete);
			listButtonDelete.addEventListener(CommonEvent.MOUSE_OUT_BUTTONLIST, onOutButtonlist);
			//BUFFER
			listButtonBuffer = new ListButton("buffer");
			contentButton.addChild(listButtonBuffer);
			listButtonBuffer.y = -11;
			listButtonBuffer.x = -20;
			listButtonBuffer.addEventListener(CommonEvent.MOUSE_OVER_BUFFER, onOverBuffer);
			listButtonBuffer.addEventListener(CommonEvent.MOUSE_OUT_BUTTONLIST, onOutButtonlist);
			//Button EDIT
			listButtonEdit = new ListButton("cogwheel");
			contentButton.addChild(listButtonEdit);
			listButtonEdit.y = -11;
			listButtonEdit.x = -35;
			listButtonEdit.addEventListener(CommonEvent.MOUSE_OVER_COGWHEEL, onOverCogweel);
			listButtonEdit.addEventListener(CommonEvent.MOUSE_OUT_BUTTONLIST, onOutButtonlist);
			//разбиение строки на массив букв для выявления в строке символа "/" и применение определенного цвета
			var arrChar:Array = titleName.split("");
			for(var i:int = 0; i < arrChar.length; i++){
				if(arrChar[i]=="/"){
					newColor = true
					this.txt.htmlText +="<font color='#5C5C5C'>"+"/"+"</font>";
				}else if(newColor == false){
					this.txt.htmlText +="<font color='#000066'>"+arrChar[i]+"</font>";
				}else{
					this.txt.htmlText +="<font color='#5C5C5C'>"+arrChar[i]+"</font>";
				}
			}
		}
		public function replaceLinkText(title:String):void {
			this.txt.htmlText = "";
			var arrChar:Array = title.split("");
			for(var i:int = 0; i < arrChar.length; i++){
				if(arrChar[i]=="/"){
					newColor = true;
					this.txt.htmlText +="<font color='#5C5C5C'>"+"/"+"</font>";
				}else if(newColor == false){
					this.txt.htmlText +="<font color='#000066'>"+arrChar[i]+"</font>";
				}else{
					this.txt.htmlText +="<font color='#5C5C5C'>"+arrChar[i]+"</font>";				
				}
			}
		}
			
		protected function onOut(event:MouseEvent):void{
			ct.color = 0xCCCCCC;
			fillButton.transform.colorTransform = ct;
			
		}
		public function selectColor():void {
			ct.color = 0xCCCCC;
			fillButton.transform.colorTransform = ct;
			
		}
		public function noneColor():void{
			ct.color = 0xCCCCCC;
			fillButton.transform.colorTransform = ct;
		}
		protected function onOver(event:MouseEvent):void{
			ct.color = 0xFFFFFF;
			fillButton.transform.colorTransform = ct;
			
		}
		public function setID(id:int):void {
			this.id = id;
			
		}
		public function getID():int {
			return id;
			
		}
		public function setNumber(num:Number):void{
			this.num = num;
			numberList.updateNumber(num+1);
		}

		public function setDes(text:String):void {
			desTemp = text;
			
		}
		public function getDes():String {
			return desTemp;
			
		}
		public function setTitle(text:String):void {
			titleTemp = text;
			
		}
		public function setFullTitle(text:String):void {
			fullTitleTemp = text;
			
		}
		public function getFullTitle():String {
			return fullTitleTemp;
			
		}
		public function getTitle():String {
			return titleTemp;
			
		}
		protected function onOverCogweel(event:CommonEvent):void {
			listButtonEdit.y = 0;	
		}
		
		protected function onOverBuffer(event:CommonEvent):void {
			listButtonBuffer.y = 0;
		}
		
		protected function onOverDelete(event:CommonEvent):void{
			listButtonDelete.y = 0;
			
		}
		
		protected function onOutButtonlist(event:CommonEvent):void {
			listButtonDelete.y = -11;
			listButtonBuffer.y = -11;
			listButtonEdit.y = -11;
		}
		
		public function getCount():int{		
			return num;
			
		}

		public override function set width(value:Number):void{
			numberList.x = value;
			fillButton.x = -15;//расстояние кнопок от скролла
			fillButton.updateXY(value+40, 20, 0xCCCCCC);
			
			txt.width = -value-45;
			txt.x = value+25;

		}

	}
}