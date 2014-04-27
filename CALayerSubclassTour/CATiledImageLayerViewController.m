//
//  CATiledImageLayerViewController.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 5/4/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "CATiledImageLayerViewController.h"
#import "TilingViewForImage.h"

@interface CATiledImageLayerViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet TilingViewForImage *tilingView;
@end

@implementation CATiledImageLayerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.tilingView.tileNamePrefix = FileName;
  
  [self.navigationController.navigationBar.layer removeAllAnimations];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  self.scrollView.contentSize = (CGSize){5120.0f, 3200.0f};
}

- (IBAction)doneButtonTapped:(id)sender
{
  [UIView transitionWithView:self.navigationController.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
