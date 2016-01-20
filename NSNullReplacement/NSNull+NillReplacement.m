//
//  NSNull+NillReplacement.m
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 14.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "NSNull+NillReplacement.h"
#import "KBObjectNull.h"
#import <objc/runtime.h>

typedef id(^KBBlockWithImplementation)(IMP implementation);

@implementation NSNull (NillReplacement)

+ (void)load {
    [self replaceAllocWithZone];
    [self replaceNull];
}

+ (instancetype) newNull {
    __strong static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [NSNull null];
        object_setClass(sharedObject, [KBObjectNull class]);
    });
    
    return sharedObject;
}

+ (void)replaceNull {
    SEL selector = @selector(null);
    
    KBBlockWithImplementation block = ^(IMP implementation) {
        
        return (id)^(NSNull *nullObject) {
            return [self newNull];
        };
    };
    
    [self setBlock:block forSelector:selector];
}


+ (void)replaceAllocWithZone {
    SEL selector = @selector(allocWithZone:);
    
    KBBlockWithImplementation block = ^(IMP implementation) {
        
        return (id)^(NSNull *nullObject, id zone) {
            return [self newNull];
        };
    };
    
    [self setBlock:block forSelector:selector];
}


+ (void)setBlock:(KBBlockWithImplementation)block forSelector:(SEL)selector {
    IMP implementation = [self instanceMethodForSelector:selector];
    IMP blockIMP = imp_implementationWithBlock(block(implementation));
    
    Method method = class_getClassMethod([NSNull class], selector);
    method_setImplementation(method, blockIMP);
}

@end
