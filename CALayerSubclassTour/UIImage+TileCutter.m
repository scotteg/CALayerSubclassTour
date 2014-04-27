//
//  UIImage+TileCutter.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 5/3/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "UIImage+TileCutter.h"

@implementation UIImage (TileCutter)

+ (void)saveTilesOfSize:(CGSize)size imageName:(NSString *)imageName
{
  NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
  NSString *filePath = [NSString stringWithFormat:@"%@/%@_0_0.png", cachesPath, imageName];
  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
  
  if (!fileExists) {
    __block CGSize tileSize = size;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
      UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", imageName, @".jpg"]];
      CGImageRef imageRef = image.CGImage;
      NSUInteger scale = (NSUInteger)[UIScreen mainScreen].scale;
      NSUInteger totalColumns = ceilf(image.size.width / tileSize.width) * scale;
      NSUInteger totalRows = ceilf(image.size.height / tileSize.height) * scale;
      CGFloat partialColumnWidth = (NSUInteger)image.size.width % (NSUInteger)tileSize.width;
      CGFloat partialRowHeight = (NSUInteger)image.size.height % (NSUInteger)tileSize.height;
      
      for (int y = 0; y < totalRows; y++) {
        for (int x = 0; x < totalColumns; x++) {
          if (partialRowHeight && y + 1 == totalRows) {
            tileSize.height = partialRowHeight;
          }
          
          if (partialColumnWidth && x + 1 == totalColumns) {
            tileSize.width = partialColumnWidth;
          }
          
          CGImageRef tileImageRef = CGImageCreateWithImageInRect(imageRef, (CGRect){{x * tileSize.width, y * tileSize.height}, tileSize});
          NSData *imageData = UIImagePNGRepresentation([UIImage imageWithCGImage:tileImageRef]);
          CGImageRelease(tileImageRef);
          NSString *path = [NSString stringWithFormat:@"%@/%@_%d_%d.png", cachesPath, imageName, x, y];
          [imageData writeToFile:path atomically:NO];
        }
      }
    });
  }
}

@end
