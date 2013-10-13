package components {
	import controls.ui.CheckButton;
	import controls.ui.SingleButtonAdv;
	
	import events.ButtonEvent;
	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	public class InsideWindow extends Sprite{
		private var bg:GraphicElement;
		private var glowBG:GlowFilter = new GlowFilter(0x000000, 1, 16, 16, 1, 1);
		public var txtTitle:TextField;
		public var txtDescript:TextField;
		private var btnOk:SingleButtonAdv;
		private var bntContainer:Sprite;
		private var checkbtn:CheckButton;
		
		public function InsideWindow(title:String, initWidth:int, initHeight:int) {
			
			bg = new GraphicElement(initWidth, initHeight, 0xFFFFFF);
			addChild(bg);
			bg.filters = [glowBG];
			bntContainer = new Sprite();
			addChild(bntContainer);
			btnOk = new SingleButtonAdv("Ok");
			bntContainer.addChild(btnOk);
			btnOk.addEventListener(MouseEvent.MOUSE_UP, onMouseUpOk);

			var btnCancel:SingleButtonAdv = new SingleButtonAdv("Cancel");
			bntContainer.addChild(btnCancel);
			btnCancel.addEventListener(MouseEvent.MOUSE_UP, onMouseUpCancel);
			btnCancel.x = btnOk.x + btnOk.width+5;
			bntContainer.x = -bntContainer.width-5;
			bntContainer.y = initHeight - bntContainer.height-5;
			var txtLabel:TextField = createTextField(title, -bg.width, bg.width, 20, "none");
			addChild(txtLabel);

			txtTitle = createTextField("", -bg.width+2, bg.width-4, 20, "INPUT_LINE", true);
			addChild(txtTitle);
			txtTitle.y = txtLabel.y + txtLabel.height;
			txtTitle.addEventListener(Event.CHANGE, checkTextField);
			//
			if(title != "Login"){
				var txtLabelDes:TextField = createTextField("Description", -bg.width, bg.width, 20, "none");
				addChild(txtLabelDes);
				txtLabelDes.y = txtTitle.y + txtTitle.height+2;
				txtDescript = createTextField("", -bg.width+2, bg.width-4, 60, "INPUT", true);
				addChild(txtDescript);
				txtDescript.y = txtLabelDes.y + txtLabelDes.height+2;
			}else{
				txtTitle.displayAsPassword = true;
				checkbtn = new CheckButton("Запомнить");
				checkbtn.x = -bg.width+18;
				checkbtn.y = txtTitle.y + txtTitle.height+5;
				addChild(checkbtn);

				checkbtn.addEventListener(CommonEvent.TOGGLE_CHECKBOX_UP, checkBoxUp);
				checkbtn.addEventListener(CommonEvent.TOGGLE_CHECKBOX_DOWN, checkBoxDown);
				
				txtDescript = createTextField("", -bg.width, bg.width, 60, "DYNAMIC");
				addChild(txtDescript);
				txtDescript.textColor = 0xFF0000;
				txtDescript.y = checkbtn.y + checkbtn.height+2;
				
			}
			checkTextField();
			
		}
		
		protected function checkBoxDown(event:Event):void{
			dispatchEvent(new ButtonEvent(ButtonEvent.BUTTON_CHECKBOX, "false"));
			
		}
		
		protected function checkBoxUp(event:CommonEvent):void{
			dispatchEvent(new ButtonEvent(ButtonEvent.BUTTON_CHECKBOX, "true"));
			
		}

		public function errorMessages(str:String):void {
			txtDescript.text = str
			bntContainer.y = (txtDescript.y + txtDescript.height+5);
			bg.updateXY(0, 150, txtDescript.y + txtDescript.height + bntContainer.height+10); 

			txtDescript.wordWrap = true;
			txtDescript.multiline = true;
			txtDescript.autoSize = TextFieldAutoSize.LEFT;

		}
		private function checkTextField(e:Event=null):void {
			if(txtTitle.length > 1){
				btnOk.mouseChildren = true;
				btnOk.mouseEnabled = true;
				btnOk.alpha = 1
			}else{
				btnOk.mouseChildren = false;
				btnOk.mouseEnabled = false;
				btnOk.alpha = 0.5
			}
			
		}
		protected function onMouseUpOk(event:MouseEvent):void {
			dispatchEvent(new ButtonEvent(ButtonEvent.BUTTON_OK, txtTitle.text+","+ txtDescript.text));

		}
		
		protected function onMouseUpCancel(event:MouseEvent):void {
			dispatchEvent(new ButtonEvent(ButtonEvent.BUTTON_CANCEL,null));

		}
		public function writeTextTitle(title:String):void{
			txtTitle.text = title;
			checkTextField();
			
		}
		public function writeTextDes(des:String):void{
			txtDescript.text = des;
			checkTextField();
			
		}
		private function createTextField(txtLabel:String, initX:Number, initWidth:Number, height:Number, txtType:String, bgBoo:Boolean = false):TextField{
			var txt:TextField = new TextField();
			txt.text = txtLabel;
			txt.x = initX;
			txt.width = initWidth;
			txt.height = height;
			txt.selectable = false;

			if(txtType == "INPUT"){
				txt.width = initWidth
				txt.height = height;
				txt.selectable = true
				txt.wordWrap = true;
				txt.multiline = true;
				txt.textColor = 0xFFFFFF
				txt.type = TextFieldType.INPUT;
			}
			if(txtType == "DYNAMIC"){
				txt.width = initWidth
				txt.height = height;
				txt.selectable = false
				txt.mouseEnabled = false

			}
			if(txtType == "INPUT_LINE"){
				txt.width = initWidth
				txt.height = height;
				txt.selectable = true
				txt.wordWrap = false;
				txt.multiline = false;
				txt.textColor = 0xFFFFFF
				txt.type = TextFieldType.INPUT;
			}
			if(bgBoo != false)txt.background = true, txt.backgroundColor = 0x000000;
			return txt;
		}
	}
}