//
//  NSNull+NillReplacement.m
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 14.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "NSNull+KBNilReplacement.h"
#import "KBObjectNull.h"
#import <objc/runtime.h>

typedef id(^KBBlockWithImplementation)(IMP implementation);

static IMP implementationNew = nil;
static IMP implementationAlloc = nil;
static IMP implementationNull = nil;
static IMP implementationAllocWithZone = nil;

@implementation NSNull (KBNilReplacement)

+ (void)load {
    [self replaceClassMethodsOldSelector:@selector(allocWithZone:) byNewSelector:@selector(newAllocWithZone:)];
    [self replaceClassMethodsOldSelector:@selector(null) byNewSelector:@selector(newNull)];
}

+ (instancetype)newAllocWithZone:(struct _NSZone *)zone {
    return (self  == [NSNull class]) ? [KBObjectNull sharedObject] : [super allocWithZone:0];
}

+ (id)newNull {
    return [KBObjectNull sharedObject];
}

+ (void)replaceClassMethodsOldSelector:(SEL)oldSelector byNewSelector:(SEL)newSelector {
    Method newMethod = class_getClassMethod([NSNull class], newSelector);
    IMP newImplementation = method_getImplementation(newMethod);
    
    Method method = class_getClassMethod([NSNull class], oldSelector);
    method_setImplementation(method, newImplementation);
}

#pragma mark -
#pragma mark Injection -

+ (void)logInjectionEnable {
    if (!implementationNew) {
        id objectFromClass = [NSNull class];
        Class class = object_getClass(objectFromClass);
        
        implementationNew = [self replaceClassMethodWithoutParameters:@selector(new) class:class];
        implementationAlloc = [self replaceClassMethodWithoutParameters:@selector(alloc) class:class];
        implementationNull = [self replaceClassMethodWithoutParameters:@selector(null) class:class];
        implementationAllocWithZone = [self replaceClassMethodAllocWithZoneInClass:class];
    }
}

+ (void)logInjectionDisable {
    if (implementationNew) {
        id objectFromClass = [NSNull class];
        Class class = object_getClass(objectFromClass);
        
        [self replaceMethod:@selector(new) inClass:class byImplementation:implementationNew isResetImplementation:YES];
        [self replaceMethod:@selector(alloc) inClass:class byImplementation:implementationAlloc isResetImplementation:YES];
        [self replaceMethod:@selector(null) inClass:class byImplementation:implementationNull isResetImplementation:YES];
        [self replaceMethod:@selector(allocWithZone:) inClass:class byImplementation:implementationAllocWithZone isResetImplementation:YES];
    }
}

+ (IMP)replaceClassMethodWithoutParameters:(SEL)selector class:(Class)class{
    IMP implementation = [class instanceMethodForSelector:selector];
    id block = ^(id blockObject, SEL blockSelector) {
        NSLog(@"Method %s call", sel_getName(selector));
        
        return ((id(*)(id, SEL))implementation)(blockObject, selector);
    };
    IMP blockIMP = imp_implementationWithBlock(block);
    [self replaceMethod:selector inClass:class byImplementation:blockIMP isResetImplementation:NO];
    
    return implementation;
}

+ (IMP)replaceClassMethodAllocWithZoneInClass:(Class)class {
    SEL selector = @selector(allocWithZone:);
    IMP implementation = [class instanceMethodForSelector:selector];
    id block = ^(id blockObject, SEL blockSelector, NSZone *zone) {
        NSLog(@"Method %s call", sel_getName(selector));
        
        return ((id(*)(id, SEL, NSZone *))implementation)(blockObject, blockSelector, zone);
    };
    IMP blockIMP = imp_implementationWithBlock(block);
    [self replaceMethod:selector inClass:class byImplementation:blockIMP isResetImplementation:NO];
    
    return implementation;
}

+ (void)replaceMethod:(SEL)selector inClass:(Class)class byImplementation:(IMP)implementation isResetImplementation:(BOOL)isResetIMP {
    Method method = class_getClassMethod(class, selector);
    class_replaceMethod(class,
                        selector,
                        implementation,
                        method_getTypeEncoding(method));
    implementation = isResetIMP ? nil : implementation;
}

@end
