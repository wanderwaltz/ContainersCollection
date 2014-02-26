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

- (void) enumerateObjectsUsingBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block
{
    [self enumerateObjectsWithOptions: 0
                           usingBlock: block];
}


- (void) enumerateObjectsWithOptions: (NSEnumerationOptions) options
                          usingBlock: (void (^)(id object, NSInteger index, BOOL *stop)) block
{
    if (block == nil) @throw [[self class] noBlockProvidedException];
    
    CCIndexedGeneratorRange normalizedRange = CCNormalizeRange(self.range);
    
    if (options & NSEnumerationConcurrent) // Concurrent enumeration
    {
        __block BOOL stop = NO;
        
        if (options & NSEnumerationReverse) // Reverse concurrent enumeration
        {
            dispatch_apply(normalizedRange.length, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                           ^(size_t i) {
                               if (!stop)
                               {
                                   NSInteger index = normalizedRange.location + normalizedRange.length - 1 - i;
                                   
                                   block([self objectAtIndex: index], index, &stop);
                               }
                           });
        }
        else // Forward concurrent enumeration
        {
            dispatch_apply(normalizedRange.length, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                           ^(size_t i) {
                               if (!stop)
                               {
                                   NSInteger index = normalizedRange.location + i;
                                   
                                   block([self objectAtIndex: index], index, &stop);
                               }
                           });
        }
    }
    else // Sequential enumeration
    {
        BOOL stop = NO;
        
        if (options & NSEnumerationReverse) // Reverse sequential enumeration
        {
            for (NSInteger i = normalizedRange.length; i > 0; --i)
            {
                NSInteger index = normalizedRange.location + i - 1;
                
                block([self objectAtIndex: index], index, &stop);
                
                if (stop)
                {
                    break;
                }
            }
        }
        else // Forward sequential enumeration
        {
            for (NSInteger i = 0; i < normalizedRange.length; ++i)
            {
                NSInteger index = normalizedRange.location + i;
                
                block([self objectAtIndex: index], index, &stop);
                
                if (stop)
                {
                    break;
                }
            }
        }
    }
}


#pragma mark -
#pragma mark <NSFastEnumeration>

typedef struct
{
    NSInteger      index;
    NSUInteger zeroIndex;
    __unsafe_unretained id object;
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
        
        _CCFiniteIndexedObjectGeneratorEnumerationState     initialState = { self.range.location, 0, nil };
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
    state->itemsPtr  = &enumState.object;
    
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
