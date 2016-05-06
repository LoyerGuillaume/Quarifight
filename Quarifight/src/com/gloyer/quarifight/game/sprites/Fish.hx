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
	
	private static inline var SPEED_ANIMATION:Float = 0.7;
	private static inline var DEFAULT_SCALE:Float = 0.8;
	
	private static inline var MIN_DURATION_MOVEMENT:Float = 3;
	private static inline var MAX_DURATION_MOVEMENT:Float = 6;
	
	private static inline var MIN_DURATION_WAIT_MOVEMENT:Float = 1;
	private static inline var MAX_DURATION_WAIT_MOVEMENT:Float = 3;
	
	//FIXME : Use Bounding box mais pas dans le poisson
	private static inline var MIN_MOVEMENT_X:Int = -1200;
	private static inline var MIN_MOVEMENT_Y:Int = -450;
	private static inline var MAX_MOVEMENT_X:Int = 1200;
	private static inline var MAX_MOVEMENT_Y:Int = 500;
	
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
	
	
	private function changeSpeedAnimation():Void {
		cast(anim, FlumpMovie).animationSpeed = SPEED_ANIMATION;
	}
	
	private function changeOrientation():Void {
		anim.scale.x *= -1;
	}
	
	private function startRandomTargetMovement():Void {
		var lPositionTarget:Point = getRandomPositionMovement();
		
		trace((lPositionTarget.x - x));
		var nextOrientationIsLeft:Bool = (lPositionTarget.x - x) <= 0; //FIXME: Obliger de décaller le résultat parce que l'origine est au centre de l'écran
		if (nextOrientationIsLeft != orientationLeft) {
			changeOrientation();
			orientationLeft = nextOrientationIsLeft;
		}
		
		tweenMovement = TweenLite.fromTo(this, getRandomDurationMovement(), {x: x, y: y}, {x: lPositionTarget.x, y: lPositionTarget.y, ease: Power2.easeOut, onComplete: waitForMove});
	}
	
	private function waitForMove():Void {
		TimerDelay.getInstance().startDelay("Movement Fish " + id, getRandomDurationWaitMovement(), startRandomTargetMovement);
	}
	
	private function getRandomDurationWaitMovement():Int {
		return MathPerso.getRandomInt(MIN_DURATION_WAIT_MOVEMENT, MAX_DURATION_WAIT_MOVEMENT) * 1000;
	}
	
	private function getRandomDurationMovement():Float {
		return MathPerso.getRandomFloat(MIN_DURATION_MOVEMENT, MAX_DURATION_MOVEMENT);
	}
	
	private function getRandomPositionMovement():Point {
		return new Point(MathPerso.getRandomInt(MIN_MOVEMENT_X, MAX_MOVEMENT_X), MathPerso.getRandomInt(MIN_MOVEMENT_Y, MAX_MOVEMENT_Y));
	}
	
	
	override public function start():Void 
	{
		super.start();
		startRandomTargetMovement();
		changeSpeedAnimation();
	}
	
	override private function setModeNormal():Void {
		setState('lvl'+level, true);
		super.setModeNormal();
	}
	
}