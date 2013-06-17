//
//  SODialogViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 17/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SODialogViewController.h"

@interface SODialogViewController ()

@end

@implementation SODialogViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    if ( (self = [super init]) != nil)
    {
        _dialogView = [[SODialogView alloc] initWithFrame:CGRectMake(0, 0, 185, 160)
                                                titleText:@""
                                              messageText:@""];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GREY_COLOR_TOP_BACKGROUND;
	_dialogView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3);
    
    [self.view addSubview:_dialogView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
