package controls.ui {
	import components.GraphicElement;
	
	import events.OneNumberEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Slider extends Sprite {

		private var bg:GraphicElement;
		private var _initWidth:int;
		public const _widthPimp:int = 18;
		private var movePimpBoo:Boolean = true;
		private var _grab:Number;
		private var pimpBitmap:Bitmap;
		private var pimp:Sprite = new Sprite();
		
		[Embed(source="assets/button/pimp.png")]
		private var PimpClass:Class;
		private var progressBar:GraphicElement;
		private var pos:Number;

		public function Slider(initWidth:int) {	
			_initWidth = initWidth;
			
			if (this.stage != null)init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		public function newPositionPimp(positionPimp:uint):void {
			if(movePimpBoo){
				progressBar.updateXY(-2, positionPimp*2, 3, 0.5, 0.5);
				pimp.x = -progressBar.width;
			}	
		}
		private function init(e:Event = null):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
				
			bg = new GraphicElement(_initWidth, 5, 0xffffff,3,3);
			addChild(bg);
			progressBar = new GraphicElement(0, 3, 0xCCCCCC, 0.5, 0.5);
			addChild(progressBar);
			progressBar.y = 1;
			addChild(pimp);
			pimpBitmap = new PimpClass();
			pimp.addChild(pimpBitmap)
			pimp.rotation = 180;
			pimp.addEventListener(MouseEvent.MOUSE_DOWN, downPimp);
			pimp.x = 0;
			pimp.y = pimp.height-2;
			
		}
		protected function downPimp(event:MouseEvent):void{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, movePimp);
			stage.addEventListener(MouseEvent.MOUSE_UP, upPimp);
			movePimpBoo = false;
			_grab = pimp.mouseX;
			
		}
		
		protected function upPimp(event:MouseEvent):void{
			movePimpBoo = true;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, movePimp);
			dispatchEvent(new OneNumberEvent(OneNumberEvent.CLICK_SLIDER_PIMP, pimp.x));
			stage.removeEventListener(MouseEvent.MOUSE_UP, upPimp);
		}
		public function update(num:Number):void {
			bg.updateXY(0, num-90, 5, 3, 3);

		}
		protected function movePimp(event:MouseEvent):void{
			pimp.x = Math.min(Math.max(-(bg.x+bg.width-_widthPimp-1), this.mouseX+_grab), 0);
			progressBar.updateXY(-2, -pimp.x, 3,0.5,0.5);
			
		}
		public function enabled():void {
			pimp.visible = true;
			this.mouseChildren = true;
			this.mouseEnabled = true;
			
		}
		public function disabled():void {
			pimp.visible = false;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
		}
	}
}