//
//  CCIndexedGeneratorTypes.h
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 25/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark Typedefs

typedef struct
{
    NSInteger  location;
    NSUInteger length;
} CCIndexedGeneratorRange;

typedef id (^CCIndexedObjectGeneratorBlock)(NSInteger index);


#pragma mark -
#pragma mark Functions

CCIndexedGeneratorRange CCMakeRange(NSInteger location, NSUInteger length) __attribute__((const));
CCIndexedGeneratorRange CCRangeFromNSRange(NSRange range)                  __attribute__((const));