//
//  UIColor+String.m
//
//  Created by 万绍发 on 15/10/31.
//  Copyright © 2015年 王烨谱. All rights reserved.
//

#import "UIColor+String.h"
int charToInt(char c);
int stringToInt(NSString *str){
    int res = 0;
    
    NSInteger length = str.length;
    for (int i = 0; i < length; i++) {
        char c = [str characterAtIndex:i];
        int s = charToInt(c);
        res += s * pow(16, length - 1 - i);
    }
    
    return res;
}

int charToInt(char c){
    int res = 0;
    if (c >= 'A' && c <= 'F') {
        switch (c) {
            case 'A':
            {
                res = 10;
            }
                break;
            case 'B':
            {
                res = 11;
            }
                break;
            case 'C':
            {
                res = 12;
            }
                break;
            case 'D':
            {
                res = 13;
            }
                break;
            case 'E':
            {
                res = 14;
            }
                break;
            case 'F':
            {
                res = 15;
            }
                break;
                
            default:
                break;
        }
    }
    
    if (c >= '0' && c <= '9') {
        res = c-48;
    }
    
    return res;
}

@implementation UIColor (String)
+(UIColor *)colorWithString:(NSString *)colorString{
    colorString = [colorString uppercaseString];
    UIColor *color = nil;
    // #ff00ff
    if (![colorString hasPrefix:@"#"]) {
        return color;
    }
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    if ([colorString length] == 7) {
        NSString *rs = [colorString substringWithRange:NSMakeRange(1, 2)];
        NSString *gs = [colorString substringWithRange:NSMakeRange(3, 2)];
        NSString *bs = [colorString substringWithRange:NSMakeRange(5, 2)];
        r = stringToInt(rs);
        g = stringToInt(gs);
        b = stringToInt(bs);
    }
    
    
    color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    
    return color;
}
@end
