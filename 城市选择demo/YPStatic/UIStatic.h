//
//  UIStatic.h
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/23.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIStatic : NSObject

/** 1.统一的较小间距 5 */
UIKIT_EXTERN CGFloat const YPMarginSmall;

/** 2.统一的间距 10 */
UIKIT_EXTERN CGFloat const YPMargin;

/** 3.统一的较大间距 16 */
UIKIT_EXTERN CGFloat const YPMarginBig;

/** 4.导航栏的最大的Y值 64 */
UIKIT_EXTERN CGFloat const YPNavigationBarY;

/** 5.控件的系统高度 44 */
UIKIT_EXTERN CGFloat const YPControlSystemHeight;

/** 6.控件的普通高度 36 */
UIKIT_EXTERN CGFloat const YPControlNormalHeight;

/** 本地存储的最近访问最大值 5 */
UIKIT_EXTERN NSInteger const YPLoactionBiggestNumber;

@end
