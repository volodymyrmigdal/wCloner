( function _Cloner_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    require( '../wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

}

var Self = wTools;
var _ = wTools;
var _ObjectHasOwnProperty = Object.hasOwnProperty;

// --
// routines
// --

// function cloneDeep_deprecated( src,options )
// {
//   var result;
//
//   if( options !== undefined && !_.objectIs( options ) )
//   throw _.err( 'wTools.cloneDeep_deprecated :','need options' );
//
//   var options = options || Object.create( null );
//
//   if( options.forWorker === undefined ) options.forWorker = 0;
//
//   if( options.depth === undefined ) options.depth = 16;
//
//   if( options.useClone === undefined ) options.useClone = 1;
//
//   if( options.depth < 0 )
//   {
//     if( options.silent ) console.log( 'wTools.cloneDeep_deprecated : overflow' );
//     else throw _.err( 'wTools.cloneDeep_deprecated :','overflow' );
//   }
//
//   _.assert( !options.forWorker,'forWorker is deprecated' );
//
//   /* */
//
//   if( !src ) return src;
//
//   if( options.useClone && _.routineIs( src.clone ) )
//   {
//     result = src.clone();
//   }
//   else if( _.arrayIs( src ) )
//   {
//
//     result = [];
//     src.forEach(function( child, index, array ) {
//       result[index] = cloneDeep_deprecated( child,options );
//     });
//
//   }
//   else if( _.objectIs( src ) )
//   {
//
//     result = Object.create( null );
//     var proto = Object.getPrototypeOf( src );
//     var result = Object.create( proto );
//     for( var s in src )
//     {
//       if( !_ObjectHasOwnProperty.call( src,s ) )
//       continue;
//       var c = cloneDeep_deprecated( src[ s ],{
//         depth : options.depth-1,
//         silent :options.silent,
//         forWorker : options.forWorker,
//       });
//       result[s] = c;
//     }
//
//   }
//   else if( src.constructor )
//   {
//
//     if( options.forWorker )
//     {
//       var good = _.strIs( src ) || _.numberIs( src ) || _.dateIs( src ) || _.boolIs( src ) || _.regexpIs( src ) || _.bufferTypedIs( src );
//       if( good )
//       {
//         return src;
//       }
//       else
//       {
//         return;
//       }
//     }
//     else
//     {
//       if( _.strIs( src ) || _.numberIs( src ) || _.dateIs( src ) || _.boolIs( src ) || _.regexpIs( src ) )
//       result = src.constructor( src );
//       else if( _.routineIs( src ) )
//       result = src;
//       else
//       result = new src.constructor( src );
//     }
//
//   }
//   else
//   {
//
//     result = src;
//
//   }
//
//   return result;
// }

//

function _cloneIterator()
{
  var result = Object.create( null );

  _.assert( arguments.length === 0 );

  return result;
}

//

function _cloneIteration( iteration,isRoot )
{
  var result = Object.create( null );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.numberIs( iteration.copyDegree ) );

  result.level = iteration.level;
  result.copyDegree = iteration.copyDegree;

  if( isRoot )
  result.iterationPrev = null;
  else
  result.iterationPrev = iteration;

  if( !isRoot )
  if( result.copyDegree === 2 )
  result.copyDegree -= 1;

  return result;
}

//

function _cloneOptions( routine,o )
{
  var routine = routine || _cloneOptions;

  _.assert( arguments.length === 2 );
  _.routineOptions( routine,o );

  /* */

  var iteration = _cloneIteration( o,1 );
  iteration.dst = o.dst;
  iteration.src = o.src;

  iteration.key = o.key;
  iteration.proto = o.proto;
  iteration.level = o.level;
  iteration.path = o.path;

  iteration.customFields = o.customFields;
  iteration.dropFields = o.dropFields;
  iteration.screenFields = o.screenFields;

  iteration.instanceAsMap = o.instanceAsMap;
  iteration.copyDegree = o.copyDegree;

  /* */

  var iterator = _cloneIterator();
  iterator.rootSrc = o.rootSrc;

  iterator.copyingComposes = o.copyingComposes;
  iterator.copyingAggregates = o.copyingAggregates;
  iterator.copyingAssociates = o.copyingAssociates;
  iterator.copyingRestricts = o.copyingRestricts;
  iterator.copyingBuffers = o.copyingBuffers;
  iterator.copyingCustomFields = o.copyingCustomFields;

  iterator.levels = o.levels;
  iterator.technique = o.technique;

  iterator.onString = o.onString;
  iterator.onRoutine = o.onRoutine;
  iterator.onBuffer = o.onBuffer;
  iterator.onContainerUp = o.onContainerUp;
  iterator.onContainerDown = o.onContainerDown;
  iterator.onElementUp = o.onElementUp;
  iterator.onElementDown = o.onElementDown;

  var result = Object.create( null );
  result.iteration = iteration;
  result.iterator = iterator;
  return result;
}

