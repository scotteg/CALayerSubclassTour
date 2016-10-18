//
//  CATransformLayerViewController.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 4/21/14.
//  Copyright (c) 2014 Optimac, Inc. All rights reserved.
//

#import "CATransformLayerViewController.h"
#import "TrackBall.h"
@import CoreText;

static CGFloat const SideLength = 160.0f;
static CGFloat const ReducedAlpha = 0.8f;

typedef enum : NSUInteger {
  ColorRed,
  ColorOrange,
  ColorYellow,
  ColorGreen,
  ColorBlue,
  ColorPurple
} Color;

@interface CATransformLayerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *boxTappedLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForTransformLayer;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *colorAlphaSwitches;
@property (strong, nonatomic) CATransformLayer *transformLayer;
@property (strong, nonatomic) CATextLayer *swipeMeTextLayer;
@property (strong, nonatomic) UIColor *redColor;
@property (strong, nonatomic) UIColor *orangeColor;
@property (strong, nonatomic) UIColor *yellowColor;
@property (strong, nonatomic) UIColor *greenColor;
@property (strong, nonatomic) UIColor *blueColor;
@property (strong, nonatomic) UIColor *purpleColor;
@property (strong, nonatomic) TrackBall *trackBall;
@end

@implementation CATransformLayerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.swipeMeTextLayer = [CATextLayer layer];
  self.swipeMeTextLayer.frame = (CGRect){Zero, SideLength / 4.0f, SideLength, SideLength / Two};
  self.swipeMeTextLayer.string = @"Swipe me";
  self.swipeMeTextLayer.alignmentMode = kCAAlignmentCenter;
  self.swipeMeTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
  CFStringRef fontName = (__bridge CFStringRef)@"Noteworthy-Light";
  CTFontRef fontRef = CTFontCreateWithName(fontName, 24.0f, NULL);
  self.swipeMeTextLayer.font = fontRef;
  self.swipeMeTextLayer.contentsScale = [UIScreen mainScreen].scale;
  CFRelease(fontRef);
  
  self.redColor = [UIColor redColor];
  self.orangeColor = [UIColor orangeColor];
  self.yellowColor = [UIColor yellowColor];
  self.greenColor = [UIColor greenColor];
  self.blueColor = [UIColor blueColor];
  self.purpleColor = [UIColor purpleColor];
  [self buildCube];
}

- (void)buildCube
{
  self.transformLayer = [CATransformLayer layer];
  
  CALayer *layer = [self sideLayerWithColor:self.redColor];
  [layer addSublayer:self.swipeMeTextLayer];
  [self.transformLayer addSublayer:layer];
  
  layer = [self sideLayerWithColor:self.orangeColor];
  CATransform3D transform = CATransform3DMakeTranslation(SideLength / Two, Zero, SideLength / -Two);
  transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(90), Zero, One, Zero);
  layer.transform = transform;
  [self.transformLayer addSublayer:layer];
  
  layer = [self sideLayerWithColor:self.yellowColor];
  layer.transform = CATransform3DMakeTranslation(Zero, Zero, -SideLength);
  [self.transformLayer addSublayer:layer];
  
  layer = [self sideLayerWithColor:self.greenColor];
  transform = CATransform3DMakeTranslation(SideLength / -Two, 0.0, SideLength / -Two);
  transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(90), Zero, One, Zero);
  layer.transform = transform;
  [self.transformLayer addSublayer:layer];
  
  layer = [self sideLayerWithColor:self.blueColor];
  transform = CATransform3DMakeTranslation(Zero, SideLength / -Two, SideLength / -Two);
  transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(90), One, Zero, Zero);
  layer.transform = transform;
  [self.transformLayer addSublayer:layer];
  
  layer = [self sideLayerWithColor:self.purpleColor];
  transform = CATransform3DMakeTranslation(Zero, SideLength / Two, SideLength / -Two);
  transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(90), One, Zero, Zero);
  layer.transform = transform;
  [self.transformLayer addSublayer:layer];
  
  self.transformLayer.anchorPointZ = SideLength / -Two;
  [self.viewForTransformLayer.layer addSublayer:self.transformLayer];
}

- (CALayer *)sideLayerWithColor:(UIColor *)color
{
  CALayer *layer = [CALayer layer];
  layer.frame = (CGRect){CGPointZero, SideLength, SideLength};
  layer.position = (CGPoint){CGRectGetMidX(self.viewForTransformLayer.bounds), CGRectGetMidY(self.viewForTransformLayer.bounds)};
  layer.backgroundColor = color.CGColor;
  return layer;
}

- (UIColor *)colorForColor:(UIColor *)color withAlpha:(CGFloat)newAlpha
{
  CGFloat red, green, blue, alpha;
  
  if ([color getRed:&red green:&green blue:&blue alpha:&alpha]) {
    color = [UIColor colorWithRed:red green:green blue:blue alpha:newAlpha];
  }
  
  return color;
}

- (IBAction)colorAlphaSwitchChanged:(UISwitch *)sender
{
  CGFloat alpha = sender.on ? ReducedAlpha : One;
  
  switch ([self.colorAlphaSwitches indexOfObject:sender]) {
    case ColorRed:
      self.redColor = [self colorForColor:self.redColor withAlpha:alpha];
      break;
      
    case ColorOrange:
      self.orangeColor = [self colorForColor:self.orangeColor withAlpha:alpha];
      break;
      
    case ColorYellow:
      self.yellowColor = [self colorForColor:self.yellowColor withAlpha:alpha];
      break;
      
    case ColorGreen:
      self.greenColor = [self colorForColor:self.greenColor withAlpha:alpha];
      break;
      
    case ColorBlue:
      self.blueColor = [self colorForColor:self.blueColor withAlpha:alpha];
      break;
      
    case ColorPurple:
      self.purpleColor = [self colorForColor:self.purpleColor withAlpha:alpha];
      break;
      
  }
  
  [self.transformLayer removeFromSuperlayer];
  [self buildCube];
}

- (void)showBoxTappedLabel
{
  self.boxTappedLabel.alpha = One;
  self.boxTappedLabel.hidden = NO;
  
  [UIView animateWithDuration:0.5 delay:1.0 options:kNilOptions animations:^{
    self.boxTappedLabel.alpha = Zero;
  } completion:^(BOOL finished) {
    self.boxTappedLabel.hidden = YES;
  }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint location = [[touches anyObject] locationInView:self.viewForTransformLayer];
  
  CALayer *layer = self.viewForTransformLayer.layer;
  CALayer *hitLayer = [layer hitTest:location];
  
  if (hitLayer) {
    [self showBoxTappedLabel];
  }
  
  if (!self.trackBall) {
    self.trackBall = [TrackBall trackBallWithLocation:location inRect:self.viewForTransformLayer.bounds];
  } else {
    [self.trackBall setStartPointFromLocation:location];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint location = [[touches anyObject] locationInView:self.viewForTransformLayer];
  CATransform3D transform = [self.trackBall rotationTransformForLocation:location];
  self.viewForTransformLayer.layer.sublayerTransform = transform;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint location = [[touches anyObject] locationInView:self.viewForTransformLayer];
  [self.trackBall finalizeTrackBallForLocation:location];
}

@end
