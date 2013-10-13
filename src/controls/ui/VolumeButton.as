package controls.ui {
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class VolumeButton extends Sprite {
		
		private var volumeBtn:Bitmap;
		private var sp:Sprite;
		
		[Embed(source="/assets/button/volumeButton.png")]
		private var VolumeButtonClass:Class;
		public var sp_circle:Sprite;
		public var container:Sprite;
		private var isDown:Boolean;
		
		public function VolumeButton() {
			super();
			container = new Sprite();
			var containerSp:Sprite = new Sprite();
			addChild(containerSp);
			addChild(container);
			volumeBtn = new VolumeButtonClass();
			containerSp.addChild(volumeBtn);
			containerSp.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

			sp = new Sprite();
			sp_circle = new Sprite();
			
			container.addChild(sp)
			container.addChild(sp_circle);

			sp.graphics.lineStyle(2,0xC2C2C2)
			sp.graphics.drawCircle(0,0,15)
			sp.graphics.endFill();

			sp_circle.graphics.beginFill(0xFF6633);
			sp_circle.graphics.drawCircle(0, 0,5);
			sp_circle.graphics.endFill();
			sp_circle.x = 15;
			container.x = 10;
			container.y = 10;
			container.visible = false;
			container.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		public function mouseDown():void {
			isDown=false;
		}
		public function mouseUp():void {
			var tpoint:Point = localToGlobal(new Point(mouseX,mouseY));
			isDown=true;
			if(container.hitTestPoint(tpoint.x,tpoint.y,true)){
			
			}else{
				container.visible = false
			}
		}
		protected function onMouseOut(event:MouseEvent):void{
			if(isDown){
				container.visible = false;
			}			
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			container.visible = true;			
		}						
		
	}
}