_cloneOptions.defaults =
{

  src : null,
  key : null,
  dst : null,
  proto : null,
  level : 0,
  path : '',
  customFields : null,
  dropFields : null,
  screenFields : null,
  instanceAsMap : 0,
  copyDegree : 3,

  copyingComposes : 3,
  copyingAggregates : 1,
  copyingAssociates : 1,
  copyingRestricts : 0,
  copyingBuffers : 3,
  copyingCustomFields : 0,

  rootSrc : null,
  levels : 999,
  technique : null,

  onString : null,
  onRoutine : null,
  onBuffer : null,
  onContainerUp : null,
  onContainerDown : null,
  onElementUp : null,
  onElementDown : null,

}

//

function _cloneHandleElementUp( iteration,iterator )
{

  if( iterator.onElementUp )
  {
    var r = iterator.onElementUp( iteration.src,iteration,iterator );
    _.assert( r === undefined || r === false );
    if( r === false )
    return false;
  }

  return true;
}

//

function _cloneHandleElementDown( iteration,iterator )
{

  if( iterator.onElementDown )
  {
    var r = iterator.onElementDown( iteration.dst,iteration,iterator );
    _.assert( r === undefined || r === false );
    if( r === false )
    return false;
  }

  return true;
}

//

function _cloneMap( iteration,iterator )
{
  var result;

  _.assert( iteration.copyDegree >= 1 );
  _.assert( arguments.length === 2 );
  _.assert( _.objectLike( iteration.src ) );

  /* */

  if( iterator.onContainerUp )
  {
    var r = iterator.onContainerUp( iteration.src,iteration,iterator );
    _.assert( r === undefined || r === false );
    if( r === false )
    return iteration.dst;
  }

  /* low copy degree */

  if( iteration.copyDegree === 1 )
  return iteration.dst = iteration.src;

  /* map */

  var mapLike = _.mapLike( iteration.src ) || iteration.instanceAsMap;

  if( !mapLike )
  {
    debugger;
    throw _.err
    (
      'Complex objets should have ' +
      ( iterator.technique === 'data' ? 'cloneData' : 'cloneObject' ) +
      ', but object ' + _.strTypeOf( iteration.src ) + ' at ' + ( iteration.path || '.' ), 'does not have such method','\n',
      iteration.src,'\n',
      'try to mixin wCopyable'
    );
  }

  /* */

  if( iteration.dst )
  {}
  else if( iteration.proto )
  iteration.dst = new iteration.proto();
  else
  {
    iteration.dst = _.entityNew( iteration.src );
  }

  /* */

  var screen = iteration.screenFields ? iteration.screenFields : iteration.src;

  if( iteration.copyDegree )
  for( var key in screen )
  {

    if( screen[ key ] === undefined )
    continue;

    if( iteration.src[ key ] === undefined )
    continue;

    // if( !( key in iteration.src ) )
    // continue;

    if( iteration.dropFields )
    if( iteration.dropFields[ key ] !== undefined )
    continue;

    if( !mapLike && !iteration.screenFields )
    if( !Object.hasOwnProperty.call( iteration.src,key ) )
    {
      debugger;
      continue;
    }

    var newIteration = _._cloneIteration( iteration );
    newIteration.src = iteration.src[ key ];
    newIteration.key = key;
    newIteration.path = iteration.path + '.' + key;

    // if( key === 'elements' && newIteration.src )
    // debugger;

    iteration.dst[ key ] = _cloneAct( newIteration,iterator );
  }

  /* container down */

  if( iterator.onContainerDown )
  {
    var r = iterator.onContainerDown( iteration.dst,iteration,iterator );
    _.assert( r === undefined );
  }

  /* */

  return iteration.dst;
}

//

