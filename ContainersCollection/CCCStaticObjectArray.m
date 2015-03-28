//
//  CCCStaticObjectArray.m
//  ContainersCollection
//
//  Created by Egor Chiglintsev on 18/02/14.
//  Copyright (c) 2014 Frostbit. All rights reserved.
//

#if (__has_feature(objc_arc))
#error "This file should be compiled with ARC disabled"
#endif

#import "CCCStaticObjectArray.h"
#import "CCCAccessors.h"


#pragma mark -
#pragma mark Static helper functions

static NSDictionary *DefaultOptions(void)
{
    return @{ @(CCCStaticObjectArrayOptionSetterPolicy) : @(CCCStaticObjectArraySetterPolicyDefault),
              @(CCCStaticObjectArrayOptionGetterPolicy) : @(CCCStaticObjectArrayGetterPolicyDefault) };
}


static NSDictionary *OverrideDefaultOptions(NSDictionary *optionsToOverride)
{
    NSMutableDictionary *options = [DefaultOptions() mutableCopy];
    
    [optionsToOverride enumerateKeysAndObjectsUsingBlock:
     ^(id key, id obj, BOOL *stop) {
         options[key] = obj;
     }];
    
    NSDictionary *immutable = [options copy];
    
    [options release];
    
    return [immutable autorelease];
}


static CCCSetterPtr SetterForCCCStaticObjectArraySetterPolicy(CCCStaticObjectArraySetterPolicy policy)
{
    switch (policy)
    {
        case CCCStaticObjectArraySetterPolicyAssign: return CCCSetterAssign; break;
        case CCCStaticObjectArraySetterPolicyRetain: return CCCSetterRetain; break;
        case CCCStaticObjectArraySetterPolicyCopy:   return CCCSetterCopy;   break;
            
        default: return nil; break;
    }
}


static CCCGetterPtr GetterForCCCStaticObjectArrayGetterPolicy(CCCStaticObjectArrayGetterPolicy policy)
{
    switch (policy)
    {
        case CCCStaticObjectArrayGetterPolicyRetainAutorlease: return CCCGetterRetainAutorelease; break;
        case CCCStaticObjectArrayGetterPolicyRaw:              return CCCGetterRaw;               break;
            
        default: return nil; break;
    }
}




#pragma mark -
#pragma mark CCCStaticObjectArray private

@interface CCCStaticObjectArray()
{
@private
    /// array of objects stored in the container
    id* _objects;
    
    CCCGetterPtr _getter;
    CCCSetterPtr _setter;
    
    unsigned long _mutationFlag;
}

@end


#pragma mark -
#pragma mark CCCStaticObjectArray implementation

@implementation CCCStaticObjectArray

#pragma mark - properties

- (NSUInteger)count
{
    return self.capacity;
}

#pragma mark -
#pragma mark initialization methods

- (void)dealloc
{
    for (NSInteger i = 0; i < _capacity; ++i) {
        [self setObject: nil atIndex: i];
    }
    
    free(_objects); _objects = nil;
    
    [_options release]; _options = nil;
    
    _getter = NULL;
    _setter = NULL;
    
    [super dealloc];
}


- (instancetype)init
{
    return [self initWithCapacity: 0
                options: DefaultOptions()];
}


- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    return [self initWithCapacity: capacity
                options: DefaultOptions()];
}


- (instancetype)initWithCapacity:(NSUInteger)capacity
                    options:(NSDictionary *)options
{
    self = [super init];
    
    if (self != nil) {
        _capacity = capacity;
        
        if (_capacity > 0)
        {
            _objects = calloc(capacity, sizeof(id));
        }
        else
        {
            _objects = NULL;
        }
        
        _options = [OverrideDefaultOptions(options) retain];
        
        
        CCCStaticObjectArrayGetterPolicy getterPolicy =
        [_options[@(CCCStaticObjectArrayOptionGetterPolicy)] integerValue];
        
        CCCStaticObjectArraySetterPolicy setterPolicy =
        [_options[@(CCCStaticObjectArrayOptionSetterPolicy)] integerValue];
        
        
        _getter  = GetterForCCCStaticObjectArrayGetterPolicy(getterPolicy);
        _setter  = SetterForCCCStaticObjectArraySetterPolicy(setterPolicy);
    }
    
    return self;
}


- (instancetype)initWithArray:(NSArray *)array
{
    return [self initWithArray: array
                options: DefaultOptions()];
}


- (instancetype)initWithArray:(NSArray *)array
                    options:(NSDictionary *)options
{
    self = [self initWithCapacity: array.count
                          options: options];
    
    if (self != nil)
    {
        [array enumerateObjectsUsingBlock:
         ^(id object, NSUInteger index, BOOL *stop) {
             
             [self setObject: object atIndex: index];
             
         }];
    }
    return self;
}



#define Synthesize_initWithObjectsOptions(Options)  \
if (firstObject != nil) {                           \
    NSUInteger count = 1;                           \
                                                    \
    va_list args;                                   \
    va_start(args, firstObject);                    \
                                                    \
    while (va_arg(args, id) != nil) count++;        \
                                                    \
    va_end(args);                                   \
                                                    \
    self = [self initWithCapacity: count            \
                options: Options];                  \
                                                    \
    if (self != nil) {                              \
        [self setObject: firstObject atIndex: 0];   \
        NSUInteger i = 1;                           \
        id arg       = nil;                         \
                                                    \
        va_start(args, firstObject);                \
                                                    \
        while ((arg = va_arg(args, id))) {          \
            [self setObject: arg atIndex: i];       \
            i++;                                    \
        }                                           \
                                                    \
        va_end(args);                               \
    }                                               \
    return self;                                    \
}                                                   \
else {                                              \
    return [self initWithCapacity: 0                \
                options: Options];                  \
}


- (instancetype)initWithObjects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    Synthesize_initWithObjectsOptions(DefaultOptions());
}


- (instancetype)initWithOptions:(NSDictionary *)options
                     objects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    Synthesize_initWithObjectsOptions(options);
}

#undef Synthesize_initWithObjectsOptions


+ (NSDictionary *)defaultOptions
{
    return DefaultOptions();
}


#pragma mark -
#pragma mark getting/setting elements

- (id)objectAtIndex:(NSUInteger)index
{
    NSAssert(_getter != nil, @"Getter policy is not set!");
    return _getter(_objects+index);
}


- (void)setObject:(id)object
            atIndex:(NSUInteger)index
{
    NSAssert(_setter != nil, @"Setter policy is not set!");
    _setter(_objects+index, object);
    _mutationFlag = clock();
}


- (void)setObject:(id)object
             atIndexedSubscript:(NSUInteger)index
{
    [self setObject: object atIndex: index];
}


#pragma mark -
#pragma mark <NSFastEnumeration>

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState *)  state
                                   objects: (id __unsafe_unretained []) buffer
                                     count: (NSUInteger) len
{
    // See https://mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html
    
    // TODO: this probably won't work with weak storage policy
    if (state->state == 0)
    {
        state->mutationsPtr = &_mutationFlag;
        state->itemsPtr     = _objects;
        state->state        = 1;
        
        return _capacity;
    }
    else
        return 0;
}


#pragma mark -
#pragma mark <NSCoding>

- (instancetype) initWithCoder: (NSCoder *) aDecoder
{
    // TODO: implement
    return nil;
}


- (void) encodeWithCoder: (NSCoder *) aCoder
{
    // TODO: implement
}


#pragma mark -
#pragma mark <NSCopying>

- (instancetype) copyWithZone:(NSZone *)zone
{
    // TODO: implement
    return nil;
}

@end
