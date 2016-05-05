package com.isartdigital.utils.game.iso;

/**
 * Interface des objets à "z sorter"
 * @author Mathieu Anthoine
 */
interface IZSortable 
{
	
	// colonne minimum
	public var colMin:UInt;
	
	// colonne maximum
	public var colMax:UInt;
	
	// ligne minimum
	public var rowMin:UInt;
	
	// ligne maximum
	public var rowMax:UInt;
}