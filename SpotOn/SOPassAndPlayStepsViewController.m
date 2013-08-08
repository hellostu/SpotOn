//
//  SOPassAndPlayerStepsViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 12/07/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOPassAndPlayStepsViewController.h"
#import "SOCircle.h"
#import "SOButton.h"
#import "SOAvatarChooser.h"
#import "SOCodeSelectionView.h"

#import <QuartzCore/QuartzCore.h>

@interface SOPassAndPlayStepsViewController () <UITextFieldDelegate, SOButtonDelegate, SOCodeSelectionViewDelegate>
{
    @private
    int                 _step;
    SODifficulty        _difficulty;
    
    UITextField         *_nameField;
    SOButton            *_backButton;
    SOButton            *_submitButton;
    NSString            *_name;
    SOCodeSelectionView *_codeSelectionView;
    
    CGRect              _startingFrame;
    UIView              *_contentView;
}
@end

@implementation SOPassAndPlayStepsViewController
@dynamic name;

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithStep:(int)step name:(NSString *)name difficulty:(SODifficulty)difficulty
{
    if ( (self = [super init]) != nil)
    {
        _step = step;
        _name = [name retain];
        _nameField = nil;
        _difficulty = difficulty;
        _codeSelectionView = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _startingFrame = _contentView.frame;
    [_backgroundView removeFromSuperview];
    [_contentView addSubview:_backgroundView];
    
	SOCircle *numberCircle = [[SOCircle alloc] initWithFrame:CGRectMake(0, 0, 90, 90) expandTouchArea:NO];
    numberCircle.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.2);
    
    int rand = arc4random()%6;
    numberCircle.fillColor = [SOCircle colorForTag:rand];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 88)];
    numberLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.2);
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont fontWithName:@"GothamHTF-Bold" size:50.0f];
    numberLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    stepLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.375-15);
    stepLabel.backgroundColor = [UIColor clearColor];
    stepLabel.textColor = GREY_COLOR_TOP_TEXT;
    stepLabel.font = [UIFont fontWithName:@"GothamHTF-Light" size:20.0f];
    stepLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    messageLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.375+15);
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = GREY_COLOR_TOP_TEXT;
    messageLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:30.0f];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat y = self.view.frame.size.height*0.92;
    
    _backButton = [[SOButton alloc] initWithType:SOButtonTypeBack];
    _backButton.delegate = self;
    _backButton.center = CGPointMake(self.view.frame.size.width/2-50, y);
    [self.view addSubview:_backButton];
    
    _submitButton = [[SOButton alloc] initWithType:SOButtonTypeSubmit];
    _submitButton.delegate = self;
    _submitButton.alpha = 0.0f;
    _submitButton.center = CGPointMake(self.view.frame.size.width/2+50, y);
    [self.view addSubview:_submitButton];
    
    switch (_step)
    {
        case 1:
        {
            numberLabel.text = @"1";
            stepLabel.text = @"STEP ONE";
            messageLabel.text = @"Enter Name";
            
            UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
            borderView.layer.borderWidth = 1.0f;
            borderView.layer.borderColor = GREY_COLOR_TOP_TEXT.CGColor;
            borderView.backgroundColor = self.view.backgroundColor;
            borderView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.5+30);
            
            _nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 230, 30)];
            _nameField.textColor = GREY_COLOR_TOP_TEXT;
            _nameField.font = [UIFont fontWithName:@"GothamHTF-Medium" size:20.0f];
            _nameField.center = CGPointMake(borderView.frame.size.width/2, borderView.frame.size.height/2);
            _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _nameField.textAlignment = NSTextAlignmentCenter;
            _nameField.returnKeyType = UIReturnKeyDone;
            _nameField.delegate = self;
            [borderView addSubview:_nameField];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
            [_contentView addGestureRecognizer:tapGesture];
            [tapGesture release];
            
            [_contentView addSubview:borderView];
            [borderView release];
            
            break;
        }
        case 2:
        {
            numberLabel.text = @"2";
            stepLabel.text = @"STEP TWO";
            messageLabel.text = @"Select Avatar";
            
            SOAvatarChooser *avatarChooser = [[SOAvatarChooser alloc] init];
            avatarChooser.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.65);
            
            _submitButton.alpha = 1.0f;
            
            [_contentView addSubview:avatarChooser];
            break;
        }
        case 3:
        default:
        {
            int numberOfColors = 4;
            int numberOfRecepticles = 4;
            switch (_difficulty)
            {
                case SODifficultyEasy:
                {
                    numberOfColors = 4;
                    numberOfRecepticles = 4;
                    break;
                }
                case SODifficultyMedium:
                {
                    numberOfColors = 6;
                    numberOfRecepticles = 4;
                    break;
                }
                case SODifficultyHard:
                default:
                {
                    numberOfColors = 6;
                    numberOfRecepticles = 5;
                    break;
                }
            }
            
            _codeSelectionView = [[SOCodeSelectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.35)
                                                             numberOfColors:numberOfColors
                                                        numberOfRecepticles:numberOfRecepticles];
            _codeSelectionView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.68);
            _codeSelectionView.delegate = self;
            
            [_contentView addSubview:_codeSelectionView];
            
            numberLabel.text = @"3";
            stepLabel.text = @"STEP THREE";
            messageLabel.text = @"Choose Code";
            break;
        }
    }
    
    [_contentView addSubview:numberCircle];
    [_contentView addSubview:numberLabel];
    [_contentView addSubview:stepLabel];
    [_contentView addSubview:messageLabel];
    [_contentView addSubview:_backButton];
    [_contentView addSubview:_submitButton];
    [self.view addSubview:_contentView];
    [numberLabel release];
    [numberCircle release];
    [stepLabel release];
    [messageLabel release];
}

