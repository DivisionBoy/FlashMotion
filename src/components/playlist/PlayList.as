package components.playlist {
	import components.SquareGraphic;
	
	import controls.ui.CloseButton;
	import controls.ui.ScrollBox;
	import controls.ui.ScrollVertical;
	
	import events.CommonEvent;
	import events.OneNumberEvent;
	import events.ParamsEvent;
	import events.PlayerEvent;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import model.ID3Rus;

	public class PlayList extends Sprite {
		
		/*
		Number
		*/
		
		private var len:int;//число композиций
		private var targetItemNum:int = -1;//-1 - для деактивации вызова метода удаления трека при нажатии на кнопку del, так как по дифолту треки не выделены
		private var ID:int;
		private var tracer:int;//текущий трек
		private var currentContentHeight:int;
		private var playbackPercent:int = -1; // -1 если не был воспроизведен один из треков
		private var currentPlayItem:int;
		private var _widthProgressBar:int;
		private var _initWidth:Number;
		private var _initHeight:Number;
		private var _gapX:Number;
		
		/*
		Graphic
		*/
		
		private var bg:SquareGraphic;
		private var bgList:SquareGraphic;
		private var dragBar:SquareGraphic;
		private var item:Item;
		
		/*
		Sound
		*/
		
		private var sound:Sound;
		private var currentSound:Sound;
		private var currentPlaySound:Sound;
		private var channel:SoundChannel;
		private var st:SoundTransform;
		private var soundPosition:Number;
		private static var $st:SoundTransform;
		private static var $channel:SoundChannel;
		
		//
		
		private var playingSound:Boolean = false;
		
		private var playListText:TextField;
		
		private var selectObject:Object;
		private var currentItem:Object;
		
		private var content:Sprite;

		private var arrSong:Array = new Array();
		private var arrLocation:Array = new Array();
		
		private var scroll:ScrollVertical;
		
		private var lineVert:SquareGraphic;
		
		private var updateTime:Timer;
		private var connect:SQLConnection;
		
		private var closeButton:CloseButton;
				
		public function PlayList(widthProgressBar:int, initWidth:Number, initHeight:Number) {
			this.addEventListener(Event.ADDED_TO_STAGE, initListiners);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnter);
			
			_widthProgressBar = widthProgressBar/2;
			updateTime = new Timer(100);
			_initWidth = initWidth;
			_initHeight = initHeight;
			
			bg = new SquareGraphic(-initWidth, initHeight, 0xCCCCCC);
			addChild(bg);
			bgList = new SquareGraphic(-initWidth, 20, 0x4A4A4A);
			bgList.y = -bgList.height;
			addChild(bgList);
			dragBar = new SquareGraphic(-initWidth, 20, 0x3D3D3D);
			addChild(dragBar);
			dragBar.addEventListener(MouseEvent.MOUSE_DOWN, onDownPlayListBar);
			dragBar.addEventListener(MouseEvent.MOUSE_UP, onUpPlayListBar);
			dragBar.y = -(bgList.height*2); 
			content = new Sprite();

			scroll = new ScrollVertical(content, initHeight);
			addChild(scroll);
			content.x = -bg.width;
			lineVert = new SquareGraphic(1, initHeight, 0x919191);
			addChild(lineVert);
			lineVert.x = -45;

			closeButton = new CloseButton();
			addChild(closeButton);
			closeButton.x = -15
			closeButton.y = dragBar.y+2
			
			closeButton.addEventListener(MouseEvent.MOUSE_UP, closePlayListBtn);
			//TextField
			playListText = new TextField();
			addChild(playListText);
			playListText.selectable = false;
			this.playListText.htmlText ="<font face='Verdana' size='13' color='#FFFFFF'> Список</font>";
			playListText.autoSize = TextFieldAutoSize.LEFT;
			//
			playListText.y = bgList.y;
			playListText.x = -_initWidth;
			
			initDB();	
			initObjects();

		}
		
		protected function closePlayListBtn(event:MouseEvent):void{
			for each (var key:Object in arrSong) {//удаляет текущее выделение
				key.removeSelectItems();
			}
			this.dispatchEvent(new CommonEvent(CommonEvent.PLAYLIST_CLOSE));
			
		}
		public function setVolume(vol:Number):void {
			st.volume = vol;
			channel.soundTransform = st;

		}

		public function visibleDragBar():void {
			this.removeChild(dragBar);
			this.removeChild(closeButton);
			dragBar = null;
			closeButton = null;
			
		}
		protected function onUpPlayListBar(event:MouseEvent):void{
			this.alpha = 1;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMovePlayListBar);
			
		}
		
		protected function onDownPlayListBar(event:MouseEvent):void{
			_gapX = this.mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMovePlayListBar);
			
		}
		public function getItemNum():int {
			return targetItemNum;
		}
		public function getPlaybackPrecent():int {
			return playbackPercent;
			
		}
		public function getSoundPosition():Number {
			return channel.position;
			
		}
		
		protected function onMovePlayListBar(event:MouseEvent):void {
			if(_gapX > this.mouseX+20 || _gapX < this.mouseX-20){
				this.alpha = 0.5;
				soundPosition = channel.position;//текущая позиция трека
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMovePlayListBar);
				EngineCore.playlistOut(targetItemNum, playbackPercent, soundPosition, false);

				closePlayList();
				
			}
		}
		public function removeTimer():void {
			updateTime.removeEventListener(TimerEvent.TIMER, getMP3Time);
			
		}
		protected function closePlayList(event:MouseEvent=null):void{
			updateTime.removeEventListener(TimerEvent.TIMER, getMP3Time);
			this.dispatchEvent(new CommonEvent(CommonEvent.PLAYLIST_REMOVE));
			
		}
		public function selectItem(num:int):void {
			if(num > -1)arrSong[num].selectItem(_initWidth);
			
		}
		protected function initListiners(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, initListiners);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, deleteRow);
			
		}
		private function initObjects():void{
			st = new SoundTransform(1, 0);
			$st = st;
			channel = new SoundChannel();
			$channel = channel;
			
		}
		public function getRows(num:int):int{
			var selectStmt:SQLStatement = new SQLStatement();
			selectStmt.sqlConnection = connect;
			selectStmt.text = "SELECT * FROM PLAYLIST"
			selectStmt.execute();
			var result:SQLResult = selectStmt.getResult();

			if (result != null){
				if(result.data != null)var selectRow:Object = result.data[num]
			}
			return selectRow.id;
		}
		public function mouseDownPlay():void{
			if (playingSound){
				
				soundPosition = channel.position;

				updateTime.stop();
				
				channel.stop();
				
				playingSound = false;
				
			}
			else if (!playingSound){
					SoundMixer.stopAll();
					
					if(channel.position > 0)playSong(true, soundPosition);
					else
						playSong(false, 0);
					
					playingSound = true;
				}
		}
		public function playNextSong():void{
			if(tracer == (len-1)){
				tracer = 0;
			}else{
				tracer++;
			}
			handleNextPrev();
		}
		public function playPrevSong():void{
			if(tracer == 0){
				tracer = len;
			}
			tracer--;
			handleNextPrev();
		}
		private function handleNextPrev():void{
			playingSound = true;//при переходе на следующую дорожку сбрасывается позиция предыдущей
			var string:String;

			currentPlayItem = tracer;
			targetItemNum = tracer;//после перехода на следующий трек записывает его позицию
			updateTime.removeEventListener(TimerEvent.TIMER, getMP3Time);
			
			try{

				var id:int = getRows(tracer);
				currentSound = new Sound(new URLRequest(arrLocation[tracer]));
				SoundMixer.stopAll();
				
				playSong(false, 0, id);
				
			}catch(event:Error){
				if(arrSong.length > 0){
					var id2:int = getRows(0);

					currentSound = new Sound(new URLRequest(arrLocation[0]));
					SoundMixer.stopAll();

					playSong(false, 0, id);

				}
				
			}
		}
		private function getMP3Time(e:TimerEvent):void{
			//currentPlaySound - текущая комопозиция, которая играет, переменная необходима для избежания ошибочного определения параметров добавленной песни в плей-лист
			var totalMinutes:Number = Math.floor(currentPlaySound.length / 1000 / 60);
			var totalSeconds:Number = Math.floor(currentPlaySound.length / 1000) % 60;
			var currentMinutes:Number = Math.floor(channel.position / 1000 / 60);
			var currentSeconds:Number = Math.floor(channel.position / 1000) % 60;

			if (totalSeconds < 10) totalSeconds = 0 + totalSeconds;
			if (currentSeconds < 10) currentSeconds = 0 + currentSeconds;
			
			var estimatedLength:int = Math.ceil(currentPlaySound.length / (currentPlaySound.bytesLoaded / currentPlaySound.bytesTotal));
			playbackPercent = _widthProgressBar * (channel.position / estimatedLength );
			
			//отправляет в MusicBox текущее и полное время трека + длина трека
			dispatchEvent(new PlayerEvent(PlayerEvent.UPDATE_TIME, currentMinutes, currentSeconds, totalMinutes, totalSeconds, playbackPercent))
			
		}
		//
		public function positionPimp(positionPimpNum:int):void {
			channel.stop()

			var fullTime:int = Math.floor(currentSound.length / 1000);
			var newPos:Number = fullTime / _widthProgressBar * Math.floor(positionPimpNum * 1000);

			soundPosition = -newPos / 2;
			//Отпустив мышь с пимпа отправляется событие с параметрами актуального времени. soundPosition
			var totalMinutes:Number = Math.floor(currentPlaySound.length / 1000 / 60);
			var totalSeconds:Number = Math.floor(currentPlaySound.length / 1000) % 60;
			var currentMinutes:Number = Math.floor(soundPosition / 1000 / 60);
			var currentSeconds:Number = Math.floor(soundPosition / 1000) % 60;

			if (totalSeconds < 10) totalSeconds = 0 + totalSeconds;
			if (currentSeconds < 10) currentSeconds = 0 + currentSeconds;

			var estimatedLength:int = Math.ceil(currentPlaySound.length / (currentPlaySound.bytesLoaded / currentPlaySound.bytesTotal));
			playbackPercent = _widthProgressBar * (soundPosition / estimatedLength );

			
			//отправляет в MusicBox текущее и полное время трека + длина трека
			dispatchEvent(new PlayerEvent(PlayerEvent.UPDATE_TIME, currentMinutes, currentSeconds, totalMinutes, totalSeconds, playbackPercent))

			if(playingSound)playSong(true, soundPosition);
			
		}
		private function dragEnter(event:NativeDragEvent):void{
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnter);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDrop);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExit);
			var clip:Clipboard = event.clipboard;
			selectObject = clip.getData(ClipboardFormats.FILE_LIST_FORMAT);
			currentContentHeight = content.height;
			
			if (selectObject[0].extension.toLowerCase() == "mp3"){
				NativeDragManager.acceptDragDrop(this);
			}
		}
		private function dragExit(event:NativeDragEvent):void{
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnter);
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExit);

		}
		private function dragDrop(event:NativeDragEvent):void{
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExit);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnter);
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDrop);
			var clip:Clipboard = event.clipboard;
			var object:Object = clip.getData(ClipboardFormats.FILE_LIST_FORMAT);
			//Добавляется как 1 трек, так и список. selectObject.length - число выделенных объектов
			for(var i:int = 0; i < selectObject.length; i++){
				sound = new Sound(new URLRequest(object[i].url));
				sound.addEventListener(Event.COMPLETE, soundLoaded);
			}
		}
	
		private function initDB():void{
			var file:File = File.applicationStorageDirectory.resolvePath("playlist.db");
			connect = new SQLConnection();
			connect.open(file);
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = connect;
			statement.text = "CREATE TABLE IF NOT EXISTS PLAYLIST (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, Artist TEXT, Song TEXT, TotalMinutes NUMERIC, TotalSeconds NUMERIC, Location TEXT)";
			statement.execute();
			loadData();

		}
		private function soundLoaded(event:Event):void{
			currentSound = event.target as Sound;
			var id:ID3Info = currentSound.id3;
			var artist:String = id.artist;
			var song:String = id.songName;
			var url:String = currentSound.url;
			//Time mp3
			var totalMinutes:Number = Math.floor(currentSound.length / 1000 / 60);
			var totalSeconds:Number = Math.floor(currentSound.length / 1000) % 60;
			
			if (totalSeconds < 10) totalSeconds = 0 + totalSeconds;
			
			item = new Item(artist, song, totalMinutes+":"+totalSeconds, _initWidth, _initHeight);
			item.doubleClickEnabled = true;
			item.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickItem);
			item.addEventListener(MouseEvent.CLICK, onClick);
			item.addEventListener(MouseEvent.ROLL_OVER, onOver);
			item.addEventListener(MouseEvent.ROLL_OUT, onOut);
			
			arrSong.push(item);
			arrLocation.push(url);
			len = arrSong.length;
			
			content.addChild(item)
			_alignWithY();
			scroll.updateGraphic(bg.width, bg.height, content.height)//при добавлении, постоянно обновляет высоту ползунка 

			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = connect;
			statement.text = "INSERT INTO PLAYLIST (Artist, Song, TotalMinutes, TotalSeconds, Location) VALUES (?, ?, ?, ?, ?)";
			statement.parameters[0] = ID3Rus.convert(artist);
			statement.parameters[1] = ID3Rus.convert(song);
			statement.parameters[2] = totalMinutes;
			statement.parameters[3] = totalSeconds;
			statement.parameters[4] = url;
			statement.execute();
			
		}
		private function loadData():void{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = connect;
			statement.text = "SELECT * FROM PLAYLIST";
			statement.execute();
			var result:SQLResult = statement.getResult();
			if (result != null && result.data != null){
				var numRows:int = result.data.length
				len = numRows;

				for(var i:int = 0; i < numRows; i++){
					var row:Object = result.data[i];
					item = new Item(row.Artist, row.Song, row.TotalMinutes+":"+row.TotalSeconds, _initWidth, _initHeight);
					item.doubleClickEnabled = true;
					item.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickItem);
					item.addEventListener(MouseEvent.CLICK, onClick);
					item.addEventListener(MouseEvent.ROLL_OVER, onOver);
					item.addEventListener(MouseEvent.ROLL_OUT, onOut);
					
					arrSong.push(item);
					arrLocation.push(result.data[i].Location);

					content.addChild(item)
					_alignWithY();

				}
				scroll.updateGraphic(bg.width, bg.height, content.height)
			}
			
		}
		
		protected function onClick(e:MouseEvent):void {
			var targetLink:Object = e.currentTarget as DisplayObject;
			targetItemNum = arrSong.indexOf(targetLink);
			currentItem = targetLink;
			for each (var key:Object in arrSong) {//удаляет текущее выделение
				key.removeSelectItems();
			}
			e.currentTarget.selectItems(_initWidth);
			ID = getRows(targetItemNum);

		}
		
		protected function onOut(e:MouseEvent):void{
			e.currentTarget.onOut();
			
		}
		
		protected function onOver(e:MouseEvent):void{
			e.currentTarget.onOver(_initWidth);
			
		}
		protected function _alignWithY():void{	
			for (var i:int = 0; i < this.arrSong.length; i++){

				this.arrSong[i].y = i === 0
					? i
					: this.arrSong[i - 1].y + this.arrSong[i - 1].height;
			}
		}
		private function createItem(name:String):TextField {
			var txt:TextField = new TextField();
			txt.border = true;
			txt.height = 20;
			txt.width = _initWidth-40;
			txt.text = name+"";
			txt.selectable = false;

			return txt;
			
		}
		public function playSong(useSp:Boolean, sp:Number, id:int=-1):void {
			if (useSp) channel = currentSound.play(sp);
			else channel = currentSound.play();

			try {
			
				for(var i:int; i<len; i++){
					if(id == getRows(i)){
						arrSong[i].removeSelectItem();
						arrSong[i].selectItem(_initWidth);//создает новое выделение
					}else if(id > -1){
						arrSong[i].removeSelectItem();
					}
				}
				currentPlaySound = currentSound;

				updateTime.addEventListener(TimerEvent.TIMER, getMP3Time);

				updateTime.start();

				dispatchEvent(new ParamsEvent(ParamsEvent.PLAYLIST_INFO, arrSong[tracer].getArtist(), arrSong[tracer].getSong(), 0))
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}catch(event:Error){
			}
		}
		private function onSoundComplete(event:Event):void{
			playNextSong();
		}
		private function deliClick():void {
			arrSong.splice(targetItemNum, 1);
			arrLocation.splice(targetItemNum, 1);
			content.removeChild(currentItem as DisplayObject);
			_alignWithY();
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = connect;
			
			statement.text = "DELETE FROM PLAYLIST WHERE id ="+ID;
			statement.execute();

			len = arrSong.length;
			
			if(currentPlayItem > targetItemNum){
				tracer = currentPlayItem-1;
			}
			
			targetItemNum = -1;
			scroll.updateGraphic(_initWidth, bg.height, content.height); 
		}
		public function playSoundAfterMove(targetItemNum:int, soundPositionv:Number):void {
			this.targetItemNum = targetItemNum;
			soundPosition = soundPositionv
			currentPlayItem = targetItemNum;
			playingSound = true;
			tracer = targetItemNum;
			SoundMixer.stopAll();

			currentSound = new Sound(new URLRequest(arrLocation[targetItemNum]));
			
			playSong(true, soundPositionv);
			
		}
		protected function doubleClickItem(e:MouseEvent):void {
			var targetLink:Object = e.currentTarget as DisplayObject;
			targetItemNum = arrSong.indexOf(targetLink);
			currentItem = targetLink;
			currentPlayItem = targetItemNum;
			dispatchEvent(new CommonEvent(CommonEvent.PLAYLIST_DOUBLE_CLICK));
			playingSound = true;
			soundPosition = 0;
			tracer = targetItemNum;
			channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			SoundMixer.stopAll();

			currentSound = new Sound(new URLRequest(arrLocation[targetItemNum]));
			
			playSong(false, 0, targetItemNum);
			for each (var key:Object in arrSong) {//удаляет текущее выделение
					key.removeSelectItem();
			}
			e.currentTarget.selectItem(_initWidth);//создает новое выделение
		}
		private function deleteRow(e:KeyboardEvent):void {
			if( e.keyCode == Keyboard.DELETE ){
				if(targetItemNum >= 0)deliClick();
			}
			
		}
		public function updateFullScreenMode(initHeight:int):void {
			bg.updateXY(-_initWidth, initHeight, 0xCCCCCC);
			scroll.updateGraphic(_initWidth, bg.height, content.height); 
			lineVert.updateXY(1, initHeight, 0x6B6B6B);
		}
		public function updatePosition(initWidth:int, initHeight:int, offset:int=90):void {
			_initWidth = initWidth;
			_initHeight = initHeight;
			bg.updateXY(-initWidth, initHeight, 0xCCCCCC);
			bgList.updateXY(-initWidth, 20, 0x4A4A4A);
			if(dragBar != null)dragBar.updateXY(-initWidth, 20, 0x3D3D3D);
			scroll.updateGraphic(initWidth, bg.height, content.height); 
			content.x = -bg.width;
			_widthProgressBar = (initWidth - offset - 18)/2;
			playListText.y = bgList.y;
			playListText.x = -initWidth;
			if(currentPlaySound != null && playingSound){
				var estimatedLength:int = Math.ceil(currentPlaySound.length / (currentPlaySound.bytesLoaded / currentPlaySound.bytesTotal));
				var playbackPercent:int = _widthProgressBar * (channel.position / estimatedLength );	
				//диспатчит в MusicBox новые параметры соотношения длина трека - длина прогресса, когда ресайзится окно
				dispatchEvent(new OneNumberEvent(OneNumberEvent.PLAYBACK_PERCENT, playbackPercent));
			}else if(currentPlaySound != null){//если на паузе, то используется soundPosition, который определяет положение пимпа
				var estimatedLength:int = Math.ceil(currentPlaySound.length / (currentPlaySound.bytesLoaded / currentPlaySound.bytesTotal));
				var playbackPercent:int = _widthProgressBar * (soundPosition / estimatedLength );	
				//диспатчит в MusicBox новые параметры соотношения длина трека - длина прогресса, когда ресайзится окно
				dispatchEvent(new OneNumberEvent(OneNumberEvent.PLAYBACK_PERCENT, playbackPercent));
					
			}

			lineVert.updateXY(1, initHeight, 0x6B6B6B);
			for each (var key:Object in arrSong) {
				key.updateScale(initWidth);
			}
		}
		
	}
}