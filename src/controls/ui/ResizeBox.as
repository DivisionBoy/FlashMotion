package controls.ui {
	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ResizeBox extends Sprite {
		
		private var btnResize:Sprite;
		private var line:Sprite;
		private var btnRotate:Sprite;

		public function ResizeBox(initX:Number, initY:Number) {
			btnResize = createCircle(0xFFFFFF);
			addChild(btnResize);
			btnResize.x = initX;
			btnResize.y = initY;
			btnResize.addEventListener(MouseEvent.MOUSE_DOWN, downResize);

			btnRotate = createCircle(0x9FFF80);
			addChild(btnRotate);
			btnRotate.x = initX/2;
			btnRotate.y = 0
			btnRotate.addEventListener(MouseEvent.MOUSE_DOWN, downRotate);

			line = new Sprite();
			addChildAt(line, getChildIndex(btnResize));
			line.addEventListener(MouseEvent.MOUSE_DOWN, onPressBox);
			line.graphics.beginFill(0xCCCCCC,0.1);
			line.graphics.lineStyle(2,0x000000);
			line.graphics.drawRect(0,0,btnResize.x,btnResize.y);
			line.graphics.endFill();
			
		}
		public function getWidth():Number {
			return line.width;
			
		}
		public function getHeight():Number {
			return line.height;
			
		}
		
		protected function onPressBox(event:MouseEvent):void{
			dispatchEvent(new CommonEvent(CommonEvent.ON_PRESS_DRAGGABLE));
			
		}
		
		protected function onPress(event:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onPress);
		}
		
		protected function downRotate(event:MouseEvent):void{
			dispatchEvent(new CommonEvent(CommonEvent.ON_PRESS_ROTATE));

		}
		
		protected function downResize(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onPress);
			
		}		
		
		protected function onMouseMove(e:MouseEvent):void{
			btnResize.x = mouseX;
			btnResize.y = mouseY;
			btnRotate.x = btnResize.x/2;
			updateLine(btnResize.x, btnResize.y);

			e.updateAfterEvent();
		}
		public function getResize():Number{
			return btnResize.x;
		}
		private function updateLine(initX:Number, initY:Number):void{		
			line.graphics.clear();

			line.graphics.beginFill(0xCCCCCC,0.1);
			line.graphics.lineStyle(2,0x000000);
			line.graphics.drawRect(0,0,initX,initY);
			line.graphics.endFill();
		}
		
		private function createCircle(color:uint):Sprite{
			var spCircle:Sprite = new Sprite();
			spCircle.graphics.beginFill(color)
			spCircle.graphics.lineStyle(1,0x000000);
			spCircle.graphics.drawCircle(0,0,5);
			spCircle.graphics.endFill();
			
			return spCircle;
			
		}

	}
}