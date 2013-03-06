//
//  MLFeatureWheelLayer.m
//  SpinnyFeatureWheel
//
//  Created by Matt Long on 3/5/13.
//  Copyright (c) 2013 Matt Long. All rights reserved.
//

#import "MLFeatureWheelLayer.h"

#define kDefaultLayerSize        CGSizeMake(500.0f, 300.0f)
#define kMaxStarSize             CGSizeMake(200.0f, 200.0f)
#define kDefaultNumberOfSegments 28
#define kBackgroundUpsizeFactor  2.5f
#define kDefaultStarCount        7
#define kDefaultBurstColor       [UIColor orangeColor]
#define kDefaultAltBurstColor    [UIColor yellowColor]
#define kDefaultStarColor        [UIColor redColor]

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
    [self setStarCount:kDefaultStarCount];
    [self setBurstColor:kDefaultBurstColor];
    [self setAltBurstColor:kDefaultAltBurstColor];
    [self setStarColor:kDefaultStarColor];
    [self setShouldDisplayStars:YES];
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
  
  CGFloat width = radius * 2 * M_PI / (CGFloat)[self segmentCount];
  for (NSInteger i = 0; i < [self segmentCount]; ++i) {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0.0f, 0.0f, width, radius)];
    [shapeLayer setPosition:CGPointMake([_outerLayer bounds].size.width/2.0f, [_outerLayer bounds].size.height / 2.0f)];
    [shapeLayer setAnchorPoint:CGPointMake(0.5f, 1.0f)];
    if (i % 2 == 0) {
      [shapeLayer setFillColor:[[self burstColor] CGColor]];
    } else {
      [shapeLayer setFillColor:[[self altBurstColor] CGColor]];
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
  
  if ([self shouldDisplayStars]) {
    for (NSInteger i = 0; i < [self starCount]; ++i) {
      UIBezierPath *path = [self randomStarPath];
      CAShapeLayer *starLayer = [CAShapeLayer layer];
      [starLayer setBounds:[path bounds]];
      [starLayer setPath:[path CGPath]];
      CGFloat x = (CGFloat)(arc4random() % (NSInteger)[self bounds].size.width);
      CGFloat y = (CGFloat)(arc4random() % (NSInteger)[self bounds].size.width);
      [starLayer setPosition:CGPointMake(x, y)];
      [starLayer setFillColor:[[self starColor] CGColor]];
      NSInteger randomAngleInDegrees = arc4random() % 360;
      [starLayer setTransform:CATransform3DMakeRotation((CGFloat)randomAngleInDegrees * 180.0f / M_PI, 0.0f, 0.0f, 1.0f)];
      [self addSublayer:starLayer];
    }
  }
  
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

- (UIBezierPath*)randomStarPath
{
  CGFloat size = (CGFloat)(arc4random() % (NSInteger)kMaxStarSize.width);

  UIBezierPath *starPath = [UIBezierPath bezierPath];
  
  CGFloat xCenter = size / 2.0f;
  CGFloat yCenter = size / 2.0f;
  
  double radius = size / 2.0;
  CGFloat flip = -1.0;

  double angle = 2.0 * M_PI * (2.0 / 5.0);

  [starPath moveToPoint:CGPointMake(xCenter, radius * flip + yCenter)];
  
  for (NSUInteger index = 1; index < 5; ++index) {
    CGFloat x = radius * sin(index * angle);
    CGFloat y = radius * cos(index * angle);
    [starPath addLineToPoint:CGPointMake(x+xCenter, y * flip + yCenter)];
  }
  
  [starPath closePath];
  
  return starPath;
}

@end
