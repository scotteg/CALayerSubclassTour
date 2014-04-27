//
//  TilingViewForImage.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 5/4/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "TilingViewForImage.h"

static CGFloat const SideLength = 640.0f;

@interface TilingViewForImage ()
@property (copy, nonatomic) NSString *cachesPath;
@end

@implementation TilingViewForImage

+ (Class)layerClass
{
  return [CATiledLayer class];
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  CATiledLayer *tiledLayer = (CATiledLayer *)self.layer;
  tiledLayer.tileSize = (CGSize){SideLength, SideLength};
  tiledLayer.contentsScale = [UIScreen mainScreen].scale;
  self.cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

- (void)drawRect:(CGRect)rect
{
  CGFloat sideLength = 640.0f;
  int firstColumn = (int)(CGRectGetMinX(rect) / sideLength);
  int lastColumn = (int)(CGRectGetMaxX(rect) / sideLength);
  int firstRow = (int)(CGRectGetMinY(rect) / sideLength);
  int lastRow = (int)(CGRectGetMaxY(rect) / sideLength);
  
  for (int row = firstRow; row <= lastRow; row++) {
    for (int column = firstColumn; column <= lastColumn; column++) {
      UIImage *tile = [self imageForTileAtColumn:column row:row];
      CGRect tileRect = (CGRect){{sideLength * column, sideLength * row}, sideLength, sideLength};
      tileRect = CGRectIntersection(self.bounds, tileRect);
      [tile drawInRect:tileRect];
    }
  }
}

- (UIImage *)imageForTileAtColumn:(int)column row:(int)row
{
  NSString *path = [NSString stringWithFormat:@"%@/%@_%d_%d.png", self.cachesPath, self.tileNamePrefix, column, row];
  return  [UIImage imageWithContentsOfFile:path];
}

@end