function _cloneBuffer( iteration,iterator )
{
  var handled = 0;
  var degree = Math.min( iterator.copyingBuffers,iteration.copyDegree );

  _.assert( iteration.copyDegree >= 1,'not tested' );
  _.assert( !_.bufferNodeIs( iteration.src ),'not tested' );

  _.assert( arguments.length === 2 );
  _.assert( _.bufferAnyIs( iteration.src ) );

  if( !degree )
  debugger;

  if( !degree )
  return;

  if( iterator.onContainerUp )
  {
    var r = iterator.onContainerUp( iteration.src,iteration,iterator );
    _.assert( r === undefined || r === false );
    if( r === false )
    return iteration.dst;
  }

  /* buffer */

  if( degree >= 2 )
  {
    iteration.dst = _._arrayCopy( iteration.src );
  }
  else
  {
    iteration.dst = iteration.src;
  }

  handled = 1;

  /* container down */

  if( iterator.onContainerDown )
  {
    debugger;
    var r = iterator.onContainerDown( iteration.dst,iteration,iterator );
    _.assert( r === undefined );
  }

  /* */

  if( iterator.onBuffer )
  {
    debugger;
    var r = iterator.onBuffer( iteration.dst,iteration,iterator );
    _.assert( r === undefined );
  }

  /* */

  if( !handled )
  _.assert( 0,'unknown type of buffer',_.strTypeOf( iteration.src ) );

  return iteration.dst;
}

//

function _cloneArray( iteration,iterator )
{

  _.assert( iteration.copyDegree >= 1 );
  _.assert( arguments.length === 2 );
  _.assert( _.arrayLike( iteration.src ) );
  _.assert( !_.bufferAnyIs( iteration.src ) );

  /* */

  if( iterator.onContainerUp )
  {
    var r = iterator.onContainerUp( iteration.src,iteration,iterator );
    _.assert( r === undefined || r === false );
    if( r === false )
    return iteration.dst;
  }

  /* low copy degree */

  if( iteration.copyDegree === 1 )
  return iteration.dst = iteration.src;

  /* */

  if( iteration.dst )
  {}
  else if( iteration.proto )
  {
    debugger;
    iteration.dst = new iteration.proto( iteration.src.length );
  }
  else
  {
    iteration.dst = _.arrayNew( iteration.src );
  }

  /* */

  if( _.bufferRawIs( iteration.src ) )
  throw _.err( 'not implemented' );

  if( _.bufferTypedIs( iteration.src ) )
  debugger;

  if( iteration.copyDegree )
  for( var key = 0 ; key < iteration.src.length ; key++ )
  {

    var newIteration = _._cloneIteration( iteration );
    newIteration.src = iteration.src[ key ];
    newIteration.key = key;
    newIteration.path = iteration.path + '.' + key;

    iteration.dst[ key ] = _cloneAct( newIteration,iterator );
  }

  /* container down */

  if( iterator.onContainerDown )
  {
    var r = iterator.onContainerDown( iteration.dst,iteration,iterator );
    _.assert( r === undefined );
  }

  return iteration.dst;
}

//

