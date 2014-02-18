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


- (void) test_initWithCapacity_positive_nonNil
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithCapacity: 123];
    
    XCTAssertNotNil(array, @"-initWithCapacity: returns a non-nil array when passed capacity > 0.");
}


- (void) test_initWithCapacity_positive_capacityValue
{
    CCCStaticObjectArray *array = [[CCCStaticObjectArray alloc] initWithCapacity: 123];
    
    XCTAssertEqual(array.capacity, 123,
                   @"CCCStaticObjectArray returned by -initWithCapacity: should have the "
                   @"corresponding capacity value.");
}


- (void) test_initWithCapacity_zero_throws
{
    XCTAssertThrows([[CCCStaticObjectArray alloc] initWithCapacity: 0],
                    @"-initWithCapacity: should throw an exception if passed capacity == 0");
}

@end
