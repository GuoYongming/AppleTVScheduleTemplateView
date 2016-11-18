//
//  NLTVScheduleTemplateVerticalCell.h
//  ScheduleTemplate
//
//  Created by GuoYongming on 11/15/16.
//  Copyright © 2016 Neulion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLTVScheduleTemplateProtocol.h"
@interface NLTVScheduleTemplateVerticalCell : UICollectionViewCell
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, weak) id<NLTVScheduleTemplateProtocol>delegate;
@property (nonatomic, strong) NSNumber *currentCellIndex;
@property (nonatomic, assign) CGFloat innerItemMinimumLineSpacing;
@property (nonatomic, assign) CGFloat innerItemMinimumInteritemSpacing;
- (void)reloadData;
- (void)reloadAllData;
@end
