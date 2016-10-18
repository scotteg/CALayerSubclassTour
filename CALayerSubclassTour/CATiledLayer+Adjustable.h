//
//  CATiledLayer+Adjustable.h
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 5/1/14.
//  Copyright (c) 2014 Optimac, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CATiledLayer (Adjustable)

+ (CFTimeInterval)newFadeDuration;
+ (void)setNewFadeDuration:(CFTimeInterval)fadeDuration;

@end
