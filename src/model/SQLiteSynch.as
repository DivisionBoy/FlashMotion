package model {

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Sprite;
	import flash.errors.SQLError;
	import flash.events.Event;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	public class SQLiteSynch extends Sprite {
		
		private static var sqlc:SQLConnection = new SQLConnection();
		private static var selectStmt:SQLStatement;

		public static var numRows:int;
		public static var labelName:String;
		public static var result:SQLResult
		
		//CONSTRUCTOR
		public function SQLiteSynch() {
			//initSQL();
		}
		
		public static function initSQL():void {
			var db:File = File.applicationStorageDirectory.resolvePath("StickerDB.db");
			if(db.exists){

				sqlc.open(db);
				selectStmt = new SQLStatement();
				selectStmt.sqlConnection = sqlc;

				var sql:String = "SELECT * FROM sectionSticker";
				selectStmt.text = sql;

				try {
					selectStmt.execute();
				}catch (error:SQLError) {
					
					/*trace("SELECT error:", error);
					trace("error.message:", error.message);
					trace("error.details:", error.details);*/
					
					return;
				}
			}else{

					var GroupsTable:String = "CREATE TABLE IF NOT EXISTS sectionSticker (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, url TEXT, message TEXT, date TEXT, visible NUMERIC, stickerX NUMERIC, stickerY NUMERIC, textX NUMERIC, textY NUMERIC, textWidth NUMERIC, textHeight NUMERIC, textRotation NUMERIC)";
					sqlc.open(db);
					selectStmt = new SQLStatement();
					selectStmt.sqlConnection = sqlc;
					selectStmt.text = GroupsTable;

					try {
						selectStmt.execute();
					}catch (error:SQLError) {
						
						/*trace("SELECT error:", error);
						trace("error.message:", error.message);
						trace("error.details:", error.details);*/
						
						return;
				}	
			}

			try {
				selectStmt.execute();
			}catch (error:SQLError) {
				
				/*trace("SELECT error:", error);
				trace("error.message:", error.message);
				trace("error.details:", error.details);*/
				
				return;
			}
			
			result = selectStmt.getResult();
			if (result != null && result.data != null){
				numRows = result.data.length;
			}
		}
		public static function closeSticBase():void {
			sqlc.close();
			
		}
		public static function getCurrentNumber():Number {
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = sqlc;
			selectStmt.text = "SELECT * FROM sectionSticker";
			selectStmt.execute();
			result = selectStmt.getResult();
			var currentNumRows:Number;

			if (result != null && result.data)currentNumRows = result.data.length;	
			
			return currentNumRows;
			
		}
		public static function getID(num:int):int{
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = sqlc;
			selectStmt.text = "SELECT * FROM sectionSticker";
			selectStmt.execute();
			result = selectStmt.getResult();

			if (result != null && result.data){
				var selectRow:Object = result.data[num]
			}
			
			return selectRow.id;
		}
		public static function getX(num:int):int{		
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = sqlc;
			selectStmt.text = "SELECT * FROM sectionSticker";
			selectStmt.execute();
			result = selectStmt.getResult();

			if (result != null && result.data){
				var selectRow:Object = result.data[num]
			}
			
			return selectRow.textX;
		}
		public static function getY(num:int):int{			
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = sqlc;
			selectStmt.text = "SELECT * FROM sectionSticker";
			selectStmt.execute();
			result = selectStmt.getResult();

			if (result != null && result.data){
				var selectRow:Object = result.data[num]
			}
			
			return selectRow.textY;
		}
		public static function getWidth(num:int):int{			
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = sqlc;
			selectStmt.text = "SELECT * FROM sectionSticker";
			selectStmt.execute();
			result = selectStmt.getResult();
			if (result != null && result.data){
				var selectRow:Object = result.data[num]
			}
			
			return selectRow.textWidth;
		}
		public static function getRotate(num:int):int{			
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = sqlc;
			selectStmt.text = "SELECT * FROM sectionSticker";
			selectStmt.execute();
			result = selectStmt.getResult();

			if (result != null && result.data){
				var selectRow:Object = result.data[num]
			}
			
			return selectRow.textRotation;
		}
		public static function addItem(url:String, message:String, date:String, visible:int, stickerX:Number, stickerY:Number, textX:Number, textY:Number, textWidth:Number, textHeight:Number, textRotation:Number):void {
			selectStmt.text = "INSERT INTO sectionSticker (url, message, date, visible, stickerX, stickerY, textX, textY, textWidth, textHeight, textRotation) VALUES('"+url+"'," +
				"'"+message+"'," +
				"'"+date+"'," +
				"'"+visible+"'," +
				"'"+stickerX+"'," +
				"'"+stickerY+"'," +
				"'"+textX+"'," +
				"'"+textY+"'," +
				"'"+textWidth+"'," +
				"'"+textHeight+"'," +
				"'"+textRotation+"')"
			selectStmt.execute();

		}

		public static function editCoordinate(stickerX:Number, stickerY:Number, id:uint):void {
			selectStmt.text ="UPDATE sectionSticker SET stickerX='"+stickerX+"', stickerY='"+stickerY+"' WHERE id='"+id+"'";

		}
		public static function editVisible(visible:int, id:uint):void {
			selectStmt.text ="UPDATE sectionSticker SET visible='"+visible+"' WHERE id='"+id+"'";
			selectStmt.execute();

		}
		public static function editMessage(message:String, id:uint):void {
			selectStmt.text ="UPDATE sectionSticker SET message='"+message+"' WHERE id='"+id+"'";
			selectStmt.execute();

		}

		public static function remove(id:uint):void {
			selectStmt.text = "DELETE FROM sectionSticker WHERE id="+id;
			selectStmt.execute();

		}		
		
	}
}