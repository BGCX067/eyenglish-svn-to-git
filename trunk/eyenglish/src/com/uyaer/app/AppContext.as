package com.uyaer.app
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class AppContext extends Sprite
	{
		private var dataProvider:AppData;
		private var soundManager:SoundManager;
		
		private var container:Sprite;
		private var wordTF:TextField;
		private var spellTF:TextField;
		private var desTF:TextField;
		private var SW:Number;
		private var SH:Number;
		private var wordFormat:TextFormat;
		private var spellFormat:TextFormat;
		private var desFormat:TextFormat;
		private var timer:Timer;
		private var timeIndex:int = 0;
		private var glow:GlowFilter;
		private var canvas:Stage;
		public function AppContext(stage:Stage)
		{
			this.canvas = stage;
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			dataProvider = new AppData();
			soundManager = new SoundManager();
			EManager.addListener(EType.PROGRESS, onProgressHandler);
			EManager.addListener(EType.START, onStartHandler);
		}
		
		protected function onTimer(e:TimerEvent):void{
			if(timeIndex > 5 && soundManager.isSpellOver){
				timeIndex = 0;
				update();
			}
			timeIndex++;
		}
		
		private function changeBg(e:Event):void{
			graphics.beginFill(0);
			graphics.drawRect(0,0,SW,SH);
			graphics.endFill();
			Log.logln("draw background!");
		}
		
		private function onStartHandler(e:Event):void{
			container = new Sprite();
			wordTF = new TextField();
			spellTF = new TextField();
			desTF = new TextField();
			
			wordTF.width = 500;
			spellTF.width = 500;
			desTF.width = 500;
			
			wordTF.autoSize = TextFieldAutoSize.LEFT;
			spellTF.autoSize = TextFieldAutoSize.LEFT;
			desTF.autoSize = TextFieldAutoSize.LEFT;
			
			wordFormat = new TextFormat("宋体",66,0xffffff,true);
			spellFormat = new TextFormat("宋体",50,0xffffff,false,true);
			desFormat = new TextFormat("宋体",42,0xffffff,false,false,true);
			
			wordTF.defaultTextFormat = wordFormat;
			spellTF.defaultTextFormat = spellFormat;
			desTF.defaultTextFormat = desFormat;
			
			glow = new GlowFilter(0xffffff,0.5);
			wordTF.filters = [glow];
			spellTF.filters = [glow];
			desTF.filters = [glow];
			
			container.addChild(wordTF);
			container.addChild(spellTF);
			container.addChild(desTF);
			addChild(container);
			
			SW = canvas.stageWidth;
			SH = canvas.stageHeight;
			
			update();
			timer.start();
			changeBg(null);
		}
		
		private function onProgressHandler(e:Event):void{
			
		}
		
		private function update():void{
			var bean:Bean = dataProvider.one();
			wordTF.text = bean.word;
			spellTF.text = bean.spell;
			desTF.text = bean.des;
			randomPos();
			soundManager.play(bean.word);
		}
		
		private function randomPos():void{
			wordTF.y = 0;
			spellTF.y = wordTF.height+10;
			desTF.y = spellTF.y + spellTF.height + 10;
			container.x = (SW - container.width)>>1;
			container.y = (SH - container.height)>>1;
		}
		
		public function pause():void{
			if(timer.running){
				timer.stop();
			}
			if(parent){
				parent.removeChild(this);
			}
		}
		
		public function resume():void{
			if(!timer.running){
				timer.start();
			}
			dataProvider.random();
		}
	}
}