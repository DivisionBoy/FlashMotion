package controls.ui {
	import components.CheckGraphic;
	import components.GraphicElement;
	
	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class CheckButton extends Sprite{

		private var flag:Boolean;
		private var btnCheck:GraphicElement;
		private var checkGraphic:CheckGraphic;
		private var contCheckOn:Sprite;
		
		public function CheckButton(str:String = null) {
			contCheckOn = new Sprite();
			
			buttonMode = true;
			btnCheck = new GraphicElement(16, 16, 0x000000, 5, 5);
			contCheckOn.addChild(btnCheck);
			btnCheck.addEventListener(MouseEvent.CLICK, clickButton);
			
			addChild(contCheckOn);
			if(str != null){
				var txt:TextField = new TextField();
				addChild(txt);
				txt.text = str+"";
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.height = 20;
				
				txt.x = contCheckOn.x;
				txt.selectable = false;
				txt.mouseEnabled = false;
			}
			
		}
		
		public function clickButton(e:MouseEvent):void {
			if(!this.flag){
				checkGraphic = new CheckGraphic();
				contCheckOn.addChild(checkGraphic);
				checkGraphic.x = -12;
				checkGraphic.y = 8;
				dispatchEvent(new CommonEvent(CommonEvent.TOGGLE_CHECKBOX_UP));
			}else{
				contCheckOn.removeChild(checkGraphic)
				checkGraphic = null
				dispatchEvent(new CommonEvent(CommonEvent.TOGGLE_CHECKBOX_DOWN));

			}
			this.flag = !this.flag;
			
		}
	}
}