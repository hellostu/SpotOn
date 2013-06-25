//
//  SOProfilePicture.h
//  SpotOn
//
//  Created by Stuart Lynch on 22/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOCircle.h"

typedef enum  {
    SOProfilePictureTypeLarge,
    SOProfilePictureTypeSmall
} SOProfilePictureType;


@interface SOProfilePicture : SOCircle

@property(nonatomic, readonly) UIImageView *imageView;

- (id)initWithType:(SOProfilePictureType)profilePictureType;

@end
