package com.gloyer.quarifight.ui.popin;

import com.gloyer.quarifight.game.GameManager;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Popin;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

	
/**
 * Exemple de classe héritant de Popin
 * @author Mathieu ANTHOINE
 */
class Confirm extends Popin 
{
	
	private var background:Sprite;
	
	/**
	 * instance unique de la classe Confirm
	 */
	private static var instance: Confirm;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Confirm {
		if (instance == null) instance = new Confirm();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		background = new Sprite(Texture.fromImage(Config.url(Config.assetsPath+"Confirm.png")));
		background.anchor.set(0.5, 0.5);
		addChild(background);
		interactive = true;
		buttonMode = true;
		
		once(MouseEventType.CLICK,onClick);
		once(TouchEventType.TAP,onClick);
		
	}
	
	private function test (pEvent:EventTarget):Void {
		trace (pEvent);
	}
	
	private function onClick (pEvent:EventTarget): Void {
		SoundManager.getSound("click").play();
		UIManager.getInstance().closeCurrentPopin();
		GameManager.getInstance().start();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}