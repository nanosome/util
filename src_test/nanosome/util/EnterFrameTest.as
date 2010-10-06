package nanosome.util {
	
	import flexunit.framework.TestCase;

	import flash.display.Shape;
	import flash.events.Event;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class EnterFrameTest extends TestCase {
		private var _fnc : Function;
		private var _executed : Boolean;
		private var _async : Function;
		private var _shape : Shape = new Shape();
		
		public function testEnterFrameExecution(): void {
			assertTrue( EnterFrame.add( testPass ) );
			assertFalse( EnterFrame.add( testPass ) );
			assertTrue( EnterFrame.contains( testPass ) );
			_async = addAsync( remAsync, 10000 );
		}
		
		private function remAsync( e: Event = null ): void {;
			_shape.removeEventListener( Event.ENTER_FRAME, _async );
		}
		
		private function testPass() : void {
			if( !_executed ) {
				_executed = true;
				assertTrue( EnterFrame.remove( testPass ) );
				assertFalse( EnterFrame.remove( testPass ) );
				assertFalse( EnterFrame.contains( testPass ));
				_shape.addEventListener( Event.ENTER_FRAME, _async );
			} else {
				EnterFrame.remove( testPass );
				fail( "Testpass should have been triggered just once." );
			}
		}
	}
}
