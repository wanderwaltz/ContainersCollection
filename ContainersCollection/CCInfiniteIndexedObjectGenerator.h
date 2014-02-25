//
//  CCInfiniteIndexedObjectGenerator.h
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 25/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCIndexedGeneratorTypes.h"

// TODO: fast enumeration
// TODO: search
// TODO: concurrent block-based enumeration

#pragma mark -
#pragma mark CCInfiniteIndexedObjectGenerator interface

@interface CCInfiniteIndexedObjectGenerator : NSObject


#pragma mark initialization methods

+ (instancetype) generatorWithBlock: (CCIndexedObjectGeneratorBlock) block;
- (instancetype) initWithBlock:      (CCIndexedObjectGeneratorBlock) block;


#pragma mark accessing objects

- (id) objectAtIndex:            (NSInteger) index;
- (id) objectAtIndexedSubscript: (NSInteger) index;


#pragma mark enumeration

- (void) enumerateObjectsInRange: (CCIndexedGeneratorRange) range
                       withBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block;

- (void) enumerateObjectsFromIndex: (NSInteger) startingIndex
                         withBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block;



@end
