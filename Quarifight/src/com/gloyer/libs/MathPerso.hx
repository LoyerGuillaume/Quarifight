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
	
	
	
	
	
	
	/*
	 * VECTOR
	 */
	
	public static function getRandomPoint(pMinX:Float, pMaxX:Float, pMinY:Float, pMaxY:Float):Point {
		return new Point(getRandomInt(pMinX, pMaxX), getRandomInt(pMinY, pMaxY));
	}
	
	public static function getVectorBeetweenPosition(pStartPosition:Point, pEndPosition:Point):Point {
		return soustractVector(pEndPosition, pStartPosition);
	}
	
	/**
	 * Soustrait les vecteurs pA - pB
	 * @param	pA
	 * @param	pB
	 * @return
	 */
	public static function soustractVector(pA:Point, pB:Point):Point {
		return new Point(pA.x - pB.x, pA.y - pB.y);
	}
	
	public static function normalizeVector(pVector:Point):Point {
		return multiplyVector(pVector, 1 / getVectorLength(pVector));
	}
	
	public static function multiplyVector(pVector:Point, pNumber:Float):Point {
		return new Point(pVector.x * pNumber, pVector.y * pNumber);
	}
	
	public static function getVectorLength(pVector:Point):Float {
		return Math.sqrt(pVector.x * pVector.x + pVector.y * pVector.y);
	}
	
	public static function additionVector(pA:Point, pB:Point):Point {
		return new Point(pA.x + pB.x, pA.y + pB.y);
	}
	
	
	public static function clampVector(pVector:Point, pTopLeft:Point, pBottomRight:Point):Point {
		var lVector:Point = pVector.clone();
		
		if (lVector.x < pTopLeft.x) {
			lVector.x = pTopLeft.x;
		} else if (lVector.x > pBottomRight.x) {
			lVector.x = pBottomRight.x;
		}
		
		if (lVector.y < pTopLeft.y) {
			lVector.y = pTopLeft.y;
		} else if (lVector.y > pBottomRight.y) {
			lVector.y = pBottomRight.y;
		}
		
		return lVector;
	}
}