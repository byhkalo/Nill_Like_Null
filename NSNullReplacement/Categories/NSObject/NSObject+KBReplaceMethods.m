//
//  NSObject+Subclasses.m
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 21.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "NSObject+KBReplaceMethods.h"
#import <objc/runtime.h>

@implementation NSObject (KBReplaceMethods)

+ (NSArray*)subclasses {
    
    Class parentClass = [self class];
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = (Class *)calloc(sizeof(Class) * numClasses, sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++) {
        Class superClass = classes[i];
        
        while (superClass && superClass != parentClass) {
            superClass = class_getSuperclass(superClass);
        }
        
        if (superClass == nil) {
            continue;
        }
        
        NSLog(@"Subclass %ld - %@",(long)result.count , classes[i]);
        [result addObject:classes[i]];
    }
    
    free(classes);
    
    return [result copy];
}

+ (void)replaceClassMethodsOldSelectorImplementation:(SEL)oldSelector byNewSelector:(SEL)newSelector {
    Method newMethod = class_getClassMethod(self, newSelector);
    IMP newImplementation = method_getImplementation(newMethod);
    
    [self replaceMethod:oldSelector inClass:[self metaclass] byIMP:newImplementation isResetIMP:NO];
}

+ (void)replaceMethod:(SEL)selector inClass:(Class)class byIMP:(IMP)implementation isResetIMP:(BOOL)isResetIMP; {
    Method method = class_getClassMethod(class, selector);
    class_replaceMethod(class,
                        selector,
                        implementation,
                        method_getTypeEncoding(method));
    implementation = isResetIMP ? nil : implementation;
}

#pragma mark -
#pragma mark Metaclass -

+ (Class)metaclass {
    return object_getClass([NSNull class]);
}

@end
