package nanosome.util {
	
	import flash.events.Event;

	import flexunit.framework.TestCase;

	import flash.display.Shape;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class ExitFrameTest extends TestCase {
		private var _executed : Boolean;
		private var _async : Function;
		private var _shape: Shape = new Shape();
		
		public function testExitFrameExecution(): void {
			assertTrue( ExitFrame.add( testPass ) );
			assertFalse( ExitFrame.add( testPass ) );
			assertTrue( ExitFrame.contains( testPass ) );
			_async = addAsync( remAsync, 1000 );
		}
		
		private function remAsync( e: Event = null ): void {
			_shape.removeEventListener( "exitFrame", _async );
		}
		
		private function testPass() : void {
			if( !_executed ) {
				_executed = true;
				assertTrue( ExitFrame.remove( testPass ) );
				assertFalse( ExitFrame.remove( testPass ) );
				assertFalse( ExitFrame.contains( testPass ) );
				_shape.addEventListener( "exitFrame", _async );
			} else {
				ExitFrame.remove( testPass );
				fail( "Testpass should have been triggered just once." );
			}
		}
	}
}
