//
//  CCFiniteIndexedObjectGenerator.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 25/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "CCFiniteIndexedObjectGenerator.h"


#pragma mark -
#pragma mark CCFiniteIndexedObjectGenerator private

@interface CCFiniteIndexedObjectGenerator()
@property (copy, nonatomic) CCIndexedObjectGeneratorBlock block;
@end


#pragma mark -
#pragma mark CCFiniteIndexedObjectGenerator implementation

@implementation CCFiniteIndexedObjectGenerator

#pragma mark -
#pragma mark properties

- (NSUInteger) count
{
    return _range.length;
}


#pragma mark -
#pragma mark initialization methods

+ (instancetype) generatorWithRange: (CCIndexedGeneratorRange) range
                              block: (CCIndexedObjectGeneratorBlock) block
{
    return [[self alloc] initWithRange: range
                                 block: block];
}


- (instancetype) initWithRange: (CCIndexedGeneratorRange) range
                         block: (CCIndexedObjectGeneratorBlock) block
{
    if (block == nil) @throw [[self class] noBlockProvidedException];
    
    self = [super init];
    
    if (self != nil)
    {
        _range     = range;
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

- (void) enumerateObjectsWithBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block
{
    if (block == nil) @throw [[self class] noBlockProvidedException];
    
    BOOL stop = NO;
    
    for (int64_t i = 0; i < self.range.length; ++i)
    {
        int64_t index = self.range.location + i;
        
        if (index > NSIntegerMax) break;
        
        block([self objectAtIndex: (NSInteger)index], (NSInteger)index, &stop);
        
        if (stop)
        {
            break;
        }
    }
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
