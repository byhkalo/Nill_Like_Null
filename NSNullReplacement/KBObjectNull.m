//
//  KBObjectNull.m
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 14.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "KBObjectNull.h"

@interface KBObjectNull()

@end

@implementation KBObjectNull

+ (instancetype)null
{
    // initialize sharedObject as nil (first call only)
    __strong static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[KBObjectNull alloc] init];
    });
    // returns the same object each time
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
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature) {
        // Note: "@:" are (id)self and (SEL)_cmd
        signature = [NSMethodSignature signatureWithObjCTypes:"@:"];
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // Called if NSNull received a message to a non-existent method
    // Reroute the message to nil
    id test = nil;
    [anInvocation invokeWithTarget:test];
}

@end
