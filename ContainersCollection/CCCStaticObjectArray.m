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


#pragma mark -
#pragma mark CCCStaticObjectArray private

@interface CCCStaticObjectArray()
{
@private
    /// array of objects stored in the container
    id* _objects;
}

@end


#pragma mark -
#pragma mark CCCStaticObjectArray implementation

@implementation CCCStaticObjectArray

#pragma mark -
#pragma mark initialization methods

- (instancetype) init
{
    [self release];
     self = nil;
    
    @throw [[self class] zeroCapacityException];
    
    return self;
}


- (instancetype) initWithCapacity: (NSUInteger) capacity
{
    return [self initWithCapacity: capacity
                          options: [[self class] defaultOptions]];
}


- (instancetype) initWithCapacity: (NSUInteger)     capacity
                          options: (NSDictionary *) options
{
    if (capacity > 0)
    {
        // TODO: implement
    }
    else
    {
        [self release];
         self = nil;
        
        @throw [[self class] zeroCapacityException];
    }
    
    return self;
}


- (instancetype) initWithArray: (NSArray *) array
{
    // TODO: implement
    return nil;
}


- (instancetype) initWithArray: (NSArray *) array
                       options: (NSDictionary *) options
{
    // TODO: implement
    return nil;
}


- (instancetype) initWithObjects: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    // TODO: implement
    return nil;
}


- (instancetype) initWithOptions: (NSDictionary *) options
                         objects: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    // TODO: implement
    return nil;
}


#pragma mark -
#pragma mark getting/setting elements

- (id) objectAtIndex: (NSUInteger) index
{
    // TODO: implement
    return nil;
}


- (void) setObject: (id)         object
           atIndex: (NSUInteger) index
{
    // TODO: implement
}


#pragma mark -
#pragma mark enumeration

- (void) enumerateObjectsUsingBlock: (void (^)(id object, NSUInteger index, BOOL *stop)) block
{
    // TODO: implement
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
