//
//  UIImage+TileCutter.h
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 5/3/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TileCutter)

+ (void)saveTilesOfSize:(CGSize)size imageName:(NSString *)imageName;

@end
