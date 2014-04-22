//
//  CATextLayerViewController.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 4/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "CATextLayerViewController.h"
@import CoreText;

static CGFloat const BaseFontSize = 24.0f;

typedef enum : NSUInteger {
  TruncationModeStart,
  TruncationModeMiddle,
  TruncationModeEnd,
} TruncationMode;

typedef enum : NSUInteger {
  AlignmentModeLeft,
  AlignmentModeCenter,
  AlignmentModeJustified,
  AlignmentModeRight,
} AlignmentMode;

@interface CATextLayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewForTextLayer;
@property (weak, nonatomic) CATextLayer *textLayer;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeSliderValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *fontSizeSlider;
@property (weak, nonatomic) IBOutlet UISwitch *wrapTextSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *alignmentModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *truncationModeSegmentedControl;
@property (assign, nonatomic) CGFloat fontSize;
@end

@implementation CATextLayerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.textLayer = [CATextLayer layer];
  self.textLayer.frame = self.viewForTextLayer.bounds;
  
  self.textLayer.string = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor arcu quis velit congue dictum. Phasellus eu lacus in erat tempor sollicitudin. Duis et mattis magna, luctus blandit nunc. Morbi odio quam, accumsan ac pharetra pellentesque, elementum eu nibh. Aliquam quis turpis auctor arcu egestas aliquet. Mauris volutpat commodo tellus, at sodales felis convallis eget. Nam et metus risus. Pellentesque elit mauris, dapibus sed enim vel, ullamcorper feugiat elit. Proin sed odio risus. Curabitur ac felis id justo posuere aliquam eu sit amet justo. Sed et ligula eget orci posuere porta. Nunc consectetur mauris non sapien bibendum, nec tempus sem pretium. Praesent est ante, auctor id erat sed, mollis rutrum eros. Vivamus dui velit, elementum fermentum est nec, porta placerat sem.\n\nMorbi sagittis leo et neque volutpat auctor. Vivamus mollis magna in justo gravida pharetra. Nam in purus id diam pulvinar cursus. Integer fermentum dui quis fringilla sagittis. Ut nec neque a lorem imperdiet porta. Maecenas quis lobortis elit. Cras a orci bibendum, sollicitudin sapien sit amet, mattis elit. Donec at facilisis lorem.\n\nVestibulum posuere auctor nunc ut sollicitudin. Nam eu turpis eu purus gravida blandit quis eu leo. In hac habitasse platea dictumst. Donec blandit elit non tellus blandit feugiat. Pellentesque a venenatis ligula. Nulla in hendrerit risus. Cras fringilla viverra semper. Vivamus id sodales mauris.\n\nDonec consequat urna tincidunt luctus sagittis. Nunc viverra nunc vel nulla tempus, et ultricies nibh euismod. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam consectetur orci in quam placerat, eget auctor ante venenatis. Vivamus sollicitudin nisl eu turpis euismod congue. Nulla facilisi. Donec id lorem a erat dapibus egestas sed eu diam. Nunc sodales vel enim eu varius. Aenean quis cursus enim. Sed porttitor arcu nisl, bibendum pretium purus fringilla ac. Maecenas hendrerit, risus ac rhoncus mattis, nulla magna malesuada lacus, ut vehicula odio arcu non lorem. Nunc sit amet felis dictum, pharetra odio ut, mattis enim. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nSuspendisse eget mattis orci. Nulla facilisi. Phasellus venenatis ipsum ac accumsan lacinia. Nulla mattis eu nunc ac posuere. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Suspendisse molestie nibh massa, sit amet vestibulum nunc malesuada non. Fusce accumsan imperdiet viverra. Suspendisse potenti. Mauris ultrices aliquet laoreet. Phasellus malesuada magna sed volutpat fringilla. Vivamus venenatis eleifend pharetra. Suspendisse in cursus ligula. Vestibulum non egestas nulla, et aliquet ante.";
  
  CFStringRef fontName = (__bridge CFStringRef)@"Noteworthy-Light";
  CTFontRef fontRef = CTFontCreateWithName(fontName, self.fontSize, NULL);
  self.textLayer.font = fontRef;
  CFRelease(fontRef);
  
  self.fontSize = BaseFontSize;
  self.textLayer.foregroundColor = [UIColor darkGrayColor].CGColor;
  self.textLayer.wrapped = YES;
  self.textLayer.alignmentMode = kCAAlignmentLeft;
  self.textLayer.truncationMode = kCATruncationEnd;
  
  self.textLayer.contentsScale = [UIScreen mainScreen].scale;
  
  [self.viewForTextLayer.layer addSublayer:self.textLayer];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  self.textLayer.fontSize = self.fontSize;
}

- (IBAction)fontSizeSliderValueChanged:(UISlider *)sender
{
  self.fontSizeSliderValueLabel.text = [NSString stringWithFormat:@"%0.0f%%", self.fontSizeSlider.value * 100];
  self.fontSize = BaseFontSize * sender.value;
  [self viewDidLayoutSubviews];
}

- (IBAction)wrapTextSwitchChanged:(UISwitch *)sender
{
  self.alignmentModeSegmentedControl.selectedSegmentIndex = AlignmentModeLeft;
  self.textLayer.alignmentMode = kCAAlignmentLeft;
  
  if (sender.on) {
    self.truncationModeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.textLayer.wrapped = YES;
  } else {
    self.textLayer.wrapped = NO;
  }
  
  [self viewDidLayoutSubviews];
}

- (IBAction)alignmentModeSegmentedControlChanged:(UISegmentedControl *)sender
{
  self.wrapTextSwitch.on = YES;
  self.textLayer.wrapped = YES;
  self.truncationModeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
  self.textLayer.truncationMode = kCATruncationNone;
  
  switch (sender.selectedSegmentIndex) {
    case AlignmentModeLeft:
      self.textLayer.alignmentMode = kCAAlignmentLeft;
      break;
      
    case AlignmentModeCenter:
      self.textLayer.alignmentMode = kCAAlignmentCenter;
      break;
      
    case AlignmentModeJustified:
      self.textLayer.alignmentMode = kCAAlignmentJustified;
      break;
      
    case AlignmentModeRight:
      self.textLayer.alignmentMode = kCAAlignmentRight;
      break;
  }
  
  [self viewDidLayoutSubviews];
}

- (IBAction)truncationModeSegmentedControlChanged:(UISegmentedControl *)sender
{
  self.wrapTextSwitch.on = NO;
  self.textLayer.wrapped = NO;
  self.alignmentModeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
  self.textLayer.alignmentMode = kCAAlignmentNatural;
  
  switch (sender.selectedSegmentIndex) {
    case TruncationModeStart:
      self.textLayer.truncationMode = kCATruncationStart;
      break;
      
    case TruncationModeMiddle:
      self.textLayer.truncationMode = kCATruncationMiddle;
      break;
      
    case TruncationModeEnd:
      self.textLayer.truncationMode = kCATruncationEnd;
      break;
  }
  
  [self viewDidLayoutSubviews];
}

@end
