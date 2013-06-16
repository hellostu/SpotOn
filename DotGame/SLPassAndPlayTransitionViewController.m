//
//  SLPassAndPlayTransitionViewController.m
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SLPassAndPlayTransitionViewController.h"
#import "SOSubmitButton.h"

@interface SLPassAndPlayTransitionViewController () <SOSubmitButtonDelegate>

@end

@implementation SLPassAndPlayTransitionViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithPlayType:(SLPlayType)playType
{
    if ( (self = [super init]) != nil)
    {
        self.playType = playType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.messageView.text = @"PASS THE DEVICE TO YOUR OPPONENT";
    
    UIImageView *mockup = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mockup2.jpeg"]];
    //[self.view addSubview:mockup];
    mockup.frame = self.view.frame;
    
    SOSubmitButton *submitButton = [[SOSubmitButton alloc] init];
    submitButton.delegate = self;
    submitButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-50);
    [self.view addSubview:submitButton];
    [submitButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLSubmitButtonDelegate
//////////////////////////////////////////////////////////////////////////

- (void)submitButtonPressed:(SOSubmitButton *)submitButton
{
    if ([self.delegate respondsToSelector:@selector(passAndPlayTransitionViewControllerReadyToTransition:)])
    {
        [self.delegate passAndPlayTransitionViewControllerReadyToTransition:self];
    }
}

@end
