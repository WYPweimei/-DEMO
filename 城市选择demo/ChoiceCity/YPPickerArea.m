//
//  YPPickerArea.h
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/23.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import "YPPickerArea.h"
#import "AreaDataModel.h"

@interface YPPickerArea()<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong)NSMutableArray *provinceArray;//获取的省数组
@property(nonatomic, strong)NSMutableArray *cityArray;//获取的市数组
@property(nonatomic, strong)NSMutableArray *areaArray;//获取的区数组
@property(nonatomic, strong)NSMutableArray *choiceModelArray;//选中的市场model数组
@property(nonatomic, strong)AreaDataModel *areaModel;//数据源
@property(nonatomic, strong)Province *firstLineModel;//第一行选中MODEL;
@property(nonatomic, strong)Province *secondLineModel;//第一行选中MODEL;
@property(nonatomic, strong)Province *thirdLineModel;//第一行选中MODEL;

@end

@implementation YPPickerArea

#pragma mark ——------------------------setting,getting----------------------
-(Province *)firstLineModel{
    if (_firstLineModel == nil) {
        if (self.provinceArray.count > 0) {
            _firstLineModel = self.provinceArray[0];
        }else{
            _firstLineModel = nil;
        }
    }
    return _firstLineModel;
}
-(Province *)secondLineModel{
    if (_secondLineModel == nil) {
        if (self.cityArray.count > 0) {
            _secondLineModel = self.cityArray[0];
        }else{
            _secondLineModel = nil;
        }
    }
    return _secondLineModel;
}

-(Province *)thirdLineModel{
    if (_thirdLineModel == nil) {
        if (self.areaArray.count > 0) {
            _thirdLineModel = self.areaArray[0];
        }else{
            _thirdLineModel = nil;
        }
    }
    return _thirdLineModel;
}


-(AreaDataModel *)areaModel{
    if (_areaModel == nil) {
        _areaModel = [[AreaDataModel alloc]init];
    }
    return _areaModel;
}

-(NSMutableArray *)provinceArray{
    if(_provinceArray == nil){
        _provinceArray = [self.areaModel pickerSearchFirstLineData];
    }
    return _provinceArray;
}

-(NSMutableArray *)cityArray{
    if(_cityArray == nil){
        Province *model  = self.provinceArray[0];
        _cityArray = [self.areaModel pickerSearchSecondLineDataWithProvince:model];
    }
    return _cityArray;
}


-(NSMutableArray *)areaArray{
    if(_areaArray == nil){
        Province *model = self.cityArray[0];
        _areaArray = [self.areaModel pickerSearchThirdLineDataWithProvince:model];
    }
    return _areaArray;
}

-(NSMutableArray *)choiceModelArray{
    if(_choiceModelArray == nil){
        _choiceModelArray = [NSMutableArray new];
    }
    return _choiceModelArray;
}
#pragma mark - --- init 视图初始化 ---
- (void)setupUI
{
    [self.pickerView selectedRowInComponent:0];
    [self.pickerView selectedRowInComponent:1];
    [self.pickerView selectedRowInComponent:2];
    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    [self setTitle:@"请选择城市地区"];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];

}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    if (component == 0) {
        return self.provinceArray.count;
    }else if (component == 1) {
        return self.cityArray.count;
    }else{
        return self.areaArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        Province *provinceModel = self.provinceArray[row];
        self.firstLineModel = provinceModel;
        self.cityArray = [self.areaModel pickerSearchSecondLineDataWithProvince:provinceModel];
        if (self.cityArray.count > 0) {
            Province *cityModel = self.cityArray[0];
            self.areaArray = [self.areaModel pickerSearchThirdLineDataWithProvince:cityModel];
            self.secondLineModel = cityModel;
        }else{
             self.secondLineModel = nil;
        }
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        if (self.areaArray.count > 0) {
            self.thirdLineModel = self.areaArray[0];
        }else{
            self.thirdLineModel = nil;
        }
    }else if (component == 1) {
        Province *cityModel = self.cityArray[row];
        self.areaArray = [self.areaModel pickerSearchThirdLineDataWithProvince:cityModel];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        self.secondLineModel = cityModel;
        if (self.areaArray.count > 0) {
            self.thirdLineModel = self.areaArray[0];
        }else{
            self.thirdLineModel = nil;
        }
    }else{
        if (self.areaArray.count > row) {
            Province *areaModel = self.areaArray[row];
            self.thirdLineModel = areaModel;
        }
    }
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    NSString *text;
    if (component == 0) {
        NSMutableArray *provinceArray = [NSMutableArray arrayWithObject:self.provinceArray[row]];
        text =  [self.areaModel getCityNameWithModelArray:provinceArray];
    }else if (component == 1){
        NSMutableArray *cityArray = [NSMutableArray arrayWithObject:self.cityArray[row]];
        text =  [self.areaModel getCityNameWithModelArray:cityArray];
    }else{
        if (self.areaArray.count > 0) {
            NSMutableArray *areaArray = [NSMutableArray arrayWithObject:self.areaArray[row]];
            text =  [self.areaModel getCityNameWithModelArray:areaArray];
        }else{
            text =  @"";
        }
    }
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;



}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    if ([self.delegate respondsToSelector:@selector(pickerArea:modelArray:)]) {
        [self.delegate pickerArea:self modelArray:self.choiceModelArray];
    }
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    [self.choiceModelArray removeAllObjects];
    if (self.firstLineModel) {
        [self.choiceModelArray  addObject:self.firstLineModel];
    }
    if (self.secondLineModel) {
        if ([self.secondLineModel.name isEqualToString:@"全部"]) {
            
        }else{
            [self.choiceModelArray  addObject:self.secondLineModel];
        }
    }
    if (self.thirdLineModel) {
        if ([self.thirdLineModel.name isEqualToString:@"全部"]) {
        }else{
            [self.choiceModelArray  addObject:self.thirdLineModel];
        }
    }
    NSString *title = [self.areaModel getCityNameWithModelArray:self.choiceModelArray];
    
    [self setTitle:title];
}

@end


