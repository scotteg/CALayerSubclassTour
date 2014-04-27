//
//  SubclassesViewController.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 4/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "SubclassesViewController.h"

@interface SubclassesViewController ()
@property (copy, nonatomic) NSArray *subclasses;
@end

@implementation SubclassesViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.subclasses = @[
    @[@"CAScrollLayer", @"Display portion of a scrollable layer"],
    @[@"CATextLayer", @"Render plain text or attributed strings"],
    @[@"CAGradientLayer", @"Apply a color gradient over background"],
    @[@"CAShapeLayer", @"Draw using scalable vector graphics"],
    @[@"CATiledLayer", @"Split large content into tiles"],
    @[@"CAReplicatorLayer", @"Duplicate a source layer"],
    @[@"CATransformLayer", @"Create 3D structures"],
    @[@"CAEmitterLayer", @"Render animated particles"],
    @[@"CAEAGLLayer", @"Draw OpenGL content"]
  ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.subclasses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  cell.textLabel.text = self.subclasses[indexPath.row][0];
  cell.detailTextLabel.text = self.subclasses[indexPath.row][1];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = self.subclasses[indexPath.row][0];
  [self performSegueWithIdentifier:identifier sender:nil];
}

@end
