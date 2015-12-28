package com.uyaer.app
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class AppData
	{
		private var loader:URLLoader;
		private var data:Vector.<Bean>;
		private var index:int = 0;
		private var len:int;
		public function AppData()
		{
			loader = new URLLoader(new URLRequest("assets/word.txt"));
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE,initData);
			Log.logln("  load data...:  "+len);
			EManager.emit(EType.PROGRESS);
		}
		
		private function initData(...args):void{
			Log.logln("  start uncopress data:  "+len);
			data = new Vector.<Bean>();	
			var str:String = loader.data;
			var arr:Array = str.split("\r\n");
			len = arr.length;
			var start:int;
			var end:int;
			for(var i:int = 0 ; i < len; i ++){
				var astr:String = arr[i];
				if(astr.length>2){
					var bean:Bean = new Bean();
					start = astr.indexOf("/");
					if(start==-1){
						start = astr.indexOf("\[");
					}
					bean.word = Util.trimEn(astr.substr(0,start));
					astr = astr.substring(start+1);
					end = astr.indexOf("/");
					if(end == -1){
						end = astr.indexOf("\]");
					}
					bean.spell = "/"+Util.trimEn(astr.substr(0,end))+"/";
					bean.des = Util.trimEn(astr.substring(end+1));
					data.push(bean);
				}
			}
			arr.length = 0;
			loader.close();
			len = data.length;
			index = Util.randRangInt(0,len);
			Log.logln("  data len:  "+len);
			EManager.emit(EType.START);
		}
		
		public function one():Bean{
			if(index == len){
				index = 0 ;
			}
			var bean:Bean = data[index];
			index++;
			return bean;
		}
		
		public function random():void
		{
			index = Util.randRangInt(0,len);
		}
	}
}
