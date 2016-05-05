package com.gloyer.quarifight.game.sprites;

import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.game.StateGraphic;

/**
 * ...
 * @author Loyer Guillaume
 */
class LevelBackground extends StateGraphic
{
	
	private var level:Int;

	public function new(pLevel:Int) 
	{
		super();
		factory = new FlumpMovieAnimFactory();
		level = pLevel;
		start();
	}
	
	override private function setModeNormal():Void {
		setState(Std.string(level), true);
		super.setModeNormal();
	}
	
}