//
//  CATiledLayer+Adjustable.m
//  CALayerSubclassTour
//
//  Created by Scott Gardner on 5/1/14.
//  Copyright (c) 2014 Optimac, Inc. All rights reserved.
//

#import "CATiledLayer+Adjustable.h"
@import ObjectiveC;

static CFTimeInterval newFadeDuration = 0.25;

@implementation CATiledLayer (Adjustable)

+ (void)load
{
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    Class class = object_getClass((id)self);
    SEL originalSelector = @selector(fadeDuration);
    SEL swizzledSelector = @selector(adjust_fadeDuration);
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
      class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
  });
}

+ (CFTimeInterval)newFadeDuration
{
  @synchronized(self) {
    return newFadeDuration;
  }
}

+ (void)setNewFadeDuration:(CFTimeInterval)fadeDuration
{
  @synchronized(self) {
    newFadeDuration = fadeDuration;
  }
}

+ (CFTimeInterval)adjust_fadeDuration
{
  return newFadeDuration;
}

@end
