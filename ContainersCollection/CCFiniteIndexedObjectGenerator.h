//
//  CCFiniteIndexedObjectGenerator.h
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 25/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCIndexedGeneratorTypes.h"

// TODO: optional range checking
// TODO: cyclic ranges
// TODO: search

#pragma mark -
#pragma mark CCFiniteIndexedObjectGenerator interface

@interface CCFiniteIndexedObjectGenerator : NSObject<NSFastEnumeration>

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

- (void) enumerateObjectsUsingBlock:  (void (^)(id object, NSInteger index, BOOL *stop)) block;
- (void) enumerateObjectsWithOptions: (NSEnumerationOptions) options
                          usingBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block;

@end
