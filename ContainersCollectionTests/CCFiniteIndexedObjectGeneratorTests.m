//
//  CCFiniteIndexedObjectGeneratorTests.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 26/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import <XCTest/XCTest.h>
#import "CCFiniteIndexedObjectGenerator.h"


#pragma mark -
#pragma mark CCFiniteIndexedObjectGeneratorTests interface

@interface CCFiniteIndexedObjectGeneratorTests : XCTestCase
@end


#pragma mark -
#pragma mark CCFiniteIndexedObjectGeneratorTests implementation

@implementation CCFiniteIndexedObjectGeneratorTests

#pragma mark -
#pragma mark enumeration tests

- (void) test_enumeration
{
    CCFiniteIndexedObjectGenerator *generator =
    [CCFiniteIndexedObjectGenerator generatorWithRange: CCMakeRange(0, 4)
                                                 block:
     ^id(NSInteger index) {
         return @(index);
     }];
    
    NSMutableArray *enumerated = [NSMutableArray new];
    NSArray        *expected   = @[@0, @1, @2, @3];
    
    [generator enumerateObjectsWithBlock:
     ^(id object, NSInteger index, BOOL *stop) {
        [enumerated addObject: object];
    }];
    
    XCTAssertEqualObjects(enumerated, expected,
                          @"Enumerating CCFiniteIndexedObjectGenerator should yield all values in range.");
}


- (void) test_enumeration_overflow
{
    CCFiniteIndexedObjectGenerator *generator =
    [CCFiniteIndexedObjectGenerator generatorWithRange: CCMakeRange(NSIntegerMax-1, 7)
                                                 block:
     ^id(NSInteger index) {
         return @(index);
     }];
    
    NSMutableArray *enumerated = [NSMutableArray new];
    NSArray        *expected   = @[@(NSIntegerMax-1), @(NSIntegerMax)];
    
    [generator enumerateObjectsWithBlock:
     ^(id object, NSInteger index, BOOL *stop) {
         [enumerated addObject: object];
     }];
    
    XCTAssertEqualObjects(enumerated, expected,
                          @"Enumerating CCFiniteIndexedObjectGenerator should "
                          @"stop upon encountering NSIntegerMax even when the range "
                          @"exceeds that.");
}


- (void) test_fastEnumeration_positive
{
    CCFiniteIndexedObjectGenerator *generator =
    [CCFiniteIndexedObjectGenerator generatorWithRange: CCMakeRange(0, 7)
                                                 block:
     ^id(NSInteger index) {
         return @(index);
     }];
    
    NSMutableArray *enumerated = [NSMutableArray new];
    NSArray        *expected   = @[@0, @1, @2, @3, @4, @5, @6];
    
    for (id object in generator)
    {
        [enumerated addObject: object];
    }
    
    XCTAssertEqualObjects(enumerated, expected,
                          @"Enumerating CCFiniteIndexedObjectGenerator should yield all values in range.");
}


- (void) test_fastEnumeration_negative
{
    CCFiniteIndexedObjectGenerator *generator =
    [CCFiniteIndexedObjectGenerator generatorWithRange: CCMakeRange(-3, 7)
                                                 block:
     ^id(NSInteger index) {
         return @(index);
     }];
    
    NSMutableArray *enumerated = [NSMutableArray new];
    NSArray        *expected   = @[@-3, @-2, @-1, @0, @1, @2, @3];
    
    for (id object in generator)
    {
        [enumerated addObject: object];
    }
    
    XCTAssertEqualObjects(enumerated, expected,
                          @"Enumerating CCFiniteIndexedObjectGenerator should yield all values in range.");
}


- (void) test_fastEnumeration_overflow
{
    CCFiniteIndexedObjectGenerator *generator =
    [CCFiniteIndexedObjectGenerator generatorWithRange: CCMakeRange(NSIntegerMax-1, 7)
                                                 block:
     ^id(NSInteger index) {
         return @(index);
     }];
    
    NSMutableArray *enumerated = [NSMutableArray new];
    NSArray        *expected   = @[@(NSIntegerMax-1), @(NSIntegerMax)];
    
    for (id object in generator)
    {
        [enumerated addObject: object];
    }
    
    XCTAssertEqualObjects(enumerated, expected,
                          @"Enumerating CCFiniteIndexedObjectGenerator should "
                          @"stop upon encountering NSIntegerMax even when the range "
                          @"exceeds that.");
}


- (void) test_fastEnumeration_concurrent
{
    __block BOOL done1 = NO;
    __block BOOL done2 = NO;
    
    CCFiniteIndexedObjectGenerator *generator =
    [CCFiniteIndexedObjectGenerator generatorWithRange: CCMakeRange(0, 16)
                                                 block:
     ^id(NSInteger index) {
         return @(index);
     }];
    
    NSMutableArray *enumerated1 = [NSMutableArray new];
    NSMutableArray *enumerated2 = [NSMutableArray new];
    NSArray        *expected    = @[ @0,  @1,  @2,  @3,
                                     @4,  @5,  @6,  @7,
                                     @8,  @9, @10, @11,
                                    @12, @13, @14, @15];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (id object in generator)
        {
            [enumerated1 addObject: object];
        }
        
        done1 = YES;
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (id object in generator)
        {
            [enumerated2 addObject: object];
        }
        
        done2 = YES;
    });
    
    while (!done1 || !done2) {}
    
    XCTAssertEqualObjects(enumerated1, expected,
                          @"CCFiniteIndexedObjectGenerator should allow concurrent fast enumeration.");
    XCTAssertEqualObjects(enumerated2, expected,
                          @"CCFiniteIndexedObjectGenerator should allow concurrent fast enumeration.");
}

@end
