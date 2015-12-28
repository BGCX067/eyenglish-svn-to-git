package com.uyaer.app
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class Log
	{
		private static var logFile:File;
		private static var logs:FileStream;
		public static function log(str:String):void{
			if(!logs){
				init();
			}
			logs.open(logFile,FileMode.APPEND);
			logs.writeUTF(str);
			logs.close();
		}
		
		private static function init():void{
			logFile = File.applicationStorageDirectory.resolvePath("cache.log");
			trace(logFile.nativePath);
			logs = new FileStream();
		}
		
		public static function logln(str:String):void{
			if(!logs){
				init();
			}
			logs.open(logFile,FileMode.APPEND);
			logs.writeUTF(str+"\r\n");
			logs.close();
		}
	}
}