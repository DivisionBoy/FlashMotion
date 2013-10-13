package controls.ui {
	import components.BorderGraphicElement;
	import components.ComplexGraphicElement;
	import components.GraphicElement;
	import components.TopBar;
	
	import controls.StaticField;
	
	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class EmptyForm extends Sprite {
		
		private const MIN_WIDTH:int = -250;
		private const GAP:int = 20;
		private const strokeColor:uint = 0xE0E0E0;
		//private const MIN_HEIGHT:int = 350;
		private var resizebtn:DragButton;
		private var borderGE:BorderGraphicElement;
		private var topBar:TopBar;
		private var statusBar:ComplexGraphicElement;
		private var mainBG:GraphicElement;
		private var title:StaticField;
		
		public function EmptyForm(titleValue:String, initWidth:Number, initHeight:Number) {
			super();
			
			var glowBG:GlowFilter = new GlowFilter(0x000000, 1, 16, 16, 1, 1);
			resizebtn = new DragButton();
			resizebtn.x = Math.min(-initWidth, MIN_WIDTH);
			resizebtn.y = initHeight;
			
			mainBG = new GraphicElement(-resizebtn.x+GAP, resizebtn.y+resizebtn.height, 0xB9BDC1);
			addChild(mainBG);
			mainBG.filters = [glowBG];
			mainBG.x = 0;

			borderGE = new BorderGraphicElement(-resizebtn.x+GAP, resizebtn.y+resizebtn.height, strokeColor);

			topBar = new TopBar(-resizebtn.x+GAP, 20, 10, 10, 0, 0);
			addChild(topBar);
			if(titleValue.length > 0){
				title = new StaticField("title", "wordWrap", "", "",0, 18, initWidth);
				addChild(title);
				title.text = titleValue;
				title.x = -initWidth-GAP;
				title.width = initWidth+GAP;
			}
			
			statusBar = new ComplexGraphicElement(-resizebtn.x+GAP - resizebtn.width,-resizebtn.x+GAP - resizebtn.width, 20, 0, 0, 0, 10, 0xF8F5F0);	
			statusBar.y = resizebtn.y;
			
			this.addChild(statusBar);
			this.addChild(resizebtn);
			this.addChild(borderGE);
		}
		protected function close(event:MouseEvent):void{
			dispatchEvent(new CommonEvent(CommonEvent.EXIT));
			
		}
		public function showCloseButton():void {
			var closeBTN:CloseButton = new CloseButton();
			addChild(closeBTN);
			closeBTN.x = -15;
			closeBTN.y = 2;
			closeBTN.addEventListener(MouseEvent.CLICK, close);
			
		}
		public function hideStatusBar():void {
			statusBar.visible = false;
			resizebtn.visible = false;
		}
	}
}