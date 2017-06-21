//
//  LcViewController.m
//  LaraCryptObjC
//
//  Created by r.khalafi65@gmail.com on 06/21/2017.
//  Copyright (c) 2017 r.khalafi65@gmail.com. All rights reserved.
//

#import "LcViewController.h"
#import "LaraCrypt.h"

@interface LcViewController ()

@end

@implementation LcViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *key = @"u6KuXJLIUwEUl7noY8J8H1ffDRwLC/5gjaWW1qTQ3hE=";
    NSString *message = @"123456";
    NSString *encryptedString = [[LaraCrypt laravelCrypt]laraEncWithMessage:message andKey:key];
    
    NSLog(@"encryptedString is: %@",encryptedString);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
