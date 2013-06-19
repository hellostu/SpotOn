//
//  SOWaitingForCodeViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 19/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOWaitingForCodeViewController.h"

@interface SOWaitingForCodeViewController ()

@end

@implementation SOWaitingForCodeViewController

- (id)init
{
    if ( (self = [super init]) != nil)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = self.messageView.frame;
    frame.origin.y-=20;
    self.messageView.frame = frame;
	self.messageView.text = @"WAITING FOR OPPONENT'S CODE TO GET STARTED";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
