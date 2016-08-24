//
//  ChoiceCityCollectionView.m
//  城市选择demo
//
//  Created by 王烨谱 on 16/8/17.
//  Copyright © 2016年 DaBaiCai. All rights reserved.
//

#import "ChoiceCityCollectionView.h"
#import "MasterChoiseLayout.h"//collectionView布局
#import "MasterChoiseCollectionViewCell.h"//itme
#import "ChoiceHeaderReusableView.h"
#import "AreaDataModel.h"

static const NSInteger kRowCount = 4;
static NSString *const cellIdentify = @"MasterChoiseCollectionViewCell";
static NSString *const headerIdentify = @"ChoiceHeaderReusableView";

@interface ChoiceCityCollectionView()<MasterChoiseLayoutDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(nonatomic, strong)NSMutableArray *hotCityArray;

@end
@implementation ChoiceCityCollectionView

#pragma mark ------------getting----------------
-(AreaDataModel *)areaDataModel{
    if (_areaDataModel == nil) {
        _areaDataModel = [[AreaDataModel alloc]init];
    }
    return _areaDataModel;
}

-(NSMutableArray *)locationCityArray{
    if (_locationCityArray == nil) {
        _locationCityArray = [self.areaDataModel getLocationModelArray];
    }
    return _locationCityArray;
}


-(NSMutableArray *)hotCityArray{
    if (_hotCityArray == nil) {
        _hotCityArray = [self.areaDataModel getHotModelArrayWithHotId:self.hotCitys];
    }
    return _hotCityArray;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self configXib];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configXib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configXib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configXib];
    }
    return self;
}



-(void)configXib{
    //布局collectionViewFlowLayout
    CGFloat spacing = 10;
    CGFloat mainScrreenWidth = [UIScreen mainScreen].bounds.size.width;
    MasterChoiseLayout *layout = [[MasterChoiseLayout alloc] init];
    layout.itemSize = CGSizeMake((mainScrreenWidth-(kRowCount+1)*spacing)/kRowCount, 150);
    layout.interitemSpacing = spacing;
    layout.lineSpacing = spacing;
    layout.delegate = self;
    layout.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.collectionViewLayout = layout;
    self.delegate = self;
    self.dataSource = self;
    //注册单元格
    UINib *nib = [UINib nibWithNibName:cellIdentify bundle:nil];
    [self registerNib:nib forCellWithReuseIdentifier:cellIdentify];
    
    //注册空的CELL
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"nullCell"];
    
    //注册头部视图
    UINib *headerNib = [UINib nibWithNibName:headerIdentify bundle:nil];
    [self registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentify];
}

//*******************************************************
#pragma mark -------------UICollectionViewDataSource,UICollectionViewDelegateFlowLayout----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0 ) {
        return self.locationCityArray.count;
    }else if(section == 1){
        return self.hotCityArray.count;
    }else{
        return 1;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        MasterChoiseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:cellIdentify owner:self options:nil].lastObject;
        }
        NSMutableArray *provinceArray;
        if (indexPath.section == 0) {
            provinceArray = self.locationCityArray[indexPath.row];
        }else{
            provinceArray = self.hotCityArray[indexPath.row];
        }
        cell.textLabel.text = [self.areaDataModel getCityNameWithModelArray:provinceArray];
        return cell;
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nullCell" forIndexPath:indexPath];
        return cell;
    }
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ChoiceHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentify forIndexPath:indexPath];
        view.backgroundColor = [UIColor redColor];
        if (indexPath.section == 0 || indexPath.section == 1) {
            if (indexPath.section == 0) {
                view.titleLabel.text = @"  最近访问城市";
            }else{
                view.titleLabel.text = @"  热门城市";
            }
            view.titleLabel.hidden = NO;
            view.choiceButton.hidden = YES;
        }else{
            __weak ChoiceCityCollectionView *this = self;
            [view choiceButtonBlockAction:^{
                [this choiceCityBlockAction];
            }];
            view.choiceButton.hidden = NO;
            view.titleLabel.hidden = YES;
        }
        return view;
    }else{
        return nil;
    }
}



#pragma mark - - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *provinceModelArray;
    if (indexPath.section == 0) {
        provinceModelArray = self.locationCityArray[indexPath.row];
    }else if(indexPath.section == 1){
        provinceModelArray = self.hotCityArray[indexPath.row];
    }else{
    }
    if (provinceModelArray != nil) {
        if (self.cellBlock) {
            self.cellBlock(provinceModelArray);
        }
    }
}

-(CGSize)masterChoiseLayout:(MasterChoiseLayout *)layout itemSizeForIndexPath:(NSIndexPath *)indexPath{
    NSString *cityName;
    NSMutableArray *provinceModelArray;
    if (indexPath.section == 0) {
         provinceModelArray = self.locationCityArray[indexPath.row];
        cityName = [self.areaDataModel getCityNameWithModelArray:provinceModelArray];
    }else if(indexPath.section == 1){
         provinceModelArray = self.hotCityArray[indexPath.row];
        cityName = [self.areaDataModel getCityNameWithModelArray:provinceModelArray];
    }else{
        cityName = @"";
    }
    CGSize size = [cityName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGFloat space = 15;// 左右间距
    CGFloat lineSpace = 10; // 上下间距
    size = CGSizeMake(size.width+space*2, size.height+lineSpace*2);
    return size;
}

-(CGSize)masterChoiseLayout:(MasterChoiseLayout *)layout headerViewSizeForSection:(NSInteger)section{
    return CGSizeMake(layout.collectionView.frame.size.width, 35);
}


#pragma Mark --------------block------------------
/**
 *  城市选择点击回调
 */
-(void)choiceCityBlockAction{
    if (self.block) {
        self.block();
    }
}

-(void)choiceButtonBlockAction:(ChoiceButtonBlock)block{
    if (block) {
        self.block = block;
    }
}

-(void)cellSelectedBlockAction:(CellSelectedBlock)block{
    if (block) {
        self.cellBlock = block;
    }
}


#pragma mark --------------setting----------------------


@end
