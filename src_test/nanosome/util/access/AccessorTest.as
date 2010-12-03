package nanosome.util.access {
	import org.flexunit.asserts.assertStrictlyEquals;
	import nanosome.util.ChangedPropertyNode;
	import flexunit.framework.TestCase;

	import nanosome.util.pool.InstancePool;
	import nanosome.util.pool.POOL_STORAGE;

	

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class AccessorTest extends TestCase {
		
		private static const changePool: InstancePool = POOL_STORAGE.getOrCreate( ChangedPropertyNode );

		public function testAccess(): void {
			var facade: Accessor = Accessor.forObject( null );
			assertNotNull( facade );
			facade = Accessor.forObject( {} );
			assertEquals( facade, Accessor.forObject( {} ) );
			assertEquals( "Facades returned for a class have to match the facade for an instance",
						  facade, Accessor.forObject( Object ) );
		}
		
		public function testInternal(): void {
			var intern: InternalClass = new InternalClass();
			var facade: Accessor = Accessor.forObject( intern );
			assertFalse( Accessor.forObject( null ) == facade );
			
			assertTrue( "Allowed to set content to proper type", facade.write( intern, "content", 1 ) );
			assertFalse( "Not allowed to set the content to wrong type", facade.write( intern, "content", {} ) );
			assertTrue( "Allowed to set primitive types even without proper type", facade.write( intern, "content", "1.0" ) );
			assertFalse( "Not allowed to set just any variable", facade.write( intern, "test", "a" ) );
		}
		
		public function testObject(): void {
			var obj: Object = {};
			var facade: Accessor = Accessor.forObject( obj );
			assertTrue( facade.write( obj, "test", true ) );
			assertTrue( obj["test"] );
			assertTrue( facade.write( obj, "test", null ) );
			assertNull( obj["test"] );
			
			var first: ChangedPropertyNode = changePool.getOrCreate();
			first.name = "test";
			first.oldValue = null;
			first.newValue = "a";
			
			var second: ChangedPropertyNode = changePool.getOrCreate();
			second.name = "test2";
			second.oldValue = null;
			second.newValue = "b";
			
			second.addTo( first );
			
			facade.writeAllByNodes( obj, first );
			
			assertEquals( obj["test"], "a" );
			assertEquals( obj["test2"], "b" );
			
			assertTrue( facade.hasReadableProperty( "test" ) );
			assertTrue( facade.hasWritableProperty( "test" ) );
			assertFalse( facade.isSendingChangeEvent( "test" ) );
			
			assertObjectEquals( obj, facade.readAll( obj, null, true ) );
			assertFalse( obj === facade.readAll( obj, null, true ) );
		}
		
		public function testProxyBehaviour(): void {
			var proxy: ProxyClass = new ProxyClass();
			var accessor: Accessor = accessFor( ProxyClass );
			
			var originalArr: Array = [];
			
			proxy.bindable = originalArr;
			assertTrue( accessor.write( proxy, "bindable", null ) );
			assertObjectEquals( {
				"bindable": null
			}, proxy.changedProperties );
			assertNotNull( proxy.bindable );
			
			var arr2: Array = [];
			assertTrue( accessor.write( proxy, "bindable", arr2 ) );
			assertObjectEquals( {
				"bindable": arr2
			}, proxy.changedProperties );
			assertEquals( originalArr, proxy.bindable );
			
			assertFalse( accessor.write( proxy, "not_valid", 123 ) );
		}
		
		public function testDynamicClass(): void {
			var dynamicInstance: DynamicClass = new DynamicClass( int.MAX_VALUE );
			var accessor: Accessor = Accessor.forObject( dynamicInstance );
			
			assertTrue( accessor.hasReadableProperty( "normal" ) );
			assertTrue( accessor.hasWritableProperty( "normal" ) );
			assertFalse( accessor.isSendingChangeEvent( "normal" ) );
			
			assertTrue( accessor.hasReadableProperty( "internalClass" ) );
			assertTrue( accessor.hasWritableProperty( "internalClass" ) );
			assertFalse( accessor.isSendingChangeEvent( "internalClass" ) );
			
			assertTrue( accessor.hasReadableProperty( "bindable" ) );
			assertTrue( accessor.hasWritableProperty( "bindable" ) );
			assertTrue( accessor.isSendingChangeEvent( "bindable" ) );
			
			assertTrue( accessor.hasReadableProperty( "observable" ) );
			assertTrue( accessor.hasWritableProperty( "observable" ) );
			assertTrue( accessor.isSendingChangeEvent( "observable" ) );
			
			assertTrue( accessor.hasReadableProperty( "anyproperty" ) );
			assertTrue( accessor.hasWritableProperty( "anyproperty" ) );
			assertFalse( accessor.isSendingChangeEvent( "anyproperty" ) );
			
			var obj: Object = {};
			var arr: Array = [];
			var arr2: Array = [];
			dynamicInstance.normal = arr2;
			assertFalse( accessor.write( dynamicInstance, "normal", obj ) );
			assertStrictlyEquals( arr2, dynamicInstance.normal );
			assertTrue( accessor.write( dynamicInstance, "normal", arr ) );
			assertStrictlyEquals( arr, dynamicInstance.normal );
			
			dynamicInstance.bindable = arr2;
			assertFalse( accessor.write( dynamicInstance, "bindable", obj ) );
			assertStrictlyEquals( arr2, dynamicInstance.bindable );
			assertTrue( accessor.write( dynamicInstance, "bindable", arr ) );
			assertStrictlyEquals( arr, dynamicInstance.bindable );
			
			dynamicInstance.observable = arr2;
			assertFalse( accessor.write( dynamicInstance, "observable", obj ) );
			assertStrictlyEquals( arr2, dynamicInstance.observable );
			assertTrue( accessor.write( dynamicInstance, "observable", arr ) );
			assertStrictlyEquals( arr, dynamicInstance.observable );
			
			dynamicInstance["anyproperty"] = arr;
			assertTrue( accessor.write( dynamicInstance, "anyproperty", obj ) );
			assertStrictlyEquals( obj, dynamicInstance["anyproperty"] );
			assertTrue( accessor.write( dynamicInstance, "anyproperty", 1 ) );
			assertStrictlyEquals( 1, dynamicInstance["anyproperty"]);
			
			assertObjectEquals( {
					wasLocked: false,
					wasUnlocked: false,
					locked: false,
					internalClass: null,
					normal: arr,
					bindable: arr,
					observable: arr,
					anyproperty: 1,
					uid: int.MAX_VALUE
				}, accessor.readAll( dynamicInstance, null, true )
			);
			
			assertObjectEquals( {
					bindable: arr,
					internalClass: null,
					locked: false,
					normal: arr,
					observable: arr,
					uid: int.MAX_VALUE,
					wasLocked: false,
					wasUnlocked: false
				}, accessor.readAll( dynamicInstance, null, false )
			);
		}
		
		public function testWriteAllByNodes(): void {
			writeAll( true );
		}
		
		public function testWriteAll(): void {
			writeAll( false );
		}
		
		private function writeAll( useList: Boolean ): void {
			var dynamicInstance: DynamicClass = new DynamicClass( int.MAX_VALUE-1 );
			var facade: Accessor = Accessor.forObject( dynamicInstance );
			
			var obj: Object = {};
			var arr: Array = [];
			var node: ChangedPropertyNode;
			
			var properties: Object = {
				normal: arr,
				observable: obj,
				bindable: arr,
				anyproperty: null
			};
			
			if( useList ) {
				node = createNodes( properties );
				facade.writeAllByNodes( dynamicInstance, node );
				node.returnAll();
			} else {
				facade.writeAll( dynamicInstance, properties );
			}
			
			assertTrue( dynamicInstance.wasLocked );
			assertTrue( dynamicInstance.wasUnlocked );
			assertFalse( dynamicInstance.locked );
			
			assertEquals( arr, dynamicInstance.normal );
			assertEquals( arr, dynamicInstance.bindable );
			assertNull( dynamicInstance.observable );
			assertStrictlyEquals( dynamicInstance["anyproperty"], null );
			
			dynamicInstance.lock();
			
			properties = {
				normal: null,
				observable: null
			};
			
			if( useList ) {
				node = createNodes( properties );
				facade.writeAllByNodes( dynamicInstance, node );
				node.returnAll();
			} else {
				facade.writeAll( dynamicInstance, properties );
			}
			
			assertTrue( dynamicInstance.locked );
			assertNull( "Using list? " + useList, dynamicInstance.normal );
		}
		
		private function createNodes( properties: Object ): ChangedPropertyNode {
			
			var first: ChangedPropertyNode;
			var former: ChangedPropertyNode;
			
			for( var name: String in properties ) {
				
				var node: ChangedPropertyNode = changePool.getOrCreate();
				node.name = name;
				node.newValue = properties[ name ];
				former = node.addTo( former );
				
				if( !first ) first = node;
			}
			return first;
		}
	}
}

class InternalClass {
	public var content: int;
	public var content2: int;
}