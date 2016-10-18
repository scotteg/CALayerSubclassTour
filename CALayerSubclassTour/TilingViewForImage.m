//
//  TilingViewForImage.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 5/4/14.
//  Copyright (c) 2014 Optimac, Inc. All rights reserved.
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
  int firstColumn = (int)(CGRectGetMinX(rect) / SideLength);
  int lastColumn = (int)(CGRectGetMaxX(rect) / SideLength);
  int firstRow = (int)(CGRectGetMinY(rect) / SideLength);
  int lastRow = (int)(CGRectGetMaxY(rect) / SideLength);
  
  for (int row = firstRow; row <= lastRow; row++) {
    for (int column = firstColumn; column <= lastColumn; column++) {
      UIImage *tile = [self imageForTileAtColumn:column row:row];
      CGRect tileRect = (CGRect){{SideLength * column, SideLength * row}, SideLength, SideLength};
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
