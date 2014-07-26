//
//  CAReplicatorLayerViewController.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 4/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "CAReplicatorLayerViewController.h"

static CGFloat const LengthMultiplier = 3.0f;
static NSString * const FadeAnimation = @"FadeAnimation";

typedef enum : NSUInteger {
  OffsetRed = 1,
  OffsetGreen,
  OffsetBlue,
  OffsetAlpha
} Offset;

@interface CAReplicatorLayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewForReplicatorLayer;
@property (weak, nonatomic) IBOutlet UISlider *layerSizeSlider;
@property (weak, nonatomic) IBOutlet UILabel *layerSizeSliderValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *instanceCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *instanceCountSliderValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *instanceDelaySlider;
@property (weak, nonatomic) IBOutlet UILabel *instanceDelaySliderValueLabel;
@property (weak, nonatomic) IBOutlet UISwitch *offsetRedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *offsetGreenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *offsetBlueSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *offsetAlphaSwitch;

@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CALayer *layer;
@property (strong, nonatomic) CABasicAnimation *fadeAnimation;
@end

@implementation CAReplicatorLayerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.replicatorLayer = [CAReplicatorLayer layer];
  self.replicatorLayer.frame = self.viewForReplicatorLayer.bounds;
  self.replicatorLayer.instanceCount = self.instanceCountSlider.value;
  self.replicatorLayer.instanceDelay = self.instanceDelaySlider.value / self.replicatorLayer.instanceCount;
  self.replicatorLayer.preservesDepth = NO;
  self.replicatorLayer.instanceColor = [UIColor whiteColor].CGColor;
  self.replicatorLayer.instanceRedOffset = [self offsetValueForSwitch:self.offsetRedSwitch];
  self.replicatorLayer.instanceGreenOffset = [self offsetValueForSwitch:self.offsetGreenSwitch];
  self.replicatorLayer.instanceBlueOffset = [self offsetValueForSwitch:self.offsetBlueSwitch];
  self.replicatorLayer.instanceAlphaOffset = [self offsetValueForSwitch:self.offsetAlphaSwitch];
  
  CGFloat angle = (M_PI * Two) / self.replicatorLayer.instanceCount;
  CATransform3D transform = CATransform3DMakeRotation(angle, Zero, Zero, One);
  self.replicatorLayer.instanceTransform = transform;
  
  [self.viewForReplicatorLayer.layer addSublayer:self.replicatorLayer];
  
  self.layer = [CALayer layer];
  CGFloat layerWidth = self.layerSizeSlider.value;
  CGFloat midX = CGRectGetMidX(self.viewForReplicatorLayer.bounds) - layerWidth / Two;
  self.layer.frame = (CGRect){midX, Zero, layerWidth, layerWidth * LengthMultiplier};
  self.layer.backgroundColor = [UIColor whiteColor].CGColor;
  
  self.fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  self.fadeAnimation.fromValue = @(One);
  self.fadeAnimation.toValue = @(Zero);
  self.fadeAnimation.repeatCount = CGFLOAT_MAX;
  
  [self.replicatorLayer addSublayer:self.layer];
  
  [self updateLayerSizeSliderValueLabel];
  [self updateInstanceCountSliderValueLabel];
  [self updateInstanceDelaySliderValueLabel];
}

- (void)setLayerFadeAnimation
{
  self.layer.opacity = Zero;
  self.fadeAnimation.duration = self.instanceDelaySlider.value;
  [self.layer addAnimation:self.fadeAnimation forKey:FadeAnimation];
}

- (void)updateLayerSizeSliderValueLabel
{
  CGFloat value = self.layerSizeSlider.value;
  self.layerSizeSliderValueLabel.text = [NSString stringWithFormat:@"%.0f x %.0f", value, value * LengthMultiplier];
}

- (void)updateInstanceCountSliderValueLabel
{
  self.instanceCountSliderValueLabel.text = [NSString stringWithFormat:@"%.0f", self.instanceCountSlider.value];
}

- (void)updateInstanceDelaySliderValueLabel
{
  self.instanceDelaySliderValueLabel.text = [NSString stringWithFormat:@"%.0f", self.instanceDelaySlider.value];
}

- (IBAction)layerSizeSliderChanged:(UISlider *)sender
{
  CGFloat value = sender.value;
  self.layer.bounds = (CGRect){CGPointZero, value, value * LengthMultiplier};
  [self updateLayerSizeSliderValueLabel];
}

- (IBAction)instanceCountSliderChanged:(UISlider *)sender
{
  self.replicatorLayer.instanceCount = sender.value;
  self.replicatorLayer.instanceAlphaOffset = [self offsetValueForSwitch:self.offsetAlphaSwitch];
  [self updateInstanceCountSliderValueLabel];
}

- (IBAction)instanceDelaySliderChanged:(UISlider *)sender
{
  if (sender.value > 0) {
    self.replicatorLayer.instanceDelay = sender.value / self.replicatorLayer.instanceCount;
    [self setLayerFadeAnimation];
  } else {
    self.replicatorLayer.instanceDelay = Zero;
    self.layer.opacity = One;
    [self.layer removeAllAnimations];
  }
  
  [self updateInstanceDelaySliderValueLabel];
}

- (CGFloat)offsetValueForSwitch:(UISwitch *)offsetSwitch
{
  if (offsetSwitch == self.offsetAlphaSwitch) {
    return offsetSwitch.on ? -One / self.replicatorLayer.instanceCount : Zero;
  } else {
    return offsetSwitch.on ? Zero : -0.05f;
  }
}

- (IBAction)offsetSwitchChanged:(UISwitch *)sender
{
  switch (sender.tag) {
    case OffsetRed:
      self.replicatorLayer.instanceRedOffset = [self offsetValueForSwitch:sender];
      break;
      
    case OffsetGreen:
      self.replicatorLayer.instanceGreenOffset = [self offsetValueForSwitch:sender];
      break;
      
    case OffsetBlue:
      self.replicatorLayer.instanceBlueOffset = [self offsetValueForSwitch:sender];
      break;
      
    case OffsetAlpha:
      self.replicatorLayer.instanceAlphaOffset = [self offsetValueForSwitch:sender];
      break;
  }
}

@end
