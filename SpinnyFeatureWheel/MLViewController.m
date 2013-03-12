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
