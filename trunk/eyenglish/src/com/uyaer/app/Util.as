package com.uyaer.app
{
	public class Util
	{
		
		public static function trimEn(s : String):String  { 
			return s.replace(/\s/g,"");
		} 
		
		public static function randRangNumber(start:Number, end:Number):Number{
			return Math.random()*(end-start)+start;
		}
		
		public static function randRangInt(start:int, end:int):int{
			return Math.ceil(Math.random()*(end-start))+start;
		}
	}
}