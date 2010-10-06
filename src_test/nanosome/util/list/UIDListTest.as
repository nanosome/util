package nanosome.util.list {
	import flexunit.framework.TestCase;

	import nanosome.util.UID;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class UIDListTest extends TestCase {
		
		private var _list : ExampleUIDList;
		private var _a : UID;
		private var _b : UID;
		private var _c : UID;
		private var _d : UID;
		
		override public function setUp() : void {
			_list = new ExampleUIDList();
			_a = new UID();
			_b = new UID();
			_c = new UID();
			_d = new UID();
		}
		
		public function testAddRemoveInIteration(): void {
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), null );
			_list.add( _a );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), _a );
			_list.add( _b );
			assertEquals( _list.iterate(), _b );
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), _b );
			_list.remove( _b );
			assertEquals( _list.iterate(), null );
			_list.add( _b );
			_list.add( _c );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), _b );
			assertEquals( _list.iterate(), _c );
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), _a );
			_list.remove( _b );
			assertEquals( _list.iterate(), _c );
			assertEquals( _list.iterate(), null );
			
			_list.add( _c );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), _c );
			assertEquals( _list.iterate(), null );
		}
		
		public function testNormalAddRemoveFunctionality(): void {
			assertTrue( _list.empty );
			assertTrue( _list.add( _a ) );
			assertFalse( _list.empty );
			assertTrue( _list.contains( _a ) );
			assertFalse( _list.add( _a ) );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), null );
			assertFalse( _list.empty );
			assertTrue( _list.add( _b ) );
			assertTrue( _list.size, 2 );
			assertFalse( _list.add( _b ) );
			assertTrue( _list.size, 2 );
			assertTrue( _list.contains( _b ) );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), _b );
			assertEquals( _list.iterate(), null );
			assertTrue( _list.remove( _b ) );
			assertFalse( _list.remove( _b ) );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), null );
			assertTrue( _list.remove( _a ) );
			assertEquals( _list.size, 0 );
			assertFalse( _list.contains( _a ) );
			assertFalse( _list.remove( _a ) );
			assertFalse( _list.contains( _a ) );
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), null);
		}
		
		public function testWeakOperations(): void {
			assertTrue( _list.empty );
			assertFalse( _list.isWeakAdded( _a ) );
			
			assertTrue( _list.add( _a, true ) );
			assertFalse( _list.empty );
			assertEquals( 1, _list.size );
			assertTrue( _list.isWeakAdded( _a ) );
			assertTrue( _list.contains( _a ) );
			
			assertTrue( _list.remove( _a ) );
			assertTrue( _list.empty );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.contains( _a ) );
			assertEquals( 0, _list.size );
			
			assertTrue( _list.add( _a, true ) );
			assertFalse( _list.add( _a, true ) );
			assertTrue( _list.add( _a, false ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertTrue( _list.contains( _a ) );
			
			assertTrue( _list.add( _b, true ) );
			assertFalse( _list.empty );
			assertTrue( _list.isWeakAdded( _b ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertTrue( _list.contains( _b ) );
			assertTrue( _list.contains( _a ) );
			assertEquals( 2, _list.size );
			
			assertTrue( _list.remove( _a ) );
			assertFalse( _list.empty );
			assertTrue( _list.isWeakAdded( _b ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertTrue( _list.contains( _b ) );
			assertFalse( _list.contains( _a ) );
			assertEquals( 1, _list.size );
			
			assertTrue( _list.add( _c, true ) );
			assertEquals( 2, _list.size );
			assertTrue( _list.isWeakAdded( _b ) );
			assertTrue( _list.isWeakAdded( _c ) );
			assertFalse( _list.empty );
			
			assertTrue( _list.add( _c, false ) );
			assertEquals( 2, _list.size );
			assertFalse( _list.isWeakAdded( _c ) );
			assertTrue( _list.isWeakAdded( _b ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.empty );
		}
		
		public function testWhileIteration(): void {
			// Assure that in a locked state works 
			// adding like expected
			_list.pseudoIterate();
			assertTrue( _list.add( _a ) );
			assertEquals( 1, _list.size );
			assertFalse( _list.empty );
			assertTrue( _list.contains( _a ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.add( _a ) );
			_list.pseudoStopIterate();
			
			// Assure that after unlocking the values are properly in the list
			assertEquals( 1, _list.size );
			assertFalse( _list.empty );
			assertFalse( _list.isWeakAdded( _a ) );
			assertTrue( _list.contains( _a ) );
			
			// Assure that locking and adding works right after each other
			_list.pseudoIterate();
			assertFalse( _list.add( _a ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertTrue( _list.add( _a, true ) );
			assertTrue( _list.isWeakAdded( _a ) );
			assertFalse( _list.add( _a, true ) );
			assertTrue( _list.isWeakAdded( _a ) );
			assertTrue( _list.add( _a ) );
			assertFalse( _list.isWeakAdded( _a ) );
			_list.pseudoStopIterate();
			
			_list.add( _b );
			assertFalse( _list.isWeakAdded( _b ) );
			assertFalse( _list.isWeakAdded( _a ) );
			
			// Assure that during lock state, removing works
			_list.pseudoIterate();
			assertTrue( _list.remove( _a ) );
			assertEquals( 1, _list.size );
			assertFalse( _list.empty );
			assertFalse( _list.contains( _a ) );
			assertFalse( _list.remove( _a ) );
			_list.pseudoStopIterate();
			
			// Assure mixed-ins of lock state, weak reference changes work properly
			_list.pseudoIterate();
			assertTrue( _list.add( _c, true ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.isWeakAdded( _b ) );
			assertTrue( _list.isWeakAdded( _c ) );
			assertTrue( _list.remove( _b ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.isWeakAdded( _b ) );
			assertTrue( _list.isWeakAdded( _c ) );
			assertEquals( 1, _list.size );
			assertTrue( _list.add( _c, false ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.isWeakAdded( _b ) );
			assertFalse( _list.isWeakAdded( _c ) );
			assertEquals( 1, _list.size );
			_list.pseudoStopIterate();
			
			_list.pseudoIterate();
			_list.add( _a, true );
			assertTrue( _list.isWeakAdded( _a ) );
			_list.pseudoStopIterate();
			
			assertTrue( _list.isWeakAdded( _a ) );
			_list.remove( _a );
			
			assertTrue( _list.add( _c, true ) );
			assertTrue( _list.isWeakAdded( _c ) );
			
			// Assure locking really works for iteration
			_list.add( _b );
			_list.pseudoIterate();
			assertObjectEquals( _list.allWeak, [ _c ] );
			assertObjectEquals( _list.allNormal, [ _b ] );
			_list.remove( _c );
			assertObjectEquals( _list.allWeak, [] );
			_list.add( _c, true );
			assertObjectEquals( _list.allWeak, [] );
			_list.remove( _b );
			assertObjectEquals( _list.allNormal, [] );
			_list.add( _b );
			assertObjectEquals( _list.allNormal, [] );
			_list.pseudoStopIterate();
			
			assertObjectEquals( _list.allWeak, [ _c ] );
			assertObjectEquals( _list.allNormal, [ _b ] );
		}
	}
}
