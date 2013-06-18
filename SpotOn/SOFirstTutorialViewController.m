//
//  SOFirstTutorialViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 17/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOFirstTutorialViewController.h"

@interface SOFirstTutorialViewController ()

@end

@implementation SOFirstTutorialViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    if ( (self = [super init]) != nil)
    {
        _codeSelectionView = [[SOCodeSelectionView alloc] initWithFrame:CGRectMake(0, 0, 50, 200) numberOfColors:1 numberOfRecepticles:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = GREY_COLOR_TOP_BACKGROUND;
    
    _codeSelectionView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _codeSelectionView.regrowCircles = NO;
    [self.view addSubview:_codeSelectionView];
    [_codeSelectionView release];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture)];
    [self.view addGestureRecognizer:panGesture];
    [panGesture release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panGesture
{
    
}

- (void)dealloc
{
    [_codeSelectionView release];
    [super dealloc];
}

@end
