//
//  SOMenuController.m
//  SpotOn
//
//  Created by Stuart Lynch on 21/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOMenuController.h"
#import "SOGameListViewController.h"

@interface SOMenuController () <UINavigationControllerDelegate>
{
    UIButton *_backButton;
}
@end

@implementation SOMenuController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    if ( (self = [super init]) != nil )
    {
        [self setNavigationBarHidden:YES animated:NO];
        
        SOGameListViewController *gameList = [[SOGameListViewController alloc] init];
        [self pushViewController:gameList animated:NO];
        [gameList release];
        
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 24, 47)];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow_active.png"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _backButton.alpha = 0.0;
    //[self.view addSubview:_backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UINavigationControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 1)
    {
        [UIView animateWithDuration:0.2 animations:^() {
            _backButton.alpha = 1.0f;
            _backButton.frame = CGRectMake(5, 20, 24, 47);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^() {
            _backButton.alpha = 0.0f;
            _backButton.frame = CGRectMake(-20, 20, 24, 47);
        }];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////

- (void)backButtonPressed
{
    [self popViewControllerAnimated:YES];
}

@end
