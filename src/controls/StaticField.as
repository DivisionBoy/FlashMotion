package controls {
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	public class StaticField extends TextField {
		
		private var formats:Object = new Object();
		private var editTextVar:String;
		private var _format:String;
		
		// CONSTRUCTOR
		public function StaticField(format:String, wordWrapText:String, borderText:String, editText:String, color:uint = 0, h:uint=17,w:uint=140):void {
			editTextVar = editText;
			_format = format;
			// FORMATS
			formats.regular = new TextFormat("Arial", 12);
			formats.regular.align = TextFormatAlign.LEFT;
			addEventListener(MouseEvent.CLICK, mouseDown);
			addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, focusKill);
			addEventListener(FocusEvent.FOCUS_OUT, focusKill);
			
			formats.search = new TextFormat("Arial", 11);
			formats.search.align = TextFormatAlign.LEFT;
			
			formats.tabBar = new TextFormat("Arial", 11);
			formats.tabBar.align = TextFormatAlign.LEFT;
			
			formats.boldText = new TextFormat("tahoma", 14);
			formats.boldText.align = TextFormatAlign.LEFT;
			formats.boldText.bold = true;
						
			formats.title = new TextFormat("Arial", 12, 0x484C51);
			formats.title.align = TextFormatAlign.LEFT;
			formats.title.bold = true;
			
			formats.componentTitle = new TextFormat("Arial", 12, 0x484C51);
			formats.componentTitle.align = TextFormatAlign.CENTER;
			formats.componentTitle.bold = true;
			
			formats.componentRegular = new TextFormat("Arial", 12, 0x484C51);
			formats.componentRegular.align = TextFormatAlign.LEFT;

			height = h;
			selectable = false;
			antiAliasType = AntiAliasType.ADVANCED;
			type = TextFieldType.INPUT;
			if(color != 0)background = true, backgroundColor = color;
			
			if("edit" == editTextVar){
				mouseEnabled = true;
			}else{
				mouseEnabled = false;
			}
			
			defaultTextFormat = formats[format];
			if (w == 0) autoSize = TextFieldAutoSize.LEFT else width = w;
			if("border" == borderText){
				border = true; 
			} else{ 
				border = false;
			}
			if("wordWrap" == wordWrapText){
				multiline = true;
				wordWrap = true;			
			}
			if("Main" == wordWrapText){
				textColor =(0x7A7A7A);		
			}
		}
		public function updateXY(PAD:Number, initWidth:Number):void {
			x = - initWidth;
			width = initWidth-PAD;
			
		}
		private function focusKill(e:FocusEvent=null):void {
			if(_format != "search"){
				textColor =(0x000000);
				background = true;
				backgroundColor = 0xFFFFFF;
				selectable = false;
				stage.focus = null;				
			}else{
				textColor =(0x000000);
				background = false;
				selectable = false;
				stage.focus = null;
				border = false;
			}
		}
		
		public function mouseDown(e:MouseEvent=null):void {
			if("edit" == editTextVar){
				textColor =(0xFFFFFF);
				background = true;
				backgroundColor = 0x000000;
				mouseEnabled = true;
				selectable = true;
				type = TextFieldType.INPUT;
				if(_format == "search")background = false, border = true, textColor =(0x00000);
			}
		}
		
		public function setFormat(format:String):void {
			setTextFormat(formats[format]);
		}
		
		public function resizeWidth(WIDTH:uint):void {
			width = WIDTH;
		}
		
		public function resizeHeight(HEIGHT:uint):void {
			//height = HEIGHT;
		}
		
	}//class
}//package