function _cloneAct( iteration,iterator )
{
  var handled = 0;
  var r;
  var objectLike = _.objectLike( iteration.src );
  var arrayLike = _.arrayLike( iteration.src );
  var bufferTypedIs = _.bufferAnyIs( iteration.src );

  if( ( arrayLike && objectLike ) )
  {
    debugger;
    _.objectLike( iteration.src );
  }

  _.assert( arguments.length === 2 );
  _.assert( iteration.level >= 0 );
  _.assert( iteration.copyDegree > 0 );
  _.assert( _.strIs( iteration.path ) );
  _.assert( !( arrayLike && objectLike ) );

  iteration.level += 1;

  if( !( iteration.level <= iterator.levels ) )
  throw _.err
  (
    'failed to clone structure',_.strTypeOf( iterator.rootSrc ) +
    '\nat ' + iteration.path +
    '\ntoo deep structure' +
    '\nrootSrc : ' + _.toStr( iterator.rootSrc ) +
    '\niteration : ' + _.toStr( iteration ) +
    '\niterator : ' + _.toStr( iterator )
  );

  /* */

  if( !_._cloneHandleElementUp( iteration,iterator ) )
  return iteration.dst;

  /* class instance */

  if( iteration.copyDegree > 1 && iteration.src )
  if( iterator.technique === 'data' )
  {
    if( iteration.src.cloneData )
    {
      iteration.src._cloneData( iteration,iterator );
      _cloneHandleElementDown( iteration,iterator );
      return iteration.dst;
    }
  }
  else if( iterator.technique === 'object' )
  {
    if( iteration.src.cloneObject )
    {
      iteration.src._cloneObject( iteration,iterator );
      _cloneHandleElementDown( iteration,iterator );
      return iteration.dst;
    }
  }
  else
  {
    throw _.err( 'unexpected clone technique : ' + iterator.technique );
  }

  /* object like */

  if( objectLike )
  {
    handled = 1;
    _._cloneMap( iteration,iterator );
  }

  /* array like */

  if( arrayLike && !bufferTypedIs )
  {
    handled = 1;
    _._cloneArray( iteration,iterator );
  }

  /* buffer like */

  if( bufferTypedIs )
  {
    handled = 1;
    _._cloneBuffer( iteration,iterator );
  }

  if( !iteration.dst )
  iteration.dst = iteration.src;

  /* routine */

  if( _.routineIs( iteration.src ) )
  {
    handled = 1;
    if( iterator.onRoutine )
    debugger;
    if( iterator.onRoutine )
    iterator.onRoutine( iteration.src,iteration,iterator );
  }

  /* string */

  if( _.strIs( iteration.src ) )
  {
    handled = 1;
    if( iterator.onString )
    iterator.onString( iteration.src,iteration,iterator );
  }

  /* atomic */

  if( _.atomicIs( iteration.src ) )
  {
    handled = 1;
  }

  /* */

  if( !_cloneHandleElementDown( iteration,iterator ) )
  return iteration.dst;

  /* */

  if( !handled && iteration.copyDegree > 1 )
  {
    debugger;
    throw _.err( 'unknown type of src : ' + _.strTypeOf( iteration.src ) );
  }

  return iteration.dst;
}

//

function _clone( o )
{

  if( o.rootSrc === undefined )
  o.rootSrc = o.src;

  if( o.src === undefined )
  {
    console.warn( 'REMINDER:','experimental' );
    debugger;
    /* o.src = null; */
  }

  var r = _cloneOptions( _clone,o );
  return _cloneAct( r.iteration,r.iterator );
}

_clone.defaults = _cloneOptions.defaults;

//

function cloneJust( src )
{
  _.assert( arguments.length === 1 );

  var o = Object.create( null );
  o.src = src;

  _.routineOptions( cloneJust,o );

  return _._clone( o );
}

cloneJust.defaults =
{
  technique : 'object',
}

cloneJust.defaults.__proto__ = _clone.defaults;

//

function cloneObject( o )
{

  if( o.rootSrc === undefined )
  o.rootSrc = o.src;

  _.routineOptions( cloneObject,o );

  var result = _clone( o );

  return result;
}

cloneObject.defaults =
{
  copyingAssociates : 1,
  technique : 'object',
}

cloneObject.defaults.__proto__ = _clone.defaults;

//

function cloneObjectMergingBuffers( o )
{
  var result = Object.create( null );
  var src = o.src;
  var descriptorsMap = o.src.descriptorsMap;
  var buffer = o.src.buffer;
  var data = o.src.data;

  if( o.rootSrc === undefined )
  o.rootSrc = o.src;

  _.routineOptions( cloneObjectMergingBuffers,o );

  _.assert( _.objectIs( o.src.descriptorsMap ) );
  _.assert( _.bufferRawIs( o.src.buffer ) );
  _.assert( o.src.data !== undefined );

  /* */

  var optionsForCloneObject = _.mapScreen( _.cloneObject.defaults,o );
  optionsForCloneObject.src = data;

  /* onString */

  optionsForCloneObject.onString = function onString( strString,iteration,iterator )
  {

    var id = _.strUnjoin( strString,[ '--buffer-->',_.strUnjoin.any,'<--buffer--' ] )

    if( id === undefined )
    return strString;

    var descriptor = descriptorsMap[ strString ];
    _.assert( descriptor !== undefined );

    var bufferConstructor = _global_[ descriptor[ 'bufferConstructorName' ] ];
    var offset = descriptor[ 'offset' ];
    var size = descriptor[ 'size' ];
    var sizeOfAtom = descriptor[ 'sizeOfAtom' ];
    var result = bufferConstructor ? new bufferConstructor( buffer,offset,size / sizeOfAtom ) : null;

    iteration.dst = result;

    return result;
  }

  /* clone object */

  var result = _.cloneObject( optionsForCloneObject );

  return result;
}

