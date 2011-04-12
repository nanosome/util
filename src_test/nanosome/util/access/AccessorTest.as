package nanosome.util.access {
	import flexunit.framework.TestCase;

	import nanosome.util.ChangedPropertyNode;
	import nanosome.util.pool.InstancePool;
	import nanosome.util.pool.POOL_STORAGE;

	import flash.utils.Dictionary;

	

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class AccessorTest extends TestCase {
		
		private static const changePool: InstancePool = POOL_STORAGE.getOrCreate( ChangedPropertyNode );

		public function testAccess(): void {
			var facade: Accessor = accessFor( null );
			assertNotNull( facade );
			facade = accessFor( {} );
			assertEquals( facade, accessFor( {} ) );
			assertEquals( "Facades returned for a class have to match the facade for an instance",
						  facade, accessFor( Object ) );
		}
		
		public function testInternal(): void {
			var intern: InternalClass = new InternalClass();
			var facade: Accessor = accessFor( intern );
			assertFalse( accessFor( null ) == facade );
			
			assertTrue( "Allowed to set content to proper type", facade.write( intern, qname( "content" ), 1 ) );
			assertFalse( "Not allowed to set the content to wrong type", facade.write( intern, qname( "content" ), {} ) );
			assertTrue( "Allowed to set primitive types even without proper type", facade.write( intern, qname( "content" ), "1.0" ) );
			assertFalse( "Not allowed to set just any variable", facade.write( intern, qname( "content" ), "a" ) );
			assertTrue( "Allowed to set content to proper type", facade.write( intern, qname( sample + "::content3" ), 1 ) );
			assertTrue( "Allowed to set content to proper type", facade.write( intern, qname( sample + "::content3" ), 2 ) );
			assertEquals( intern.sample::content3, 2 );
			
			assertObjectEquals( {
					content: 1,
					content2: 0,
					"nanosome.util::content3": 2
				}, 
				facade.readAll( intern )
			);
			assertObjectEquals( {
					c1: 1,
					c2: 0,
					c3: 2
				},
				facade.readMapped( intern, {
					content: "c1",
					content2: "c2",
					"nanosome.util::content3": "c3"
				})
			);
			
			var changes1: Object = {
				a1: "hello",
				content: 2,
				content1: 7,
				content2: 4,
				"nanosome.util::content3": 6,
				content3: 7
			};
			
			var failedChanges: Array = [];
			for( var i: String in changes1 ) if( i == "content3" || i == "content1" || i == "a1" ) failedChanges.push( qname( i ) );
			
			assertObjectEquals( failedChanges, facade.writeAll( intern, changes1 ) );
			assertEquals( 2, intern.content );
			assertEquals( 4, intern.content2 );
			assertEquals( 6, intern.sample::content3 );
			assertObjectEquals( failedChanges, facade.writeAllByNodes( intern, getChangedNode( changes1, {
				a1: "froop",
				content: 12,
				content1: 14,
				content2: 16,
				"nanosome.util::content3": 18,
				content3: 22
			} ) ) );
			assertEquals( 12, intern.content );
			assertEquals( 16, intern.content2 );
			assertEquals( 18, intern.sample::content3 );
			var storage: Object = {};
			var expChanges: Changes = new Changes();
			expChanges.oldValues[ "content" ] = undefined;
			expChanges.oldValues[ "content2" ] = undefined;
			expChanges.oldValues[ "nansome.util::content3" ] = undefined;
			expChanges.newValues[ "content" ] = 12;
			expChanges.newValues[ "content2" ] = 16;
			expChanges.newValues[ "nansome.util::content3" ] = 18;
			
			assertObjectEquals( expChanges, facade.updateStorage( intern, storage ) );
			assertObjectEquals( {
				content: 12,
				content2: 16,
				"nanosome.util::content3": 18
			}, storage );
		}
		
		public function testObject(): void {
			var obj: Object = {};
			var facade: Accessor = accessFor( obj );
			assertTrue( facade.write( obj, qname( "test" ), true ) );
			assertTrue( obj["test"] );
			assertTrue( facade.write( obj, qname( "test" ), null ) );
			assertNull( obj["test"] );
			
			var first: ChangedPropertyNode = changePool.getOrCreate();
			first.name = qname( "test" );
			first.oldValue = null;
			first.newValue = "a";
			
			var second: ChangedPropertyNode = changePool.getOrCreate();
			second.name = qname( "test2" );
			second.oldValue = null;
			second.newValue = "b";
			
			second.addTo( first );
			
			facade.writeAllByNodes( obj, first );
			
			assertEquals( obj["test"], "a" );
			assertEquals( obj["test2"], "b" );
			
			assertTrue( facade.hasReadableProperty( "test" ) );
			assertTrue( facade.hasWritableProperty( "test" ) );
			assertFalse( facade.isSendingChangeEvent( qname( "test" ) ) );
			
			assertObjectEquals( obj, facade.readAll( obj, null, true ) );
			assertFalse( obj === facade.readAll( obj, null, true ) );
		}
		
		public function testProxyBehaviour(): void {
			var proxy: ProxyClass = new ProxyClass();
			var accessor: Accessor = accessFor( ProxyClass );
			
			var originalArr: Array = [];
			
			proxy.bindable = originalArr;
			assertTrue( accessor.write( proxy, qname( "bindable" ), null ) );
			assertObjectEquals( {
				"bindable": null
			}, proxy.changedProperties );
			assertNotNull( proxy.bindable );
			
			var arr2: Array = [];
			assertTrue( accessor.write( proxy, qname( "bindable" ), arr2 ) );
			assertObjectEquals( {
				"bindable": arr2
			}, proxy.changedProperties );
			assertEquals( originalArr, proxy.bindable );
			
			assertFalse( accessor.write( proxy, qname( "not_valid" ), 123 ) );
		}
		
		public function testDynamicClass(): void {
			var dynamicInstance: DynamicClass = new DynamicClass( int.MAX_VALUE );
			var accessor: Accessor = accessFor( dynamicInstance );
			
			assertTrue( accessor.hasReadableProperty( "normal" ) );
			assertTrue( accessor.hasWritableProperty( "normal" ) );
			assertFalse( accessor.isSendingChangeEvent( qname( "normal" ) ) );
			
			assertTrue( accessor.hasReadableProperty( "internalClass" ) );
			assertTrue( accessor.hasWritableProperty( "internalClass" ) );
			assertFalse( accessor.isSendingChangeEvent( qname( "internalClass" ) ) );
			
			assertTrue( accessor.hasReadableProperty( "bindable" ) );
			assertTrue( accessor.hasWritableProperty( "bindable" ) );
			assertTrue( accessor.isSendingChangeEvent( qname( "bindable" ) ) );
			
			assertTrue( accessor.hasReadableProperty( "observable" ) );
			assertTrue( accessor.hasWritableProperty( "observable" ) );
			assertTrue( accessor.isSendingChangeEvent( qname( "observable" ) ) );
			
			assertTrue( accessor.hasReadableProperty( "anyproperty" ) );
			assertTrue( accessor.hasWritableProperty( "anyproperty" ) );
			assertFalse( accessor.isSendingChangeEvent( qname( "anyproperty" ) ) );
			
			var obj: Object = {};
			var arr: Array = [];
			var arr2: Array = [];
			dynamicInstance.normal = arr2;
			assertFalse( accessor.write( dynamicInstance, qname( "normal" ), obj ) );
			assertStrictlyEquals( arr2, dynamicInstance.normal );
			assertTrue( accessor.write( dynamicInstance, qname( "normal" ), arr ) );
			assertStrictlyEquals( arr, dynamicInstance.normal );
			
			dynamicInstance.bindable = arr2;
			assertFalse( accessor.write( dynamicInstance, qname( "bindable" ), obj ) );
			assertStrictlyEquals( arr2, dynamicInstance.bindable );
			assertTrue( accessor.write( dynamicInstance, qname( "bindable" ), arr ) );
			assertStrictlyEquals( arr, dynamicInstance.bindable );
			
			dynamicInstance.observable = arr2;
			assertFalse( accessor.write( dynamicInstance, qname( "observable" ), obj ) );
			assertStrictlyEquals( arr2, dynamicInstance.observable );
			assertTrue( accessor.write( dynamicInstance, qname( "observable" ), arr ) );
			assertStrictlyEquals( arr, dynamicInstance.observable );
			
			dynamicInstance["anyproperty"] = arr;
			assertTrue( accessor.write( dynamicInstance, qname( "anyproperty" ), obj ) );
			assertStrictlyEquals( obj, dynamicInstance["anyproperty"] );
			assertTrue( accessor.write( dynamicInstance, qname( "anyproperty" ), 1 ) );
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
			var facade: Accessor = accessFor( dynamicInstance );
			
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
			
			for( var name: * in properties ) {
				
				var node: ChangedPropertyNode = changePool.getOrCreate();
				node.name = qname( name );
				node.newValue = properties[ name ];
				former = node.addTo( former );
				
				if( !first ) first = node;
			}
			return first;
		}
	}
}
import nanosome.util.access.sample;

class InternalClass {
	public var content: int;
	public var content2: int;
	sample var content3: int;
}