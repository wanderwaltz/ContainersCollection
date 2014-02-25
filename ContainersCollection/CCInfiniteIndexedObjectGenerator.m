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
        
    }
    return self;
}


#pragma mark -
#pragma mark accessing objects

- (id) objectAtIndex: (NSInteger) index
{
    
}


- (id) objectAtIndexedSubscript: (NSInteger) index
{
    
}


#pragma mark -
#pragma mark enumeration

- (void) enumerateObjectsInRange: (CCIndexedGeneratorRange) range
                       withBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block
{
    
}


- (void) enumerateObjectsFromIndex: (NSInteger) startingIndex
                         withBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block
{
    [self enumerateObjectsInRange: CCMakeRange(startingIndex, )
                        withBlock: block];
}

@end
