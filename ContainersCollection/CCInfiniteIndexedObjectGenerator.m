//
//  CCInfiniteIndexedObjectGenerator.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 25/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "CCInfiniteIndexedObjectGenerator.h"


#pragma mark -
#pragma mark CCInfiniteIndexedObjectGenerator private

@interface CCInfiniteIndexedObjectGenerator()
@property (copy, nonatomic) CCIndexedObjectGeneratorBlock block;
@end


#pragma mark -
#pragma mark CCInifiniteIndexedObjectGenerator implementation

@implementation CCInfiniteIndexedObjectGenerator

#pragma mark -
#pragma mark initialization methods

+ (instancetype) generatorWithBlock: (CCIndexedObjectGeneratorBlock) block
{
    return [[self alloc] initWithBlock: block];
}


- (instancetype) initWithBlock: (CCIndexedObjectGeneratorBlock) block
{
    self = [super init];
    
    if (self != nil)
    {
        self.block = block;
    }
    return self;
}


#pragma mark -
#pragma mark accessing objects

- (id) objectAtIndex: (NSInteger) index
{
    return self.block(index);
}


- (id) objectAtIndexedSubscript: (NSInteger) index
{
    return [self objectAtIndex: index];
}


#pragma mark -
#pragma mark enumeration

- (void) enumerateObjectsInRange: (CCIndexedGeneratorRange) range
                       withBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block
{
    if (block == nil) @throw [[self class] noBlockProvidedException];
    
    BOOL stop = NO;
    
    for (int64_t i = 0; i < range.length; ++i)
    {
        int64_t index = range.location + i;
        
        if (index > NSIntegerMax) break;
        
        block([self objectAtIndex: (NSInteger)index], (NSInteger)index, &stop);
        
        if (stop)
        {
            break;
        }
    }
}


- (void) enumerateObjectsFromIndex: (NSInteger) startingIndex
                         withBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block
{
    [self enumerateObjectsInRange: CCMakeRange(startingIndex, NSUIntegerMax)
                        withBlock: block];
}


#pragma mark -
#pragma mark exceptions

+ (NSException *) noBlockProvidedException
{
    return [NSException exceptionWithName: NSInvalidArgumentException
                                   reason: @"A non-nil block parameter is expected."
                                 userInfo: nil];
}

@end
