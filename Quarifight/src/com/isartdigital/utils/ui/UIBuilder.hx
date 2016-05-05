package com.isartdigital.utils.ui;

import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.UIPosition;
import flump.json.FlumpJSON;
import haxe.Json;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.display.FlumpSprite;

/**
 * ...
 * @author Mathieu Anthoine
 */
class UIBuilder
{
	
	/**
	 * fichier de description des assets d'UI au format Flump
	 */
	private static var description:Map<String,String>;

	/**
	 * suffixe des FlumpSprite "texte"
	 */
	private static inline var TXT_SUFFIX:String = "_txt";
	
	/**
	 * suffixe des FlumpButton
	 */
	private static inline var BTN_SUFFIX:String = "Button";
	
	/**
	 * wrapper vers UIPosition
	 */
	private static var uiPos:Map<String,String> =
		[
			"L" => UIPosition.LEFT,
			"R" => UIPosition.RIGHT,
			"T" => UIPosition.TOP,
			"B" => UIPosition.BOTTOM,
			"TL" => UIPosition.TOP_LEFT,
			"TR" => UIPosition.TOP_RIGHT,
			"BL" => UIPosition.BOTTOM_LEFT,
			"BR" => UIPosition.BOTTOM_RIGHT,
			"FW" => UIPosition.FIT_WIDTH,
			"FH" => UIPosition.FIT_HEIGHT,
			"FS" => UIPosition.FIT_SCREEN
		];
	
	private function new() {}	
	
	/**
	 * Initialise le parseur
	 * @param	pFile nom du fichier qui contient les données de mise en forme de l'UI
	 * @param	pPackage nom du package des boutons
	 */
	public static function addDescriptions(pFile:String,pPackage:String):Void {
		if (description == null) description = new Map < String, String>();
		description.set(pFile, pPackage);
	}
	
	/**
	 * Crée les éléments composant un Screen
	 * @param	pId assetName de l'écran
	 */
	public static function build (pId:String) : Array<UIPositionable> {
		
		var lData:FlumpJSON;
		var lObj:Container;
		var lItem;
		var lUIPos:Array<UIPositionable>=[];
		
		for (lDescription in description.keys()) {
		
			lData= cast GameLoader.getContent(lDescription);
			
			for (lMovie in lData.movies) {
				if (lMovie.id == pId) {
					for (lItem in lMovie.layers) {
						
						if (StringTools.endsWith(lItem.name,TXT_SUFFIX)) {
							//TODO: A vous de le coder pour remplacer le texte statique en un texte dynamique localisable
							lObj = new UIAsset(lItem.keyframes[0].ref);
						} else if (StringTools.endsWith(lItem.name,BTN_SUFFIX)) {	
							lObj = Type.createInstance(Type.resolveClass(description.get(lDescription)+"." + lItem.keyframes[0].ref), []);
						} else {
							lObj = new UIAsset(lItem.keyframes[0].ref);
						}
						
						lObj.name = lItem.keyframes[0].ref;
						if (Reflect.hasField(lItem.keyframes[0],"loc")) lObj.position.set(lItem.keyframes[0].loc.x, lItem.keyframes[0].loc.y);
						if (Reflect.hasField(lItem.keyframes[0],"scale")) lObj.scale.set(lItem.keyframes[0].scale.x, lItem.keyframes[0].scale.y);
						if (Reflect.hasField(lItem.keyframes[0],"skew")) lObj.skew.set(lItem.keyframes[0].skew.x,lItem.keyframes[0].skew.y);
						
						lUIPos.push(getUIPositionable(lObj,uiPos.get(lItem.name.split("_")[0])));
									
					}
				}
			}
			
		}
		
		return lUIPos;
		
	}
	
	public static function getTextStyle(pId:String):UITextStyle {
		var lData:Json;
		
		for (lDescription in description.keys()) {	
			lData = cast GameLoader.getContent("texts_"+lDescription);
			if (Reflect.hasField(lData, pId)) return Reflect.field(lData, pId);
		}
		return null;
	}
	
	/**
	 * retourne un UIPositionable correctement construit
	 * @param	pObj Item d'interface
	 * @param	pPosition ancrage "UIPosition"
	 * @return un UIPositionable
	 */
	private static function getUIPositionable (pObj:Container,pPosition:String):UIPositionable {
		
		var lOffset:Point = new Point (0, 0);
		
		if (
			pPosition != UIPosition.BOTTOM &&
			pPosition != UIPosition.BOTTOM_LEFT &&
			pPosition != UIPosition.BOTTOM_RIGHT &&
			pPosition != UIPosition.FIT_HEIGHT &&
			pPosition != UIPosition.FIT_SCREEN &&
			pPosition != UIPosition.FIT_WIDTH &&
			pPosition != UIPosition.LEFT &&
			pPosition != UIPosition.RIGHT &&
			pPosition != UIPosition.TOP &&
			pPosition != UIPosition.TOP_LEFT &&
			pPosition != UIPosition.TOP_RIGHT
		) pPosition = "";
		else {
			if (pPosition == UIPosition.TOP || pPosition == UIPosition.TOP_LEFT || pPosition == UIPosition.TOP_RIGHT ||
				pPosition == UIPosition.BOTTOM || pPosition == UIPosition.BOTTOM_LEFT || pPosition == UIPosition.BOTTOM_RIGHT) lOffset.y = pObj.y;
			if (pPosition == UIPosition.LEFT || pPosition == UIPosition.TOP_LEFT || pPosition == UIPosition.BOTTOM_LEFT ||
				pPosition == UIPosition.RIGHT || pPosition == UIPosition.TOP_RIGHT || pPosition == UIPosition.BOTTOM_RIGHT) lOffset.x = pObj.x;		
		}
		
		return {item:pObj, align:pPosition, offsetX:lOffset.x, offsetY:lOffset.y, update:true};
	}
	
}

