//
//  CCCStaticObjectArrayTests_no_ARC.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 20/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#if (__has_feature(objc_arc))
#error "This file should be compiled with ARC disabled"
#endif

#import <XCTest/XCTest.h>
#import "CCCStaticObjectArray.h"


#pragma mark -
#pragma mark CCCStaticObjectArrayTests_no_ARC interface

@interface CCCStaticObjectArrayTests_no_ARC : XCTestCase
@end


#pragma mark -
#pragma mark CCCStaticObjectArrayTests_no_ARC implementation

@implementation CCCStaticObjectArrayTests_no_ARC

#pragma mark -
#pragma mark CCCStaticObjectArraySetterPolicyRetain tests

- (void) test_CCCStaticObjectArraySetterPolicyRetain_setObject
{
    CCCStaticObjectArray *array =
    [[CCCStaticObjectArray alloc] initWithCapacity: 1
                                           options: @{ @(CCCStaticObjectArrayOptionSetterPolicy) :
                                                           @(CCCStaticObjectArraySetterPolicyRetain)}];
    
    NSObject *obj = [NSObject new];
    
    NSUInteger oldRetainCount = obj.retainCount;
    
    [array setObject: obj atIndex: 0];
    
    XCTAssertEqual(oldRetainCount+1, obj.retainCount,
                   @"Setting object at index with CCCStaticObjectArraySetterPolicyRetain should "
                   @"increase retainCount of the object in question.");
    
    [array release];
    [obj   release];
}


- (void) test_CCCStaticObjectArraySetterPolicyRetain_replaceObject
{
    CCCStaticObjectArray *array =
    [[CCCStaticObjectArray alloc] initWithCapacity: 1
                                           options: @{ @(CCCStaticObjectArrayOptionSetterPolicy) :
                                                           @(CCCStaticObjectArraySetterPolicyRetain)}];
    
    NSObject *originalObject    = [NSObject new];
    NSObject *replacementObject = [NSObject new];
    
    [array setObject: originalObject atIndex: 0];
    
    NSUInteger oldRetainCount = originalObject.retainCount;
    
    [array setObject: replacementObject atIndex: 0];
    
    XCTAssertEqual(oldRetainCount-1, originalObject.retainCount,
                   @"Replacing object at index with CCCStaticObjectArraySetterPolicyRetain should "
                   @"release the replaced object.");
    
    [array             release];
    [originalObject    release];
    [replacementObject release];
}


- (void) test_CCCStaticObjectArraySetterPolicyRetain_replaceWithNil
{
    CCCStaticObjectArray *array =
    [[CCCStaticObjectArray alloc] initWithCapacity: 1
                                           options: @{ @(CCCStaticObjectArrayOptionSetterPolicy) :
                                                           @(CCCStaticObjectArraySetterPolicyRetain)}];
    
    NSObject *originalObject = [NSObject new];
    
    [array setObject: originalObject atIndex: 0];
    
    NSUInteger oldRetainCount = originalObject.retainCount;
    
    [array setObject: nil atIndex: 0];
    
    XCTAssertEqual(oldRetainCount-1, originalObject.retainCount,
                   @"Replacing object at index with CCCStaticObjectArraySetterPolicyRetain should "
                   @"release the replaced object.");
    
    [array          release];
    [originalObject release];
}


- (void) test_CCCStaticObjectArraySetterPolicyRetain_replaceWithSameObject
{
    CCCStaticObjectArray *array =
    [[CCCStaticObjectArray alloc] initWithCapacity: 1
                                           options: @{ @(CCCStaticObjectArrayOptionSetterPolicy) :
                                                           @(CCCStaticObjectArraySetterPolicyRetain)}];
    
    NSObject *originalObject = [NSObject new];
    
    [array setObject: originalObject atIndex: 0];
    
    NSUInteger oldRetainCount = originalObject.retainCount;
    
    [array setObject: originalObject atIndex: 0];
    
    XCTAssertEqual(oldRetainCount, originalObject.retainCount,
                   @"Replacing object at index with CCCStaticObjectArraySetterPolicyRetain with the same object "
                   @"should not alter the retainCount of the object.");
    
    [array          release];
    [originalObject release];
}


