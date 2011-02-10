// @license@ 
package nanosome.util {
	
	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public function fncMerge( ...fncs: Array ): Function {
		var list: WeakFunctionSet = new WeakFunctionSet();
		for( var i: int = 0; i < fncs.length; ++i ) {
			list.storage[ fncs[i] ] = true;
		}
		return list.executeAndReturn;
	}
}

import flash.utils.Dictionary;

class WeakFunctionSet {
	public var storage: Dictionary = new Dictionary( true );
	
	public function WeakFunctionSet() {}
	
	public function executeAndReturn( ...args: Array ): Array {
		var result: ReturnSet = new ReturnSet;
		var i: int = -1;
		for( var fnc: * in storage ) {
			var midResult: * = fnc['apply']( null, args );
			if ( midResult is ReturnSet ) {
				midResult['unshift']( i, 0 );
				result.splice.apply( null, midResult );
			} else {
				i = result.length;
				result[ ++i ] = midResult;
			}
		}
		return result;
	}
}

dynamic class ReturnSet extends Array {
	public function ReturnSet() {}
}