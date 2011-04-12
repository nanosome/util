// @license@ 
package nanosome.util.access {
	import nanosome.util.ChangedPropertyNode;
	import nanosome.util.ILockable;
	import nanosome.util.UID;
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
		
		// Stores the properties which are writable
		private var _writableLookup: Object /* String -> Boolean */;
		
		// Stores the types to the writable properties
		private var _writableTypeLookup: Object /* String -> Class */;
		
		// Lists all readable properties of the class
		private var _normalReadable: Array /* QName */;
		
		// List of readables that send out an event
		private var _sendingEventReadable: Array /* QName */;
		
		private var _readWriteable: Array /* QName */;
		
		private var _readWriteableTypeLookup: Object /* String -> Class */;
		
		// Stores the properties that are readable
		private var _readableLookup: Object /* String -> Boolean */;
		
		private var _bindables: Object /* String -> Boolean */;
		
		private var _observables: Object /* String -> Boolean */;
		
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
						trace( "Warning: '" + typeName + "' can not be properly analyzed, accessFor/Accessor can become slow. Error while instantiation: \n" + e );
					}
				}
				xml = describeType( object );
				
				var interfaces: XMLList = xml.factory.implementsInterface + xml.implementsInterface;
				var variables: XMLList = xml.factory.variable + xml.variable;
				
				_isSetterProxy = interfaces.(@type==IPROPERTIES_SETTER_PROXY).length() > 0;
				_isGetterProxy = interfaces.(@type==IPROPERTIES_GETTER_PROXY).length() > 0;
				_isDynamic = xml["@isDynamic"] == "true" || ( _isSetterProxy && _isGetterProxy );
				_isAnnonymous = false;
				
				var accessors: XMLList = xml.factory.accessor + xml.accessor;
				var fullName: String;
				var qName: QName;
				
				// Save some time, if its a ISetterProxy, no lookup is required
				if( !_isSetterProxy ) {
					
					_writableLookup = {};
					_writableTypeLookup = {};
					
					// Collect all information about writable properties
					var writeAbles: XMLList = accessors.(@access=="readwrite"||@access=="writeonly") + variables;
					for each( var writeAble: XML in writeAbles ) {
						fullName = writeAble.@name.toString();
						if( writeAble.@uri.length() > 0 ) {
							fullName = writeAble.@uri + "::" + fullName;
						}
						_writableLookup[ fullName ] = true;
						try {
							_writableTypeLookup[ fullName ] = getDefinitionByName( writeAble.@type ) || Object;
						} catch( e: Error ) {
							// If the type is not accessible it't not possible to do a verification!
							_writableTypeLookup[ fullName ] = Object;
						}
					}
				}
				
				// Save some time, if its a IGetterProxy, no lookup is required
				if( !_isGetterProxy ) {
					
					_readableLookup = {};
					
					// Collect all information about the readable properties
					var readAbles: XMLList = accessors.(@access=="readwrite"||@access=="readonly") + variables;
					for each( var readAble: XML in readAbles ) {
						fullName = readAble.@name.toString();
						if( readAble.@uri.length() > 0 ) {
							fullName = readAble.@uri + "::" + fullName;
						}
						qName = qname( fullName );
						_readableLookup[ fullName ] = true;
						
						if( _writableLookup[ fullName ] ) {
							if( !_readWriteable ) {
								_readWriteable = [];
								_readWriteableTypeLookup = {};
							}
							_readWriteable.push( qName );
							try {
								_readWriteableTypeLookup[ fullName ] = getDefinitionByName( readAble.@type ) || Object;
							} catch( e: Error ) {
								// If the type is not accessible it't not possible to do a verification!
								_readWriteableTypeLookup[ fullName ] = Object;
							}
						}
						
						var bindable: Boolean = readAble.metadata.(@name=="Bindable").length() != 0;
						if( bindable )
							( _bindables || ( _bindables = {} ) )[ fullName ] = true;
							
						var observable: Boolean = readAble.metadata.(@name=="Observable").length() != 0;
						if( observable )
							( _observables || ( _observables = {} ) )[ fullName ] = true;
						
						// TODO: Implement a mechanism which tells the system to update certain properties
						// not on-enterframe but rather on some addEventListener event ... man, that would
						// be cool
						
						if( bindable || observable ) {
							( _sendingEventReadable || ( _sendingEventReadable = [] ) ).push( qName );
						} else {
							( _normalReadable || ( _normalReadable = [] ) ).push( qName );
						}
						
					}
				}
				_isLockable = interfaces.(@type==ILOCKABLE).length() > 0;
			}
		}
		
		/**
		 * Sets a target's property in a passed-in instance to a value.
		 * 
		 * <p>This method will check the passed-in value to its type if possible.
		 * else it will try/catch try to find out if the type matches.</p>
		 * 
		 * <p>If the class implements ISetterProxy, this method will be used
		 * instead of trying to set it manually.</p>
		 * 
		 * @param target Instance that should be written
		 * @param name Name of the property to be set, may contain a namespace seperated
		 *           with two colons
		 * @param value Value that the property should get
		 * @param ns Namespace of the variable to write
		 * @param fullName Name including the namespace (if not passed in it will be generated from the ns)
		 * @return <code>true</code> if it could have been set properly
		 * @see ISetterProxy
		 */
		public function write( target: *, name: QName, value: * ): Boolean {
			if( !name || !target ) {
				
				return false;
				
			} else {
				
				if( _isAnnonymous ) {
					
					try {
						target[name] = value;
						return target[name] == value;
					} catch( e: Error ){}
					return false;
					
				} else if( _isSetterProxy ) {
					
					return ISetterProxy( target ).write( name, value );
				
				} else {
					
					var type: Class;
					if( _writableTypeLookup ) {
						type = _writableTypeLookup[ name.toString() ];
					}
					
					if( type ) {
						// If the type can't be verified i.E. when the type was internal
						// then a try/catch is necessary.
						
						// Primitive type checking.
						if( type == String || type == int || type == uint || type == Boolean ) {
							var temp: *  = type( value );
							if( temp != value ) {
								try {
									target[ name ] = 0;
								} catch( e: Error ) {}
								return false;
							}
						} else if( !( value is type ) && value != null ) {
							return false;
						}
						try {
							target[ name ] = value;
							return true;
						} catch( e: Error ) {}
						return false;
						
					} else if( _isDynamic ) {
						
						try {
							target[name] = value;
							return target[name] == value;
						} catch( e: Error ){}
						return false;
						
					} else {
						return false;
					}
				}
			}
		}
		
		/**
		 * Writes all passed-in properties to the target
		 * 
		 * <p>This method call will automatically lock the target before setting
		 * the first property and unlock it afterwards (if it wasn't locked before).</p>
		 * 
		 * @param target target that should be modified.
		 * @param properties Object that maps property-names to values to be set
		 * @return list of nodes that couldn't be written, null if all could have
		 */
		public function writeAll( target: *, properties: Object ): Array {
			if( target && properties ) {
				var doUnlock: Boolean = false;
				if( _isLockable ) {
					const lockable: ILockable = ILockable( target );
					if( !lockable.locked ) {
						doUnlock = true;
						lockable.lock();
					}
				}
				
				var failed: Array = null;
				var i: int = 0;
				var qName: QName;
				
				for( var name: * in properties ) {
					qName = qname( name );
					if( !write( target, qName, properties[ name ] ) ) {
						( failed || (failed = []) )[ i++ ] = qName;
					}
				}
				
				if( doUnlock ) lockable.unlock();
				
				return failed;
			}
			return null;
		}
		
		/**
		 * Fills, like <code>writeAll</code>, a instance with all passed
		 * in properties by using a change-property-node-list.
		 * 
		 * @param target target instance that should be written to
		 * @param changed Nodes that were changed
		 * @param map Mapping of the changed properties to the object properties
		 * @return list of properties that couldn't be written (unmapped, as in the
		 *          ChangedPropertyNode), null if all could have
		 * @see IPropertyObserver
		 */
		public function writeAllByNodes( target: *, changed: ChangedPropertyNode, map: Object = null ): Array {
			var doUnlock: Boolean = false;
			if( _isLockable ) {
				const lockable: ILockable = ILockable( target );
				if( !lockable.locked ) {
					doUnlock = true;
					lockable.lock();
				}
			}
			
			var failed: Array = null;
			var i: int = 0;
			
			if( map ) {
				while( changed ) {
					if( !write( target, map[ changed.name.toString() ], changed.newValue ) ) {
						( failed || (failed = []) )[ i++ ] = changed.name;
					};
					changed = changed.next;
				}
			} else {
				while( changed ) {
					if( !write( target, changed.name, changed.newValue ) ) {
						( failed || (failed = []) )[ i++ ] = changed.name;
					};
					changed = changed.next;
				}
			}
			
			if( doUnlock ) lockable.unlock();
			
			return failed;
		}
		
		public function remove( source: *, property: QName ): Boolean {
			if( _isSetterProxy ) {
				return ISetterProxy( source ).remove( property );
			}
			
			try {
				source[ property ] = null;
			} catch( e: Error ) {
				return false;
			}
			if( _isDynamic || _writableLookup && _writableLookup[ property ] ) {
				delete source[ property ];
			}
			return true;
		}
		
		public function readMapped( source: *, propertyMap: Object ): Object {
			var result: Object = {};
			for( var name: * in propertyMap ) {
				result[ propertyMap[ name ] ] = read( source, qname( name ) );
			}
			return result;
		}
		
		/**
		 * If you have a method that should check whether 
		 * 
		 * @param target object to see if the properties changed
		 * @param storage map that contains the former values of this object to
		 * 					compare to
		 * @param limitToFields limits the comparsion to a map (String,name of the
		 * 				field -> Boolean, true if it should bre read ) of fields 
		 * @return A <code>Changes</code> instance if changes between the former storage
		 *         object and the current storage object happend, else <code>null</code>.
		 */
		public function updateStorage( target: *, storage: Object, limitToFields: Object = null ): Changes {
			
			var fullName: String;
			var qName: QName; 
			var newValue: *;
			var oldValue: *;
			var changes: Changes;
			
			if( _isGetterProxy ) {
				
				target = IGetterProxy( target ).readAll( limitToFields );
				
			} else if( _normalReadable ) {
				
				var i: int = _normalReadable.length;
				var checkArray: Array = limitToFields as Array;
				while( --i-(-1) ) {
					qName = _normalReadable[i];
					fullName = qName.toString();
					if( !limitToFields || ( checkArray ? checkArray.indexOf( qName ) : limitToFields[ qName ] ) ) {
						try {
							newValue = target[ qName ];
						} catch( e: Error ) {
							newValue = null;
						}
						oldValue = storage[ fullName ];
						if( oldValue != newValue ) {
							storage[ fullName ] = newValue;
							if( !changes ) {
								changes = CHANGES_POOL.getOrCreate();
							}
							changes.oldValues[ fullName ] = oldValue;
							changes.newValues[ fullName ] = newValue;
						}
					}
				}
			}
			
			
			if( _isDynamic || _isGetterProxy ) {
				
				for( fullName in target ) {
					try {
						newValue = target[ fullName ];
					} catch( e: Error ) {
						newValue = null;
					}
					oldValue = storage[ fullName ];
					if( oldValue != newValue ) {
						storage[ fullName ] = newValue;
						if( !changes ) {
							changes = CHANGES_POOL.getOrCreate();
						}
						changes.oldValues[ fullName ] = oldValue;
						changes.newValues[ fullName ] = newValue;
					}
				}
				
				var targetAsObject: Object = target;
				
				for( fullName in storage ) {
					if( !targetAsObject.hasOwnProperty( fullName ) ) {
						if( !changes ) {
							changes = CHANGES_POOL.getOrCreate();
						}
						changes.oldValues[ fullName ] = storage[ fullName ];
						changes.newValues[ fullName ] = DELETED;
						delete storage[ fullName ];
					}
				}
			}
			
			return changes;
		}
		
		/**
		 * Getter for all properties of an instance.
		 * 
		 * <p>The object returned may be optimized for frequent access. The instance
		 * may only be used for access purposes. <strong>Do not modify the returned
		 * object!</strong></p>
		 * 
		 * <p>If the instance implements <code>IGetterProxy</code> then <code>
		 * instance.getAll</code> will be utilized.</p>
		 * 
		 * @param instance Instance whose properties are requested
		 * @param dynamicOnly <code>true</code> to list only properties that are
		 *        not registered
		 * @param addDynamic <code>true</code> adds the dynamic fields too.
		 * @return <code>Object</code> that contains all the properties requested.
		 */
		
		public function readAll( instance: *, fields: Array = null, addDynamic: Boolean = true ): Object {
			if( _isGetterProxy ) {
					
				return IGetterProxy( instance ).readAll( fields, addDynamic );
					
			} else {
				
				var qName: QName;
				var i: int;
				var result: Object = {};
				
				if( fields ) {
					i = fields.length;
					while ( --i-(-1) ) {
						qName = fields[ i ];
						try {
							result[ qName.toString() ] = instance[ qName ];
						} catch( e: Error ) {}
					}
				} else {
					if( _sendingEventReadable ) {
						i = _sendingEventReadable.length;
						
						while( --i-(-1) ) {
							qName = _sendingEventReadable[ i ];
							result[ qName.toString() ] = instance[ qName ];
						}
					}
					
					if( _normalReadable ) {
						i = _normalReadable.length;
						
						while( --i-(-1) ) {
							qName = _normalReadable[ i ];
							result[ qName.toString() ] = instance[ qName ];
						}
					}
				}
				
				if( addDynamic &&_isDynamic ) {
					
					for( var name: String in instance ) {
						result[ name ] = instance[ name ];
					}
				}
				
				return result;
			}
		}
		
		/**
		 * Reads a property of a instance.
		 * 
		 * <p>Utilizes <code>IGetterProxy</code> if the instance implements it.</p>
		 * 
		 * @param instance Instance to be accessed.
		 * @param name Name of the property to be read
		 * @param ns Namespace of the variable to take
		 * @param fullName Name of the variable including the namespace (if not passed-in
		 *        it will be generated from the namespace and the name)
		 * @return content of the instance's property
		 * @see nanosome.util.access#ns
		 */
		public function read( instance: *, name: QName ): * {
			if( _isGetterProxy ) {
				
				return IGetterProxy( instance ).read( name );
				
			} else {
				
				if( instance && ( _isDynamic || ( _readableLookup && _readableLookup[ name.toString() ] ) ) ) {
				
					try {
						return instance[ name ];
					} catch ( e: Error ) {
						return null;
					}
				}
				
				return null;
			}
		}
		
		/**
		 * @param name Property name of instances of this class.
		 * @return <code>true</code> if the property can be read.
		 */
		public function hasReadableProperty( fullName: String ): Boolean {
			return _isDynamic || ( _readableLookup && _readableLookup[ fullName ] );
		}
		
		/**
		 * @param name Property name of instances of this class.
		 * @return <code>true</code> if the property is supposed to send a event
		 *         on change. (<code>[Bindable]</code> or <code>[Observable]</code>)
		 */
		public function isSendingChangeEvent( qName: QName ): Boolean {
			return ( _sendingEventReadable && _sendingEventReadable.indexOf( qName ) != -1 );
		}
		
		public function get nonEventSendingProperties(): Array {
			return _normalReadable;
		}
		
		public function get eventSendingReadableProperties(): Array {
			return _sendingEventReadable;
		}
		
		public function get properties(): Array {
			return _readWriteable;
		}

		/**
		 * @param name Property name of instances of this class.
		 * @return <code>true</code> if the property can be written or not.
		 */
		public function hasWritableProperty( fullName: String ): Boolean {
			return _isDynamic || ( _writableLookup && _writableLookup[ fullName ] );
		}

		public function get hasNonEventSendingProperties(): Boolean {
			return _isDynamic || _normalReadable;
		}
		
		public function get hasBindable() : Boolean {
			return _bindables != null;
		}
		
		public function get hasObservable() : Boolean {
			return _observables != null;
		}
		
		public function isBindable( fullName: String ): Boolean {
			return _bindables ? _bindables[ fullName ] : _isGetterProxy;
		}
		
		public function isObservable( fullName: String ): Boolean {
			return _observables ? _observables[ fullName ] : _isGetterProxy;
		}
		
		public function get isDynamic(): Boolean {
			return _isDynamic;
		}
		
		public function getPropertyType( fullName: String ): Class {
			return _readWriteableTypeLookup ? _readWriteableTypeLookup[ fullName ] : null;
		}
	}
}
