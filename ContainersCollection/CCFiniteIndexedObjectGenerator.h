//
//  CCFiniteIndexedObjectGenerator.h
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 25/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCIndexedGeneratorTypes.h"

// TODO: fast enumeration
// TODO: optional range checking
// TODO: cyclic ranges
// TODO: search
// TODO: concurrent block-based enumeration

#pragma mark -
#pragma mark CCFiniteIndexedObjectGenerator interface

@interface CCFiniteIndexedObjectGenerator : NSObject
@property (readonly, nonatomic) CCIndexedGeneratorRange range;
@property (readonly, nonatomic) NSUInteger              count;


#pragma mark initialization methods

+ (instancetype) generatorWithRange: (CCIndexedGeneratorRange) range
                              block: (CCIndexedObjectGeneratorBlock) block;

- (instancetype) initWithRange: (CCIndexedGeneratorRange) range
                         block: (CCIndexedObjectGeneratorBlock) block;


#pragma mark accessing objects

- (id) objectAtIndex:            (NSInteger) index;
- (id) objectAtIndexedSubscript: (NSInteger) index;


#pragma mark enumeration

- (void) enumerateObjectsWithBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block;

@end
