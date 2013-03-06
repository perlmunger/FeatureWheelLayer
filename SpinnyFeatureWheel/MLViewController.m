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

  MLFeatureWheelLayer *featureWheelLayer = [[MLFeatureWheelLayer alloc] initWithFrame:[[self view] bounds]];
  [featureWheelLayer setPosition:[[self view] center]];
  
  [[[self view] layer] addSublayer:featureWheelLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
