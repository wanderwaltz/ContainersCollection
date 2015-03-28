//
//  CCMappedArrayTests.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 28/03/15.
//  Copyright (c) 2015 Frostbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CCMappedArray.h"

@interface CCMappedArrayTests : XCTestCase
@end

@implementation CCMappedArrayTests

#pragma mark - empty CCMappedArray

- (void)test_empty_hasZeroCount
{
    NSArray *mapped = [CCMappedArray array];
    XCTAssertEqual(mapped.count, 0u, @"Empty mapped array should have count of zero");
}


#pragma mark - identity mapping

- (void)test_nilMapper_count
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]];
    XCTAssertEqual(mapped.count, 3u, @"Nil mapper should not change the count of the elements");
}

- (void)test_nilMapper_isIdentity
{
    NSArray *original = @[@1, @2, @3];
    NSArray *mapped = [CCMappedArray arrayWithArray: original];
    XCTAssertEqualObjects(mapped, original,
                          @"Initializing mapped array without a mapping should yield identity mapping");
}


#pragma mark - mapping

- (void)test_mappingDoesNotChangeCount
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    
    XCTAssertEqual(mapped.count, 3u, @"Mapped array should not change the count of items inside the array");
}


- (void)test_mapping_nonNil
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    
    NSArray *expected = @[@2, @4, @6];
    
    XCTAssertEqualObjects(mapped, expected,
                          @"Mapped array should apply mapper block to each of the original array elements");
}


- (void)test_mapping_nil
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return ([object integerValue] % 2 == 0) ? object : nil;
                                             }];
    
    NSArray *expected = @[[NSNull null], @2, [NSNull null]];
    
    XCTAssertEqualObjects(mapped, expected,
                          @"nil values returned from the mapper block should be represented as NSNulls");
}


#pragma mark - lazy evaluation

- (void)test_mapperIsNotInvokedToGetCount
{
    __block NSUInteger timesBlockCalled = 0;
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 timesBlockCalled++;
                                                 return @([object integerValue] * 2);
                                             }];
    
    [mapped count];
    XCTAssertEqual(timesBlockCalled, 0u, @"Mapper block should not be invoked to return count of the elements");
}


- (void)test_mapperIsInvokedPerElement
{
    __block NSUInteger timesBlockCalled = 0;
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 timesBlockCalled++;
                                                 return @([object integerValue] * 2);
                                             }];
    
    [mapped objectAtIndex: 2];
    XCTAssertEqual(timesBlockCalled, 1u, @"Mapper block should be invoked only when accessing elements");
}


#pragma mark - immutability

- (void)test_mappingImmutable
{
    NSMutableArray *mutable = [NSMutableArray arrayWithObjects: @1, @2, @3, nil];
    NSArray *mapped = [CCMappedArray arrayWithArray: mutable
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    
    XCTAssertFalse([mapped isKindOfClass: [NSMutableArray class]], @"Mapped array should be immutable");
}


- (void)test_mappingCopiesOriginal
{
    NSMutableArray *mutable = [NSMutableArray arrayWithObjects: @1, @2, @3, nil];
    NSArray *mapped = [CCMappedArray arrayWithArray: mutable
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    
    [mutable addObject: @4];
    
    NSArray *expected = @[@2, @4, @6];
    
    XCTAssertEqualObjects(mapped, expected, @"Mapped array should copy the original array");
}


#pragma mark - <NSCopying>

- (void)test_copy_kind
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    NSArray *clone = [mapped copy];
    
    XCTAssertTrue([clone isKindOfClass: [CCMappedArray class]],
                  @"copying mapped array should result in mapped array");
}


- (void)test_copy_equal
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    
    NSArray *clone = [mapped copy];
    
    XCTAssertEqualObjects(mapped, clone, @"copying mapped array should result in equal array");
}


#pragma mark - <NSMutableCopying>

- (void)test_mutableCopy_kind
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    NSArray *clone = [mapped mutableCopy];
    
    XCTAssertTrue([clone isKindOfClass: [NSMutableArray class]],
                  @"mutable copy of mapped array should be kind of NSMutableArray");
}


- (void)test_mutableCopy_equal
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    NSArray *clone = [mapped mutableCopy];
    
    XCTAssertEqualObjects(mapped, clone, @"mutable copying mapped array should result in equal array");
}


- (void)test_mutableCopy_differentIdentity
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    
    NSMutableArray *clone = [mapped mutableCopy];
    [clone addObject: @8];
    
    XCTAssertNotEqualObjects(mapped, clone, @"mutable copy of mapped array should be independent of the original");
}


#pragma mark - <NSCoding>

- (void)test_encodingDeconding
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    
    NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject: mapped];
    NSArray *decoded = [NSKeyedUnarchiver unarchiveObjectWithData: encoded];
    
    XCTAssertEqualObjects(mapped, decoded, @"Mapped array should be able to be encoded/decoded with NSCoder");
}


#pragma mark - NSArray integration

- (void)test_fastEnumeration
{
    NSMutableArray *enumerated = [NSMutableArray new];
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    
    for (id object in mapped) {
        [enumerated addObject: object];
    }
    
    XCTAssertEqualObjects(mapped, enumerated, @"Mapped array should support fast enumeration");
}


- (void)test_indexedSubscripting
{
    NSArray *mapped = [CCMappedArray arrayWithArray: @[@1, @2, @3]
                                             mapper:^id(id object, NSUInteger index) {
                                                 return @([object integerValue] * 2);
                                             }];
    
    XCTAssertEqualObjects(mapped[1], @4, @"Mapped array should support indexed subscripting");
}

@end
