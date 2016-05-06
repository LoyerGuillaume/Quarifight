package com.gloyer.quarifight.game.sprites;

import com.gloyer.libs.MathPerso;
import com.gloyer.libs.TimerDelay;
import com.greensock.TweenLite;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.game.StateGraphic;
import pixi.core.math.Point;
import pixi.display.FlumpMovie;
import tween.easing.Back;
import tween.easing.Circ;
import tween.easing.Power1;
import tween.easing.Power2;

/**
 * ...
 * @author Loyer Guillaume
 */
class Fish extends StateGraphic
{
	private var level:Int;
	
	private static var idFish:Int = 0;
	private var id:Int;
	
	private static inline var WAIT_SPEED_ANIMATION:Float = 0.4;
	private static inline var SWIM_SPEED_ANIMATION:Float = 0.8;
	private static inline var DEFAULT_SCALE:Float = 0.8;
	
	private static inline var MIN_DURATION_MOVEMENT:Float = 3;
	private static inline var MAX_DURATION_MOVEMENT:Float = 6;
	
	private static inline var MIN_DURATION_WAIT_MOVEMENT:Float = 0.5;
	private static inline var MAX_DURATION_WAIT_MOVEMENT:Float = 1.5;
	
	//FIXME : Use Bounding box mais pas dans le poisson
	private static inline var MIN_MOVEMENT_X:Int = -1200;
	private static inline var MIN_MOVEMENT_Y:Int = -450;
	private static inline var MAX_MOVEMENT_X:Int = 1200;
	private static inline var MAX_MOVEMENT_Y:Int = 500;
	
	private static inline var MIN_SPEED_MOVEMENT:Float = 50;
	private static inline var MAX_SPEED_MOVEMENT:Float = 500;
	
	private var orientationLeft:Bool;
	
	private var tweenMovement:TweenLite;

	public function new(pLevel:Int) 
	{
		super();
		factory = new FlumpMovieAnimFactory();
		
		//FIXME
		scale = new Point(DEFAULT_SCALE, DEFAULT_SCALE);
		
		level = pLevel;
		id = idFish++;
		
		orientationLeft = true;
	}
	
	
	private function changeSpeedAnimation(pSpeedAnimation:Float):Void {
		cast(anim, FlumpMovie).animationSpeed = pSpeedAnimation;
	}
	
	private function changeOrientation():Void {
		anim.scale.x *= -1;
	}
	
	private function startRandomTargetMovement():Void {
		changeSpeedAnimation(SWIM_SPEED_ANIMATION);
		var lPositionTarget:Point = getRandomPositionMovement();
		
		var nextOrientationIsLeft:Bool = (lPositionTarget.x - x) <= 0; //FIXME: Obliger de décaller le résultat parce que l'origine est au centre de l'écran
		if (nextOrientationIsLeft != orientationLeft) {
			changeOrientation();
			orientationLeft = nextOrientationIsLeft;
		}
		
		tweenMovement = TweenLite.fromTo(this, getRandomDurationMovement(), {x: x, y: y}, {x: lPositionTarget.x, y: lPositionTarget.y, ease: Power1.easeInOut, onComplete: waitForMove});
	}
	
	private function waitForMove():Void {
		changeSpeedAnimation(WAIT_SPEED_ANIMATION);
		TimerDelay.getInstance().startDelay("Movement Fish " + id, getRandomDurationWaitMovement(), startRandomTargetMovement);
	}
	
	private function getRandomDurationWaitMovement():Int {
		return MathPerso.getRandomInt(MIN_DURATION_WAIT_MOVEMENT, MAX_DURATION_WAIT_MOVEMENT) * 1000;
	}
	
	private function getRandomDurationMovement():Float {
		return MathPerso.getRandomFloat(MIN_DURATION_MOVEMENT, MAX_DURATION_MOVEMENT);
	}
	
	
	
	private function getRandomPositionMovement():Point {
		return movementRadius();
	}
	
	private function movementRadius():Point {
		var lPosition:Point = MathPerso.getRandomPoint(MIN_MOVEMENT_X, MAX_MOVEMENT_X, MIN_MOVEMENT_Y, MAX_MOVEMENT_Y);
		
		var vector:Point = MathPerso.getVectorBeetweenPosition(position, lPosition);
		var vectorNormalize:Point = MathPerso.normalizeVector(vector);
		
		var lNewPosition:Point = MathPerso.additionVector(MathPerso.multiplyVector(vectorNormalize, MathPerso.getRandomFloat(MIN_SPEED_MOVEMENT, MAX_SPEED_MOVEMENT)), position);
		lNewPosition = MathPerso.clampVector(lNewPosition, new Point(MIN_MOVEMENT_X, MIN_MOVEMENT_Y), new Point(MAX_MOVEMENT_X, MAX_MOVEMENT_Y));
		
		return lNewPosition;		
	}
	
	private function movementStandard():Point {
		var lPosition:Point = MathPerso.getRandomPoint(MIN_MOVEMENT_X, MAX_MOVEMENT_X, MIN_MOVEMENT_Y, MAX_MOVEMENT_Y);
		return lPosition;
	}
	
	
	
	override public function start():Void 
	{
		super.start();
		startRandomTargetMovement();
		changeSpeedAnimation(SWIM_SPEED_ANIMATION);
	}
	
	override private function setModeNormal():Void {
		setState('lvl'+level, true);
		super.setModeNormal();
	}
	
}