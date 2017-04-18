//
//  AutoFitHeightCell.m
//  AutoHeightTextViewDemo
//
//  Created by 张令林 on 2017/4/18.
//  Copyright © 2017年 personer. All rights reserved.
//

#import "AutoFitHeightCell.h"
#import "GCPlaceholderTextView.h"
#import "Masonry.h"

#define kFONTOFSIZE 17.0f

@interface AutoFitHeightCell ()

@property (nonatomic, strong) GCPlaceholderTextView *textView;
@property (nonatomic, assign) CGFloat currentHeight;

@end

@implementation AutoFitHeightCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        self.textLabel.text = @" ";
        self.textLabel.hidden = YES;
        
        self.textView = [[GCPlaceholderTextView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(5.0f, 3.0f, 5.0f, 3.0f))];
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.textView setFont:[UIFont systemFontOfSize:kFONTOFSIZE]];
        [self.textView setTextColor:[UIColor blackColor]];
        [self.textView setRealTextColor:[UIColor blackColor]];
        self.textView.textContainerInset = UIEdgeInsetsZero;
        self.textView.textContainer.lineFragmentPadding = 0;
        [self.textView setBackgroundColor:[UIColor clearColor]];
        self.textView.placeholderColor = [UIColor grayColor];
        [[self contentView] addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textLabel);
            make.right.equalTo(self.contentView).offset(-3.0);
            make.top.equalTo(self.contentView).offset(10.0f);
            make.bottom.equalTo(self.contentView).offset(-5.0f);
        }];
        self.textView.placeholder = NSLocalizedString(@"Default", @"Default");
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agendaEndEditing:) name:UITextViewTextDidEndEditingNotification object:self.textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agendaDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
    }
    
    self.currentHeight = [self getCurrentHeight];
    
    return self;
}

#pragma mark - Private Methods
- (CGFloat)getCurrentHeight
{
    UIFont *font = [UIFont systemFontOfSize:kFONTOFSIZE];
    CGSize size =  CGSizeZero;
    NSString *aString = self.textString ? self.textString : @"  ";
    float width = CGRectGetWidth(self.bounds) - 24.0f;
    
    CGSize fudgeFactor = CGSizeMake(10.0, 16.0);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect bounds = [aString boundingRectWithSize:CGSizeMake(width, 9999)
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                                       attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: style} context:nil];
    
    bounds.size.height += fudgeFactor.height;
    bounds.size.width += fudgeFactor.width;
    size = bounds.size;
    
    self.currentHeight = size.height + 2.0f;

    return MAX(45.0f, self.currentHeight);
}

#pragma mark - Notification
- (void)agendaEndEditing:(NSNotification*) notification
{
    GCPlaceholderTextView *textView = (GCPlaceholderTextView *)notification.object;
    
    if([textView isKindOfClass:[GCPlaceholderTextView class]] == NO)
        return;
    
    if ([textView.text isEqualToString:textView.placeholder])
    {
        self.textString = @"";
    }
    else
    {
        self.textString = textView.text;
    }
}

- (void)agendaDidChange:(NSNotification*) notification
{
    GCPlaceholderTextView *textView = (GCPlaceholderTextView *)notification.object;
    
    if ([textView.text isEqualToString:textView.placeholder])
    {
        self.textString = @"";
    }
    else
    {
        self.textString = textView.text;
    }
    
    NSString *aString = textView.text;
    
    UIFont *font = [UIFont systemFontOfSize:kFONTOFSIZE];
    CGSize size =  CGSizeZero;
    
    float width = CGRectGetWidth(textView.bounds) - 6.0f;
    
    CGSize fudgeFactor = CGSizeMake(10.0, 16.0);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect bounds = [aString boundingRectWithSize:CGSizeMake(width, 9999)
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                                       attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: style} context:nil];
    
    bounds.size.height += fudgeFactor.height;
    bounds.size.width += fudgeFactor.width;
    size = bounds.size;
    
    if (self.currentHeight != size.height + 2.0f)
    {
        self.currentHeight = size.height + 2.0f;
        if ([self.delegate respondsToSelector:@selector(autoFitHeightCell:DidChangedHeight:)])
        {
            [self.delegate autoFitHeightCell:self DidChangedHeight:self.currentHeight];
        }
    }
    
    CGRect rect = textView.frame;
    rect.size.height = textView.contentSize.height;
    textView.frame = rect;
    [textView scrollRangeToVisible:NSMakeRange(0,0)];
}

@end
