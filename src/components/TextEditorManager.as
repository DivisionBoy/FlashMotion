package components {
	import controls.ui.ColorPicker;
	import controls.ui.ComboBox;
	import controls.ui.ToggleButton;
	
	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TextEditorManager extends Sprite {
		
		private var myText:String;
		private var myText_orig:String;
		private var _mainText:TextField;
		private var userFonts:Array;
		private var allFontNames:Array;

		public static const ON_TEXT_SAVED:String = "onTextSaved";
		private var sizeArray:Array = new Array("8","9", "10", "11", "12", "14","16","18","20","22","24","26","28","36","48","72"); 
		private var buttonBold:ToggleButton;
		private var fontList:ComboBox;
		private var buttonItalic:ToggleButton;
		private var buttonUnderline:ToggleButton;
		private var buttonLeft:ToggleButton;
		private var buttonRight:ToggleButton;
		private var buttonCenter:ToggleButton;
		private var sizeList:ComboBox;
		private var colorPicker:ColorPicker;
		
		public function TextEditorManager(mainText:TextField = null) {
			super();
			_mainText = mainText;
			_mainText.alwaysShowSelection = true;
			_mainText.addEventListener(MouseEvent.MOUSE_UP, checkTextFormat);
			
			buttonBold = new ToggleButton("assets/button/textEditor/textEditor_bold_up.png","assets/button/textEditor/textEditor_bold_down.png");
			addChild(buttonBold);
			buttonBold.addEventListener(MouseEvent.CLICK, changeBold);
			buttonBold.y = 22;
			//
			buttonItalic = new ToggleButton("assets/button/textEditor/textEditor_italic_up.png","assets/button/textEditor/textEditor_italic_down.png");
			addChild(buttonItalic);
			buttonItalic.addEventListener(MouseEvent.CLICK, changeItalic);
			buttonItalic.y = 22;
			buttonItalic.x = 27
			//
			buttonUnderline = new ToggleButton("assets/button/textEditor/textEditor_underline_up.png","assets/button/textEditor/textEditor_underline_down.png");
			addChild(buttonUnderline);
			buttonUnderline.addEventListener(MouseEvent.CLICK, changeUnderline);
			buttonUnderline.y = 22;
			buttonUnderline.x = buttonItalic.x*2;
			//
			buttonLeft = new ToggleButton("assets/button/textEditor/textEditor_left_up.png","assets/button/textEditor/textEditor_left_down.png");
			addChild(buttonLeft);
			buttonLeft.addEventListener(MouseEvent.CLICK, setLeft);
			buttonLeft.y = 22;
			buttonLeft.x = buttonUnderline.x+27;
			//
			buttonCenter = new ToggleButton("assets/button/textEditor/textEditor_center_up.png","assets/button/textEditor/textEditor_center_down.png");
			addChild(buttonCenter);
			buttonCenter.addEventListener(MouseEvent.CLICK, setCenter);
			buttonCenter.y = 22;
			buttonCenter.x = buttonUnderline.x*2;
			//
			buttonRight = new ToggleButton("assets/button/textEditor/textEditor_right_up.png","assets/button/textEditor/textEditor_right_down.png");
			addChild(buttonRight);
			buttonRight.addEventListener(MouseEvent.CLICK, setRight);
			buttonRight.y = 22;
			buttonRight.x = buttonCenter.x+27;
			//
			sizeList = new ComboBox(null, 20);
			addChild(sizeList);
			sizeList.setValue(12+"");
			sizeList.addEventListener(CommonEvent.CHANGE, changeSize);
			sizeList.y = 0;
			sizeList.x = buttonRight.x-8;
			//
			colorPicker = new ColorPicker();
			addChild(colorPicker);
			colorPicker.x = sizeList.x - 5
			colorPicker.addEventListener(CommonEvent.CHANGE, changeColor);
			//
			fontList = new ComboBox(null, 90);
			addChild(fontList);
			fontList.addEventListener(CommonEvent.CHANGE, changeFont);
			fontList.y = 0;
			fontList.x = colorPicker.x-123;
			fontList.setValue("Arial");
			userFonts = Font.enumerateFonts(true);
			userFonts.sortOn("fontName", Array.CASEINSENSITIVE);

			allFontNames = new Array();
			
			for (var i:int = 0; i < userFonts.length; i++ ) {
				fontList.addItem( userFonts[i].fontName+"" );

				allFontNames.push(userFonts[i].fontName);
			}
			for(var j:int=0; j < sizeArray.length; j++){
					sizeList.addItem( sizeArray[j]+"", 40 );
				
			}
			
		}
		public function nextEventMouseUp():void {
	
		}
		
		private function enableButtons():void {
			fontList.addEventListener(CommonEvent.CHANGE, changeFont);
			buttonBold.addEventListener(MouseEvent.CLICK, changeBold);

		}	
					
	
		
		private function changeFont(e:CommonEvent):void {
			editTextFormat("font", e.target.label);
			dispatchEvent(new CommonEvent(CommonEvent.BACK));
		}
		
		private function changeSize(e:Event):void {
			editTextFormat("size", e.target.label);
			dispatchEvent(new CommonEvent(CommonEvent.BACK));
		}
		
		private function changeColor(e:Event):void {
			editTextFormat("color", e.target.selectedColor);
			dispatchEvent(new CommonEvent(CommonEvent.BACK));
		}
		
		private function changeBold(e:Event):void {
			editTextFormat("bold");
			dispatchEvent(new CommonEvent(CommonEvent.BACK));
		}
		
		private function changeItalic(e:MouseEvent):void {
			editTextFormat("italic");
			dispatchEvent(new CommonEvent(CommonEvent.BACK));
		}
		
		private function changeUnderline(e:MouseEvent):void {
			editTextFormat("underline");
			dispatchEvent(new CommonEvent(CommonEvent.BACK));
		}
		
		private function setLeft(e:MouseEvent):void {
			editTextFormat("left");
			dispatchEvent(new CommonEvent(CommonEvent.BACK));
		}
		
		private function setCenter(e:MouseEvent):void {
			editTextFormat("center");
			dispatchEvent(new CommonEvent(CommonEvent.BACK));
		}
		
		private function setRight(e:MouseEvent):void {
			editTextFormat("right");
			dispatchEvent(new CommonEvent(CommonEvent.BACK));
		}
		
		private function setURL(e:Event):void {
			editTextFormat("url", e.target.text);
		}
		
		private function setTarget(e:Event):void {
			editTextFormat("target", e.target.selectedItem.data);
		}
		
		private function checkTextFormat(e:Event = null):void {	
			if (_mainText.selectionBeginIndex != _mainText.selectionEndIndex){				
				var tempTextFormat:TextFormat = _mainText.getTextFormat(_mainText.selectionBeginIndex, _mainText.selectionEndIndex);

				tempTextFormat.bold ? buttonBold.state("false") : buttonBold.state("true");
				tempTextFormat.italic ? buttonItalic.state("false") : buttonItalic.state("true");
				tempTextFormat.underline ? buttonUnderline.state("false") : buttonUnderline.state("true");

				tempTextFormat.align == "left" ? buttonLeft.state("false") : buttonLeft.state("true");
				tempTextFormat.align == "center" ? buttonCenter.state("false") : buttonCenter.state("true");
				tempTextFormat.align == "right" ? buttonRight.state("false") : buttonRight.state("true");

				sizeList.setValue(int(tempTextFormat.size)+"")

				tempTextFormat.font ? fontList.selectedIndex = allFontNames.indexOf(tempTextFormat.font) : fontList.selectedIndex = -1;

			}
		}

		private function editTextFormat(type:String, val:* = null):void {		
			if (_mainText.selectionBeginIndex != _mainText.selectionEndIndex){
				var tempTextFormat:TextFormat = _mainText.getTextFormat(_mainText.selectionBeginIndex, _mainText.selectionEndIndex);

				switch(type){
					case "font":
						tempTextFormat.font = val;
						break;
					case "size":
						tempTextFormat.size = val;
						break;
					case "color":
						tempTextFormat.color = val;
						break;
					case "bold":
						tempTextFormat.bold ? tempTextFormat.bold = false : tempTextFormat.bold = true;
						break;	
					case "italic":
						tempTextFormat.italic ? tempTextFormat.italic = false : tempTextFormat.italic = true;
						break;	
					case "underline":
						tempTextFormat.underline ? tempTextFormat.underline = false : tempTextFormat.underline = true;
						break;
					case "left":
						tempTextFormat.align = "left";
						break;				
					case "center":
						tempTextFormat.align = "center";
						break;				
					case "right":
						tempTextFormat.align = "right";
						break;			
					case "url":
						tempTextFormat.url = val;
						val != "" ? tempTextFormat.underline = true : tempTextFormat.underline = false;
						break;
					case "target":
						tempTextFormat.target = val;
						break;							
					default:
				}

				_mainText.setTextFormat(tempTextFormat, _mainText.selectionBeginIndex, _mainText.selectionEndIndex);
				checkTextFormat();
			}
		}

	}
}