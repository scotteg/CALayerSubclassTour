//
//  CAGradientLayerViewController.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 4/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "CAGradientLayerViewController.h"

typedef enum : NSUInteger {
  ColorRed,
  ColorOrange,
  ColorYellow,
  ColorGreen,
  ColorBlue,
  ColorIndigo,
  ColorViolet,
} Color;

@interface CAGradientLayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewForGradientLayer;
@property (weak, nonatomic) IBOutlet UISlider *startPointSlider;
@property (weak, nonatomic) IBOutlet UILabel *startPointSliderValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *endPointSlider;
@property (weak, nonatomic) IBOutlet UILabel *endPointSliderValueLabel;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *colorSwitches;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *locationSliders;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *locationValueLabels;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (copy, nonatomic) NSArray *colors;
@property (copy, nonatomic) NSArray *locations;
@end

@implementation CAGradientLayerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.gradientLayer = [CAGradientLayer layer];
  self.gradientLayer.frame = self.viewForGradientLayer.bounds;
  self.colors = @[(__bridge id)[UIColor colorWithRed:209/255.0f green:0.0f blue:0.0f alpha:1.0f].CGColor,
    (__bridge id)[UIColor colorWithRed:1.0f green:102/255.0f blue:34/255.0f alpha:1.0f].CGColor,
    (__bridge id)[UIColor colorWithRed:1.0f green:218/255.0f blue:33/255.0f alpha:1.0f].CGColor,
    (__bridge id)[UIColor colorWithRed:51/255.0f green:221/255.0f blue:0.0f alpha:1.0f].CGColor,
    (__bridge id)[UIColor colorWithRed:17/255.0f green:51/255.0f blue:204/255.0f alpha:1.0f].CGColor,
    (__bridge id)[UIColor colorWithRed:34/255.0f green:0.0f blue:102/255.0f alpha:1.0f].CGColor,
    (__bridge id)[UIColor colorWithRed:51/255.0f green:0.0f blue:68/255.0f alpha:1.0f].CGColor];
  self.gradientLayer.colors = self.colors;
  self.gradientLayer.startPoint = (CGPoint){0.5f, 0.0f};
  self.gradientLayer.endPoint = (CGPoint){0.5f, 1.0f};
  self.locations = @[@0.0, @(1/6.0f), @(1/3.0f), @0.5, @(2/3.0f), @(5/6.0f), @1.0];
  self.gradientLayer.locations = self.locations;
  [self.viewForGradientLayer.layer addSublayer:self.gradientLayer];
  
  __weak typeof(self)weakSelf = self;
  [self.locationSliders enumerateObjectsUsingBlock:^(UISlider *slider, NSUInteger idx, BOOL *stop) {
    __strong typeof(weakSelf)strongSelf = weakSelf;
    slider.value = [strongSelf.locations[idx] floatValue];
  }];
  
  [self updateStartAndEndPointValueLabels];
  [self updateLocationValueLabels];
}

- (IBAction)startPointSliderChanged:(UISlider *)sender
{
  self.gradientLayer.startPoint = (CGPoint){sender.value, 0.0f};
  [self updateStartAndEndPointValueLabels];
}

- (IBAction)endPointSliderChanged:(UISlider *)sender
{
  self.gradientLayer.endPoint = (CGPoint){sender.value, 1.0f};
  [self updateStartAndEndPointValueLabels];
}

- (void)updateStartAndEndPointValueLabels
{
  self.startPointSliderValueLabel.text = [NSString stringWithFormat:@"(%.1f, 0.0)", self.startPointSlider.value];
  self.endPointSliderValueLabel.text = [NSString stringWithFormat:@"(%.1f, 1.0)", self.endPointSlider.value];
}

- (IBAction)colorSwitchChanged:(UISwitch *)sender
{
  NSMutableArray *colors = [NSMutableArray new];
  NSMutableArray *locations = [NSMutableArray new];
  
  __weak typeof(self)weakSelf = self;
  [self.colorSwitches enumerateObjectsUsingBlock:^(UISwitch *colorSwitch, NSUInteger idx, BOOL *stop) {
    __strong typeof(weakSelf)strongSelf = weakSelf;

    UISlider *slider = strongSelf.locationSliders[idx];
    
    if (colorSwitch.on) {
      [colors addObject:self.colors[idx]];
      UISlider *slider = strongSelf.locationSliders[idx];
      [locations addObject:@(slider.value)];
      slider.hidden = NO;
    } else {
      slider.hidden = YES;
    }
  }];
  
  if ([colors count] == 1) {
    [colors addObject:colors[0]];
  }
  
  self.gradientLayer.colors = colors;
  self.gradientLayer.locations = [locations count] > 1 ? locations : nil;
  [self updateLocationValueLabels];
}

- (IBAction)locationSliderChanged:(UISlider *)sender
{
  NSMutableArray *locations = [NSMutableArray new];
  
  __weak typeof(self)weakSelf = self;
  [self.locationSliders enumerateObjectsUsingBlock:^(UISlider *slider, NSUInteger idx, BOOL *stop) {
    __strong typeof(weakSelf)strongSelf = weakSelf;
    UISwitch *colorSwitch = strongSelf.colorSwitches[idx];
    
    if (colorSwitch.on) {
      [locations addObject:@(slider.value)];
    }
  }];
  
  self.gradientLayer.locations = locations;
  [self updateLocationValueLabels];
}

- (void)updateLocationValueLabels
{
  __weak typeof(self)weakSelf = self;
  [self.locationValueLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
    __strong typeof(weakSelf)strongSelf = weakSelf;
    UISwitch *colorSwitch = strongSelf.colorSwitches[idx];
    
    if (colorSwitch.on) {
      UISlider *slider = strongSelf.locationSliders[idx];
      label.text = [NSString stringWithFormat:@"%.2f", slider.value];
      label.hidden = NO;
    } else {
      label.hidden = YES;
    }
  }];
}

@end
