//
//  CAShapeLayerViewController.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 4/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "CAShapeLayerViewController.h"

typedef enum : NSUInteger {
  FillRuleNonZero,
  FillRuleEvenOdd
} FillRule;

typedef enum : NSUInteger {
  LineCapButt,
  LineCapRound,
  LineCapSquare
} LineCap;

typedef enum : NSUInteger {
  LineJoinMiter,
  LineJoinRound,
  LineJoinBevel
} LineJoin;

@interface CAShapeLayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewForShapeLayer;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIBezierPath *openPath;
@property (strong, nonatomic) UIBezierPath *closedPath;
@property (weak, nonatomic) IBOutlet UISwitch *closePathSwitch;
@property (weak, nonatomic) IBOutlet UISlider *hueSlider;
@property (weak, nonatomic) IBOutlet UISwitch *fillSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fillRuleSegmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *lineWidthSlider;
@property (weak, nonatomic) IBOutlet UISwitch *lineDashSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lineCapSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lineJoinSegmentedControl;
@end

@implementation CAShapeLayerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.color = [UIColor colorWithHue:120/359.0f saturation:1.0f brightness:0.4f alpha:1.0f];
  
  self.openPath = [UIBezierPath bezierPath];
  [self.self.openPath moveToPoint:(CGPoint){30.0f, 196.0f}];
  [self.self.openPath addCurveToPoint:(CGPoint){112.0f, 12.5f}
                        controlPoint1:(CGPoint){110.56f, 13.79f}
                        controlPoint2:(CGPoint){112.07f, 13.01f}];
  [self.self.openPath addCurveToPoint:(CGPoint){194.0f, 196.0f}
                        controlPoint1:(CGPoint){111.9f, 11.81f}
                        controlPoint2:(CGPoint){194.0f, 196.0f}];
  [self.self.openPath addLineToPoint:(CGPoint){30.0f, 85.68f}];
  [self.self.openPath addLineToPoint:(CGPoint){194.0f, 48.91f}];
  [self.self.openPath addLineToPoint:(CGPoint){30.0f, 196.0f}];
  
  CGMutablePathRef closedPathRef = CGPathCreateMutableCopy(self.openPath.CGPath);
  self.closedPath = [UIBezierPath bezierPath];
  self.closedPath.CGPath = closedPathRef;
  [self.closedPath closePath];
  CGPathRelease(closedPathRef);
  
  self.shapeLayer = [CAShapeLayer layer];
  self.shapeLayer.path = self.self.openPath.CGPath;
  self.shapeLayer.fillColor = nil;
  self.shapeLayer.fillRule = kCAFillRuleNonZero;
  self.shapeLayer.lineCap = kCALineCapButt;
  self.shapeLayer.lineDashPattern = nil;
  self.shapeLayer.lineDashPhase = 0.0f;
  self.shapeLayer.lineJoin = kCALineJoinMiter;
  self.shapeLayer.lineWidth = 1.0f;
  self.shapeLayer.miterLimit = 4.0f;
  self.shapeLayer.strokeColor = self.color.CGColor;

  [self.viewForShapeLayer.layer addSublayer:self.shapeLayer];
}

- (IBAction)closePathSwitchChanged:(UISwitch *)sender
{
  if (sender.on) {
    self.lineCapSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.shapeLayer.path = self.closedPath.CGPath;
  } else {
    if (self.shapeLayer.lineCap == kCALineCapButt) {
      self.lineCapSegmentedControl.selectedSegmentIndex = LineCapButt;
    } else if (self.shapeLayer.lineCap == kCALineCapRound) {
      self.lineCapSegmentedControl.selectedSegmentIndex = LineCapRound;
    } else {
      self.lineCapSegmentedControl.selectedSegmentIndex = LineCapSquare;
    }
    
    self.shapeLayer.path = self.openPath.CGPath;
  }
}

- (IBAction)hueSliderChanged:(UISlider *)sender
{
  CGFloat hue = sender.value / 359.0f;
  UIColor *color = [UIColor colorWithHue:hue saturation:hue brightness:0.4f alpha:1.0f];
  self.shapeLayer.fillColor = self.fillSwitch.on ? color.CGColor : nil;
  self.shapeLayer.strokeColor = color.CGColor;
  self.color = color;
}

- (IBAction)fillSwitchChanged:(UISwitch *)sender
{
  if (sender.on) {
    self.shapeLayer.fillColor = self.color.CGColor;
    
    if (self.shapeLayer.fillRule == kCAFillRuleNonZero) {
      self.fillRuleSegmentedControl.selectedSegmentIndex = FillRuleNonZero;
    } else {
      self.fillRuleSegmentedControl.selectedSegmentIndex = FillRuleEvenOdd;
    }
  } else {
    self.fillRuleSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.shapeLayer.fillColor = nil;
  }
}

- (IBAction)fillRuleSegmentedControlChanged:(UISegmentedControl *)sender
{
  self.fillSwitch.on = YES;
  self.shapeLayer.fillColor = self.color.CGColor;
  
  if (sender.selectedSegmentIndex == FillRuleNonZero) {
    self.shapeLayer.fillRule = kCAFillRuleNonZero;
  } else {
    self.shapeLayer.fillRule = kCAFillRuleEvenOdd;
  }
}

- (IBAction)lineWidthSliderChanged:(UISlider *)sender
{
  self.shapeLayer.lineWidth = sender.value;
}

- (IBAction)lineDashSwitchChanged:(UISwitch *)sender
{
  if (sender.on) {
    self.shapeLayer.lineDashPattern = @[@50, @50];
    self.shapeLayer.lineDashPhase = 25.0f;
  } else {
    self.shapeLayer.lineDashPattern = nil;
    self.shapeLayer.lineDashPhase = 0.0f;
  }
}

- (IBAction)lineCapSegmentedControlChanged:(UISegmentedControl *)sender
{
  self.closePathSwitch.on = NO;
  self.shapeLayer.path = self.openPath.CGPath;
  
  switch (sender.selectedSegmentIndex) {
    case LineCapButt:
      self.shapeLayer.lineCap = kCALineCapButt;
      break;
      
    case LineCapRound:
      self.shapeLayer.lineCap = kCALineCapRound;
      break;
      
    case LineCapSquare:
      self.shapeLayer.lineCap = kCALineCapSquare;
      break;
  }
}

- (IBAction)lineJoinSegmentedControlChanged:(UISegmentedControl *)sender
{
  switch (sender.selectedSegmentIndex) {
    case LineJoinMiter:
      self.shapeLayer.lineJoin = kCALineJoinMiter;
      break;
      
    case LineCapRound:
      self.shapeLayer.lineJoin = kCALineJoinRound;
      break;
      
    case LineCapSquare:
      self.shapeLayer.lineJoin = kCALineJoinBevel;
      break;
  }
}

@end
