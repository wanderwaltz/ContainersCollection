//
//  CCCAccessors.h
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 19/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (*CCCSetterPtr)(id* addr, id value);
typedef id   (*CCCGetterPtr)(id* addr);


BOOL CCCSetterRetain(id* addr, id value);
BOOL CCCSetterAssign(id* addr, id value);
BOOL CCCSetterCopy  (id* addr, id value);

id CCCGetterRetainAutorelease(id* addr);
id CCCGetterRaw(id* addr);