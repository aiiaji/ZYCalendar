//
//  ZYCalendarTableViewCell.m
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import "ZYCalendarTableViewCell.h"
#import "NSDate+ZYDateTools.h"
#import "ZYCalendarCell.h"
#import "ZYCalendar.h"
#import "ZYCalendarTableViewCellModel.h"
#import "ZYCalendarCellModel.h"

#define ZYCalendar_CellID @"ZYCalendar_CellID"
@interface ZYCalendarTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZYCalendarCellDelegate>

@property (nonatomic, copy, readwrite)NSDate *beginDate;
@property (nonatomic, copy, readwrite )NSDate *endDate;
@property (nonatomic, assign, readwrite)CGFloat leftPadding;
@property (nonatomic, assign, readwrite)CGFloat rightPadding;
@property (nonatomic, assign, readwrite)BOOL sundayFirst;
@property (nonatomic, strong, readwrite)NSMutableArray *ranges;
@property (nonatomic, assign, readwrite)CGFloat cellHeight;
@property (nonatomic, assign, readwrite)CGFloat cellWidth;
@property (nonatomic, assign, readwrite)CGFloat linePadding;
@property (nonatomic, assign, readwrite)NSInteger linesCount;
@property (nonatomic, assign)CGFloat lineHeight;

@property (nonatomic, strong)NSMutableDictionary<NSString *,ZYCalendarCellModel *> *modelsDict;

@property (nonatomic, strong)UICollectionView *collectionView;


@end



@implementation ZYCalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)customConfigForDateCell:(ZYCalendarCell *)cell {
    if ([self.delegate respondsToSelector:@selector(customConfigForDateCell:)]) {
        
        [self.delegate customConfigForDateCell:cell];
    }
}


+ (instancetype)tableViewCellWithIdentifier:(NSString *)identifier cellWidth:(CGFloat)cellwidth cellHeight:(CGFloat)cellHeight leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding linePadding:(CGFloat)linePadding{
    
    ZYCalendarTableViewCell *cell = [[ZYCalendarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.leftPadding = leftPadding;
    cell.rightPadding = rightPadding;
    cell.cellHeight = cellHeight;
    //must adjust the width of your set,if not will display a slim line between dateCell;
    //必须调整设定的宽度，否则会在dateCell之间显示白色线条
    CGFloat adjustedWidth = ((int)((cellwidth - cell.leftPadding  - cell.rightPadding)/7.0) + 0.5) * 7;
    cell.backgroundColor = [UIColor clearColor];
    cell.cellWidth = adjustedWidth;
   
    cell.linePadding = linePadding;
    cell.modelsDict = [NSMutableDictionary dictionary];
    [cell setUpCollectionView];
    
    return cell;
}

- (void)setModelItem:(ZYCalendarTableViewCellModel *)modelItem {
     
    
    
    _modelItem = modelItem;
    self.beginDate = modelItem.beginDate;
    self.endDate = modelItem.endDate;
    self.ranges = modelItem.ranges;
    self.linesCount = modelItem.linesCount;
    self.linePadding = modelItem.linePadding;
    self.lineHeight = modelItem.lineHeight;
    
    [self.collectionView reloadData];
}



- (void)setUpCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    

    
    layout.minimumLineSpacing = self.linePadding;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.cellWidth, self.cellHeight) collectionViewLayout:layout];
    self.collectionView.scrollEnabled = NO;

    [self.collectionView registerClass:[ZYCalendarCell class] forCellWithReuseIdentifier:ZYCalendar_CellID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    
}

#pragma UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return  CGSizeMake((self.cellWidth - self.leftPadding  - self.rightPadding)/7.0, (self.cellWidth - self.leftPadding  - self.rightPadding)/7.0);
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}


- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.linesCount * 7;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYCalendarCell *cell = (ZYCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(ZYCalendarTableViewCell:didSelectDateCell:)]) {
        
        [self.delegate ZYCalendarTableViewCell:self didSelectDateCell:cell];
    }
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYCalendar_CellID forIndexPath:indexPath];
    cell.square = self.square;
    cell.hightlightColor = self.highlightDateCellColor;
    cell.dotColor = self.dotColor;
    cell.dotRadius = self.dotRadius;
    cell.userInteractionEnabledForOtherDays = self.userInteractionEnabledForOtherDays;
    cell.delegate = self;
    cell.todayTitle = self.todayTitle;
    cell.dateColor = self.dateColor;
    ZYCalendarCellModel *model = nil;
    
    if ([self.cacher respondsToSelector:@selector(ZYCalendarTableViewCell:cacheForCell:dateCellIndexPath:)]) {
        
        model =  [self.cacher ZYCalendarTableViewCell:self cacheForCell:cell dateCellIndexPath:indexPath];
    }
    
    model.range = [self rangeWithDate:model.cellDate potition:model.position];
    [cell updateWithModelItem:model];
    
    return cell;
}




- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(self.linePadding, self.leftPadding, self.linePadding, self.rightPadding);
}


- (ZYCalendarRange *)rangeWithDate:(NSDate *)date potition:(ZYCalendarCellPosition )position {
    
    ZYCalendarRange *tempRange = [ZYCalendarRange rangeWithBeginDate:self.beginDate endDate:self.endDate color:nil];
    for (ZYCalendarRange *range in self.ranges) {
        if ([range isContainsDate:date]) {
            return range;
        }else if (position == ZYCalendarCellPositionNoneBefore || position == ZYCalendarCellPositionNoneLater) {
            BOOL flag1 = (position == ZYCalendarCellPositionNoneBefore || position == ZYCalendarCellPositionNoneLater) && [range isLargeOrEqualToRange:tempRange] && ![date lzy_isEarlierThanOrEqualTo:range.beginDate] && ![date lzy_isLaterThanOrEqualTo:range.endDate];
            BOOL flag2 = position == ZYCalendarCellPositionNoneBefore && [range isLargeOrEqualToRange:tempRange] && ![date lzy_isEarlierThanOrEqualTo:range.beginDate] && [self.endDate lzy_isEarlierThanOrEqualTo:range.endDate];
            
            BOOL flag3 = (position == ZYCalendarCellPositionNoneBefore || position == ZYCalendarCellPositionNoneLater) && [range isLargeOrEqualToRange:tempRange] && ![date lzy_isEarlierThanOrEqualTo:range.beginDate] && [self.beginDate lzy_isLaterThanOrEqualTo:range.beginDate] && [date lzy_isEarlierThanOrEqualTo:range.endDate];
            
            BOOL flag4 = position == ZYCalendarCellPositionNoneLater && [range isLargeOrEqualToRange:tempRange] && [date lzy_isEarlierThanOrEqualTo:range.endDate];
            
            BOOL flag5 = position == ZYCalendarCellPositionNoneBefore && [range isLargeOrEqualToRange:tempRange] && [date lzy_isLaterThanOrEqualTo:range.beginDate];
            
            BOOL flag6 = position == ZYCalendarCellPositionNoneLater && [range isLargeOrEqualToRange:tempRange] && ![date lzy_isEarlierThanOrEqualTo:range.beginDate] && ![range.endDate lzy_isEarlierThanOrEqualTo:self.endDate];
            
            BOOL flag7 = position == ZYCalendarCellPositionNoneBefore && [range isLargeOrEqualToRange:tempRange] && [range.beginDate lzy_isEarlierThan:self.beginDate] && [range.endDate lzy_isLaterThan:self.beginDate];
            
            if (flag1 || flag2 || flag3 || flag4 || flag5 || flag6 || flag7) {
                return range;
            }
            
            
        }
    }
    
    
    return nil;
}





@end
