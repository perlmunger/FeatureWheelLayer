//
//  MLFeatureWheelLayer.m
//  SpinnyFeatureWheel
//
//  Created by Matt Long on 3/5/13.
//  Copyright (c) 2013 Matt Long. All rights reserved.
//

#import "MLFeatureWheelLayer.h"

#define kDefaultLayerSize CGSizeMake(500.0f, 300.0f)
#define kDefaultNumberOfSegments 28
#define kBackgroundUpsizeFactor 2.5f

@implementation MLFeatureWheelLayer

+ (id)layer
{
  return [[[self class] alloc] init];
}

- (id)init
{
  return [self initWithFrame:CGRectMake(0.0f, 0.0f, kDefaultLayerSize.width, kDefaultLayerSize.height)];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super init];
  if (self) {
    [self setBounds:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
    [self setBorderWidth:1.0f];
    [self setSegmentCount:kDefaultNumberOfSegments];
    [self setMasksToBounds:YES];
    [self buildSublayers];
  }
  return self;
}

- (void)buildSublayers
{
  CGFloat distance = (M_PI * 2) / (CGFloat)[self segmentCount];
  CGRect bounds = CGRectMake(0.0f, 0.0f, [self bounds].size.width * kBackgroundUpsizeFactor, [self bounds].size.height * kBackgroundUpsizeFactor);
  CGFloat radius = bounds.size.width / 2.0f;
  
  _outerLayer = [CALayer layer];
  [_outerLayer setBounds:bounds];
  [_outerLayer setPosition:CGPointMake([self bounds].size.width/2.0f, [self bounds].size.height/2.0f)];
//  [_outerLayer setBackgroundColor:[[UIColor grayColor] CGColor]];
  
  CGFloat width = radius * 2 * M_PI / (CGFloat)[self segmentCount];
  for (NSInteger i = 0; i < [self segmentCount]; ++i) {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0.0f, 0.0f, width, radius)];
    [shapeLayer setPosition:CGPointMake([_outerLayer bounds].size.width/2.0f, [_outerLayer bounds].size.height / 2.0f)];
    [shapeLayer setAnchorPoint:CGPointMake(0.5f, 1.0f)];
    if (i % 2 == 0) {
      [shapeLayer setFillColor:[[UIColor orangeColor] CGColor]];
    } else {
      [shapeLayer setFillColor:[[UIColor yellowColor] CGColor]];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width/2.0f, radius)];
    [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
    [path addLineToPoint:CGPointMake(width, 0.0f)];
    [path closePath];
    [shapeLayer setPath:[path CGPath]];
    [shapeLayer setTransform:CATransform3DMakeRotation(i*distance, 0.0f, 0.0f, 1.0f)];
    [_outerLayer addSublayer:shapeLayer];
  }
  
  [self addSublayer:_outerLayer];
  [self startAnimating];
}

- (void)startAnimating
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
  [animation setFromValue:[NSNumber numberWithFloat:0.0f]];
  [animation setToValue:[NSNumber numberWithFloat:2.0f * M_PI]];
  [animation setDuration:30.0f];
  [animation setRepeatCount:HUGE_VALF];
  
  [_outerLayer addAnimation:animation forKey:@"transform.rotation"];

}

@end
