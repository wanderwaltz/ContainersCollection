//
//  CCCStaticObjectArrayTests.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 18/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/message.h>
#import "CCCStaticObjectArray.h"


#pragma mark -
#pragma mark CCCStaticObjectArrayTests interface

@interface CCCStaticObjectArrayTests : XCTestCase
@end


#pragma mark -
#pragma mark CCCStaticObjectArrayTests implementation

@implementation CCCStaticObjectArrayTests

#pragma mark -
#pragma mark initialization tests

#pragma mark -init tests

- (void) test_init_throws
{
    XCTAssertThrows([CCCStaticObjectArray valueForKeyPath: @"alloc.init"],
                    @"Sending -init message should throw an exception.");
}


- (void) test_new_throws
{
    XCTAssertThrows([CCCStaticObjectArray performSelector: @selector(new)],
                    @"Sending +new message should throw an exception.");
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
    
    XCTAssertEqual(array.capacity, 123u,
                   @"CCCStaticObjectArray returned by -initWithCapacity: should have the "
                   @"corresponding capacity value.");
}


- (void) test_initWithCapacity_zero_throws
{
    XCTAssertThrows([[CCCStaticObjectArray alloc] initWithCapacity: 0],
                    @"-initWithCapacity: should throw an exception if passed capacity == 0");
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
    
    XCTAssertEqual(array.capacity, 123u,
                   @"CCCStaticObjectArray returned by -initWithCapacity:options: should have the "
                   @"corresponding capacity value.");
}


- (void) test_initWithCapacityOptions_zero_throws
{
    XCTAssertThrows([[CCCStaticObjectArray alloc] initWithCapacity: 0
                                                           options: nil],
                    @"-initWithCapacity:options: should throw an exception if passed capacity == 0");
}


#pragma mark -initWithObjects: tests

- (void) test_initWithObjects_nil_throws
{
    XCTAssertThrows([[CCCStaticObjectArray alloc] initWithObjects: nil],
                    @"-initWithObjects: should throw an exception if passed only a single nil value");
}


- (void) test_initWithObjects_nonNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithObjects: @1, @2, @3, nil];
    
    XCTAssertNotNil(array, @"-initWithObjects: returns a non-nil array when passed several objects.");
}


- (void) test_initWithObjects_capacityValue
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithObjects: @1, @2, @3, nil];
    
    XCTAssertEqual(array.capacity, 3u,
                   @"CCCStaticObjectArray returned by -initWithObjects: should have the "
                   @"corresponding capacity value.");
}


#pragma mark -initWithOptions:objects: tests

- (void) test_initWithOptionsObjects_nil_throws
{
    XCTAssertThrows([[CCCStaticObjectArray alloc] initWithOptions: nil objects: nil],
                    @"-initWithOptions:objects: should throw an exception if passed only a single nil value");
}


- (void) test_initWithOptionsObjects_nonNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithOptions: nil objects: @1, @2, @3, nil];
    
    XCTAssertNotNil(array, @"-initWithObjects: returns a non-nil array when passed several objects.");
}


- (void) test_initWithOptions:objects_capacityValue
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithOptions: nil objects: @1, @2, @3, nil];
    
    XCTAssertEqual(array.capacity, 3u,
                   @"CCCStaticObjectArray returned by -initWithObjects: should have the "
                   @"corresponding capacity value.");
}


@end
