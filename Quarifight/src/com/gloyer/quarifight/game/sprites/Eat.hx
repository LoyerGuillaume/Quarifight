package com.gloyer.quarifight.game.sprites;

import com.gloyer.libs.TimerDelay;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.game.StateGraphic;
import haxe.Timer;
import com.greensock.TweenLite;
import pixi.core.math.Point;
import tween.easing.Power0;

/**
 * ...
 * @author Loyer Guillaume
 */
class Eat extends StateGraphic
{
	private var level:Int;
	
	private static var idEat:Int = 0;
	private static var DEFAULT_SCALE:Int = 1;
	private static var SPEED_FALL:Int = 2;
	private static var DURATION_ALIVE:Int = 8;
	private static var DURATION_ALPHA_ZERO:Int = 1;
	
	public function new(pLevel:Int) 
	{
		super();
		factory = new FlumpMovieAnimFactory();
		
		level = pLevel;
		
		//FIXME
		scale = new Point(DEFAULT_SCALE, DEFAULT_SCALE);
		
		TimerDelay.getInstance().startDelay("startDestroyEat" + idEat++, DURATION_ALIVE * 1000, startDestroyEat);
		//boxType = BoxType.SIMPLE;
	}
	
	private function startDestroyEat():Void {
		var lTween:TweenLite =  TweenLite.fromTo(this, DURATION_ALPHA_ZERO, { alpha: 1 }, { alpha: 0, ease: Power0.easeIn, onComplete:destroyMe});
	}
	
	private function destroyMe():Void {
		LevelManager.getInstance().destroyEat(this);
	}
	
	private function fall():Void {
		if (y < LevelManager.DISTANCE_TOP_GROUND) {
			position.y += SPEED_FALL;			
		}
	}

	override function doActionNormal():Void {
		fall();
	}
	
	override private function setModeNormal():Void {
		setState('lvl'+level, true);
		super.setModeNormal();
	}
	
}