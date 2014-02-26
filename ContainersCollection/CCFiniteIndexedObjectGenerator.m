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
{
@private
    __unsafe_unretained id _enumeratedObject;
}

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
    
    // We need to check the integer overflow here, so we can't actually
    // add a loop variable to self.range.location to get the resulting
    // index. Instead we have two loop variables and either of them
    // overflowing the maximum value will result in stopping the loop.
    NSInteger      index = self.range.location;
    NSUInteger zeroIndex = 0;
    
    for (/*already initialized*/; zeroIndex < self.range.length; ++zeroIndex, ++index)
    {
        block([self objectAtIndex: index], index, &stop);
        
        if (index == NSIntegerMax) break;
        
        if (stop)
        {
            break;
        }
    }
}


#pragma mark -
#pragma mark <NSFastEnumeration>

typedef struct
{
    NSInteger      index;
    NSUInteger zeroIndex;
} _CCFiniteIndexedObjectGeneratorEnumerationState;

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState *)  state
                                   objects: (id __unsafe_unretained []) buffer
                                     count: (NSUInteger) len
{
    // See https://mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html
    
    if (state->state == 0)
    {
        // This should detect block change, but we cannot detect
        // the case when values returned from the block for the same
        // index would be different.
        state->mutationsPtr = (__bridge void *)self.block;
        
        _CCFiniteIndexedObjectGeneratorEnumerationState     initialState = { self.range.location, 0 };
        *(_CCFiniteIndexedObjectGeneratorEnumerationState *)state->extra = initialState;
        state->state = 1;
    }
    else if (state->state == 2)
    {
        return 0;
    }
    
    
    _CCFiniteIndexedObjectGeneratorEnumerationState enumState =
    *(_CCFiniteIndexedObjectGeneratorEnumerationState *)state->extra;

    _enumeratedObject = [self objectAtIndex: enumState.index];
    state->itemsPtr   = &_enumeratedObject;
    
    if ((enumState.index <= NSIntegerMax) && (enumState.zeroIndex < self.range.length))
    {
        if (enumState.index < NSIntegerMax)
        {
            enumState.index     ++;
            enumState.zeroIndex ++;
        }
        else
        {
            enumState.zeroIndex = self.range.length;
        }
        
        *(_CCFiniteIndexedObjectGeneratorEnumerationState *)state->extra = enumState;
        
        return 1;
    }
    else
    {
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