- (void)dealloc
{
    [_nameField release];
    [_submitButton release];
    [_backButton release];
    [_name release];
    [_contentView release];
    [_codeSelectionView release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITextFieldDelegate
//////////////////////////////////////////////////////////////////////////

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.view.frame.size.height < 500) //IS iPHONE 4 or 4S
    {
        [UIView animateWithDuration:0.3 animations:^()
         {
             CGRect frame = _contentView.frame;
             frame.origin.y = -45;
             _contentView.frame = frame;
         }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0)
    {
        _submitButton.alpha = 1.0f;
    }
    else
    {
        _submitButton.alpha = 0.0f;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    return YES;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOCodeSelectionViewDelegate
//////////////////////////////////////////////////////////////////////////

- (void)codeSelectionViewDidChangeRecepticles:(SOCodeSelectionView *)codeSelectionView
{
    if ([codeSelectionView recepticlesPopulated] == YES)
    {
        [UIView animateWithDuration:0.2 animations:^() {
            _submitButton.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^() {
           _submitButton.alpha = 0.0;
        }];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOButtonDelegate
//////////////////////////////////////////////////////////////////////////

- (void)buttonPressed:(SOButton *)button
{
    if (button == _submitButton)
    {
        switch (_step)
        {
            case 1:
            case 2:
            {
                if ([self.delegate respondsToSelector:@selector(passAndPlayStepsViewController:returnedWithStep:)])
                {
                    [self.delegate passAndPlayStepsViewController:self returnedWithStep:_step];
                }
                break;
            }
            case 3:
            default:
            {
                if ([_codeSelectionView recepticlesPopulated] == YES)
                {
                    if ([self.delegate respondsToSelector:@selector(passAndPlayStepsViewController:returnedWithCode:)])
                    {
                        [self.delegate passAndPlayStepsViewController:self returnedWithCode:[_codeSelectionView colorsInRecepticles]];
                    }
                }
                break;
            }
        }
        
    }
    else if(button == _backButton)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////

- (void)dismissKeyboard
{
    [_nameField resignFirstResponder];
    if (self.view.frame.size.height < 500) //IS iPHONE 4 or 4S
    {
        [UIView animateWithDuration:0.3 animations:^()
         {
             _contentView.frame = _startingFrame;
         }];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (NSString *)name
{
    if (_step == 1)
    {
        return _nameField.text;
    }
    else
    {
        return _name;
    }
}

@end
