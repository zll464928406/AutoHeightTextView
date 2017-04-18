//
//  ViewController.m
//  AutoHeightTextViewDemo
//
//  Created by sunny on 17/4/17.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "ViewController.h"
#import "GCPlaceholderTextView.h"
#import "Masonry.h"
#import "TestViewController.h"

static NSString *cellId = @"cellId";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *agendaString;
@property (nonatomic, assign) CGFloat agendaCellCurrentHeight;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat kbHeight;
@property (nonatomic, assign) CGFloat agendaTextViewHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    self.count = 6;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.count - 1)
    {
        static NSString *textCellIdentifier = @"textCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:textCellIdentifier ];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.clipsToBounds = YES;
            cell.textLabel.text = @" ";
            cell.textLabel.hidden = YES;
            
            GCPlaceholderTextView *textView = [[GCPlaceholderTextView alloc] initWithFrame:UIEdgeInsetsInsetRect(cell.bounds, UIEdgeInsetsMake(5.0f, 3.0f, 5.0f, 3.0f))];
            textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [textView setFont:[UIFont systemFontOfSize:17.0f]];
            [textView setTextColor:[UIColor blackColor]];
            [textView setRealTextColor:[UIColor blackColor]];
            textView.textContainerInset = UIEdgeInsetsZero;
            textView.textContainer.lineFragmentPadding = 0;
            [textView setBackgroundColor:[UIColor clearColor]];
            [textView setTag:999];
            [textView setUserInteractionEnabled:NO];
            [textView setEditable:NO];
            textView.placeholderColor = [UIColor grayColor];
            [[cell contentView] addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.textLabel);
                make.right.equalTo(cell.contentView).offset(-3.0);
                make.top.equalTo(cell.contentView).offset(10.0f);
                make.bottom.equalTo(cell.contentView).offset(-5.0f);
            }];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agendaEndEditing:) name:UITextViewTextDidEndEditingNotification object:textView];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agendaDidChange:) name:UITextViewTextDidChangeNotification object:textView];
        }
        
        GCPlaceholderTextView *textView = (GCPlaceholderTextView *)[cell viewWithTag:999];
        textView.text = self.agendaString;
        textView.placeholder = NSLocalizedString(@"AgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgendaAgenda", @"Agenda");
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text =  [NSString stringWithFormat:@"------%zd--------",indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.count - 1)
    {
        if (self.agendaCellCurrentHeight > 0)
        {
            return MAX(45.0f, self.agendaCellCurrentHeight);
        }
        else
        {
            UIFont *font = [UIFont systemFontOfSize:17.0f];
            CGSize size =  CGSizeZero;
            NSString *aString = self.agendaString ? self.agendaString : @"  ";
            float width = CGRectGetWidth(self.tableView.bounds) - 24.0f;
            
            CGSize fudgeFactor = CGSizeMake(10.0, 16.0);
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            CGRect bounds = [aString boundingRectWithSize:CGSizeMake(width, 9999)
                                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                                               attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: style} context:nil];
            
            bounds.size.height += fudgeFactor.height;
            bounds.size.width += fudgeFactor.width;
            size = bounds.size;
            
            self.agendaCellCurrentHeight = size.height + 2.0f;
        }
        
        return MAX(45.0f, self.agendaCellCurrentHeight);
    }
    return 55.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.count - 1)
    {
        GCPlaceholderTextView *textView = (GCPlaceholderTextView *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:999];
        BOOL bNeedDelay = [self.view endEditing:YES];
        [textView setUserInteractionEnabled:YES];
        [textView setEditable:YES];
        float delay = bNeedDelay ? 0.3 : 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [textView becomeFirstResponder];
        });
    }
    else
    {
        [self.view endEditing:YES];
        
        TestViewController *testView = [[TestViewController alloc] init];
        [self.navigationController pushViewController:testView animated:YES];
    }
}

#pragma mark - Notification
- (void)agendaEndEditing:(NSNotification*) notification
{
    GCPlaceholderTextView *textView = (GCPlaceholderTextView *)notification.object;
    [textView setEditable:NO];
    [textView setUserInteractionEnabled:NO];
    
    if([textView isKindOfClass:[GCPlaceholderTextView class]] == NO)
        return;
    
    if ([textView.text isEqualToString:textView.placeholder])
    {
        self.agendaString = @"";
    }
    else
    {
        self.agendaString = textView.text;
    }
    
    [self.tableView reloadData];
}

- (void)agendaDidChange:(NSNotification*) notification
{
    GCPlaceholderTextView *textView = (GCPlaceholderTextView *)notification.object;
    
    if ([textView.text isEqualToString:textView.placeholder])
    {
        self.agendaString = @"";
    }
    else
    {
        self.agendaString = textView.text;
    }
    
    NSString *aString = textView.text;
    
    UIFont *font = [UIFont systemFontOfSize:17.0f];
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
    
    if (self.agendaCellCurrentHeight != size.height + 2.0f) {
        self.agendaCellCurrentHeight = size.height + 2.0f;
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    
    CGRect rect = textView.frame;
    rect.size.height = textView.contentSize.height;
    textView.frame = rect;
    [textView scrollRangeToVisible:NSMakeRange(0,0)];
    
    [self setTableViewLocationWithKeyBoardHeight:self.kbHeight];
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.kbHeight = kbHeight;
    
    [self setTableViewLocationWithKeyBoardHeight:kbHeight];
}

- (void) keyboardWillHide:(NSNotification *)notify {
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)setTableViewLocationWithKeyBoardHeight:(CGFloat)kbHeight
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.count - 1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    GCPlaceholderTextView *textView = (GCPlaceholderTextView *)[cell viewWithTag:999];
    if (textView.isFirstResponder)
    {
        [UIView animateWithDuration:0.5f animations:^{
            
            CGFloat needOffset = 55.0f*(self.count - 1) + textView.frame.size.height + kbHeight - self.view.frame.size.height;
            if (needOffset > 0)
            {
                [self.tableView setContentOffset:CGPointMake(0, needOffset + 20.0f)];
            }
            
        }];
    }
    
}

@end

