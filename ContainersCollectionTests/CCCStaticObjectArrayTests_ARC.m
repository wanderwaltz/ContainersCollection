//
//  CCCStaticObjectArrayTests.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 18/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import <XCTest/XCTest.h>
#import <objc/message.h>
#import "CCCStaticObjectArray.h"


#pragma mark -
#pragma mark CCCStaticObjectArrayTests interface

@interface CCCStaticObjectArrayTests_ARC : XCTestCase
@end


#pragma mark -
#pragma mark CCCStaticObjectArrayTests implementation

@implementation CCCStaticObjectArrayTests_ARC

#pragma mark -
#pragma mark initialization tests

#pragma mark -init tests

- (void) test_init_nonNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] init];
    
    XCTAssertNotNil(array, @"-init returns a non-nil array.");
}


- (void) test_init_capacityValue
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] init];
    
    XCTAssertEqual(array.capacity, (NSUInteger)0,
                   @"CCCStaticObjectArray returned by -init should have zero capacity");
}


- (void) test_init_defaultOptions
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] init];
    
    XCTAssertEqualObjects(array.options, [CCCStaticObjectArray defaultOptions],
                          @"-init should create CCCStaticObjectArray with default options.");
}


#pragma mark -initWithCapacity: tests

- (void) test_initWithCapacity_positive_nonNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithCapacity: 123];
    
    XCTAssertNotNil(array, @"-initWithCapacity: returns a non-nil array when passed capacity > 0.");
}


- (void) test_initWithCapacity_positive_capacityValue
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithCapacity: 123];
    
    XCTAssertEqual(array.capacity, (NSUInteger)123,
                   @"CCCStaticObjectArray returned by -initWithCapacity: should have the "
                   @"corresponding capacity value.");
}


- (void) test_initWithCapacity_defaultOptions
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithCapacity: 123];
    
    XCTAssertEqualObjects(array.options, [CCCStaticObjectArray defaultOptions],
                          @"-initWithCapacity: should create CCCStaticObjectArray with default options.");
}


#pragma mark -initWithCapacity:options: tests

- (void) test_initWithCapacityOptions_positive_nonNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithCapacity: 123
                                                                         options: nil];
    
    XCTAssertNotNil(array, @"-initWithCapacity:options: returns a non-nil array when passed capacity > 0.");
}


- (void) test_initWithCapacityOptions_positive_capacityValue
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithCapacity: 123
                                                                         options: nil];
    
    XCTAssertEqual(array.capacity, (NSUInteger)123,
                   @"CCCStaticObjectArray returned by -initWithCapacity:options: should have the "
                   @"corresponding capacity value.");
}


#pragma mark -initWithObjects: tests

- (void) test_initWithObjects_nonNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithObjects: @1, @2, @3, nil];
    
    XCTAssertNotNil(array, @"-initWithObjects: returns a non-nil array when passed several objects.");
}


- (void) test_initWithObjects_capacityValue
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithObjects: @1, @2, @3, nil];
    
    XCTAssertEqual(array.capacity, (NSUInteger)3,
                   @"CCCStaticObjectArray returned by -initWithObjects: should have the "
                   @"corresponding capacity value.");
}


- (void) test_initWithObjects_nil_capacityValue
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithObjects: nil];
    
    XCTAssertEqual(array.capacity, (NSUInteger)0,
                   @"CCCStaticObjectArray returned by -initWithObjects: should have the "
                   @"corresponding capacity value.");
}


- (void) test_initWithObjects_defaultOptions
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithObjects: nil];
    
    XCTAssertEqualObjects(array.options, [CCCStaticObjectArray defaultOptions],
                          @"-initWithObjects: should create CCCStaticObjectArray with default options.");
}


#pragma mark -initWithOptions:objects: tests

- (void) test_initWithOptionsObjects_nonNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithOptions: nil objects: @1, @2, @3, nil];
    
    XCTAssertNotNil(array, @"-initWithObjects: returns a non-nil array when passed several objects.");
}


- (void) test_initWithOptionsObjects_capacityValue
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithOptions: nil objects: @1, @2, @3, nil];
    
    XCTAssertEqual(array.capacity, (NSUInteger)3,
                   @"CCCStaticObjectArray returned by -initWithObjects: should have the "
                   @"corresponding capacity value.");
}


- (void) test_initWithOptionsObjects_nil_capacityValue
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithOptions: nil objects: nil];
    
    XCTAssertEqual(array.capacity, (NSUInteger)0,
                   @"CCCStaticObjectArray returned by -initWithOptions:objects: should have the "
                   @"corresponding capacity value.");
}


#pragma mark -
#pragma mark enumeration tests

#pragma mark <NSFastEnumeration> tests

- (void) test_fastEnumeration_count_nonZero_nonNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithObjects: @1, @2, @3, @4, nil];
    
    NSUInteger count = 0;
    
    for (id object in array)
    {
        count++;
    }
    
    XCTAssertEqual(count, array.capacity, @"NSFastEnumeration should enumerate all objects in the array.");
}


- (void) test_fastEnumeration_count_nonZero_allNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithCapacity: 100];
    
    NSUInteger count = 0;
    
    for (id object in array)
    {
        count++;
    }
    
    XCTAssertEqual(count, array.capacity, @"NSFastEnumeration should enumerate all objects in the array.");
}


- (void) test_fastEnumeration_count_zero
{
    CCCStaticObjectArray *array = [CCCStaticObjectArray new];
    
    NSUInteger count = 0;
    
    for (id object in array)
    {
        count++;
    }
    
    XCTAssertEqual(count, array.capacity, @"NSFastEnumeration should enumerate all objects in the array.");
}


- (void) test_fastEnumeration_objects_nonZero_nonNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithObjects: @1, @2, @3, @4, nil];
    
    NSMutableArray *mutable = [NSMutableArray new];
    
    for (id object in array)
    {
        [mutable addObject: object];
    }
    
    XCTAssertEqualObjects(mutable, (@[@1, @2, @3, @4]),
                          @"NSFastEnumeration should enumerate all objects in the array.");
}


- (void) test_fastEnumeration_values_nonZero_allNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithCapacity: 100];
    
    NSUInteger nilCount = 0;
    NSUInteger    count = 0;
    
    for (id object in array)
    {
        if (object == nil) nilCount++;
        count++;
    }
    
    XCTAssertEqual(count, nilCount, @"NSFastEnumeration should enumerate all objects in the array including nil values.");
}


- (void) test_fastEnumeration_break
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithCapacity: 100];
    
    NSUInteger count = 0;
    
    for (id object in array)
    {
        count++;
        
        if (count == 3) break;
    }
    
    XCTAssertEqual(count, (NSUInteger)3, @"NSFastEnumeration should respect the break statement.");
}


@end
