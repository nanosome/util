// @license@
package nanosome.util.normalize {
	
	/**
	 * Shortcut helper to create eighter a <code>NormalizeMappedRange</code> (if
	 * map given) or <code>NormalizeRange</code>.
	 * 
	 * @param min value of 0.0 point
	 * @param max value of 1.0 point 
	 * @return new NormalizedRange or NormalizeMappedRange instance
	 * @see NormalizeRange
	 * @see NormalizeMappedRange
	 */
	public function range( min: Number, max: Number, map: INormalizeMap = null ): INormalizeRange {
		if( map ) {
			return new NormalizeMappedRange( min, max, map );
		} else {
			return new NormalizeRange( min, max );
		}
	}
	
}
