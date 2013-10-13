package components {
	import components.playlist.PlayList;

	import controls.ui.CloseButton;
	import controls.ui.OptionButton;
	import controls.ui.PlaylistButton;
	import controls.ui.Slider;
	import controls.ui.VolumeButton;
	
	import events.PlayerEvent;
	import events.OneNumberEvent;
	import events.ParamsEvent;
	import events.CommonEvent;

	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	import flash.text.TextField;

	public class MusicBox extends Sprite{

		private const HEIGHT:int = 50;
		
		private var fillType:String = GradientType.LINEAR;
		private var colors:Array = [0x535353, 0x262626];
		private var alphas:Array = [1, 1];
		private var ratios:Array = [0x00, 0xFF];
		private var matr:Matrix = new Matrix();
		private var spreadMethod:String = SpreadMethod.PAD;
		
		[Embed(source="/assets/button/play_off.png")]
		private var PlayOff:Class;
		[Embed(source="/assets/button/play_roll_over.png")]
		private var PlayRollOver:Class;
		[Embed(source="/assets/button/pause_roll_over.png")]
		private var PauseRollOver:Class;
		
		[Embed(source="/assets/button/nextPrev.png")]
		private var Next:Class;
		[Embed(source="/assets/button/nextPrev.png")]
		private var Prev:Class;
		
		private var g:Graphics;
		private var next:Bitmap;
		private var prev:Bitmap;
		
		private var playOff:Bitmap;
		private var playRollOver:Bitmap;
		private var pauseRollOver:Bitmap;
		private var cont:Sprite;

		private var optionButton:OptionButton;
		private var _initWidth:int;
		private var _initHeight:int;
		private var isPlay:Boolean = false;
		private var closeButton:CloseButton;
		private var playListText:TextField;
		private var gr:GraphicElement;
		private var info:TextField;
		private var prevBtn:Sprite;
		private var nextBtn:Sprite;
		private var infoTimeCurrent:TextField;
		private var slider:Slider;
		public var playlist:PlayList;
		private var infoTimeTotal:TextField;
		private var currentTimePimpPosition:int;
		private var isOut:int;
		private var volumeButton:VolumeButton;
		
		public function MusicBox(initWidth:int, initHeight:int, isOut:int) {
			matr.createGradientBox(-HEIGHT, HEIGHT, Math.PI / 2, 0, 0);
			_initWidth = initWidth;
			_initHeight = initHeight;
			this.isOut = isOut;
			
			nextBtn = new Sprite();
			addChild(nextBtn);
			nextBtn.buttonMode = true;
			nextBtn.mouseEnabled = false;
			prevBtn = new Sprite();
			addChild(prevBtn);
			prevBtn.buttonMode = true;
			prevBtn.mouseEnabled = false;
			
			g = this.graphics;
			cont = new Sprite();
			cont.mouseEnabled = false
			
			g.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			cont.addEventListener(MouseEvent.ROLL_OVER, onOver);
			cont.addEventListener(MouseEvent.ROLL_OUT, onOut);
			g.drawRect(-initWidth, 0, initWidth, HEIGHT);
			g.endFill();
			
			var playlistButton:PlaylistButton = new PlaylistButton()
			addChild(playlistButton);
			playlistButton.y = 0
			playlistButton.addEventListener(MouseEvent.MOUSE_UP, onUpOptionButton);

			next = new Next();
			nextBtn.addChild(next)
			nextBtn.addEventListener(MouseEvent.MOUSE_UP, nextSong);
			prev = new Prev();
			prevBtn.addChild(prev);
			prevBtn.addEventListener(MouseEvent.MOUSE_UP, prevSong);
			prevBtn.rotation = 180;

			playRollOver = new PlayRollOver();
			cont.addChild(playRollOver);
			playRollOver.visible = false
			//
			pauseRollOver = new PauseRollOver();
			cont.addChild(pauseRollOver);
			pauseRollOver.visible = false
			//
			playOff = new PlayOff();
			cont.addChild(playOff);
			playOff.visible = true;
			
			cont.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownPlay);
			cont.x = -initWidth+10;
			cont.y = (HEIGHT/2)-playOff.height/2
			addChild(cont);
			//
			nextBtn.x = cont.x+cont.width - 5;
			nextBtn.y = nextBtn.height - 5;
			
			
			prevBtn.x = cont.x+5
			prevBtn.y = prevBtn.height + 15;
			//
			infoTimeCurrent = getTextField();
			addChild(infoTimeCurrent);
			infoTimeCurrent.width = 50;
			infoTimeCurrent.x = cont.x + cont.width+9;
			infoTimeCurrent.y = cont.y+6;
			infoTimeTotal = getTextField();
			addChild(infoTimeTotal);
			infoTimeTotal.width = 50;
			infoTimeTotal.x = -55;
			infoTimeTotal.y = cont.y+6;
			//
			info = getTextField();
			addChild(info)
			info.x = cont.x + cont.width+10;
			info.y = infoTimeCurrent.y+8;
			slider = new Slider(initWidth-90);
			slider.addEventListener(OneNumberEvent.CLICK_SLIDER_PIMP, clickSliderPimp);
			addChild(slider);
			slider.disabled();
			slider.rotation = 180;
			slider.y = 15;
			slider.x = -(initWidth-cont.width-20);

		}
		public function setVolume(vol:Number):void {
			playlist.setVolume(vol)
			
		}
		public function eventUp():void {
			//endTurn();
			
		}

		public function setBooPlaylist(isOut:int):void {
			this.isOut = isOut;
			
		}
		public function removeSlider():void {
			//removeChild(slider);
			//slider = null
			
		}
		public function addSlider():void {
			/*slider = new Slider(_initWidth-90);
			slider.addEventListener(OneNumberEvent.CLICK_SLIDER_PIMP, clickSliderPimp);
			addChild(slider);
			slider.rotation = 180;
			slider.y = 15;
			slider.x = -(_initWidth-cont.width-20);
			*/
		}
		protected function clickSliderPimp(e:OneNumberEvent):void{
			if(playlist != null)playlist.positionPimp(e.value/*, e.value2*/);
			
		}
		
		protected function prevSong(event:MouseEvent):void{
			playlist.playPrevSong()
			isPlay = false
			playRollOver.visible = true
			pauseRollOver.visible = false
		}
		
		protected function nextSong(event:MouseEvent):void{
			playlist.playNextSong()
			isPlay = false
			playRollOver.visible = true
			pauseRollOver.visible = false
			
		}
		private function getTextField():TextField{
			var txt:TextField = new TextField();
			txt.selectable = false;
			txt.mouseEnabled = false
			txt.width = _initWidth-80;
			txt.height = 18

			return txt;
		}
		protected function deletePlayList(event:CommonEvent):void{
			cont.mouseChildren = false;
			cont.mouseEnabled = false;
			nextBtn.mouseEnabled = false;
			prevBtn.mouseEnabled = false;
			slider.disabled();
			removeChild(playlist);
			playlist=null;
			
		}
		protected function closePlayList(e:CommonEvent):void{
			removeChild(playlist);
			
		}
		
		protected function onOut(event:MouseEvent):void{
			if(isPlay){
				playRollOver.visible = false;
			
			}else{
				pauseRollOver.visible = false;
					
			}
			
		}
		
		protected function onOver(event:MouseEvent):void{
			if(isPlay){
				playRollOver.visible = true;
					
			}else{
				pauseRollOver.visible = true;
					
			}
			
		}
		
		protected function mouseDownPlay(event:MouseEvent):void{
			if(playlist != null)playlist.mouseDownPlay(), playOff.visible = false;
			isPlay = !isPlay;
			
		}
		public function addedPlayList(selectItemNum:int, currentPositionPimp:int, soundPosition:Number):void {
			if(playlist == null){
				playlist = new PlayList(_initWidth-90-slider._widthPimp, _initWidth, _initHeight/2);
				playlist.y = -(_initHeight/2);
				playlist.addEventListener(CommonEvent.PLAYLIST_DOUBLE_CLICK, itemDoubleClick);
				playlist.addEventListener(ParamsEvent.PLAYLIST_INFO, playlistInfo);
				playlist.addEventListener(OneNumberEvent.PLAYBACK_PERCENT, updatePercent);
				playlist.addEventListener(CommonEvent.PLAYLIST_REMOVE, deletePlayList);
				playlist.addEventListener(CommonEvent.PLAYLIST_CLOSE, closePlayList);
				playlist.addEventListener(CommonEvent.DRAGBAR_PLAYLIST, onDragPlayList);
				playlist.selectItem(selectItemNum);
				if(currentPositionPimp == -1){
					cont.mouseChildren = false;
					cont.mouseEnabled = false;
					nextBtn.mouseEnabled = false;
					prevBtn.mouseEnabled = false;
					slider.disabled();
				}else{
					playRollOver.visible = true;
					playOff.visible = false;
					cont.mouseChildren = true;
					cont.mouseEnabled = true;
					nextBtn.mouseEnabled = true;
					prevBtn.mouseEnabled = true;
					slider.enabled();
					slider.newPositionPimp(currentPositionPimp);
					playlist.playSoundAfterMove(selectItemNum, soundPosition);
				}

				playlist.addEventListener(PlayerEvent.UPDATE_TIME, updateTimePlayer);
				addChild(playlist);

			}else if(playlist.stage == null){
				addChild(playlist);
				playlist.updatePosition(_initWidth, _initHeight/2);
				playlist.y = -(_initHeight/2);

			}
		}
		protected function onUpOptionButton(event:MouseEvent):void{
			if(isOut >= 1){
				if(playlist == null){
					playlist = new PlayList(_initWidth-90-slider._widthPimp, _initWidth, _initHeight/2/*,closePlayList*/);
					playlist.y = -(_initHeight/2);
					playlist.addEventListener(CommonEvent.PLAYLIST_DOUBLE_CLICK, itemDoubleClick);
					playlist.addEventListener(ParamsEvent.PLAYLIST_INFO, playlistInfo);
					playlist.addEventListener(OneNumberEvent.PLAYBACK_PERCENT, updatePercent);
					playlist.addEventListener(CommonEvent.PLAYLIST_REMOVE, deletePlayList);
					playlist.addEventListener(CommonEvent.PLAYLIST_CLOSE, closePlayList);
					playlist.addEventListener(CommonEvent.DRAGBAR_PLAYLIST, onDragPlayList);
					playlist.addEventListener(PlayerEvent.UPDATE_TIME, updateTimePlayer);
					addChild(playlist);
				}else if(playlist.stage == null){
					addChild(playlist);
					playlist.updatePosition(_initWidth, _initHeight/2);
					playlist.y = -(_initHeight/2);
				}
			}else{

				EngineCore.playlistOut(-1,-1,0, true);
			}
			
		}		
		
		protected function onDragPlayList(e:CommonEvent):void{
			e.target.x = this.mouseX+30;
			e.target.y = this.mouseY+30;
			
		}
		
		protected function updatePercent(e:OneNumberEvent):void{
			slider.newPositionPimp(e.value)//обновляет ширину прогресса трека, когда ресайзится окно
			
		}

		protected function updateTimePlayer(e:PlayerEvent):void{
			currentTimePimpPosition = e.value5;
			slider.newPositionPimp(e.value5);
			infoTimeCurrent.htmlText = "<font face='Verdana' size='8' color='#FFFFFF'>"+e.value+":"+e.value2+"</font>"
			infoTimeTotal.htmlText = "<font face='Verdana' size='8' color='#FFFFFF'>"+e.value3+":"+e.value4+"</font>"
			
		}

		protected function playlistInfo(e:ParamsEvent):void{
			info.htmlText = "<font align='center' face='Verdana' size='10' color='#FFFFFF'><p align='center'>"+e.value1+" - "+e.value2+"</p></font>";
		}
			
		protected function itemDoubleClick(event:Event):void{
			isPlay = false;
			cont.mouseEnabled = true;
			slider.enabled();
			prevBtn.mouseEnabled = true;
			nextBtn.mouseEnabled = true;

			playOff.visible = false
			playRollOver.visible = true
			pauseRollOver.visible = false
		}		
		public function updateFullScreen(initHeight:int):void {
			_initHeight = initHeight;
			if(playlist != null){
				if(playlist.stage != null){
					playlist.updateFullScreenMode(initHeight/2);
					playlist.y = -(initHeight/2);
				}
			}
		}
		public function updateWidth(initWidth:int, initHeight:int):void {
			_initWidth = initWidth;
			_initHeight = initHeight;
			g.clear();
			g = this.graphics;
			matr.createGradientBox(-HEIGHT, HEIGHT, Math.PI / 2, 0, 0);
			g.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			g.drawRect(-initWidth, 0, initWidth, HEIGHT);
			g.endFill();
			cont.x = -initWidth+10;
			//
			infoTimeCurrent.x = cont.x + cont.width+10;
			//
			info.x = cont.x + cont.width+10;
			info.width = initWidth-80;
			slider.update(initWidth);
			slider.x = -(initWidth-cont.width-20);
			//
			nextBtn.x = cont.x+cont.width - 5;
			prevBtn.x = cont.x+5;
			if(playlist != null){
				playlist.updatePosition(initWidth, initHeight/2);
				playlist.y = -(_initHeight/2);
			}
		}

	}
}