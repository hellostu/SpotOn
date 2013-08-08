//
//  SODialogViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 17/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SODialogViewController.h"
#import "SOCodeSelectionView.h"
#import "SOGuessFeedbackIndicator.h"
#import "SOLine.h"
#import "SOButton.h"

@interface SODialogViewController ()
{
    UIView *_additionalView;
}

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
        _additionalView = nil;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_additionalView != nil)
    {
        if ([_additionalView isKindOfClass:SOCodeSelectionView.class] == YES)
        {
            [UIView animateWithDuration:0.4 animations:^(){
                _additionalView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.7);
            }];
        }
        else if([_additionalView isKindOfClass:SOGuessFeedbackIndicator.class])
        {
            if (_additionalView.alpha == 0.0)
            {
                [(SOGuessFeedbackIndicator *)_additionalView animateIn];
            }
        }
        else if([_additionalView isKindOfClass:UIView.class] == YES)
        {
            for (UIView *view in _additionalView.subviews)
            {
                if ([view isKindOfClass:SOGuessFeedbackIndicator.class])
                {
                    SOGuessFeedbackIndicator *GFI = (SOGuessFeedbackIndicator *)view;
                    if (GFI.alpha == 0.0)
                    {
                        [GFI animateIn];
                    }
                }
                else
                {
                    [UIView animateWithDuration:0.2 animations:^() {
                        view.alpha = 1.0f;
                    }];
                }
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_additionalView release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)setupPage:(int)page
{
    switch (page)
    {
        case 1:
        {
            self.dialogView.titleLabel.text = @"Nice Work!";
            self.dialogView.messageLabel.text = @"let's get started";
            self.dialogView.backgroundColor = GREEN_COLOR;
            break;
        }
        case 2:
        {
            self.dialogView.titleLabel.text = @"The Goal";
            self.dialogView.messageLabel.text = @"guess opponent's\ncolor code";
            self.dialogView.backgroundColor = PURPLE_COLOR;
            _additionalView = [[SOCodeSelectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.3)
                                                          numberOfColors:4
                                                     numberOfRecepticles:4
                                                                useHoles:NO];
            _additionalView.center = CGPointMake(self.view.frame.size.width*1.4, self.view.frame.size.height*0.7);
            [self.view addSubview:_additionalView];
            break;
        }
        case 3:
        {
            _additionalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 50)];
            _additionalView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.7);
            
            SOLine *line1 = [[SOLine alloc] initWithFrame:CGRectMake(0, 0, 10, 39)];
            line1.center = CGPointMake(55, 25);
            line1.alpha = 0.0f;
            line1.strokeColor = RED_COLOR;
            line1.dashedLine = YES;
            line1.lineType = SOLineTypeVertical;
            SOLine *line2 = [[SOLine alloc] initWithFrame:CGRectMake(0, 0, 10, 39)];
            line2.center = CGPointMake(115, 25);
            line2.alpha = 0.0f;
            line2.strokeColor = RED_COLOR;
            line2.dashedLine = YES;
            line2.lineType = SOLineTypeVertical;
            
            SOGuessFeedbackIndicator *GFI1 = [[SOGuessFeedbackIndicator alloc] initWithNumberRecepticles:5];
            GFI1.frame = CGRectMake(0, 0, 50, 50);
            [GFI1 hideDots];
            
            SOGuessFeedbackIndicator *GFI2 = [[SOGuessFeedbackIndicator alloc] initWithNumberRecepticles:5];
            GFI2.frame = CGRectMake(60, 0, 50, 50);
            [GFI2 setRightColorRightPosition:0 andRightColorWrongPosition:5];
            [GFI2 hideDots];
            
            SOGuessFeedbackIndicator *GFI3 = [[SOGuessFeedbackIndicator alloc] initWithNumberRecepticles:5];
            GFI3.frame = CGRectMake(120, 0, 50, 50);
            [GFI3 setRightColorRightPosition:5 andRightColorWrongPosition:0];
            [GFI3 hideDots];
            
            [_additionalView addSubview:GFI1];
            [_additionalView addSubview:GFI2];
            [_additionalView addSubview:GFI3];
            [_additionalView addSubview:line1];
            [_additionalView addSubview:line2];
            
            [GFI1 hideDots];
            [GFI2 hideDots];
            [GFI3 hideDots];
            
            [GFI1 release];
            [GFI2 release];
            [GFI3 release];
            [line1 release];
            [line2 release];
            
            self.dialogView.titleLabel.text = @"The System";
            self.dialogView.messageLabel.text = @"of scoring";
            self.dialogView.backgroundColor = RED_COLOR;
            
            [self.view addSubview:_additionalView];
            
            [_additionalView release];
            break;
        }
        case 4:
        {
            self.dialogView.titleLabel.text = @"New Game";
            self.dialogView.messageLabel.text = @"no score yet";
            self.dialogView.backgroundColor = GREEN_COLOR;
            
            _additionalView = [[SOGuessFeedbackIndicator alloc] initWithNumberRecepticles:5];
            _additionalView.frame = CGRectMake(0, 0, 50, 50);
            _additionalView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.7);
            _additionalView.alpha = 0.0f;
            
            [self.view addSubview:_additionalView];
            
            break;
        }
        case 5:
        {
            self.dialogView.titleLabel.text = @"Right Color";
            self.dialogView.messageLabel.text = @"wrong place";
            self.dialogView.backgroundColor = BLUE_COLOR;
            
            _additionalView = [[SOGuessFeedbackIndicator alloc] initWithNumberRecepticles:5];
            _additionalView.frame = CGRectMake(0, 0, 50, 50);
            _additionalView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.7);
            _additionalView.alpha = 0.0f;
            [(SOGuessFeedbackIndicator *)_additionalView setRightColorRightPosition:0 andRightColorWrongPosition:5];
            
            [self.view addSubview:_additionalView];
            break;
        }
        case 6:
        {
            self.dialogView.titleLabel.text = @"Right Color";
            self.dialogView.messageLabel.text = @"right place";
            self.dialogView.backgroundColor = RED_COLOR;
            
            _additionalView = [[SOGuessFeedbackIndicator alloc] initWithNumberRecepticles:5];
            _additionalView.frame = CGRectMake(0, 0, 50, 50);
            _additionalView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.7);
            _additionalView.alpha = 0.0f;
            [(SOGuessFeedbackIndicator *)_additionalView setRightColorRightPosition:5 andRightColorWrongPosition:0];
            
            [self.view addSubview:_additionalView];
            break;
        }
        case 7:
        {
            self.dialogView.titleLabel.text = @"Brilliant!";
            self.dialogView.messageLabel.text = @"game on";
            self.dialogView.backgroundColor = ORANGE_COLOR;
            
            SOButton *nextButton = [[SOButton alloc] initWithType:SOButtonTypeNext];
            nextButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.7);
            [self.view addSubview:nextButton];
            [nextButton release];
            break;
        }
        default:
            break;
    }
}

@end
