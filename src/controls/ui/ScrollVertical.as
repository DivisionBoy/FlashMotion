package controls.ui {
	
	import components.GraphicElement;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrollVertical extends Sprite {
		
		private var _mask:Sprite;
		private static var _container:Sprite;
		private static var _pimp:GraphicElement;
		private var _track:Sprite;
		private static var _height:Number;
		private static var _k:Number;
		private static var _noScroll:Boolean;
		private var _grabY:Number;
		private var _pimpMinHeight:Number;
		private var _scrollerWidth:Number;
		private var _scrollerPimpColor:uint;
		private static var contentWay:Number;
		private static var maxPimpWay:Number;
		private var pimpHeight:Number;
		
		public function ScrollVertical(content:DisplayObject, boxHeight:Number, scrollerWidth:Number = 10, scrollerPimpColor:uint = 0x808080) {
			_scrollerPimpColor = scrollerPimpColor;
			_scrollerWidth = scrollerWidth;
			_height = boxHeight;
			_container = createSprite(content.width+15, content.height);
			_container.addChild(content);
			_mask = createSprite(content.width+15, _height, 0xFF0000);
			_container.mask = _mask;
			this.addChild(_container);
			this.addChild(_mask);
			_noScroll = content.height <= _height;

			this.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
			_pimpMinHeight = _scrollerWidth * 2;
			contentWay = _container.height - _height;
			pimpHeight = _height - contentWay;
			maxPimpWay = _height - _pimpMinHeight;
			if (contentWay > maxPimpWay) {
				//slider
				_pimp = new GraphicElement(10, _pimpMinHeight,0xA3A3A3,5,5);
				_k = contentWay / maxPimpWay;
			}else{
				_pimp = new GraphicElement(10, pimpHeight,0xA3A3A3,5,5);
				_k = 1;
			}
			if (_noScroll) {
				_pimp.visible = false;
				_k = 0;
			}
			_track = createSprite(_scrollerWidth, _height, 0x00FFFFFF);
			_track.x = _container.x -3;
			_pimp.x = _track.x;
			_track.alpha = 0.4;
			addChild(_track);
			addChild(_pimp);

			if (this.stage != null) {
				init();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(event:Event = null):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);

			_pimp.addEventListener(MouseEvent.MOUSE_DOWN, pimpDownHandler);
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
			_pimp.y = Math.min(Math.max(0, _pimp.y - event.delta), _height - _pimp.height)
			moveContent();
		}

		public static function setPosY(num:Number):void {
			//если ссылка не в зоне видимости скроллера то прокрутка разрешена
			
			if(_height < num){
				_pimp.y = Math.min(Math.max(0, num/_k), _height - _pimp.height);
				
				moveContentSearch();
			}else if(_container.y < 0){
				_pimp.y = Math.min(Math.max(0, num/_k), _height - _pimp.height);
				moveContentSearch();
			}
		}
		
		private static function moveContentSearch():void{
			_container.y = -(_pimp.y*_k);
			
		}		
		
		private function movePimp(event:MouseEvent):void {
			_pimp.y = Math.min(Math.max(0, this.mouseY - _grabY), _height - _pimp.height);
			moveContent();
		}
		
		private static function moveContent():void {
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
				_pimp.updateXY(0, 10, _pimpMinHeight, 5,5);
				_pimp.y = Math.min(Math.max(0, _pimp.y), initHeight - _pimp.height);
				_k = contentWay / maxPimpWay;
				_pimp.visible = true;
			}else if(_height >= pimpHeight+10){
				_pimp.updateXY(0, 10, pimpHeight, 5,5);
				_pimp.y = Math.min(Math.max(0, _pimp.y), initHeight - _pimp.height);
				_k = 1;
				_pimp.visible = true;
			}else{
				_pimp.visible = false;
				_pimp.updateXY(0, 10, _pimpMinHeight, 5,5);
				_k = 0;
				_pimp.y = 0;
			}
		}
		
	}
}