//
//  CCIndexedGenerator.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 16.11.14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import "CCIndexedObjectGenerator.h"


#pragma mark - CCIndexedObjectGenerator private

@interface CCIndexedObjectGenerator()
@property (atomic, copy) CCIndexedObjectGeneratorBlock block;
@end


#pragma mark - CCIndexedObjectGenerator implementation

@implementation CCIndexedObjectGenerator

#pragma mark - properties

- (NSUInteger)count
{
    CCIndexedGeneratorRange normalizedRange = CCNormalizeRange(self.range);
    
    if (normalizedRange.location < 0) {
        return normalizedRange.length+normalizedRange.location;
    }
    
    return normalizedRange.length;
}


#pragma mark - initialization methods

+ (instancetype)generatorWithRange:(CCIndexedGeneratorRange)range
                    block:(CCIndexedObjectGeneratorBlock)block
{
    return [[self alloc] initWithRange: range block: block];
}


+ (instancetype)generatorWithBlock:(CCIndexedObjectGeneratorBlock)block
{
    return [[self alloc] initWithBlock: block];
}


- (instancetype)initWithRange:(CCIndexedGeneratorRange)range
                    block:(CCIndexedObjectGeneratorBlock)block
{
    if (!block) {
        @throw [self.class noBlockProvidedException];
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    self.block = block;
    _range = range;
    
    return self;
}

- (instancetype)initWithBlock:(CCIndexedObjectGeneratorBlock)block
{
    return [self initWithRange: CCMakeRange(NSIntegerMin, NSUIntegerMax)
                block: block];
}


#pragma mark - accessing objects

- (id)objectAtIndex:(NSInteger)index
{
    return self.block(index);
}


- (id)objectAtIndexedSubscript:(NSInteger)index
{
    return [self objectAtIndex: index];
}


#pragma mark - block-based enumeration (simple)

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSInteger, BOOL *))block
{
    [self enumerateObjectsWithOptions: 0
        usingBlock: block];
}


- (void)enumerateObjectsInRange:(CCIndexedGeneratorRange)range
            usingBlock:(void (^)(id, NSInteger, BOOL *))block
{
    [self enumerateObjectsInRange: range
        withOptions: 0
        usingBlock: block];
}


- (void)enumerateObjectsFromIndex:(NSInteger)startingIndex
            usingBlock:(void (^)(id, NSInteger, BOOL *))block
{
    [self enumerateObjectsFromIndex: startingIndex
        withOptions: 0
        usingBlock: block];
}


#pragma mark - block-based enumeration (with options)

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)options
            usingBlock:(void (^)(id, NSInteger, BOOL *))block
{
    [self enumerateObjectsInRange: self.range
        withOptions: options
        usingBlock: block];
}


- (void)enumerateObjectsFromIndex:(NSInteger)startingIndex
            withOptions:(NSEnumerationOptions)options
            usingBlock:(void (^)(id, NSInteger, BOOL *))block
{
    NSInteger maxValue = CCRangeMaxValue(self.range);
    CCIndexedGeneratorRange range = CCMakeRange(startingIndex, maxValue-startingIndex+1);
    
    [self enumerateObjectsInRange: range
        withOptions: options
        usingBlock: block];
}


- (void)enumerateObjectsInRange:(CCIndexedGeneratorRange)range
            withOptions:(NSEnumerationOptions)options
            usingBlock:(void (^)(id object, NSInteger index, BOOL *stop))block
{
    if (!block) {
        @throw [[self class] noBlockProvidedException];
    }
    
    CCIndexedGeneratorRange normalizedRange = CCNormalizeRange(range);
    
    if (options & NSEnumerationConcurrent) { // Concurrent enumeration
        __block BOOL stop = NO;
        
        // Concurrent enumeration does not respect the NSEnumerationReverse option
        dispatch_apply(normalizedRange.length, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            ^(size_t i) {
                if (!stop) {
                    NSInteger index = normalizedRange.location + i;
                    block([self objectAtIndex: index], index, &stop);
                }
            });
    }
    else { // Sequential enumeration
        BOOL stop = NO;
        
        if (options & NSEnumerationReverse) { // Reverse sequential enumeration
            for (NSInteger i = normalizedRange.length; i > 0; --i) {
                NSInteger index = normalizedRange.location + i - 1;
                
                block([self objectAtIndex: index], index, &stop);
                
                if (stop) {
                    break;
                }
            }
        }
        else { // Forward sequential enumeration
            for (NSInteger i = 0; i < normalizedRange.length; ++i) {
                NSInteger index = normalizedRange.location + i;
                
                block([self objectAtIndex: index], index, &stop);
                
                if (stop) {
                    break;
                }
            }
        } // if (options & NSEnumerationReverse)
    } // if (options & NSEnumerationConcurrent)
}


#pragma mark -
#pragma mark <NSFastEnumeration>

typedef struct {
    NSInteger index;
    NSUInteger zeroIndex;
    __unsafe_unretained id object;
} _CCFiniteIndexedObjectGeneratorEnumerationState;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                  objects:(id __unsafe_unretained [])buffer
                  count:(NSUInteger)len
{
    // See https://mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html
    
    if (state->state == 0) {
        // This should detect block change, but we cannot detect
        // the case when values returned from the block for the same
        // index would be different.
        state->mutationsPtr = (__bridge void *)self.block;
        
        _CCFiniteIndexedObjectGeneratorEnumerationState initialState = { self.range.location, 0, nil };
        *(_CCFiniteIndexedObjectGeneratorEnumerationState *)state->extra = initialState;
        state->state = 1;
    }
    else if (state->state == 2)
    {
        return 0;
    }
    
    _CCFiniteIndexedObjectGeneratorEnumerationState enumState =
        *(_CCFiniteIndexedObjectGeneratorEnumerationState *)state->extra;

    enumState.object = [self objectAtIndex: enumState.index];
    state->itemsPtr = &enumState.object;
    
    if ((enumState.index <= NSIntegerMax) && (enumState.zeroIndex < self.range.length)) {
        if (enumState.index < NSIntegerMax) {
            enumState.index ++;
            enumState.zeroIndex ++;
        }
        else {
            enumState.zeroIndex = self.range.length;
        }
        
        *(_CCFiniteIndexedObjectGeneratorEnumerationState *)state->extra = enumState;
        
        return 1;
    }
    else {
        return 0;
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
