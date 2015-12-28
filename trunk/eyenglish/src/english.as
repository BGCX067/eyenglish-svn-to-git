package
{
	import com.uyaer.app.AppContext;
	import com.uyaer.app.Log;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ScreenMouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class english extends Sprite
	{
		[Embed(source="assets/icon/img32.png")]
		private var icon:Class;
		private var timer:Timer;
		private var app:AppContext;
		private var startTime:Number =-1;
		private var timeIndex:int = 0;
		public var window:NativeWindow;
		public function english()
		{
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.type = NativeWindowType.LIGHTWEIGHT;
			options.transparent = true;
			options.systemChrome = NativeWindowSystemChrome.NONE;
			window = new NativeWindow(options);
			window.x = 0;
			window.y = 0;
			window.width = Screen.mainScreen.bounds.width;
			window.height = Screen.mainScreen.bounds.height;
			window.stage.align = StageAlign.TOP_LEFT;
			window.stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.nativeWindow.close();
			try{
				NativeApplication.nativeApplication.icon.bitmaps = [new icon().bitmapData];
				(NativeApplication.nativeApplication.icon as SystemTrayIcon).tooltip = "英语学习";
				if(NativeMenu.isSupported){
					var menu:NativeMenu = new NativeMenu();
					var closeItem:NativeMenuItem = new NativeMenuItem("关闭");
					closeItem.addEventListener(Event.SELECT,onSelectMenuItem);
					closeItem.name = "mi_close";
					menu.addItem(closeItem);
					(NativeApplication.nativeApplication.icon as SystemTrayIcon).menu = menu;
				}
				NativeApplication.nativeApplication.startAtLogin = true;
			}catch(e:Error){
				Log.logln(e.message);
			}
			
			this.loadConfig();
		}
		
		/**
		 * 图标点击 
		 * @param e
		 */		
		protected function onClickIcon(e:ScreenMouseEvent):void{
			
		}
		
		/**
		 * 菜单选择
		 * @param e
		 */		
		private function onSelectMenuItem(e:Event):void{
			switch(e.target.name)
			{
				case "mi_close":
					NativeApplication.nativeApplication.exit();
					break;
			}
		}
		private var loader:URLLoader;
		private function loadConfig():void{
			loader = new URLLoader(new URLRequest("assets/config.xml"));
			loader.addEventListener(Event.COMPLETE,onLoadOver);
		}
		private var timeMs:Number;
		private var delay:int;
		private function onLoadOver(e:Event):void{
			var xml:XML = new XML(loader.data);
			delay = xml.child("delay");
			var tStr:String = xml.child("time");
			var tArr:Array = tStr.split(":");
			timeMs = getMs(tArr[0],tArr[1],tArr[2]);
			
			timer = new Timer(60000);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
		}
		
		private function getMs(h:int,m:int,s:int):Number{
			return h*3600 + m*60 + s;
		}
		
		private function onTimer(e:TimerEvent):void{
			Log.log("a:"+timeIndex + "  b: "+ timer.currentCount+" c: "+startTime);
			var nowDate:Date = new Date();
			var nowMs:Number = getMs(nowDate.getHours(),nowDate.getMinutes(),nowDate.getSeconds());
			if(nowMs < timeMs){
				return;
			}
			if(startTime<=0){
				if(timeIndex>=delay-1){
					if(!app){
						app = new AppContext(window.stage);
						window.stage.addChild(app);
						Log.log("  create app: ===");
					}else{
						app.resume();
						window.stage.addChild(app);
						Log.log("  resume app: =-----");
					}
					window.activate();
					startTime = new Date().time;
					window.alwaysInFront = true;
				}else{
					try{
						(NativeApplication.nativeApplication.icon as SystemTrayIcon).tooltip = "英语学习(cd:"+(30-timeIndex)+")";
					}catch(e:Error){
						Log.logln(e.message);
					}
				}
			}else{
				var now:Number = new Date().time;
				if(now - startTime > 5*60*1000){
					app.pause();
					startTime = -1;
					window.alwaysInFront = false;
					timeIndex = 0;
					trace("  pause app: ++++");
					Log.log("  pause app: ++++");
				}
			}
			timeIndex++;
			Log.logln("");
		}
	}
}