//
//  BlackListViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/9/18.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BlackListViewController.h"
#import "ChatModel.h"
#import "ChatCell.h"
#import <RongIMLib/RongIMLib.h>
#import "ChatViewController.h"
#import "UIImageView+WebCache.h"
#import "RCAppInfoModel.h"
#import "RCWKUtility.h"

@interface BlackListViewController ()

@property (strong, nonatomic) NSMutableDictionary *dataDictionary;

@property (assign, nonatomic) NSInteger count;

@end

static NSString * const reuseIdentifier = @"cell";

@implementation BlackListViewController

- (NSMutableDictionary *)dataDictionary {
    if (!_dataDictionary) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    return _dataDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.title = NSLocalizedString(@"BlackList", nil);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self loadData];
    
    self.count = 0;
    
}

- (void)backItemOnClick:(UIBarButtonItem *)item
{
    [super backItemOnClick:item];
    
    if (self.count > 0) {
        if (self.reloadBlock) self.reloadBlock();
    }
}

#pragma mark - 网络请求

- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = @([UserInfoManager userID]);
    [self networkWithPath:@"blacklist/list" parameters:params success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if (code.intValue == 0) {
            NSArray *objArray = [MTLJSONAdapter modelsOfClass:[ChatModel class] fromJSONArray:responseObject[@"object"] error:nil];
            [self.dataDictionary removeAllObjects];
            for (ChatModel *model in objArray) {
                if (model.chatType == nil) {
                    continue ;
                }
                if (![self.dataDictionary.allKeys containsObject:model.chatType]) {
                    NSMutableArray *valueArray = [NSMutableArray array];
                    [valueArray addObject:model];
                    self.dataDictionary[model.chatType] = valueArray;
                }else {
                    NSMutableArray *valueArray = [NSMutableArray array];
                    valueArray  = self.dataDictionary[model.chatType];
                    [valueArray addObject:model];
                }
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataDictionary.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *chats = self.dataDictionary[self.dataDictionary.allKeys[section]];
    ChatModel *model = chats.firstObject;
    if (!model.targetUser.userType.isOpen) {
        NSArray *chats = self.dataDictionary[self.dataDictionary.allKeys[section]];
        return chats.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *chats = self.dataDictionary[self.dataDictionary.allKeys[indexPath.section]];
    ChatModel *model = chats[indexPath.row];
    cell.model = model;
    RCConversation *conversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_PRIVATE targetId:[NSString stringWithFormat:@"%ld", model.targetUserId]];
    
    cell.nameLabel.text = model.targetUser.nickname;
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!/both/50x50",model.targetUser.headpic]]];
    
    cell.timeLabel.text = [self ConvertChatMessageTime:conversation.sentTime];
    
    [[RCIM sharedRCIM] refreshUserInfoCache:[[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%ld",model.targetUserId] name:model.targetUser.nickname portrait:model.targetUser.headpic] withUserId:[NSString stringWithFormat:@"%ld",model.targetUserId]];
    
    cell.badge = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE targetId:[NSString stringWithFormat:@"%ld",model.targetUserId]];
    
    if ([conversation.lastestMessage respondsToSelector:@selector(conversationDigest)]) {
        NSString *digest = [conversation.lastestMessage performSelector:@selector(conversationDigest)];
        [cell.messageLabel setText:digest];
    } else if ([conversation.lastestMessage isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMsg = (RCTextMessage *)conversation.lastestMessage;
        [cell.messageLabel setText:textMsg.content];
    } else if ([conversation.lastestMessage isKindOfClass:[RCImageMessage class]]) {
        [cell.messageLabel setText:@"[图片]"];
    } else if ([conversation.lastestMessage isKindOfClass:[RCVoiceMessage class]]) {
        [cell.messageLabel setText:@"[语音]"];
    } else if ([conversation.lastestMessage isKindOfClass:[RCLocationMessage class]]) {
        [cell.messageLabel setText:@"[位置]"];
    } else if ([conversation.lastestMessage isKindOfClass:[RCDiscussionNotificationMessage class]]) {
        NSString *notifyString = [RCWKUtility formatDiscussionNotificationMessageContent:(RCDiscussionNotificationMessage *)conversation.lastestMessage];
        [cell.messageLabel setText:notifyString];
    } else {
        //        [cell.messageLabel setText:@"[不支持消息]"];
        [cell.messageLabel setText:@""];
    }
    
    return cell;
}

- (NSString*)ConvertChatMessageTime:(long long)secs{
    NSString *timeText=nil;
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs/1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM:dd"];
    
    NSString *strMsgDay = [formatter stringFromDate:messageDate];
    
    NSDate *now = [NSDate date];
    NSString* strToday = [formatter stringFromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *strYesterday = [formatter stringFromDate:yesterday];
    
    if ([strMsgDay isEqualToString:strToday]) {
        [formatter setDateFormat:@"HH':'mm"];
    }else if([strMsgDay isEqualToString:strYesterday]){
        [formatter setDateFormat:@"昨天"];
    }
    else
    {
        [formatter setDateFormat:@"MM-dd"];
    }
    timeText = [formatter stringFromDate:messageDate];
    
    return timeText;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *chats = self.dataDictionary[self.dataDictionary.allKeys[indexPath.section]];
    ChatModel *model = chats[indexPath.row];
    
    UITableViewRowAction *actionOne = [UITableViewRowAction rowActionWithStyle:0 title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self networkWithPath:@"chat/delete" parameters:@{@"chatId":@(model.chatId)} success:^(id responseObject) {
            NSNumber *code = responseObject[@"code"];
            if (code.intValue == 0) {
                NSMutableArray *temp = [NSMutableArray arrayWithArray:chats];
                NSString *key = self.dataDictionary.allKeys[indexPath.section];
                if (temp.count > 1) {
                    [temp removeObject:model];
                    self.dataDictionary[key] = temp;
                }else {
                    [self.dataDictionary removeObjectForKey:key];
                }
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }];
    actionOne.backgroundColor = [UIColor colorWithHex:0xF7D2D0];
    
    UITableViewRowAction *actionTwo = [UITableViewRowAction rowActionWithStyle:1 title:NSLocalizedString(@"RemoveFromBlack", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 取消黑名单
        [[RCIMClient sharedRCIMClient] removeFromBlacklist:[NSString stringWithFormat:@"%ld", model.targetUserId] success:^{
//            NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//            });
        } error:^(RCErrorCode status) {
            
        }];
        // 调用接口
        [self networkWithPath:@"blacklist/delete" parameters:@{@"chatId":@(model.chatId)} success:^(id responseObject) {
            NSNumber *code = responseObject[@"code"];
            if (code.intValue == 0){
                self.count++;
                NSString *key = self.dataDictionary.allKeys[indexPath.section];
                NSMutableArray *array = self.dataDictionary[key];
                if (array.count == 1) {
                    [self.dataDictionary removeObjectForKey:key];
                }else {
                    ChatModel *model = array[indexPath.row];
                    [array removeObject:model];
                    self.dataDictionary[key] = array;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            [CustomHudView showWithTip:responseObject[@"msg"]];
        } failure:^(NSError *error) {
            NSLog(@"-----");
        }];
    }];
    actionTwo.backgroundColor = [UIColor colorWithHex:0xF7DB9F];
    
    return @[actionOne, actionTwo];
}

-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message
{
    return YES;
}

@end
