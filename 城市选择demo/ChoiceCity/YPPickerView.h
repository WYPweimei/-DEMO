//
//  YPPickerView.h
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/17.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger) {
    YPPickerContentModeBottom, // 1.选择器在视图的下方
    YPPickerContentModeCenter  // 2.选择器在视图的中间
}YPPickerContentMode;

@interface YPPickerView : UIButton

/** 1.内部视图 */
@property (nonatomic, strong) UIView *contentView;
/** 2.边线,选择器和上方tool之间的边线 */
@property (nonatomic, strong)UIView *lineView;
/** 3.选择器 */
@property (nonatomic, strong)UIPickerView *pickerView;
/** 4.左边的按钮 */
@property (nonatomic, strong)UIButton *buttonLeft;
/** 5.右边的按钮 */
@property (nonatomic, strong)UIButton *buttonRight;
/** 6.标题label */
@property (nonatomic, strong)UILabel *labelTitle;
/** 7.下边线,在显示模式是STPickerContentModeCenter的时候显示 */
@property (nonatomic, strong)UIView *lineViewDown;

/** 1.标题，default is nil */
@property(nullable, nonatomic,copy) NSString          *title;
/** 2.字体，default is nil (system font 17 plain) */
@property(null_resettable, nonatomic,strong) UIFont   *font;
/** 3.字体颜色，default is nil (text draws black) */
@property(null_resettable, nonatomic,strong) UIColor  *titleColor;
/** 4.按钮边框颜色颜色，default is RGB(205, 205, 205) */
@property(null_resettable, nonatomic,strong) UIColor  *borderButtonColor;
/** 5.选择器的高度，default is 240 */
@property (nonatomic, assign)CGFloat heightPicker;
/** 6.视图的显示模式 */
@property (nonatomic, assign)YPPickerContentMode contentMode;


/**
 *  5.创建视图,初始化视图时初始数据
 */
- (void)setupUI;

/**
 *  6.确认按钮的点击事件
 */
- (void)selectedOk;

/**
 *  7.显示
 */
- (void)show;

/**
 *  8.移除
 */
- (void)remove;

@end
NS_ASSUME_NONNULL_END
