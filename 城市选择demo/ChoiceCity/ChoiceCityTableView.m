//
//  ChoiceCityTableView.m
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/17.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import "ChoiceCityTableView.h"
@interface ChoiceCityTableView()<UITableViewDelegate,UITableViewDataSource>


@end
@implementation ChoiceCityTableView

-(AreaDataModel *)areaModel{
    if (!_areaModel) {
        _areaModel = [[AreaDataModel alloc]init];
    }
    return _areaModel;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self confitXib];
    }
    return self;
}

-(void)confitXib{
    self.delegate = self;
    self.dataSource = self;
}


#pragma mark ----------------UITableViewDelegate,UITableViewDataSource----------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentify"];
    }
    NSMutableArray *provinceModelArray = self.searchCities[indexPath.row];
    cell.textLabel.text = [self.areaModel getCityNameWithModelArray:provinceModelArray];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *provinceModelArray = self.searchCities[indexPath.row];
    if (provinceModelArray) {
        if (self.block ) {
            self.block(provinceModelArray);
        }
    }else{
        NSLog(@"error:选择的城市不存在");
    }
    
}


#pragma mark --------------BLOCK----------------------
-(void)cellBlockAction:(CellSelectedBlock)block{
    if (block) {
        self.block = block;
    }
}
@end
