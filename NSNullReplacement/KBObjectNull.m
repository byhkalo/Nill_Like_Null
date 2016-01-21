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

- (Class)class {
    return [KBObjectNull class];
}

- (BOOL)isEqual:(id)object {
    return (!object || [object isKindOfClass:[NSNull class]] || [object isKindOfClass:[KBObjectNull class]]);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    // If NSNull doesn't respond to aSelector, signature will be nil and a new signature for an empty method
    // will be created and returned
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
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
