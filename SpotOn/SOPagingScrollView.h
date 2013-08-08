//
//  SOPagingScrollView.h
//  SpotOn
//
//  Created by Stuart Lynch on 13/07/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOPagingScrollView : UIView
{
    @protected
    UIScrollView *_scrollView;
}
@property(readwrite, assign) CGSize contentSize;

- (id)initWithFrame:(CGRect)frame pageWidth:(CGFloat)pageWidth;

@end
