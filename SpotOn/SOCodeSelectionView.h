//
//  SOCodeSelectionView.h
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOCodeSelectionView;
@protocol SLCodeSelectionViewDelegate;

@interface SOCodeSelectionView : UIView

@property(nonatomic, readwrite, assign) id<SLCodeSelectionViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame numberOfColors:(int)numberOfColors numberOfRecepticles:(int)numberOfRecepticles;

- (NSArray *)colorsInRecepticles;

- (void)submitAllCirclesWithCompletion:(void (^)(NSArray *circles))completion;

- (BOOL)recepticlesPopulated;
@end

@protocol SLCodeSelectionViewDelegate <NSObject>

@optional
- (void)codeSelectionViewWillChangeRecepticles:(SOCodeSelectionView *)codeSelectionView;

@end