//
//  SLCircle.h
//  Mastermind
//
//  Created by Stuart Lynch on 13/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SO_TOUCH_AREA_INCREASE 5

@class SOCircle;
@class SORecepticle;
@protocol SLCircleDelegate;

@interface SOCircle : UIView <NSCopying>

@property(nonatomic, retain) UIColor                            *fillColor;
@property(nonatomic, retain) UIColor                            *strokeColor;
@property(nonatomic, readwrite, assign) CGFloat                 strokeWidth;
@property(nonatomic, readwrite, assign) BOOL                    dashedLine;
@property(nonatomic, readwrite, assign) BOOL                    draggable;
@property(nonatomic, readwrite, assign) BOOL                    placeholder;
@property(nonatomic, readwrite, assign) SORecepticle            *recepticle;
@property(nonatomic, readwrite, assign) CGPoint                 startLocation;
@property(nonatomic, readwrite, assign) id<SLCircleDelegate>    delegate;

- (id)initWithFrame:(CGRect)frame expandTouchArea:(BOOL)expandTouchArea;
- (int)indexOfRecepticleWithCollisionFromRecepticles:(NSArray *)recepticles;
+ (UIColor *)colorForTag:(SOCircleColor)tag;
+ (NSArray *)mapFromColors:(NSArray *)colors;

@end

@protocol SLCircleDelegate <NSObject>

@optional
- (void)circle:(SOCircle *)circle beganDragAtLocation:(CGPoint)location;
- (void)circle:(SOCircle *)circle wasDraggedAtLocation:(CGPoint)location;
- (void)circle:(SOCircle *)circle endedDragAtLocation:(CGPoint)location;
- (void)circleWasTapped:(SOCircle*)circle;

@end