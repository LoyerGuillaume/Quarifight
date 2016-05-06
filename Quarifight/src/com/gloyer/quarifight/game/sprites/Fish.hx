package com.gloyer.quarifight.game.sprites;

import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.game.StateGraphic;
import pixi.display.FlumpMovie;

/**
 * ...
 * @author Loyer Guillaume
 */
class Fish extends StateGraphic
{
	private var level:Int;
	
	private static var SPEED_ANIMATION:Float = 0.7;

	public function new(pLevel:Int) 
	{
		super();
		factory = new FlumpMovieAnimFactory();
		
		
		level = pLevel;
	}
	
	
	private function changeSpeedAnimation():Void {
		cast(anim, FlumpMovie).animationSpeed = SPEED_ANIMATION;
	}
	
	
	override public function start():Void 
	{
		super.start();
		changeSpeedAnimation();
	}
	
	override private function setModeNormal():Void {
		setState('lvl'+level, true);
		super.setModeNormal();
	}
	
}