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
    [self replaceClassMethodsOldMethod:@selector(allocWithZone:) byNewSelector:@selector(newAllocWithZone:)];
    [self replaceClassMethodsOldMethod:@selector(null) byNewSelector:@selector(newNull)];
}

+ (instancetype)newAllocWithZone:(struct _NSZone *)zone {
    return (self  == [NSNull class]) ? [KBObjectNull sharedObject] : [super allocWithZone:0];
}

+ (id)newNull {
    return [KBObjectNull sharedObject];
}

+ (void)replaceClassMethodsOldMethod:(SEL)oldSelector byNewSelector:(SEL)newSelector {
    Method newMethod = class_getClassMethod([NSNull class], newSelector);
    IMP newImplementation = method_getImplementation(newMethod);
    
    Method method = class_getClassMethod([NSNull class], oldSelector);
    method_setImplementation(method, newImplementation);
}

@end
