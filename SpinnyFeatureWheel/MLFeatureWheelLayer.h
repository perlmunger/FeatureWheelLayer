//
//  MLFeatureWheelLayer.h
//  SpinnyFeatureWheel
//
//  Created by Matt Long on 3/5/13.
//  Copyright (c) 2013 Matt Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLFeatureWheelLayer : CALayer

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) NSInteger segmentCount;
@property (nonatomic, strong) CALayer *outerLayer;
@property (nonatomic, assign) BOOL shouldDisplayStars;
@property (nonatomic, assign) NSInteger starCount;

@property (nonatomic, strong) UIColor *burstColor;
@property (nonatomic, strong) UIColor *altBurstColor;
@property (nonatomic, strong) UIColor *starColor;

@property (nonatomic, strong) NSMutableArray *starLayers;
@property (nonatomic, strong) NSMutableArray *stripeLayers;

- (void)buildSublayers;

- (UIBezierPath*)randomStarPath;

@end
