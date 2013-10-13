package controls.ui {
	import components.CrossGraphic;
	import components.SquareGraphic;
	
	import events.CommonEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TwoChoiceButton extends Sprite{
		
		[Embed(source="/assets/button/twoChoiceButton.png")]
		private var TwoChoicePNG:Class;
		[Embed(source="/assets/button/twoChoiceButton_over.png")]
		private var TwoChoiceOverPNG:Class;
		private var btnOut:Bitmap;
		private var deleteButton:CrossGraphic;
		private var bgEdit:DisplayObject;
		private var bgDelete:SquareGraphic;
		private var btnOver:Bitmap;
		
		public function TwoChoiceButton(){
			super();
			bgEdit = new SquareGraphic(20,20,0xCCCCC);
			addChild(bgEdit);
			bgEdit.alpha = 0;
			bgDelete = new SquareGraphic(20,20,0xCCCCC);
			addChild(bgDelete);
			bgDelete.alpha = 0;
			btnOut = new TwoChoicePNG();
			addChild(btnOut);
			btnOut.alpha = 0.7;
			btnOver = new TwoChoiceOverPNG();
			addChild(btnOver);
			btnOver.visible = false;
			deleteButton = new CrossGraphic(0x333333);
			addChild(deleteButton);
			
			bgDelete.addEventListener(MouseEvent.MOUSE_OVER, onOverDelete);
			bgDelete.addEventListener(MouseEvent.MOUSE_OUT, onOutDelete);
			bgDelete.addEventListener(MouseEvent.CLICK, deleteClick);
			//
			bgEdit.addEventListener(MouseEvent.MOUSE_OVER, onOverEdit);
			bgEdit.addEventListener(MouseEvent.MOUSE_OUT, onOutEdit);
			bgEdit.addEventListener(MouseEvent.CLICK, editClick);
			//
			deleteButton.alpha = 0.7;
			deleteButton.scaleX = 2;
			deleteButton.scaleY = 2;
			deleteButton.x = btnOut.width+20;
			deleteButton.y = -5;
			bgDelete.x = deleteButton.x-5;
		}
		
		protected function editClick(event:Event):void{
			dispatchEvent(new CommonEvent(CommonEvent.BUTTON_EDIT_CLICK));
			
		}
		
		protected function deleteClick(event:MouseEvent):void{
			dispatchEvent(new CommonEvent(CommonEvent.BUTTON_DELETE_CLICK));
			
		}
		
		protected function onOverEdit(event:Event):void {
			btnOver.visible = true;
			btnOut.visible = false;
			
		}
		
		protected function onOutEdit(event:Event):void {
			btnOver.visible = false;
			btnOut.visible = true;
			
		}
		
		protected function onOutDelete(event:MouseEvent):void {
			deleteButton.onOut()
			
		}
		
		protected function onOverDelete(event:MouseEvent):void {
			deleteButton.onOver()
			
		}
		public function getWidth():Number{
			return this.width;
		}
		public function getHeight():Number{
			return this.height;
		}
		
	}
}