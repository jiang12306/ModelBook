//
//  ChatListViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/17.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatModel.h"
#import "ChatCell.h"
#import "ChatHeaderView.h"
#import <RongIMLib/RongIMLib.h>
#import "ChatViewController.h"
#import "UIImageView+WebCache.h"
#import "RCAppInfoModel.h"
#import "RCWKUtility.h"
#import "BlackListViewController.h"

@interface ChatListViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableDictionary *dataDictionary;

@end

static NSString * const reuseIdentifier = @"cell";

static NSString * const headRuseIdentifier = @"head";

@implementation ChatListViewController

- (NSMutableDictionary *)dataDictionary {
    if (!_dataDictionary) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    return _dataDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"tabBar-titleD", nil);
    
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemEvent) image:@"more"];//Chiang
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:headRuseIdentifier];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self takePushEvent];
    
    if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] >  0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
    }else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}

#pragma mark - 网络请求

- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = @([UserInfoManager userID]);
    [self networkWithPath:@"chat/query" parameters:params success:^(id responseObject) {
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ChatHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headRuseIdentifier];
    NSArray *chats = self.dataDictionary[self.dataDictionary.allKeys[section]];
    view.model = chats.firstObject;
    view.openBlock = ^(ChatHeaderView *view){
        [self.tableView reloadData];
    };
    return view;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *chats = self.dataDictionary[self.dataDictionary.allKeys[indexPath.section]];
    ChatModel *model = chats[indexPath.row];
    ChatViewController *controller = [[ChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:[NSString stringWithFormat:@"%ld", model.targetUserId]];
    controller.title = model.targetUser.nickname;
    controller.operateBlock = ^(){
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
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
    
    UITableViewRowAction *actionTwo = [UITableViewRowAction rowActionWithStyle:1 title:NSLocalizedString(@"AddToBlack", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 加入黑名单
        [[RCIMClient sharedRCIMClient] addToBlacklist:[NSString stringWithFormat:@"%ld", model.targetUserId] success:^{
//            NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//            });
        } error:^(RCErrorCode status) {
            NSLog(@"-----");
        }];
        // 调用接口
        [self networkWithPath:@"blacklist/insert" parameters:@{@"userId":@([UserInfoManager userID]), @"targetUserId":@(model.targetUserId)} success:^(id responseObject) {
            NSNumber *code = responseObject[@"code"];
            if (code.intValue == 0){
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

- (void)takePushEvent
{
    NSString *targetid = [UserInfoManager targetid];
    if (targetid.length == 0) return;
    [self networkWithPathWithoutHud:@"chat/insert" parameters:@{@"userId":@([UserInfoManager userID]), @"targetUserId":targetid,@"chatType":@"bookings"} success:^(id responseObject) {
        [self loadData];
    } failure:^(NSError *error) {
        
    }];
    
    [UserInfoManager setTargetid:@""];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"black"]) {
        BlackListViewController *controller = segue.destinationViewController;
        controller.reloadBlock = ^(){
            [self loadData];
        };
    }
}

#pragma mark - rightItem

- (void)rightItemEvent
{
    
    //Chiang
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"黑名单", @"联系客服", nil];
    [sheet showInView:self.view];
}

//Chiang
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"black" sender:nil];
    }else if (buttonIndex == 1) {
//        ...
    }
}

@end
