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

typedef id(^IDPBlockWithIMP)(IMP implementation);
typedef void(*IDPForwardInvocationIMP)(id, SEL, id);
typedef BOOL(*IDPIsEqualIMP)(id, SEL, id);
typedef id(*KBAllocWithZone)(id, SEL);

@implementation NSNull (NillReplacement)

+ (void)load {

    [self replaceIsEqual];
    
}

//+ (void)replaceAllocWithZone {
//    SEL selector = @selector(isEqual:);
//    
//    IDPBlockWithIMP block = ^(IMP implementation) {
//        IDPIsEqualIMP methodIMP = (IDPIsEqualIMP)implementation;
//        
//        return (id)^(KBObjectNull *nullObject, id object) {
//            if (!object) {
//                return YES;
//            }
//            
//            return methodIMP(nullObject, selector, object);
//        };
//    };
//    
//    [self setBlock:block forSelector:selector];
//}

+ (void)replaceIsEqual {
    SEL selector = @selector(isEqual:);
    
    IDPBlockWithIMP block = ^(IMP implementation) {
        IDPIsEqualIMP methodIMP = (IDPIsEqualIMP)implementation;
        
        return (id)^(NSNull *nullObject, NSZone) {
            return [KBObjectNull allocWithZone:zone];
        };
    };
    
    [self setBlock:block forSelector:selector];
}


+ (void)setBlock:(IDPBlockWithIMP)block forSelector:(SEL)selector {
    IMP implementation = [self instanceMethodForSelector:selector];
    
    IMP blockIMP = imp_implementationWithBlock(block(implementation));
    
    Method method = class_getInstanceMethod(self, selector);
    class_replaceMethod(self,
                        selector,
                        blockIMP,
                        method_getTypeEncoding(method));
}

@end
