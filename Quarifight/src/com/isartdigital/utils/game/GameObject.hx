package com.isartdigital.utils.game;

import com.isartdigital.utils.events.EventType;
import pixi.core.display.Container;

/**
 * Classe de base des objets interactifs dans le jeu
 * Met à jour automatiquement ses données internes de position et transformation
 * 
 * @author Mathieu ANTHOINE
 */
class GameObject extends Container
{

	public function new() 
	{
		super();
		on(EventType.ADDED, forceUpdateTransform);	
	}
	
	/**
	 * Force la mise à jour de la matrices de transformation des éléments constituant le GameObject
	 */
	private function forceUpdateTransform (): Void {
		untyped updateTransform();
	}
	
	/**
	 * nettoie et détruit l'instance
	 */
	override public function destroy (): Void {
		off(EventType.ADDED, forceUpdateTransform);
		super.destroy(true);
	}
	
}