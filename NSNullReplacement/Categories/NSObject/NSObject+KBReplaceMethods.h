//
//  NSObject+Subclasses.h
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 21.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KBReplaceMethods)

+ (Class)metaclass;
+ (NSArray*)subclasses;
+ (void)replaceClassMethodsOldSelectorImplementation:(SEL)oldSelector byNewSelector:(SEL)newSelector;
+ (void)replaceMethod:(SEL)selector inClass:(Class)class byIMP:(IMP)implementation isResetIMP:(BOOL)isResetIMP;

@end
