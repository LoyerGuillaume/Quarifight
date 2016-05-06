package com.gloyer.libs;

/**
 * ...
 * @author Loyer Guillaume
 */
class MathPerso
{
	
	public static function getRandomFloat(pMin:Float, pMax:Float):Float {
		return pMin + Math.random() * (pMax - pMin);
	}
	
	public static function getRandomInt(pMin:Float, pMax:Float):Int {
		return Math.round(getRandomFloat(pMin, pMax));
	}
	
}