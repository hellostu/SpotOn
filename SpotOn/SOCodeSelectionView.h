//
//  SOCodeSelectionView.h
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOCodeSelectionView;
@protocol SOCodeSelectionViewDelegate;

@interface SOCodeSelectionView : UIView

@property(nonatomic, readwrite, assign) id<SOCodeSelectionViewDelegate> delegate;
@property(nonatomic, readwrite, assign) BOOL                            regrowCircles;

- (id)initWithFrame:(CGRect)frame numberOfColors:(int)numberOfColors numberOfRecepticles:(int)numberOfRecepticles useHoles:(BOOL)holes;

- (NSArray *)colorsInRecepticles;

- (void)submitAllCirclesWithCompletion:(void (^)(NSArray *circles))completion;

- (BOOL)recepticlesPopulated;

- (void)populateRecepticlesWithCode:(NSArray *)code;
@end

@protocol SOCodeSelectionViewDelegate <NSObject>

@optional
- (void)codeSelectionViewWillChangeRecepticles:(SOCodeSelectionView *)codeSelectionView;
- (void)codeSelectionViewDidChangeRecepticles:(SOCodeSelectionView *)codeSelectionView;

@end