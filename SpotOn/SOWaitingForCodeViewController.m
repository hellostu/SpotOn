//
//  SOWaitingForCodeViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 19/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOWaitingForCodeViewController.h" 
#import "SOButton.h"
@interface SOWaitingForCodeViewController () <SOButtonDelegate>
{
    SOButton            *_backButton;
}
@end

@implementation SOWaitingForCodeViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

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
    frame.origin.y=self.view.frame.size.height*0.15;
    self.messageView.frame = frame;
	self.messageView.text = @"Waiting for your opponent to get started.";
    
    CGFloat y = self.view.frame.size.height*0.92;
    _backButton = [[SOButton alloc] initWithType:SOButtonTypeBack];
    _backButton.delegate = self;
    _backButton.center = CGPointMake(self.view.frame.size.width/2, y);
    [self.view addSubview:_backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////

- (void)buttonPressed:(SOButton *)button
{
    if (button == _backButton)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
