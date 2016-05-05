package com.isartdigital.utils.ui;

import com.isartdigital.utils.game.factory.FlumpSpriteAnimFactory;
import com.isartdigital.utils.game.StateGraphic;

/**
 * ...
 * @author Mathieu Anthoine
 */
class UIAsset extends StateGraphic
{

	public function new(pAssetName:String) 
	{
		super();
		assetName = pAssetName;
		factory = new FlumpSpriteAnimFactory();
		setState(DEFAULT_STATE);
	}
	
}