//
//  CCIndexedGeneratorTypes.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 25/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import "CCIndexedGeneratorTypes.h"

CCIndexedGeneratorRange CCMakeRange(NSInteger location, NSUInteger length)
{
    CCIndexedGeneratorRange range;
    range.location = location;
    range.length   = length;
    
    return range;
}


CCIndexedGeneratorRange CCRangeFromNSRange(NSRange nsrange)
{
    CCIndexedGeneratorRange range;
    range.location = nsrange.location;
    range.length   = nsrange.length;
    
    return range;
}


NSInteger CCRangeMaxValue(CCIndexedGeneratorRange range)
{
    CCIndexedGeneratorRange normalizedRange = CCNormalizeRange(range);
    return normalizedRange.location+normalizedRange.length-1;
}


CCIndexedGeneratorRange CCNormalizeRange(CCIndexedGeneratorRange range)
{
    BOOL uint_overflow = NSUIntegerMax - range.length < range.location;
    
    // Detect if we're overflowing the NSUInteger range
    if (uint_overflow)
    {
        range.length = NSUIntegerMax-range.location+1;
    }
    
    // Detect if we're overflowing the NSInteger range
    NSUInteger right = range.length + range.location;
    
    if (right > (NSUInteger)NSIntegerMax)
    {
        range.length = NSIntegerMax-range.location+1;
    }
    
    return range;
}