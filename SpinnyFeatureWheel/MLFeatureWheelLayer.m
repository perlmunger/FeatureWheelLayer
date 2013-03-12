// Copyright 2013 Matt Long http://www.cimgf.com/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MLFeatureWheelLayer.h"

#define kDefaultLayerSize        CGSizeMake(500.0f, 300.0f)
#define kMaxStarSize             CGSizeMake(200.0f, 200.0f)
#define kDefaultNumberOfSegments 28
#define kBackgroundUpsizeFactor  2.5f
#define kDefaultStarCount        7
#define kDefaultBurstColor       [UIColor colorWithRed:172.0f/255.0f green:193.0f/255.0f blue:210.0f/255.0f alpha:1.0f]
#define kDefaultAltBurstColor    [UIColor colorWithRed:18.0f/255.0f green:56.0f/255.0f blue:169.0f/255.0f alpha:1.0f]
#define kDefaultStarColor        [UIColor colorWithRed:25.0f/255.0f green:77.0f/255.0f blue:232.0f/255.0f alpha:1.0f]

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
    _starLayers = [[NSMutableArray alloc] init];
    _stripeLayers = [[NSMutableArray alloc] init];
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
    
    [_stripeLayers addObject:shapeLayer];
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
      [_starLayers addObject:starLayer];
      [self addSublayer:starLayer];
    }
  }
  
  [self startAnimating];
}

- (void)layoutSublayers
{
  NSInteger i = 0;
  for (CAShapeLayer *layer in _stripeLayers) {
    if (i++ % 2 == 0) {
      [layer setFillColor:[[self burstColor] CGColor]];
    } else {
      [layer setFillColor:[[self altBurstColor] CGColor]];
    }
  }

  for (CAShapeLayer *starLayer in _starLayers) {
    [starLayer setFillColor:[[self starColor] CGColor]];
  }

}

- (void)startAnimating
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
  [animation setFromValue:[NSNumber numberWithFloat:0.0f]];
  [animation setToValue:[NSNumber numberWithFloat:2.0f * M_PI]];
  [animation setDuration:30.0f];
  [animation setRepeatCount:HUGE_VALF];
  
  [_outerLayer addAnimation:animation forKey:@"transform.rotation"];
  
  // Add a rotation animation to each layer
  for (CAShapeLayer *starLayer in _starLayers) {
    CABasicAnimation *starAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [starAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
    [starAnimation setToValue:[NSNumber numberWithFloat:2.0f * M_PI]];
    [starAnimation setDuration:5.0f];
    [starAnimation setRepeatCount:HUGE_VALF];
    
    [starLayer addAnimation:starAnimation forKey:@"transform.rotation"];
  }
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
