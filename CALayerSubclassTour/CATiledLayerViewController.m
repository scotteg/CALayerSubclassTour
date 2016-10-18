//
//  CATiledLayerViewController.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 4/21/14.
//  Copyright (c) 2014 Optimac, Inc. All rights reserved.
//

#import "CATiledLayerViewController.h"
#import "TilingView.h"
#import "CATiledLayer+Adjustable.h"

@interface CATiledLayerViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *zoomLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet TilingView *viewForTiledLayer;
@property (weak, nonatomic) IBOutlet UISlider *fadeDurationSlider;
@property (weak, nonatomic) IBOutlet UILabel *fadeDurationSliderValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *tileSizeSlider;
@property (weak, nonatomic) IBOutlet UILabel *tileSizeSliderValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *levelsOfDetailSlider;
@property (weak, nonatomic) IBOutlet UILabel *levelsOfDetailSliderValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *levelsOfDetailBiasSlider;
@property (weak, nonatomic) IBOutlet UILabel *levelsOfDetailBiasSliderValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *zoomScaleSlider;
@property (weak, nonatomic) IBOutlet UILabel *zoomScaleSliderValueLabel;
@end

@implementation CATiledLayerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  srand(time(0));
  
//  [CATiledLayer setNewFadeDuration:0.25];
  self.fadeDurationSlider.value = [CATiledLayer newFadeDuration];
  [self updateFadeDurationSliderValueLabel];
  [self updateTileSizeSliderValueLabel];
  [self updateLevelsOfDetailSliderValueLabel];
  [self updateLevelsOfDetailBiasSliderValueLabel];
  [self updateZoomScaleSliderValueLabel];
  
  self.scrollView.contentSize = self.scrollView.frame.size;
  
  [self.levelsOfDetailSlider addTarget:self action:@selector(showZoomLabel)
    forControlEvents:UIControlEventTouchUpInside];
  [self.levelsOfDetailBiasSlider addTarget:self action:@selector(showZoomLabel)
    forControlEvents:UIControlEventTouchUpInside];
  
  UIImage *buttonImage = [UIImage imageNamed:@"earthwindandfireThumbnail"];
  CGRect buttonImageFrame = (CGRect){CGPointZero, {buttonImage.size.width, buttonImage.size.height}};
  UIButton *button = [[UIButton alloc] initWithFrame:buttonImageFrame];
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  button.showsTouchWhenHighlighted = YES;
  [button addTarget:self action:@selector(photoButtonTapped) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
  self.navigationItem.rightBarButtonItem = barButton;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.scrollView.zoomScale = One;
}

- (void)photoButtonTapped
{
  [self performSegueWithIdentifier:@"PhotoTilingView" sender:nil];
}

- (void)updateFadeDurationSliderValueLabel
{
  self.fadeDurationSliderValueLabel.text = [NSString stringWithFormat:@"%.2f", [CATiledLayer newFadeDuration]];
}

- (void)updateTileSizeSliderValueLabel
{
  self.tileSizeSliderValueLabel.text = [NSString stringWithFormat:@"%.0f",
    [(CATiledLayer *)self.viewForTiledLayer.layer tileSize].width];
}

- (void)updateLevelsOfDetailSliderValueLabel
{
  self.levelsOfDetailSliderValueLabel.text = [NSString stringWithFormat:@"%zu",
    [(CATiledLayer *)self.viewForTiledLayer.layer levelsOfDetail]];
}

- (void)updateLevelsOfDetailBiasSliderValueLabel
{
  self.levelsOfDetailBiasSliderValueLabel.text = [NSString stringWithFormat:@"%zu",
    [(CATiledLayer *)self.viewForTiledLayer.layer levelsOfDetailBias]];
}

- (void)updateZoomScaleSliderValueLabel
{
  self.zoomScaleSliderValueLabel.text = [NSString stringWithFormat:@"%.0f", self.scrollView.zoomScale];
}

- (void)showZoomLabel
{
  self.zoomLabel.alpha = One;
  self.zoomLabel.hidden = NO;
  
  [UIView animateWithDuration:0.5 delay:1.0 options:kNilOptions animations:^{
    self.zoomLabel.alpha = Zero;
  } completion:^(BOOL finished) {
    self.zoomLabel.hidden = YES;
  }];
}

- (IBAction)fadeDurationSliderChanged:(UISlider *)sender
{
  [CATiledLayer setNewFadeDuration:sender.value];
  [self updateFadeDurationSliderValueLabel];
  CATiledLayer *layer = (CATiledLayer *)self.viewForTiledLayer.layer;
  layer.contents = nil;
  [layer setNeedsDisplayInRect:layer.bounds];
}

- (IBAction)tileSizeSliderChanged:(UISlider *)sender
{
  [(CATiledLayer *)self.viewForTiledLayer.layer setTileSize:(CGSize){sender.value, sender.value}];
  [self updateTileSizeSliderValueLabel];
}

- (IBAction)levelsOfDetailSliderChanged:(UISlider *)sender
{
  [(CATiledLayer *)self.viewForTiledLayer.layer setLevelsOfDetail:(size_t)sender.value];
  [self updateLevelsOfDetailSliderValueLabel];
}

- (IBAction)levelsOfDetailBiasSliderChanged:(UISlider *)sender
{
  [(CATiledLayer *)self.viewForTiledLayer.layer setLevelsOfDetailBias:(size_t)sender.value];
  [self updateLevelsOfDetailBiasSliderValueLabel];
}

- (IBAction)zoomScaleSliderChanged:(UISlider *)sender
{
  self.scrollView.zoomScale = sender.value;
  [self updateZoomScaleSliderValueLabel];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return self.viewForTiledLayer;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
  [self.zoomScaleSlider setValue:self.scrollView.zoomScale animated:YES];
  [self updateZoomScaleSliderValueLabel];
}

@end
