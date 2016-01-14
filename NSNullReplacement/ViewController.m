//
//  ViewController.m
//  NSNullReplacement
//
//  Created by Byhkalo Konstantyn on 14.01.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "ViewController.h"
#import "KBNull.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNull* helpNull = [NSNull null];
    
    [helpNull performSelector:@selector(loadView)];
    
    NSNull* secondHelpNull = [[NSNull alloc]init];
    
    if ([secondHelpNull isEqual:nil]) {
        NSLog(@"Cool, something work");
    }
    
    if (secondHelpNull == [NSNull null]) {
        NSLog(@"Cool, something work");
    }
    
    if (CGRectIsNull([(id)helpNull frame])) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
