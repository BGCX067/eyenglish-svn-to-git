package com.uyaer.app
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class EManager
	{
		private static var dispatch:EventDispatcher = new EventDispatcher();
		public function EManager()
		{
		}
		
		public static function emit(type:String):void{
			dispatch.dispatchEvent(new Event(type));
		}
		
		public static function addListener(type:String, callback:Function):void{
			dispatch.addEventListener(type,callback);
		}
	}
}