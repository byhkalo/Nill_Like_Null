//
//  KBObjectNull.m
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 14.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "KBObjectNull.h"
#import <objc/runtime.h>

@interface KBObjectNull()

@end

@implementation KBObjectNull

+(void)load {
    object_setClass([NSNull null], [KBObjectNull class]);
}

+(instancetype)new {
    __strong static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KBObjectNull *sharedObject = (id)[[NSNull alloc] init];
        Class objClass = object_getClass(sharedObject);
//        if (![objClass isSubclassOfClass:[KBObjectNull class]]) {
            object_setClass(sharedObject, [KBObjectNull class]);
//        }
    });
    
    return sharedObject;
}

+ (Class)class {
    return [NSNull class];
}

- (Class)class {
    return [NSNull class];
}

- (BOOL)isEqual:(id)object {
    return (!object || [object isKindOfClass:[NSNull class]] || [object isKindOfClass:[KBObjectNull class]]);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    // If NSNull doesn't respond to aSelector, signature will be nil and a new signature for an empty method
    // will be created and returned
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    
    if (!signature) {
        // Note: "@:" are (id)self and (SEL)_cmd
        signature = [NSMethodSignature signatureWithObjCTypes:"@:"];
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    id test = nil;
    [anInvocation invokeWithTarget:test];
}

@end