cloneObjectMergingBuffers.defaults =
{
  copyingBuffers : 1,
}

cloneObjectMergingBuffers.defaults.__proto__ = cloneObject.defaults;

//

function cloneData( o )
{

  if( o.rootSrc === undefined )
  o.rootSrc = o.src;

  _.routineOptions( cloneData,o );

  var result = _clone( o );

  return result;
}

cloneData.defaults =
{
  technique : 'data',
  copyingAssociates : 0,
}

cloneData.defaults.__proto__ = _clone.defaults;

//

function cloneDataSeparatingBuffers( o )
{
  var result = Object.create( null );
  var buffers = [];
  var descriptorsArray = [];
  var descriptorsMap = Object.create( null );
  var size = 0;
  var offset = 0;

  if( o.rootSrc === undefined )
  o.rootSrc = o.src;

  _.routineOptions( cloneDataSeparatingBuffers,o ); debugger;

  /* onBuffer */

  o.onBuffer = function onBuffer( srcBuffer,iteration,iterator )
  {

    debugger;

    logger.log( 'buffer',iteration.path );

    _.assert( _.bufferTypedIs( srcBuffer ),'not tested' );

    var index = buffers.length;
    var id = _.strJoin( '--buffer-->',index,'<--buffer--' );
    var bufferSize = srcBuffer ? srcBuffer.length*srcBuffer.BYTES_PER_ELEMENT : 0;
    size += bufferSize;

    var descriptor =
    {
      'bufferConstructorName' : srcBuffer ? srcBuffer.constructor.name : 'null',
      'sizeOfAtom' : srcBuffer ? srcBuffer.BYTES_PER_ELEMENT : 0,
      'offset' : -1,
      'size' : bufferSize,
      'index' : index,
    }

    buffers.push( srcBuffer );
    descriptorsArray.push( descriptor );
    descriptorsMap[ id ] = descriptor;

    iteration.dst = id;

    // return id;
  }

  /* clone data */

  result.data = _._clone( o );
  result.descriptorsMap = descriptorsMap;

  /* sort by atom size */

  descriptorsArray.sort( function( a,b )
  {
    return b[ 'sizeOfAtom' ] - a[ 'sizeOfAtom' ];
  });

  /* alloc */

  result.buffer = new ArrayBuffer( size );
  var dstBuffer = _.bufferBytesGet( result.buffer );

  /* copy buffers */

  for( var b = 0 ; b < descriptorsArray.length ; b++ )
  {

    var descriptor = descriptorsArray[ b ];
    var buffer = buffers[ descriptor.index ];
    var bytes = buffer ? _.bufferBytesGet( buffer ) : new Uint8Array();
    var bufferSize = descriptor[ 'size' ];

    descriptor[ 'offset' ] = offset;

    _.bufferMove( dstBuffer.subarray( offset,offset+bufferSize ),bytes );

    offset += bufferSize;

  }

  debugger;

  return result;
}

cloneDataSeparatingBuffers.defaults =
{
  copyingBuffers : 1,
}

cloneDataSeparatingBuffers.defaults.__proto__ = cloneData.defaults;

// --
// prototype
// --

var Proto =
{

  // cloneDeep_deprecated : cloneDeep_deprecated, /* deprecated */

  _cloneIterator : _cloneIterator,
  _cloneIteration : _cloneIteration,
  _cloneOptions : _cloneOptions,

  _cloneHandleElementUp : _cloneHandleElementUp,
  _cloneHandleElementDown : _cloneHandleElementDown,

  _cloneMap : _cloneMap,
  _cloneBuffer : _cloneBuffer,
  _cloneArray : _cloneArray,
  _cloneAct : _cloneAct,

  _clone : _clone,
  cloneJust : cloneJust,

  cloneObject : cloneObject,
  cloneObjectMergingBuffers : cloneObjectMergingBuffers, /* experimental */
  cloneData : cloneData,
  cloneDataSeparatingBuffers : cloneDataSeparatingBuffers, /* experimental */

}

_.mapExtend( Self, Proto );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

})();
