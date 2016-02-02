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

static IMP implementationNew;
static IMP implementationAlloc;
static IMP implementationNull;
static IMP implementationAllocWithZone;

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

+ (void)logInjectionEnable {
    if (!implementationNew) {
//        Class class = [NSNull class];
        id objectFromClass = [NSNull class];
        Class class = object_getClass(objectFromClass);
        
        implementationNew = [self replaceClassMethodWithoutParameters:@selector(new) class:class];
        implementationAlloc = [self replaceClassMethodWithoutParameters:@selector(alloc) class:class];
        implementationNull = [self replaceClassMethodWithoutParameters:@selector(null) class:class];
        implementationAllocWithZone = [self replaceClassMethodWithOneIncomingParameter:@selector(allocWithZone:) class:class];
    }
}


+ (IMP)replaceClassMethodNew:(Class)class{
    SEL selector = @selector(new);
    IMP implementation = [class instanceMethodForSelector:selector];
    id block = ^(id blockObject, SEL blockSelector) {
        NSLog(@"Method new call");
        
        return ((id(*)(id, SEL))implementation)(blockObject, blockSelector);
    };
    IMP blockIMP = imp_implementationWithBlock(block);
    
    Method method = class_getClassMethod(class, selector);
    class_replaceMethod(class,
                        selector,
                        blockIMP,
                        method_getTypeEncoding(method));
    
    return implementation;
    
    //    return method_setImplementation(method, blockIMP);
}




+ (IMP)replaceClassMethodWithoutParameters:(SEL)selector class:(Class)class{
    IMP implementation = [class instanceMethodForSelector:selector];
    id block = ^(id blockObject, SEL blockSelector) {
        NSLog(@"Method %s call", sel_getName(selector));
        
        return ((id(*)(id, SEL))implementation)(blockObject, selector);
    };
    IMP blockIMP = imp_implementationWithBlock(block);
    
    Method method = class_getClassMethod(class, selector);
    class_replaceMethod(class,
                        selector,
                        blockIMP,
                        method_getTypeEncoding(method));
    
    return implementation;

//    return method_setImplementation(method, blockIMP);
}

+ (IMP)replaceClassMethodWithOneIncomingParameter:(SEL)selector class:(Class)class {
    IMP implementation = [class instanceMethodForSelector:selector];
    id block = ^(id blockObject, SEL blockSelector, NSZone *zone) {
        NSLog(@"Method %s call", sel_getName(selector));
        
        return ((id(*)(id, SEL, NSZone *))implementation)(blockObject, blockSelector, zone);
    };
    IMP blockIMP = imp_implementationWithBlock(block);
    
    Method method = class_getClassMethod(class, selector);
    
    class_replaceMethod(class,
                        selector,
                        blockIMP,
                        method_getTypeEncoding(method));
    
    return implementation;

    
//    return method_setImplementation(method, blockIMP);
    
}

+ (void)logInjectionDisable {
    if (implementationNew) {
        id objectFromClass = [NSNull class];
        Class class = object_getClass(objectFromClass);
        Method method = class_getInstanceMethod(class, @selector(new));
        method_setImplementation(method, implementationNew);
        implementationNew = nil;
        
        method = class_getInstanceMethod(class, @selector(alloc));
        method_setImplementation(method, implementationAlloc);
        implementationAlloc = nil;
        
        method = class_getInstanceMethod(class, @selector(null));
        method_setImplementation(method, implementationNull);
        implementationNull = nil;
        
        method = class_getInstanceMethod(class, @selector(allocWithZone:));
        method_setImplementation(method, implementationAllocWithZone);
        implementationAllocWithZone = nil;

    }
}

@end
