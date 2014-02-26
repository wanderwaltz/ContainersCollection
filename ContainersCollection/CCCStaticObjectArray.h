//
//  CCCStaticObjectArray.h
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 18/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: weak storage policy
// TODO: fast enumeration for weak storage policy
// TODO: sorting
// TODO: optional range checking
// TODO: optional cyclic ranges
// TODO: unit tests
// TODO: options for -objectAtIndex: to return either retain/autoreleased or as-is
// TODO: tests for: subscripting
// TODO: test for: copy storage policy
// TODO: search
// TODO: NSCoding
// TODO: NSCopying


#pragma mark -
#pragma mark Typedefs

typedef NS_ENUM(NSInteger, CCCStaticObjectArrayOptions)
{
    CCCStaticObjectArrayOptionSetterPolicy,
    CCCStaticObjectArrayOptionGetterPolicy
};


typedef NS_ENUM(NSInteger, CCCStaticObjectArraySetterPolicy)
{
    CCCStaticObjectArraySetterPolicyRetain,
    CCCStaticObjectArraySetterPolicyAssign,
    CCCStaticObjectArraySetterPolicyCopy,
    
    CCCStaticObjectArraySetterPolicyDefault = CCCStaticObjectArraySetterPolicyRetain
};


typedef NS_ENUM(NSInteger, CCCStaticObjectArrayGetterPolicy)
{
    CCCStaticObjectArrayGetterPolicyRetainAutorlease,
    CCCStaticObjectArrayGetterPolicyRaw,
    
    CCCStaticObjectArrayGetterPolicyDefault = CCCStaticObjectArrayGetterPolicyRetainAutorlease
};


#pragma mark -
#pragma mark CCCStaticObjectArray interface

/** A static (non-resizable) C array capable of holding
 *  Objective-C (id) objects.
 */
@interface CCCStaticObjectArray : NSObject<NSCoding, NSCopying, NSFastEnumeration>

#pragma mark properties

@property (readonly, nonatomic) NSUInteger   capacity;
@property (readonly, nonatomic) NSDictionary *options;



#pragma mark initialization

+ (NSDictionary *) defaultOptions;

- (instancetype) initWithCapacity: (NSUInteger)     capacity;

/// Designated initializer
- (instancetype) initWithCapacity: (NSUInteger)     capacity
                          options: (NSDictionary *) options;

- (instancetype) initWithArray: (NSArray *) array;
- (instancetype) initWithArray: (NSArray *) array
                       options: (NSDictionary *) options;

- (instancetype) initWithObjects: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype) initWithOptions: (NSDictionary *) options
                         objects: (id) firstObject, ... NS_REQUIRES_NIL_TERMINATION;



#pragma mark getting/setting elements

- (id) objectAtIndexedSubscript: (NSUInteger) index;
- (id) objectAtIndex:            (NSUInteger) index;


- (void) setObject: (id)         object
atIndexedSubscript: (NSUInteger) index;
- (void) setObject: (id)         object
           atIndex: (NSUInteger) index;


#pragma mark enumeration

- (void) enumerateObjectsUsingBlock: (void (^)(id object, NSUInteger index, BOOL *stop)) block;

- (void) enumerateObjectsWithOptions: (NSEnumerationOptions) options
                          usingBlock: (void (^)(id object, NSUInteger index, BOOL *stop)) block;


@end
