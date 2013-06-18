//
//  SLLine.h
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    SOLineTypeHorizontal,
    SOLineTypeVertical,
} SOLineType;

@interface SOLine : UIView

@property(nonatomic, retain) UIColor                *strokeColor;
@property(nonatomic, readwrite, assign) BOOL        dashedLine;
@property(nonatomic, readwrite, assign) SOLineType  lineType;

@end
