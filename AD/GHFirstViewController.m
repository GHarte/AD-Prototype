//
//  GHFirstViewController.m
//  AD
//
//  Created by Gareth Harte on 29/01/2014.
//  Copyright (c) 2014 Gareth Harte. All rights reserved.
//

#import "GHFirstViewController.h"


@interface GHFirstViewController ()

@end

@implementation GHFirstViewController

- (void)viewDidLoad
{
    
    //--------Web view-----------
    
    [super viewDidLoad];
    
    NSString *fullURL = @"http://anecdoodle.ie/";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
