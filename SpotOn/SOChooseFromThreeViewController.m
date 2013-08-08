//
//  SOChooseDifficultyViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 22/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOChooseFromThreeViewController.h"
#import "SOButton.h"

@interface SOChooseFromThreeViewController () <SOButtonDelegate>
{
    SOButton *_easyButton;
    SOButton *_mediumButton;
    SOButton *_hardButton;
    SOButton *_backButton;
    
    SOChooseFromThreeType _chooseFromThreeType;
}

@end

@implementation SOChooseFromThreeViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithType:(SOChooseFromThreeType)chooseFromThreeType;
{
    if ( (self = [super init]) != nil)
    {
        _chooseFromThreeType = chooseFromThreeType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    
    _backButton = [[SOButton alloc] initWithType:SOButtonTypeBack];
    _backButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.92);
    _backButton.delegate = self;
    
	_easyButton = [[SOButton alloc] initWithType:SOButtonTypeDefault];
    _mediumButton = [[SOButton alloc] initWithType:SOButtonTypeDefault];
    _hardButton = [[SOButton alloc] initWithType:SOButtonTypeDefault];
    
    _easyButton.delegate = self;
    _mediumButton.delegate = self;
    _hardButton.delegate = self;
    
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
    
    if (_chooseFromThreeType == SOChooseFromThreeTypeDifficulty)
    {
        easyLabel.text = @"Easy";
        mediumLabel.text = @"Medium";
        hardLabel.text = @"Hard";
        _easyButton.center = CGPointMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-80);
        _mediumButton.center = CGPointMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2);
        _hardButton.center = CGPointMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2+80);
        
        easyLabel.center = CGPointMake(self.view.frame.size.width/2+65, self.view.frame.size.height/2-80);
        mediumLabel.center = CGPointMake(self.view.frame.size.width/2+65, self.view.frame.size.height/2);
        hardLabel.center = CGPointMake(self.view.frame.size.width/2+65, self.view.frame.size.height/2+80);
    }
    else
    {
        easyLabel.text = @"Online";
        mediumLabel.text = @"Pass n' Play";
        hardLabel.text = @"Solo";
        _easyButton.center = CGPointMake(self.view.frame.size.width/2-65, self.view.frame.size.height/2-80);
        _mediumButton.center = CGPointMake(self.view.frame.size.width/2-65, self.view.frame.size.height/2);
        _hardButton.center = CGPointMake(self.view.frame.size.width/2-65, self.view.frame.size.height/2+80);
        
        easyLabel.center = CGPointMake(self.view.frame.size.width/2+50, self.view.frame.size.height/2-80);
        mediumLabel.center = CGPointMake(self.view.frame.size.width/2+50, self.view.frame.size.height/2);
        hardLabel.center = CGPointMake(self.view.frame.size.width/2+50, self.view.frame.size.height/2+80);
    }
    
    [self.view addSubview:_easyButton];
    [self.view addSubview:_mediumButton];
    [self.view addSubview:_hardButton];
    [self.view addSubview:easyLabel];
    [self.view addSubview:mediumLabel];
    [self.view addSubview:hardLabel];
    [self.view addSubview:_backButton];
    
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
    [_backButton release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOButtonDelegate
//////////////////////////////////////////////////////////////////////////

- (void)buttonPressed:(SOButton *)submitButton
{
    if(submitButton == _backButton)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([self.delegate respondsToSelector:@selector(chooseFromThreeViewController:selectedDifficulty:)] &&
             _chooseFromThreeType == SOChooseFromThreeTypeDifficulty)
    {
        if (submitButton == _easyButton)
        {
            [self.delegate chooseFromThreeViewController:self selectedDifficulty:SODifficultyEasy];
        }
        else if(submitButton == _mediumButton)
        {
            [self.delegate chooseFromThreeViewController:self selectedDifficulty:SODifficultyMedium];
        }
        else if(submitButton == _hardButton)
        {
            [self.delegate chooseFromThreeViewController:self selectedDifficulty:SODifficultyHard];
        }
    }
    else if([self.delegate respondsToSelector:@selector(chooseFromThreeViewController:selectedPlayType:)] &&
            _chooseFromThreeType == SOChooseFromThreeTypeGameType)
    {
        if (submitButton == _easyButton)
        {
            [self.delegate chooseFromThreeViewController:self selectedPlayType:SOPlayTypeGameCenter];
        }
        else if(submitButton == _mediumButton)
        {
            [self.delegate chooseFromThreeViewController:self selectedPlayType:SOPlayTypePassAndPlayPlayerOne];
        }
        else if(submitButton == _hardButton)
        {
            [self.delegate chooseFromThreeViewController:self selectedPlayType:SOPlayTypeSinglePlayer];
        }
    }
}

@end
