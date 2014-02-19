//
//  CCCStaticObjectArray.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 18/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#if (__has_feature(objc_arc))
#error "This file should be compiled with ARC disabled"
#endif

#import "CCCStaticObjectArray.h"
#import "CCCAccessors.h"


#pragma mark -
#pragma mark CCCStaticObjectArray private

@interface CCCStaticObjectArray()
{
@private
    /// array of objects stored in the container
    id* _objects;
    
    CCCGetterPtr _getter;
    CCCSetterPtr _setter;
}

@end


#pragma mark -
#pragma mark CCCStaticObjectArray implementation

@implementation CCCStaticObjectArray

#pragma mark -
#pragma mark initialization methods

- (instancetype) init
{
    return [self initWithCapacity: 0
                          options: [[self class] defaultOptions]];
}


- (instancetype) initWithCapacity: (NSUInteger) capacity
{
    return [self initWithCapacity: capacity
                          options: [[self class] defaultOptions]];
}


- (instancetype) initWithCapacity: (NSUInteger)     capacity
                          options: (NSDictionary *) options
{
    self = [super init];
    
    if (self != nil)
    {
        _capacity = capacity;
        
        if (_capacity > 0)
        {
            _objects = calloc(capacity, sizeof(id));
        }
        else
        {
            _objects = NULL;
        }
        
        // TODO: use different setters/getters depending on options
        _getter = CCCGetterRetainAutorelease;
        _setter = CCCSetterRetain;
    }
    
    return self;
}


- (instancetype) initWithArray: (NSArray *) array
{
    return [self initWithArray: array
                       options: [[self class] defaultOptions]];
}


- (instancetype) initWithArray: (NSArray *) array
                       options: (NSDictionary *) options
{
    self = [self initWithCapacity: array.count
                          options: options];
    
    if (self != nil)
    {
        [array enumerateObjectsUsingBlock:
         ^(id object, NSUInteger index, BOOL *stop) {
             
             [self setObject: object atIndex: index];
             
         }];
    }
    return self;
}



#define Synthesize_initWithObjectsOptions(Options)  \
if (firstObject != nil)                             \
{                                                   \
    NSUInteger count = 1;                           \
                                                    \
    va_list args;                                   \
    va_start(args, firstObject);                    \
                                                    \
    while (va_arg(args, id) != nil) count++;        \
                                                    \
    va_end(args);                                   \
                                                    \
    self = [self initWithCapacity: count            \
                          options: Options];        \
                                                    \
    if (self != nil)                                \
    {                                               \
        [self setObject: firstObject atIndex: 0];   \
        NSUInteger i = 0;                           \
        id arg       = nil;                         \
                                                    \
        va_start(args, firstObject);                \
                                                    \
        while ((arg = va_arg(args, id)))            \
        {                                           \
            [self setObject: arg atIndex: i];       \
            i++;                                    \
        }                                           \
                                                    \
        va_end(args);                               \
    }                                               \
    return self;                                    \
}                                                   \
else                                                \
{                                                   \
    return [self initWithCapacity: 0                \
                          options: Options];        \
}


- (instancetype) initWithObjects: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    Synthesize_initWithObjectsOptions([[self class] defaultOptions]);
}


- (instancetype) initWithOptions: (NSDictionary *) options
                         objects: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    Synthesize_initWithObjectsOptions(options);
}

#undef Synthesize_initWithObjectsOptions


#pragma mark -
#pragma mark getting/setting elements

- (id) objectAtIndex: (NSUInteger) index
{
    NSAssert(_getter != nil, @"Getter policy is not set!");
    return _getter(_objects+index);
}


- (void) setObject: (id)         object
           atIndex: (NSUInteger) index
{
    NSAssert(_setter != nil, @"Setter policy is not set!");
    _setter(_objects+index, object);
}


#pragma mark -
#pragma mark enumeration

- (void) enumerateObjectsUsingBlock: (void (^)(id object, NSUInteger index, BOOL *stop)) block
{
    BOOL stop = NO;
    
    for (NSUInteger i = 0; i < _capacity; ++i)
    {
        block([self objectAtIndex: i], i, &stop);
        if (stop) break;
    }
}


#pragma mark -
#pragma mark <NSCoding>

- (instancetype) initWithCoder: (NSCoder *) aDecoder
{
    // TODO: implement
    return nil;
}


- (void) encodeWithCoder: (NSCoder *) aCoder
{
    // TODO: implement
}


#pragma mark -
#pragma mark <NSCopying>

- (instancetype) copyWithZone:(NSZone *)zone
{
    // TODO: implement
    return nil;
}


#pragma mark -
#pragma mark private: exceptions

+ (NSException *) zeroCapacityException
{
    return [NSException exceptionWithName: NSInvalidArgumentException
                                   reason:
            [NSString stringWithFormat:
             @"Unable to create %@ instance with zero capacity.",
             NSStringFromClass(self)]
                                 userInfo: nil];
}


#pragma mark -
#pragma mark private: options

+ (NSDictionary *) defaultOptions
{
    // TODO: implement
    return nil;
}

@end
