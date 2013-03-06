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

- (void)buildSublayers;

@end
