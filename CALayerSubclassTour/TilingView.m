//
//  TilingView.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 4/28/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "TilingView.h"

static CGFloat const SideLength = 100.0f;

@implementation TilingView

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
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect bounds = self.bounds;
  CGFloat scale = [UIScreen mainScreen].scale;
  
  CGFloat red = drand48();
  CGFloat green = drand48();
  CGFloat blue = drand48();
  
  CGContextSetRGBFillColor(ctx, red, green, blue, 1.0f);
  CGContextFillRect(ctx, rect);
  
  CGFloat x = bounds.origin.x;
  CGFloat y = bounds.origin.y;
  CGFloat offset = CGRectGetWidth(bounds) / SideLength * scale;
  
  CGContextMoveToPoint(ctx, x + 9.0f * offset, y + 43.0f * offset);
  CGContextAddLineToPoint(ctx, x + 18.06f * offset, y + 22.6f * offset);
  CGContextAddLineToPoint(ctx, x + 25.0f * offset, y + 7.5f * offset);
  CGContextAddLineToPoint(ctx, x + 41.0f * offset, y + 43.0f * offset);
  CGContextAddLineToPoint(ctx, x + 9.0f * offset, y + 21.66f * offset);
  CGContextAddLineToPoint(ctx, x + 41.0f * offset, y + 14.54f * offset);
  CGContextAddLineToPoint(ctx, x + 9.0f * offset, y + 43.0f * offset);
  CGContextClosePath(ctx);
  
  red = drand48();
  green = drand48();
  blue = drand48();
  
  CGContextSetRGBFillColor(ctx, red, green, blue, 1.0f);
  CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
  CGContextSetLineWidth(ctx, 2.0f / scale);
  CGContextDrawPath(ctx, kCGPathEOFillStroke);
}

@end
