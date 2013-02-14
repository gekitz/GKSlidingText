//
//  GKSlidingText.h
//  GKSlidingText
//
//  Created by Georg Kitz on 2/10/13.
//  Copyright (c) 2013 Aurora Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKSlidingText : UIView
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;

@property (nonatomic, assign) CGFloat animationDuration;
@end
