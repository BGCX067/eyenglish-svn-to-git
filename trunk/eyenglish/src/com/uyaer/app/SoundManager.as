package com.uyaer.app
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;

	public class SoundManager
	{
		private var sound:Sound;
		private var channel:SoundChannel;
		private var prevurl:String;
		public var isSpellOver:Boolean = false;
		public function SoundManager()
		{
			prevurl = "http://www.gstatic.com/dictionary/static/sounds/de/0/";
		}
		
		private function onLoadOver(e:Event):void{
			channel = sound.play(0,1);
			channel.addEventListener(Event.SOUND_COMPLETE,onSoundEnd);
		}
		
		private function onSoundEnd(e:Event):void{
			channel.removeEventListener(Event.SOUND_COMPLETE,onSoundEnd);
			EManager.emit(EType.SPELL_OVER);
			isSpellOver = true;
			sound.removeEventListener(Event.COMPLETE,onLoadOver);
			sound.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			channel.stop();
		}
		
		public function play(name:String):void{
			isSpellOver = false;
			sound = new Sound();
			sound.addEventListener(Event.COMPLETE,onLoadOver);
			sound.addEventListener(IOErrorEvent.IO_ERROR,onError);
			sound.load(new URLRequest(prevurl+name+".mp3"));
		}
		
		private function onError(e:IOErrorEvent):void{
			isSpellOver = true;
			Log.logln("sound --- : "+sound.url);
			Log.logln(e.toString());
		}
	}
}