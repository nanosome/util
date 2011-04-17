// @license@ 
package nanosome.util.access {
	import nanosome.util.ILockable;
	import nanosome.util.UID;
	import nanosome.util.access.property.DynamicPropertyReader;
	import nanosome.util.access.property.DynamicPropertyWriter;
	import nanosome.util.access.property.GetterPropertyReader;
	import nanosome.util.access.property.PrimitiveWriter;
	import nanosome.util.access.property.SetterPropertyWriter;
	import nanosome.util.access.property.TypedPropertyWriter;
	import nanosome.util.create;

	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	

	
	/**
	 * <code>Accessor</code> is a wrapper for every instance that allows to easily
	 * manipulate a generic class without taking care of details for this.
	 * 
	 * <p>One feature of <code>Accessor</code> is that it respects the
	 * <code>IPropertiesProxy</code> interface that similar to any other proxy
	 * will receive any property change.</p>
	 * 
	 * <p>Another advantage for using this tool is that its possible to restrict
	 * the objects beeing set to just <code>[Bindable]</code> or <code>[Observable]</code>
	 * properties.</p>
	 * 
	 * <p><code>[Observable]</code> elements are properties that have as metadata
	 * 'Observable' written. In order to compile your code properly you have to add
	 * <code>-compiler.keep-as3-metadata Observable</code> to your <code>mxmlc</code>
	 * or <code>compc</code> arguments.</p>
	 * 
	 * <p>It also takes care that no unnecessary mistakes are beeing done while
	 * accessing the properties with values that don't match the contents of the
	 * target instance. (This is not taken care of properly if you just apply
	 * changes manually)</p>
	 * 
	 * <p>Furthermore changing a list of properties with <code>writeAll</code> or
	 * <code>writeAllByNodes</code> will make use of the <code>ILockable</code>
	 * interface.</p>
	 * 
	 * @example <listening version="3.0">
	 *   accessFor( {} ).write( {}, "test", 1 ); // returns true because the object is dynamic
	 * </listening>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see ISetterProxy
	 * @see IGetterProxy
	 * @see nanosome.util.ILockable
	 */
	public final class Accessor extends UID {
		
		/**
		 * Cached qualified name of the ILockable class.
		 * 
		 * @see ILockable
		 */
		protected static const ILOCKABLE: String = getQualifiedClassName( ILockable );
		
		/**
		 * Cached qualified name of the IPropertiesSetterProxy class.
		 * 
		 * @see ISetterProxy
		 */
		protected static const IPROPERTIES_SETTER_PROXY: String = getQualifiedClassName( ISetterProxy );
		
		/**
		 * Cached qualified name of the IPropertiesGetterProxy class.
		 * 
		 * @see IGetterProxy
		 */
		protected static const IPROPERTIES_GETTER_PROXY: String = getQualifiedClassName( IGetterProxy );
		
		/**
		 * Cached qualified name of the IEventDispatcher class to waste less 
		 * performance for the indentification of eventdispatcher instances.
		 * 
		 * @see IEventDispatcher
		 */
		protected static const IEVENT_DISPATCHER: String = getQualifiedClassName( IEventDispatcher );
		
		
		// Lookup for the types that are to be concidered simple types
		private static const SIMPLE_TYPE : Dictionary = new Dictionary();
		{
			SIMPLE_TYPE[ int ] = true;
			SIMPLE_TYPE[ uint ] = true;
			SIMPLE_TYPE[ Number ] = true;
			SIMPLE_TYPE[ Boolean ] = true;
			SIMPLE_TYPE[ String ] = true;
		}
		
		// Stores the property informations
		private var _propertyLookup: Object /* String -> PropertyAccess */;
		
		// Lists all readable properties of the class
		private var _normalReadable: Array /* QName */;
		
		// List of readables that send out an event
		private var _sendingEventReadable: Array /* QName */;
		
		private var _readWriteable: Array /* PropertyAccess */;
		
		// Flag if the target is dynamic (can contain additional, not-specified properties)
		private var _isDynamic: Boolean = true;
		
		// Flag if the target implements ILockable
		private var _isLockable: Boolean = false;
		
		// Flag if the target is basic object
		private var _isObject : Boolean;
		
		// Flag if the target's class can not be evaluated (null)
		private var _isAnnonymous : Boolean;
		
		// Flag if the target implements ISetterProxy
		private var _isSetterProxy: Boolean;
		
		// Flag if the target implements IGetterProxy
		private var _isGetterProxy: Boolean;
		
		private var _hasBindable: Boolean;
		private var _hasObservable: Boolean;
		
		
		/**
		 * Constructs a new <code>Modifier</code> instance.
		 * 
		 * @param typeName name of the type that this modifier should apply to
		 *        <code>null</code> will be treatened as "unaccessable".
		 */
		public function Accessor( typeName: String, object: * ) {
			super();
			_isObject = (typeName == "Object");
			_isAnnonymous = !typeName;
			
			// Create lookup tables if they can be created
			if( !_isAnnonymous && !_isObject ) {
				
				var xml: XML;
				
				// This might throw a exception which is catched in the static
				// .forObject method.
				if( object is Class ) {
					try {
						object = create( object );
					} catch( e: Error ) {
						trace( "!!! Warning: '" + typeName + "' can not be properly "
								+ "analyzed, accessFor/Accessor can become slow. "
								+ "Error while instantiation: \n" + e );
					}
				}
				xml = describeType( object );
				
				var interfaces: XMLList = xml["factory"]["implementsInterface"]
										+ xml["implementsInterface"];
				var variables: XMLList = xml["factory"]["variable"] + xml["variable"];
				
				_isSetterProxy = interfaces.( @type == IPROPERTIES_SETTER_PROXY ).length() > 0;
				_isGetterProxy = interfaces.( @type == IPROPERTIES_GETTER_PROXY ).length() > 0;
				_isDynamic = xml["@isDynamic"] == "true";
				_isAnnonymous = false;
				
				var accessors: XMLList = xml["factory"]["accessor"] + xml["accessor"];
				var fullName: String;
				var qName: QName;
				var access: PropertyAccess;
				var type: *;
				
				// Collect all information about writable properties
				var writeAbles: XMLList =
					accessors.( @access == "readwrite" || @access == "writeonly" )
					+ variables;
				
				for each( var writeAble: XML in writeAbles ) {
					access = new PropertyAccess();
					
					fullName = writeAble.@name.toString();
					if( writeAble.@uri.length() > 0 ) {
						fullName = writeAble.@uri + "::" + fullName;
					}
					
					( _propertyLookup || ( _propertyLookup = {} ) )[ fullName ] = access;
					
					try {
						type = getDefinitionByName( writeAble.@type );
					} catch( e: Error ) {}
					
					access.type = type;
					access.qName = qname( fullName );
					access.writer = 
						_isSetterProxy ? 
							new SetterPropertyWriter( access.qName )
							: type ? (
								SIMPLE_TYPE[ type ] ?
									new PrimitiveWriter( access.qName, type ) :
									new TypedPropertyWriter( access.qName, type )
								):
								new DynamicPropertyWriter( access.qName );
				}
				
				if( !_propertyLookup ) _propertyLookup = {};
				
				// Collect all information about the readable properties
				var readAbles: XMLList =
					accessors.( @access=="readwrite" || @access=="readonly" )
					+ variables;
				
				for each( var readAble: XML in readAbles ) {
					fullName = readAble.@name.toString();
					if( readAble.@uri.length() > 0 ) {
						fullName = readAble.@uri + "::" + fullName;
					}
					qName = qname( fullName );
					
					access = _propertyLookup ? _propertyLookup[ fullName ] : null;
					if( !access ) {
						access = new PropertyAccess();
					} else {
						( _readWriteable || ( _readWriteable = [] ) ).push( access );
					}
					
					( _propertyLookup || ( _propertyLookup = {} ) )[ fullName ] = access;
					
					var bindableXML: XMLList = readAble["metadata"].( @name=="Bindable" );
					var bindable: Boolean = false;
					var event: String = null;
					if( bindableXML.length() > 0 ) {
						event = "propertyChange";
						var eventXML: XMLList =
							bindableXML["arg"].( @key=="event" );
						if( eventXML.length() > 0 ) {
							event = eventXML.@value;
						}
						// Someone can write "propertyChange" into 
						if( event == "propertyChange" ) {
							bindable = true;
							_hasBindable = true;
						}
					}
						
					var observable: Boolean =
						readAble["metadata"].( @name=="Observable" ).length() != 0;
					if( observable ) {
						_hasObservable = true;
					}
					
					if( bindable || observable || event ) {
						( _sendingEventReadable || ( _sendingEventReadable = [] ) ).push( access );
					} else {
						( _normalReadable || ( _normalReadable = [] ) ).push( access );
					}
					
					try {
						type = getDefinitionByName( writeAble.@type );
					} catch( e: Error ) {}
					
					access.type = type;
					access.qName = qName;
					access.reader = 
						_isGetterProxy ? 
							new GetterPropertyReader( qName, observable, bindable, event )
						:
							new DynamicPropertyReader( qName, observable, bindable, event );
				}
				_isLockable = interfaces.(@type==ILOCKABLE).length() > 0;
			}
		}
		
		public function prop( name: * ): PropertyAccess {
			if( !( name is QName ) ) {
				name = qname( name );
			}
			if( !name ) {
				return null;
			}
			const fullName: String = name.toString();
			var access: PropertyAccess = _propertyLookup ? _propertyLookup[ fullName ] : null;
			if( !access && _isDynamic ) {
				access = new PropertyAccess();
				access.qName = name;
				if( _isGetterProxy ) {
					access.reader = new GetterPropertyReader( name, false, false, null );
				} else if( _isDynamic ){
					access.reader = new DynamicPropertyReader( name, false, false, null );
				}
				if( _isSetterProxy ) {
					access.writer = new SetterPropertyWriter( name );
				} else if( _isDynamic ) {
					access.writer = new DynamicPropertyWriter( name );
				}
				( _propertyLookup || ( _propertyLookup = {} ) )[ fullName ] = access;
			}
			return access;
		}
		
		public function get isLockable(): Boolean {
			return _isLockable;
		}
		
		public function get nonEventSendingProperties(): Array {
			return _normalReadable;
		}
		
		public function get eventSendingReadableProperties(): Array {
			return _sendingEventReadable;
		}
		
		public function get readAndWritableProperties(): Array {
			return _readWriteable;
		}
		
		public function get hasBindable(): Boolean {
			return _hasBindable;
		}
		
		public function get hasObservable(): Boolean {
			return _hasObservable;
		}
		
		public function get isDynamic(): Boolean {
			return _isDynamic;
		}
	}
}
