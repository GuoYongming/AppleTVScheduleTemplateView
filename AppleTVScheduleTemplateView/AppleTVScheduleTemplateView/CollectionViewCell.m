//
//  CollectionViewCell.m
//  ScheduleTemplate
//
//  Created by GuoYongming on 11/10/16.
//  Copyright © 2016 Neulion. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell


- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    __weak CollectionViewCell *weakSelf = self;
    [coordinator addCoordinatedAnimations:^{
        if (weakSelf.focused) {
            weakSelf.layer.shadowColor = [UIColor darkGrayColor].CGColor;
            weakSelf.layer.shadowRadius = 18.0;
            weakSelf.layer.shadowOffset = CGSizeMake(0,20);
            weakSelf.layer.shadowOpacity = 1.0;
            weakSelf.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }else{
            weakSelf.layer.shadowColor = [UIColor clearColor].CGColor;
            weakSelf.transform = CGAffineTransformIdentity;
        }
        
    } completion:nil];
}
@end
