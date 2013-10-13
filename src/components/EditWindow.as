package components {
	import controls.ui.EmptyForm;
	import controls.ui.SingleButtonAdv;
	
	import events.EditWindowEvent;
	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class EditWindow extends Sprite {
		
		private const GAP:Number = 20;
		private var editForm:EmptyForm;
		private var txt:TextField;
		private var textEditor:TextEditorManager;
		private var bg:GradientFillGraphics;
		private var ok:SingleButtonAdv;
		private var cancel:SingleButtonAdv;
		private var textTemp:String;
		public function EditWindow(message:String, formWidth:Number, formHeight:Number) {
			super();
			textTemp = message;
			
			editForm = new EmptyForm("Edit Sticker", formWidth, formHeight);
			addChild(editForm);
			editForm.hideStatusBar();

			txt = new TextField();
			txt.wordWrap = true;
			txt.multiline = true;
			txt.htmlText = message;
			editForm.addChild(txt);
			txt.type = TextFieldType.INPUT;
			txt.background = true;
			txt.backgroundColor = 0xFFFFFF;
			txt.width = formWidth + GAP - 1;
			txt.height = 150;
			txt.x = - formWidth - GAP;
			txt.y = GAP;

			txt.addEventListener(Event.CHANGE, inputText);
			//
			textEditor = new TextEditorManager(txt);
			editForm.addChild(textEditor);
			textEditor.addEventListener(CommonEvent.BACK, changeText);
			textEditor.y = txt.y + txt.height + 10;
			textEditor.x = -(txt.width) + (79);
			//

			ok = new SingleButtonAdv("OK");
			editForm.addChild(ok);
			ok.x = -ok.width - GAP;
			ok.y = formHeight - ok.HEIGHT/2;
			ok.addEventListener(MouseEvent.CLICK, onPressOk);
			//
			cancel = new SingleButtonAdv("CANCEL");
			editForm.addChild(cancel);
			cancel.addEventListener(MouseEvent.CLICK, onPressCancel);
			cancel.x = -ok.width-cancel.width - GAP - 10;
			cancel.y = formHeight - cancel.HEIGHT/2;

		}
		
		protected function inputText(event:Event):void{
			dispatchEvent(new EditWindowEvent(EditWindowEvent.MOUSE_DOWN));
			
		}
		
		protected function changeText(event:CommonEvent):void{
			dispatchEvent(new EditWindowEvent(EditWindowEvent.MOUSE_DOWN));
		}
		
		protected function onPressCancel(event:MouseEvent):void{
			txt.htmlText = textTemp;
			dispatchEvent(new EditWindowEvent(EditWindowEvent.BUTTON_CANCEL));
			
		}
		
		protected function onPressOk(event:MouseEvent):void{
			dispatchEvent(new EditWindowEvent(EditWindowEvent.BUTTON_OK));
			
		}
		public function getMessage():String {
			return txt.htmlText;
			
		}
	}
}