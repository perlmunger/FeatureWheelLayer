//
//  MLViewController.m
//  SpinnyFeatureWheel
//
//  Created by Matt Long on 3/5/13.
//  Copyright (c) 2013 Matt Long. All rights reserved.
//

#import "MLViewController.h"
#import "MLFeatureWheelLayer.h"

@interface MLViewController ()

@end

@implementation MLViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  MLFeatureWheelLayer *featureWheelLayer = [MLFeatureWheelLayer layer];
  [featureWheelLayer setPosition:CGPointMake([[self view] center].x, 240.0f)];
  
  [[[self view] layer] addSublayer:featureWheelLayer];

  MLFeatureWheelLayer *featureWheelLayer2 = [MLFeatureWheelLayer layer];
  [featureWheelLayer2 setPosition:CGPointMake([[self view] center].x, 560.0f)];
  [featureWheelLayer2 setBurstColor:[UIColor orangeColor]];
  [featureWheelLayer2 setAltBurstColor:[UIColor yellowColor]];
  [featureWheelLayer2 setStarColor:[UIColor redColor]];
  
  [[[self view] layer] addSublayer:featureWheelLayer2];
}

@end
