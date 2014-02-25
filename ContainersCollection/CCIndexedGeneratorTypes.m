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