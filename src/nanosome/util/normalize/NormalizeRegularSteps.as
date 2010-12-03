// @license@
package nanosome.util.normalize {
	
	/**
	 * <code>NormalizeRegularSteps</code> is a util to lock a normalized value to
	 * a given amount of steps.
	 * 
	 * @example <listing version="3">
	 *   var map: NormalizeRegularSteps = new NormalizeRegularSteps(5);
	 *   map.from( 0.0 ); // 0.0;
	 *   map.from( 0.25 ); // 0.25 (because its 1/4th)
	 *   map.from( 0.40 ); // 0.50 (because 0.4 is closer to 0.5 than to 0.25
	 *   map.from( 1.0 ); // 1.0
	 * </listing>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public final class NormalizeRegularSteps implements ISteppedNormalize {
		
		// Internal holder for the amount of steps of this instance.
		private var _amountSteps: uint;
		
		// Storage for the steps in array form for evaluation
		private var _steps: Array;
		
		// Distance between two steps
		private var _stepSize: Number;
		
		/**
		 * Creates a new map with a certain amount of steps it locks on to.
		 * 
		 * @param amountSteps Amount of steps this normalize function should have (0.0 and 1.0 count as step!)
		 */
		public function NormalizeRegularSteps( amountSteps: uint ) {
			super();
			if( amountSteps < 2 ) {
				throw new Error( "At least 2 steps required!" );
			}
			_amountSteps = amountSteps;
			_stepSize = 1/(_amountSteps-1);
		}
		
		/**
		 * @inheritDoc
		 */
		public function from( number: Number ): Number {
			var pos: int = number / _stepSize + .5;
			return pos * _stepSize;
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( normalized: Number ): Number {
			var pos: int = normalized / _stepSize + .5;
			return pos * _stepSize;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get steps(): Array {
			if( !_steps ) {
				_steps = [];
				// Used a stepcounter because value iteration might
				// result in floatingpoint errors
				var stepNo: int = 1;
				var step: Number = 0.0;
				while( stepNo < _amountSteps-1 ) {
					_steps[ stepNo ] = step;
					step += _stepSize;
					++stepNo;
				}
				// Make sure that its always a straight 1.0
				_steps[ stepNo ] = 1.0;
			}
			return _steps;
		}
	}
}
