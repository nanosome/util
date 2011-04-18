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
			
			assertTrue( "Allowed to set content to proper type", facade.prop( "content" ).writer.write( intern, 1 ) );
			assertFalse( "Not allowed to set the content to wrong type", facade.prop( "content" ).writer.write( intern, {} ) );
			assertTrue( "Allowed to set primitive types even without proper type", facade.prop( "content" ).writer.write( intern, "1.0" ) );
			assertFalse( "Not allowed to set just any variable", facade.prop( "content" ).writer.write( intern, "a" ) );
			assertTrue( "Allowed to set content to proper type", facade.prop( sample + "::content3" ).writer.write( intern, 1 ) );
			assertTrue( "Allowed to set content to proper type", facade.prop( sample + "::content3" ).writer.write( intern, 2 ) );
			assertEquals( intern.sample::content3, 2 );
			
			assertObjectEquals( {
					content: 0,
					content2: 0,
					"nanosome.util::content3": 2
				}, 
				readAll( intern, null, true, facade )
			);
			assertObjectEquals( {
					c1: 0,
					c2: 0,
					c3: 2
				},
				readMapped( intern, toPropMap({
					content: "c1",
					content2: "c2",
					"nanosome.util::content3": "c3"
				}, facade ) )
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
			
			assertObjectEquals( failedChanges, writeAll( intern, changes1, facade ) );
			assertEquals( 2, intern.content );
			assertEquals( 4, intern.content2 );
			assertEquals( 6, intern.sample::content3 );
			assertObjectEquals( failedChanges, writeAllByNodes( intern, getChangedNode( changes1, {
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
			
			assertObjectEquals( expChanges, refreshStorage( intern, storage, null, facade ) );
			assertObjectEquals( {
				content: 12,
				content2: 16,
				"nanosome.util::content3": 18
			}, storage );
		}

		private function toPropMap( object: Object, sourceFacade: Accessor, targetFacade: Accessor = null ): Dictionary {
			if( !targetFacade ) {
				targetFacade = accessFor( Object );
			}
			var result: Dictionary = new Dictionary();
			for( var sourceName: String in object ) {
				result[ sourceFacade.prop( sourceName ) ] = targetFacade.prop( object[ sourceName ] ); 
			}
			return result;
		}
		
		public function testObject(): void {
			var obj: Object = {};
			var facade: Accessor = accessFor( obj );
			var test: PropertyAccess = facade.prop( "test" ); 
			assertTrue( test.writer.write( obj, true ) );
			assertTrue( obj["test"] );
			assertTrue( test.writer.write( obj, null ) );
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
			
			writeAllByNodes( obj, first );
			
			assertEquals( obj["test"], "a" );
			assertEquals( obj["test2"], "b" );
			
			assertObjectEquals( obj, readAll( obj, null, true, facade ) );
			assertFalse( obj === readAll( obj, null, true, facade ) );
		}
		
		public function testProxyBehaviour(): void {
			var proxy: ProxyClass = new ProxyClass();
			var accessor: Accessor = accessFor( ProxyClass );
			
			var originalArr: Array = [];
			
			proxy.bindable = originalArr;
			assertTrue( accessor.prop( "bindable" ).writer.write( proxy, null ) );
			assertObjectEquals( {
				"bindable": null
			}, proxy.changedProperties );
			assertNotNull( proxy.bindable );
			
			var arr2: Array = [];
			assertTrue(  accessor.prop( "bindable" ).writer.write( proxy, arr2 ) );
			assertObjectEquals( {
				"bindable": arr2
			}, proxy.changedProperties );
			assertEquals( originalArr, proxy.bindable );
			
			assertNull( accessor.prop( "not_valid" ) );
		}
		
		public function testDynamicClass(): void {
			var dynamicInstance: DynamicClass = new DynamicClass( int.MAX_VALUE );
			var accessor: Accessor = accessFor( dynamicInstance );
			
			
			var obj: Object = {};
			var arr: Array = [];
			var arr2: Array = [];
			dynamicInstance.normal = arr2;
			
			var prop: PropertyAccess = accessor.prop( "normal" );
			assertFalse( prop.reader.bindable );
			assertFalse( prop.reader.observable );
			assertNull( prop.reader.sendingEvent );
			
			assertFalse( prop.writer.write( dynamicInstance, obj ) );
			assertStrictlyEquals( arr2, dynamicInstance.normal );
			
			assertTrue( prop.writer.write( dynamicInstance, arr ) );
			assertStrictlyEquals( arr, dynamicInstance.normal );
			
			
			prop = accessor.prop( "internalClass" );
			assertFalse( prop.reader.bindable );
			assertFalse( prop.reader.observable );
			assertNull( prop.reader.sendingEvent );
			
			/*
			assertFalse( prop.writer.write( dynamicInstance, obj ) );
			assertStrictlyEquals( arr2, dynamicInstance.normal );
			
			assertTrue( prop.writer.write( dynamicInstance, arr ) );
			assertStrictlyEquals( arr, dynamicInstance.normal );
			 */
			
			prop = accessor.prop( "bindable" );
			assertTrue( prop.reader.bindable );
			assertFalse( prop.reader.observable );
			assertEquals( "propertyChange", prop.reader.sendingEvent );
			
			assertFalse( prop.writer.write( dynamicInstance, obj ) );
			assertNull( dynamicInstance.bindable );
			
			assertTrue( prop.writer.write( dynamicInstance, arr ) );
			assertStrictlyEquals( arr, dynamicInstance.bindable );
			
			
			
			prop = accessor.prop( "observable" );
			assertFalse( prop.reader.bindable );
			assertTrue( prop.reader.observable );
			assertNull( prop.reader.sendingEvent );
			
			assertFalse( prop.writer.write( dynamicInstance, obj ) );
			assertNull( dynamicInstance.observable );
			
			assertTrue( prop.writer.write( dynamicInstance, arr ) );
			assertStrictlyEquals( arr, dynamicInstance.observable );
			
			
			
			prop = accessor.prop( "anyproperty" );
			assertFalse( prop.reader.bindable );
			assertFalse( prop.reader.observable );
			assertNull( prop.reader.sendingEvent );
			
			assertTrue( prop.writer.write( dynamicInstance, obj ) );
			assertStrictlyEquals( obj, dynamicInstance["anyproperty"] );
			
			assertTrue( prop.writer.write( dynamicInstance, 1 ) );
			assertStrictlyEquals( 1, dynamicInstance["anyproperty"] );
			
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
				}, readAll( dynamicInstance, null, true, accessor )
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
				}, readAll( dynamicInstance, null, false, accessor )
			);
		}
		
		public function testCustomEvents(): void {
			var test: BindableClass = new BindableClass();
			var facade: Accessor = accessFor( test );
			
			var propAny: PropertyAccess = facade.prop( "any" );
			assertFalse( "Bindables with custom events are not 'regularily' bindable.", propAny.reader.bindable );
			assertEquals( "The event has to match 'someEvent' like described in the event.", "someEvent", propAny.reader.sendingEvent );
			
			var propAnyEvent: PropertyAccess = facade.prop( "anyEvent" );
			assertFalse( "Bindables with custom events are not 'regularily' bindable.", propAnyEvent.reader.bindable );
			assertEquals( "The event has to match 'someEvent' like described in the event.", "someEvent", propAnyEvent.reader.sendingEvent );
			
			var propContent4: PropertyAccess = facade.prop( sample + "::content4" );
			assertFalse( "Bindables with namespaces are not per se bindable...", propContent4.reader.bindable );
			assertEquals( "Since its not bindable it would be good to get the 'propertyChange' event.", "propertyChange", propContent4.reader.sendingEvent );
		}
		
		public function testWriteAllByNodes(): void {
			doWriteAll( true );
		}
		
		public function testWriteAll(): void {
			doWriteAll( false );
		}
		
		private function doWriteAll( useList: Boolean ): void {
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
				writeAllByNodes( dynamicInstance, node, null, facade );
				node.returnAll();
			} else {
				writeAll( dynamicInstance, properties, facade );
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
				writeAllByNodes( dynamicInstance, node, null, facade );
				node.returnAll();
			} else {
				writeAll( dynamicInstance, properties, facade );
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

class BindableClass {
	
	[Bindable]
	sample var content4: int;
	
	[Bindable("someEvent")]
	public var any: int;
	
	[Bindable(event="someEvent")]
	public var anyEvent: int;
}