//
//  CCCStaticObjectArray.h
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 18/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: various storage policies (assign, weak, strong, copy)
// TODO: fast enumeration
// TODO: subscripting
// TODO: sorting
// TODO: optional range checking
// TODO: unit tests

#pragma mark -
#pragma mark CCCStaticObjectArray interface

/** A static (non-resizable) C array capable of holding
 *  Objective-C (id) objects.
 */
@interface CCCStaticObjectArray : NSObject<NSCoding, NSCopying>

#pragma mark properties

@property (readonly, nonatomic) NSUInteger capacity;



#pragma mark initialization

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new  NS_UNAVAILABLE;

- (instancetype) initWithCapacity: (NSUInteger)     capacity;
- (instancetype) initWithCapacity: (NSUInteger)     capacity
                          options: (NSDictionary *) options;

- (instancetype) initWithArray: (NSArray *) array;
- (instancetype) initWithArray: (NSArray *) array
                       options: (NSDictionary *) options;

- (instancetype) initWithObjects: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype) initWithOptions: (NSDictionary *) options
                         objects: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION;



#pragma mark getting/setting elements

- (id) objectAtIndex: (NSUInteger) index;

- (void) setObject: (id)         object
           atIndex: (NSUInteger) index;


#pragma mark enumeration

- (void) enumerateObjectsUsingBlock: (void (^)(id object, NSUInteger index, BOOL *stop)) block;


@end
