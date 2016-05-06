package com.gloyer.libs;
import pixi.core.math.Point;

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
	
	public static function getRandomPoint(pMinX:Float, pMaxX:Float, pMinY:Float, pMaxY:Float):Point {
		return new Point(getRandomInt(pMinX, pMaxX), getRandomInt(pMinY, pMaxY));
	}
	
}