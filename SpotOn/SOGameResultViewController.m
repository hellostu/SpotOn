//
//  SOGameResultViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 22/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameResultViewController.h"
#import "SOPreviousGuessView.h"

@interface SOGameResultViewController ()
{
    SOGameResult        _gameResult;
    
    UILabel             *_topScreenName;
    UILabel             *_bottomScreenName;
    
    SOPreviousGuessView *_topCode;
    SOPreviousGuessView *_bottomCode;
    
    int                 _numberOfColors;
}
@end

@implementation SOGameResultViewController
@dynamic topScreenName;
@dynamic bottomScreenName;

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithGameResult:(SOGameResult)gameResult numberOfColors:(int)numberOfColors
{
    if ( (self = [super init]) != nil)
    {
        _gameResult = gameResult;
        _numberOfColors = numberOfColors;
        
    }
    return self;
}

- (void)dealloc
{
    [_topProfilePicture release];
    [_bottomProfilePicture release];
    [_topScreenName release];
    [_bottomScreenName release];
    [_topCode release];
    [_bottomCode release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat labelY;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        labelY = self.view.frame.size.height*0.015;
    }
    else
    {
        labelY = self.view.frame.size.height*0.05;
    }
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, self.view.frame.size.width, 40)];
    typeLabel.font = [UIFont fontWithName:@"GothamHTF-Bold" size:42.0f];
    typeLabel.text = @"WINNER";
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.textColor = GREY_COLOR_TOP_TEXT;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *roundsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY+45, self.view.frame.size.width, 15)];
    roundsLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:16.0f];
    roundsLabel.text = @"7 ROUNDS";
    roundsLabel.backgroundColor = [UIColor clearColor];
    roundsLabel.textColor = GREY_COLOR_TOP_TEXT;
    roundsLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat topProfileY = roundsLabel.frame.origin.y+roundsLabel.frame.size.height+5;
    CGFloat topProfileHeight = self.view.frame.size.height/2-topProfileY-5;
    CGFloat topOffset = topProfileHeight*0.4-60;
    UIView *topProfile = [[UIView alloc] initWithFrame:CGRectMake(0, topProfileY, self.view.frame.size.width, topProfileHeight)];
    _topProfilePicture = [[SOProfilePicture alloc] initWithType:SOProfilePictureTypeLarge];
    _topProfilePicture.center = CGPointMake(self.view.frame.size.width/2, _topProfilePicture.frame.size.height/2+topOffset);
    [topProfile addSubview:_topProfilePicture];
    
    
    _topScreenName = [[UILabel alloc] initWithFrame:CGRectMake(0, topProfile.frame.size.height-60-topOffset, topProfile.frame.size.width, 30)];
    _topScreenName.font = [UIFont fontWithName:@"GothamHTF-Medium" size:20.0f];
    _topScreenName.text = @"ScreenName";
    _topScreenName.backgroundColor = [UIColor clearColor];
    _topScreenName.textColor = GREY_COLOR_TOP_TEXT;
    _topScreenName.textAlignment = NSTextAlignmentCenter;
    
    [topProfile addSubview:_topScreenName];
    
    _topCode = [[SOPreviousGuessView alloc] initWithFrame:CGRectMake(0, 0, topProfile.frame.size.width*0.85, 30) numberOfColors:_numberOfColors];
    _topCode.center = CGPointMake(topProfile.frame.size.width/2, topProfile.frame.size.height-15-topOffset);
    
    [topProfile addSubview:_topCode];
    
    UIView *bottomProfile = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2+5, self.view.frame.size.width, topProfileHeight)];
    _bottomProfilePicture = [[SOProfilePicture alloc] initWithType:SOProfilePictureTypeLarge];
    _bottomProfilePicture.center = CGPointMake(self.view.frame.size.width/2, _topProfilePicture.frame.size.height/2+topOffset);
    
    [bottomProfile addSubview:_bottomProfilePicture];
    
    _bottomScreenName = [[UILabel alloc] initWithFrame:CGRectMake(0, topProfile.frame.size.height-60-topOffset, topProfile.frame.size.width, 30)];
    _bottomScreenName.font = [UIFont fontWithName:@"GothamHTF-Medium" size:20.0f];
    _bottomScreenName.text = @"ScreenName";
    _bottomScreenName.backgroundColor = [UIColor clearColor];
    _bottomScreenName.textColor = GREY_COLOR_TOP_TEXT;
    _bottomScreenName.textAlignment = NSTextAlignmentCenter;
    
    [bottomProfile addSubview:_bottomScreenName];
    [_bottomScreenName release];
    
    _bottomCode = [[SOPreviousGuessView alloc] initWithFrame:CGRectMake(0, 0, topProfile.frame.size.width*0.85, 30) numberOfColors:_numberOfColors];
    _bottomCode.center = CGPointMake(topProfile.frame.size.width/2, topProfile.frame.size.height-15-topOffset);
    
    [bottomProfile addSubview:_bottomCode];
    
    [self.view addSubview:typeLabel];
    [self.view addSubview:roundsLabel];
    [self.view addSubview:topProfile];
    [self.view addSubview:bottomProfile];
    
    [typeLabel release];
    [roundsLabel release];
    [topProfile release];
    [bottomProfile release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
//////////////////////////////////////////////////////////////////////////

- (NSString *)topScreenName
{
    return _topScreenName.text;
}

- (void)setTopScreenName:(NSString *)topScreenName
{
    _topScreenName.text = topScreenName;
}

- (NSString *)bottomScreenName
{
    return _bottomScreenName.text;
}

- (void)setBottomScreenName:(NSString *)bottomScreenName
{
    _bottomScreenName.text = bottomScreenName;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)setTopCode:(NSArray *)topCode
{
    [_topCode updateWithColors:topCode];
}

- (void)setBottomCode:(NSArray *)bottomCode
{
    [_bottomCode updateWithColors:bottomCode];
}

@end
