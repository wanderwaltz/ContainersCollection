//
//  CCIndexedGenerator.h
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 16.11.14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCIndexedGeneratorTypes.h"


#pragma mark - CCIndexedObjectGenerator class cluster

@interface CCIndexedObjectGenerator : NSObject<NSFastEnumeration>
@property (nonatomic, readonly) CCIndexedGeneratorRange range;

#pragma mark initialization

+ (instancetype)generatorWithRange:(CCIndexedGeneratorRange)range
                    block:(CCIndexedObjectGeneratorBlock)block;

+ (instancetype)generatorWithBlock:(CCIndexedObjectGeneratorBlock)block;


- (instancetype)initWithRange:(CCIndexedGeneratorRange)range
                    block:(CCIndexedObjectGeneratorBlock)block;

- (instancetype)initWithBlock:(CCIndexedObjectGeneratorBlock)block;


#pragma mark accessing objects

- (id)objectAtIndex:(NSInteger)index;
- (id)objectAtIndexedSubscript:(NSInteger)index;


#pragma mark enumeration (simple)

- (void)enumerateObjectsUsingBlock:(void (^)(id object, NSInteger index, BOOL *stop))block;

- (void)enumerateObjectsInRange:(CCIndexedGeneratorRange)range
            usingBlock: (void (^)(id object, NSInteger index, BOOL *stop))block;

- (void)enumerateObjectsFromIndex:(NSInteger)startingIndex
            usingBlock:(void (^)(id object, NSInteger index, BOOL *stop))block;


#pragma mark enumeration (with options)

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)options
            usingBlock:(void (^)(id object, NSInteger index, BOOL *stop))block;

- (void)enumerateObjectsInRange:(CCIndexedGeneratorRange)range
            withOptions:(NSEnumerationOptions)options
            usingBlock: (void (^)(id object, NSInteger index, BOOL *stop))block;

- (void)enumerateObjectsFromIndex:(NSInteger)startingIndex
            withOptions:(NSEnumerationOptions)options
            usingBlock:(void (^)(id object, NSInteger index, BOOL *stop))block;

@end
