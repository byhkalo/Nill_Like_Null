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

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (Class)class {
    return [NSNull class];
}

- (Class)class {
    return [NSNull class];
}

- (BOOL)isEqual:(id)object {
    
    if (!object) {
        return YES;
    } if ([object isKindOfClass:[NSNull class]] || [object isKindOfClass:[KBObjectNull class]] ) {
        return YES;
    }
    return NO;
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
