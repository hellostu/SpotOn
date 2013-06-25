//
//  SOChooseDifficultyViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 22/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOChooseDifficultyViewController.h"
#import "SOButton.h"

@interface SOChooseDifficultyViewController () <SOButtonDelegate>
{
    SOButton *_easyButton;
    SOButton *_mediumButton;
    SOButton *_hardButton;
}

@end

@implementation SOChooseDifficultyViewController

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
    self.view.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    
	_easyButton = [[SOButton alloc] initWithType:SOButtonTypeDefault];
    _mediumButton = [[SOButton alloc] initWithType:SOButtonTypeDefault];
    _hardButton = [[SOButton alloc] initWithType:SOButtonTypeDefault];
    
    _easyButton.delegate = self;
    _mediumButton.delegate = self;
    _hardButton.delegate = self;
    
    _easyButton.center = CGPointMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-80);
    _mediumButton.center = CGPointMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2);
    _hardButton.center = CGPointMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2+80);
    
    UILabel *easyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    easyLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:20.0f];
    easyLabel.textColor = GREY_COLOR_BTM_RECEPTICLE;
    easyLabel.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    
    UILabel *mediumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    mediumLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:20.0f];
    mediumLabel.textColor = GREY_COLOR_BTM_RECEPTICLE;
    mediumLabel.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    
    UILabel *hardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    hardLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:20.0f];
    hardLabel.textColor = GREY_COLOR_BTM_RECEPTICLE;
    hardLabel.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    
    easyLabel.text = @"EASY";
    mediumLabel.text = @"MEDIUM";
    hardLabel.text = @"HARD";
    
    easyLabel.center = CGPointMake(self.view.frame.size.width/2+65, self.view.frame.size.height/2-80);
    mediumLabel.center = CGPointMake(self.view.frame.size.width/2+65, self.view.frame.size.height/2);
    hardLabel.center = CGPointMake(self.view.frame.size.width/2+65, self.view.frame.size.height/2+80);
    
    [self.view addSubview:_easyButton];
    [self.view addSubview:_mediumButton];
    [self.view addSubview:_hardButton];
    [self.view addSubview:easyLabel];
    [self.view addSubview:mediumLabel];
    [self.view addSubview:hardLabel];
    
    [easyLabel release];
    [mediumLabel release];
    [hardLabel release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_easyButton release];
    [_mediumButton release];
    [_hardButton release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOButtonDelegate
//////////////////////////////////////////////////////////////////////////

- (void)buttonPressed:(SOButton *)submitButton
{
    if ([self.delegate respondsToSelector:@selector(chooseDifficultyViewController:selectedDifficulty:)])
    {
        if (submitButton == _easyButton)
        {
            [self.delegate chooseDifficultyViewController:self selectedDifficulty:SODifficultyEasy];
        }
        else if(submitButton == _mediumButton)
        {
            [self.delegate chooseDifficultyViewController:self selectedDifficulty:SODifficultyMedium];
        }
        else if(submitButton == _hardButton)
        {
            [self.delegate chooseDifficultyViewController:self selectedDifficulty:SODifficultyHard];
        }
    }
}

@end
