package controls.ui {
	
	import components.GraphicElement;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrollBox extends Sprite {
		
		private var _mask:Sprite;
		private var _container:Sprite;
		private var _pimp:GraphicElement;
		private var _track:Sprite;
		private var _height:Number;
		private var _k:Number;
		private var _noScroll:Boolean;
		private var _grabY:Number;
		private var _pimpMinHeight:Number;
		private var _scrollerWidth:Number;
		private var _scrollerPimpColor:uint;
		private var contentWay:Number;
		private var maxPimpWay:Number;
		private var pimpHeight:Number;
		private var _width:Number;
		
		public function ScrollBox(content:DisplayObject, boxWidth:Number, boxHeight:Number, maskX:Number = 0, scrollerWidth:Number = 10, scrollerPimpColor:uint = 0x808080) {
			_scrollerPimpColor = scrollerPimpColor;
			_scrollerWidth = scrollerWidth;
			_height = boxHeight;
			_width = boxWidth;

			_container = new Sprite();
			_container.addChild(content);
			_mask = createSprite(_width-15, _height, 0xFF0000);
			_container.mask = _mask;
			this.addChild(_container);
			this.addChild(_mask);
			_track = createSprite(_scrollerWidth, _height, 0xFFFFFF);
			_track.x = _mask.x -3;
			
			_track.alpha = 0.4;
			addChild(_track);
			_noScroll = content.height <= _height;
			_pimpMinHeight = _scrollerWidth * 2;
			contentWay = _container.height - _height;
			pimpHeight = _height - contentWay;
			maxPimpWay = _height - _pimpMinHeight;
			if (contentWay > maxPimpWay) {
				//slider
				_pimp = new GraphicElement(10, _pimpMinHeight,0xA3A3A3,5,5)
				_k = contentWay / maxPimpWay;
			}else{
				_pimp = new GraphicElement(10, pimpHeight,0xA3A3A3,5,5);
				_k = 1;
			}
			if (_noScroll) {
				_pimp.visible = false;
				_pimp.updateXY(0, 10, _pimpMinHeight, 5,5);
				_k = 0;
			}
			_pimp.x = _track.x;
			addChild(_pimp);
			_pimp.addEventListener(MouseEvent.MOUSE_DOWN, pimpDownHandler);
			if (this.stage != null) {
				init();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(event:Event = null):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, pimpUpHandler);
		}
		
		private function createSprite(initWidth:Number, initHeight:Number, color:uint = 0x000000):Sprite{
			var g:Sprite = new Sprite();
			g.graphics.beginFill(color);
			g.graphics.drawRect(-initWidth, 0, initWidth, initHeight);
			g.graphics.endFill();
			
			return g;
		}
		
		private function wheelHandler(event:MouseEvent):void {
			_pimp.y = Math.min(Math.max(0, _pimp.y - event.delta), _height - _pimp.height);
			moveContent();
		}
		
		public function setPosY(num:Number):void {
			//если ссылка не в зоне видимости скроллера то прокрутка разрешена
			if(_height < num){
				_pimp.y = Math.min(Math.max(0, num/_k), _height - _pimp.height);

				moveContentSearch();
			}else if(_container.y < 0){
				_pimp.y = Math.min(Math.max(0, num/_k), _height - _pimp.height);
				moveContentSearch();
			}
		}
		public override function set width(num:Number):void {
			_mask.width = num;
			_track.x = -num;
			_pimp.x = _track.x;
		}
		private function moveContentSearch():void{
			_container.y = -(_pimp.y*_k);
			
		}		
		
		private function movePimp(event:MouseEvent):void {
			_pimp.y = Math.min(Math.max(0, this.mouseY - _grabY), _height - _pimp.height);
			moveContent();
		}
		
		private function moveContent():void {
			_container.y = -_pimp.y * _k;
		}
		private function pimpDownHandler(event:MouseEvent):void {
			_grabY = _pimp.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, movePimp);
		}
		private function pimpUpHandler(event:MouseEvent):void {
			if(stage !=null)stage.removeEventListener(MouseEvent.MOUSE_MOVE, movePimp);
		}
		public function updateGraphic(initWidth:Number, initHeight:Number, cListHeight:Number):void{
			_height = initHeight;
			_mask.width = initWidth;
			_mask.height = initHeight;
			_track.height = initHeight;
			contentWay = cListHeight - _height;
			pimpHeight = _height - contentWay;
			maxPimpWay = _height - _pimpMinHeight;
			_container.y = -_pimp.y * _k;

			if (contentWay > maxPimpWay){
				_container.y = -_pimp.y * _k;
				_pimp.updateXY(0, 10, _pimpMinHeight, 5,5)
				_pimp.y = Math.min(Math.max(0, _pimp.y), initHeight - _pimp.height)
				_pimp.visible = true;
				_k = contentWay / maxPimpWay;
			}else if(_height >= pimpHeight+10){
				_pimp.updateXY(0, 10, pimpHeight, 5,5);
				_pimp.y = Math.min(Math.max(0, _pimp.y), initHeight - _pimp.height)
				_container.y = -_pimp.y * _k;
				_k = 1;

				_pimp.visible = true;

			}else{
				_pimp.visible = false;
				_k = 0
				_pimp.y = 0	
			}
		}
		
	}
}