//
//  NSObject+Subclasses.m
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 21.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "NSObject+Subclasses.h"
#import <objc/runtime.h>

@implementation NSObject (Subclasses)

+ (NSArray*)returnSubclassesOfClass {
    
    Class parentClass = [self class];
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = (Class *)malloc(sizeof(Class) * numClasses);
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
    
    return result;
}

@end
