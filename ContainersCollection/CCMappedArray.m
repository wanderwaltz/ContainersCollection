//
//  CCMappedArray.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 28/03/15.
//  Copyright (c) 2015 Frostbir. All rights reserved.
//

#import "CCMappedArray.h"

@interface CCMappedArray()
@property (nonatomic, strong, readonly) NSArray *originalArray;
@property (nonatomic, copy, readonly) CCMappedArrayMapperBlock mapper;
@end

@implementation CCMappedArray

#pragma mark - initializers

+ (instancetype)arrayWithArray:(NSArray *)array
                        mapper:(CCMappedArrayMapperBlock)block
{
    return [[self alloc] initWithArray: array
                                mapper: block];
}


- (instancetype)initWithArray:(NSArray *)array
                       mapper:(CCMappedArrayMapperBlock)block
{
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _originalArray = [array copy];
    _mapper = [block copy];
    
    return self;
}


#pragma mark - NSArray designated initializers

- (instancetype)init
{
    return [self initWithArray: @[] mapper: nil];
}


- (instancetype)initWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    return [self initWithArray: [[NSArray alloc] initWithObjects: objects count: cnt]
                        mapper: nil];
}

#pragma mark - NSArray primitives

- (NSUInteger)count
{
    return self.originalArray.count;
}


- (id)objectAtIndex:(NSUInteger)index
{
    id result = [self.originalArray objectAtIndex: index];
    
    if (self.mapper != nil) {
        result = self.mapper(result, index) ?: [NSNull null];
    }
    
    return result;
}


#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    // Immutable; don't need to copy
    return self;
}


#pragma mark - <NSMutableCopying>

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [[NSMutableArray allocWithZone: zone] initWithArray: self];
}


#pragma mark - <NSCoding>

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSArray *original = [[NSArray alloc] initWithCoder: aDecoder];
    return [self initWithArray: original mapper: nil];
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Cannot encode the mapper block so encode the mapped array as an NSArray instead
    NSArray *mapped = [[NSArray alloc] initWithArray: self];
    [mapped encodeWithCoder: aCoder];
}

@end




@implementation NSArray(CCMappedArray)

- (NSArray *)arrayByApplyingMapping:(CCMappedArrayMapperBlock)mapping
{
    return [CCMappedArray arrayWithArray: self mapper: mapping];
}

+ (instancetype)arrayWithArray:(NSArray *)array
                        mapper:(CCMappedArrayMapperBlock)block
{
    return [CCMappedArray arrayWithArray: array
                                  mapper: block];
}

@end