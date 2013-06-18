//
//  SOTutorialViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 17/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOTutorialViewController.h"
#import "SODialogViewController.h"
#import "SOFirstTutorialViewController.h"

@interface SOTutorialViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    NSMutableArray  *_viewControllers;
    BOOL            _pastFirstPost;
}
@end

@implementation SOTutorialViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    if ( (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil]) != nil)
    {
        _pastFirstPost = NO;
        _viewControllers = [[NSMutableArray alloc] init];
        self.dataSource = self;
        self.delegate = self;
        
        SOFirstTutorialViewController *initialVC = [[SOFirstTutorialViewController alloc] init];
        initialVC.codeSelectionView.delegate = self;
        [_viewControllers addObject:initialVC];
        
        SODialogViewController *dialogVC1 = [[SODialogViewController alloc] init];
        [dialogVC1 setupPage:1];
        [_viewControllers addObject:dialogVC1];
        
        SODialogViewController *dialogVC2 = [[SODialogViewController alloc] init];
        [dialogVC2 setupPage:2];
        [_viewControllers addObject:dialogVC2];
        
        SODialogViewController *dialogVC3 = [[SODialogViewController alloc] init];
        [dialogVC3 setupPage:3];
        [_viewControllers addObject:dialogVC3];
        
        SODialogViewController *dialogVC4 = [[SODialogViewController alloc] init];
        [dialogVC4 setupPage:4];
        [_viewControllers addObject:dialogVC4];
        
        SODialogViewController *dialogVC5 = [[SODialogViewController alloc] init];
        [dialogVC5 setupPage:5];
        [_viewControllers addObject:dialogVC5];
        
        SODialogViewController *dialogVC6 = [[SODialogViewController alloc] init];
        [dialogVC6 setupPage:6];
        [_viewControllers addObject:dialogVC6];
        
        SODialogViewController *dialogVC7 = [[SODialogViewController alloc] init];
        [dialogVC7 setupPage:7];
        [_viewControllers addObject:dialogVC7];
        
        
        [self setViewControllers:@[initialVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [initialVC release];
        [dialogVC1 release];
        [dialogVC2 release];
        [dialogVC3 release];
        [dialogVC4 release];
        [dialogVC5 release];
        [dialogVC6 release];
        [dialogVC7 release];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_viewControllers release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOCodeSelectionViewDelegate
//////////////////////////////////////////////////////////////////////////

- (void)codeSelectionViewWillChangeRecepticles:(SOCodeSelectionView *)codeSelectionView
{
    if ([codeSelectionView recepticlesPopulated] == YES)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.67 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            _pastFirstPost = YES;
            
            [self setViewControllers:@[_viewControllers[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                if ([_viewControllers[0] isKindOfClass:SOFirstTutorialViewController.class])
                {
                    UIViewController *viewController = _viewControllers[0];
                    viewController.view.userInteractionEnabled = NO;
                }
            }];
        });
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIPageViewControllerDatasource
//////////////////////////////////////////////////////////////////////////

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (_pastFirstPost == NO)
    {
        return nil;
    }
    int currentViewControllerIndex = [_viewControllers indexOfObject:viewController];
    
    if (currentViewControllerIndex+1 >= _viewControllers.count)
    {
        return nil;
    }
    else
    {
        return _viewControllers[currentViewControllerIndex+1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:SOFirstTutorialViewController.class])
    {
        return nil;
    }
    int currentViewControllerIndex = [_viewControllers indexOfObject:viewController];
    
    if (currentViewControllerIndex-1 < 0)
    {
        return nil;
    }
    else
    {
        return _viewControllers[currentViewControllerIndex-1];
    }
}

@end
