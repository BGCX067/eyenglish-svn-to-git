package com.uyaer.app
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class Background
	{
		private var res:Array = ["00001.jpg"];
		private var index:int = 0;
		private var len:int = 1;
		private var loader:Loader;
		public var bmd:BitmapData;
		public function Background()
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onOver);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			next();
		}
		
		private function onError(e:IOErrorEvent):void{
			trace(e.text);
		}
		
		private function onOver(e:Event):void{
			bmd && bmd.dispose();
			var tempBmd:BitmapData = (loader.contentLoaderInfo.content as Bitmap).bitmapData;
			bmd = tempBmd.clone();
			tempBmd.dispose();
			EManager.emit(EType.BG_LOAD_OVER);
		}
		
		public function next():void{
			if(index == len){
				index = 0;
			}
			var url:String = "assets/bg/"+res[index];
			loader.load(new URLRequest(url));
			index++;
		}
	}
}