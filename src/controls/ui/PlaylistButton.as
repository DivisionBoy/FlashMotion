package controls.ui {
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class PlaylistButton extends Sprite {
		
		private var playlistBtn:Bitmap;
		
		[Embed(source="assets/button/playlistButton.png")]
		private var PlaylistButtonClass:Class;
		
		public function PlaylistButton() {
			super();
			
			playlistBtn = new PlaylistButtonClass();
			addChild(playlistBtn);
			playlistBtn.x = - playlistBtn.width-2
		}	
		
	}
}