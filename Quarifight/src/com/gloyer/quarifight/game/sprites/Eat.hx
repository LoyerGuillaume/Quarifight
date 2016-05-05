package com.gloyer.quarifight.game.sprites;

import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.game.StateGraphic;
import pixi.core.math.Point;

/**
 * ...
 * @author Loyer Guillaume
 */
class Eat extends StateGraphic
{
	private var level:Int;
	
	private static var DEFAULT_SCALE:Int = 1;
	
	public function new(pLevel:Int) 
	{
		super();
		factory = new FlumpMovieAnimFactory();
		
		level = pLevel;
		
		//FIXME
		scale = new Point(DEFAULT_SCALE, DEFAULT_SCALE);
		
		//boxType = BoxType.SIMPLE;
	}
	
	override private function setModeNormal():Void {
		setState('lvl'+level, true);
		super.setModeNormal();
	}
	
}