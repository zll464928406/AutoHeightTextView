//
//  AutoFitHeightCell.h
//  AutoHeightTextViewDemo
//
//  Created by 张令林 on 2017/4/18.
//  Copyright © 2017年 personer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutoFitHeightCell;

@protocol AutoFitHeightCellDelegate <NSObject>

- (void)autoFitHeightCell:(AutoFitHeightCell*)cell DidChangedHeight:(CGFloat)height;

@end

@interface AutoFitHeightCell : UITableViewCell

@property (nonatomic,copy) NSString *textString;
@property (nonatomic, weak) id<AutoFitHeightCellDelegate> delegate;

@end
