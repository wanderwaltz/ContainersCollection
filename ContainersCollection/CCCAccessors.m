//
//  CCCAccessors.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 19/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#if (__has_feature(objc_arc))
#error "This file should be compiled with ARC disabled"
#endif

#import "CCCAccessors.h"


BOOL CCCSetterRetain(id* addr, id value)
{
    id previous = *addr;
       *addr    = [value retain];
    [previous release];
    return YES;
}


BOOL CCCSetterAssign(id* addr, id value)
{
    *addr = value;
    return YES;
}


BOOL CCCSetterCopy(id* addr, id value)
{
    id previous = *addr;
          *addr = [value copy];
    [previous release];
    return YES;
}


id CCCGetterRetainAutorelease(id* addr)
{
    return [[*addr retain] autorelease];
}


id CCCGetterRaw(id* addr)
{
    return *addr;
}