#pragma mark -
#pragma mark CCCStaticObjectArraySetterPolicyAssign tests

- (void) test_CCCStaticObjectArraySetterPolicyAssign_setObject
{
    CCCStaticObjectArray *array =
    [[CCCStaticObjectArray alloc] initWithCapacity: 1
                                           options: @{ @(CCCStaticObjectArrayOptionSetterPolicy) :
                                                           @(CCCStaticObjectArraySetterPolicyAssign)}];
    
    NSObject *obj = [NSObject new];
    
    NSUInteger oldRetainCount = obj.retainCount;
    
    [array setObject: obj atIndex: 0];
    
    XCTAssertEqual(oldRetainCount, obj.retainCount,
                   @"Setting object at index with CCCStaticObjectArraySetterPolicyAssign should "
                   @"not alter retainCount of the object in question.");
    
    [array release];
    [obj   release];
}


- (void) test_CCCStaticObjectArraySetterPolicyAssign_replaceObject
{
    CCCStaticObjectArray *array =
    [[CCCStaticObjectArray alloc] initWithCapacity: 1
                                           options: @{ @(CCCStaticObjectArrayOptionSetterPolicy) :
                                                           @(CCCStaticObjectArraySetterPolicyAssign)}];
    
    NSObject *originalObject    = [NSObject new];
    NSObject *replacementObject = [NSObject new];
    
    [array setObject: originalObject atIndex: 0];
    
    NSUInteger oldRetainCount = originalObject.retainCount;
    
    [array setObject: replacementObject atIndex: 0];
    
    XCTAssertEqual(oldRetainCount, originalObject.retainCount,
                   @"Replacing object at index with CCCStaticObjectArraySetterPolicyAssign should "
                   @"not alter the retainCount of the the replaced object.");
    
    [array             release];
    [originalObject    release];
    [replacementObject release];
}


- (void) test_CCCStaticObjectArraySetterPolicyAssign_replaceWithNil
{
    CCCStaticObjectArray *array =
    [[CCCStaticObjectArray alloc] initWithCapacity: 1
                                           options: @{ @(CCCStaticObjectArrayOptionSetterPolicy) :
                                                           @(CCCStaticObjectArraySetterPolicyAssign)}];
    
    NSObject *originalObject = [NSObject new];
    
    [array setObject: originalObject atIndex: 0];
    
    NSUInteger oldRetainCount = originalObject.retainCount;
    
    [array setObject: nil atIndex: 0];
    
    XCTAssertEqual(oldRetainCount, originalObject.retainCount,
                   @"Replacing object at index with CCCStaticObjectArraySetterPolicyAssign should "
                   @"not alter the retainCount of the replaced object.");
    
    [array          release];
    [originalObject release];
}


- (void) test_CCCStaticObjectArraySetterPolicyAssign_replaceWithSameObject
{
    CCCStaticObjectArray *array =
    [[CCCStaticObjectArray alloc] initWithCapacity: 1
                                           options: @{ @(CCCStaticObjectArrayOptionSetterPolicy) :
                                                           @(CCCStaticObjectArraySetterPolicyAssign)}];
    
    NSObject *originalObject = [NSObject new];
    
    [array setObject: originalObject atIndex: 0];
    
    NSUInteger oldRetainCount = originalObject.retainCount;
    
    [array setObject: originalObject atIndex: 0];
    
    XCTAssertEqual(oldRetainCount, originalObject.retainCount,
                   @"Replacing object at index with CCCStaticObjectArraySetterPolicyAssign with the same object "
                   @"should not alter the retainCount of the object.");
    
    [array          release];
    [originalObject release];
}



@end
