//
//  UIColor+Random.m
//  CircleLayout
//
//  Created by Natalia Patsovska on 3/13/13.
//  Copyright (c) 2013 Olivier Gutknecht. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
}

@end
