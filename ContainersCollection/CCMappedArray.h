//
//  CCCMappedArray.h
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 28/03/15.
//  Copyright (c) 2015 Frostbit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^CCMappedArrayMapperBlock)(id object, NSUInteger index);

@interface CCMappedArray : NSArray

- (instancetype)initWithArray:(NSArray *)array
                       mapper:(CCMappedArrayMapperBlock)block NS_DESIGNATED_INITIALIZER;

+ (instancetype)arrayWithArray:(NSArray *)array
                        mapper:(CCMappedArrayMapperBlock)block;

@end



@interface NSArray(CCMappedArray)

- (NSArray *)arrayByApplyingMapping:(CCMappedArrayMapperBlock)mapping;

+ (instancetype)arrayWithArray:(NSArray *)array
                        mapper:(CCMappedArrayMapperBlock)block;

@end