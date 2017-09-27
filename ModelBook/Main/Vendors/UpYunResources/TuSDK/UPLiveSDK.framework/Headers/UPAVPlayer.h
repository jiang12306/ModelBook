//
//  UPAVPlayer.h
//  UPAVPlayerDemo
//
//  Created by DING FENG on 2/16/16.
//  Copyright © 2016 upyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UPLiveSDKConfig.h"



typedef NS_ENUM(NSInteger, UPAVPlayerStatus) {
    UPAVPlayerStatusIdle,
    UPAVPlayerStatusPlaying_buffering,
    UPAVPlayerStatusPlaying,
    UPAVPlayerStatusPause,
    UPAVPlayerStatusFailed
};

typedef NS_ENUM(NSInteger, UPAVStreamStatus) {
    UPAVStreamStatusIdle,
    UPAVStreamStatusConnecting,
    UPAVStreamStatusReady,
};


typedef void(^AudioBufferListReleaseBlock)(AudioBufferList *audioBufferListe);


@interface UPAVPlayerStreamInfo : NSObject
@property (nonatomic) float duration;
@property (nonatomic) BOOL canPause;
@property (nonatomic) BOOL canSeek;
@property (nonatomic, strong) NSDictionary *descriptionInfo;
@end

@interface UPAVPlayerDashboard: NSObject
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSString *serverIp;
@property (nonatomic, readonly) NSString *serverName;
@property (nonatomic, readonly) int cid;
@property (nonatomic, readonly) int pid;
@property (nonatomic, readonly) float fps;
@property (nonatomic, readonly) float bps;
@property (nonatomic, readonly) int vCachedFrames;
@property (nonatomic, readonly) int aCachedFrames;

@property (readonly, nonatomic) int decodedVFrameNum;//解码的视频包数量
@property (readonly, nonatomic) int decodedVKeyFrameNum;//解码的关键帧
@property (readonly, nonatomic) int decodedAFrameNum;//解码的音频包数量

@end


@class UPAVPlayer;

@protocol UPAVPlayerDelegate <NSObject>
//播放器状态
@optional
- (void)player:(UPAVPlayer *)player playerStatusDidChange:(UPAVPlayerStatus)playerStatus;
- (void)player:(UPAVPlayer *)player displayPositionDidChange:(float)position;
- (void)player:(UPAVPlayer *)player bufferingProgressDidChange:(float)progress;

@required
- (void)player:(UPAVPlayer *)player playerError:(NSError *)error;

//视频流状态
@optional
- (void)player:(UPAVPlayer *)player streamStatusDidChange:(UPAVStreamStatus)streamStatus;
- (void)player:(UPAVPlayer *)player streamInfoDidReceive:(UPAVPlayerStreamInfo *)streamInfo;

//字幕流回调
@optional
- (void)player:(UPAVPlayer *)player subtitle:(NSString *)text atPosition:(CGFloat)position shouldDisplay:(CGFloat)duration;


/*
 播放音频数据的回调.
 用途如：读取并播放音频文件，同时将音频数据送入混音器来当作背景音乐。
 */
@optional
- (void)player:(UPAVPlayer *)audioManager
willRenderBuffer:(AudioBufferList *)audioBufferList
     timeStamp:(const AudioTimeStamp *)inTimeStamp
        frames:(UInt32)inNumberFrames
          info:(AudioStreamBasicDescription)asbd
         block:(AudioBufferListReleaseBlock)release;

@end



@interface UPAVPlayer : NSObject

@property (nonatomic, strong, readonly) UPAVPlayerDashboard *dashboard;
@property (nonatomic, strong, readonly) UPAVPlayerStreamInfo *streamInfo;
@property (nonatomic, assign, readonly) UPAVPlayerStatus playerStatus;
@property (nonatomic, assign, readonly) UPAVStreamStatus streamStatus;
/// 播放器画面的View
@property (nonatomic, strong, readonly) UIView *playView;
/// 缓冲区大小,  设置为 0 的话, 会缓冲完整视频
@property (nonatomic, assign) NSTimeInterval bufferingTime;
/// 音量大小 0.0f 到 1.0f
@property (nonatomic, assign) CGFloat volume;
/// 屏幕明亮度 0.0f 到 1.0f
@property (nonatomic, assign) CGFloat bright;
/// 静音控制 默认为 NO
@property (nonatomic, assign) BOOL mute;
/// 视频缓冲超时，单位 秒, 默认 60s, 一段时间内未能缓冲到可播放的数据
@property (nonatomic, assign) NSTimeInterval timeoutForBuffering;
/// 连接超时设置，默认 10s, 一段时间内无数据传输
@property (nonatomic, assign) NSTimeInterval timeoutForOpenFile;
/// 打开视频失败后的重试次数限制，默认 1 次，最大 10 次
@property (nonatomic, assign) NSUInteger maxNumForReopenFile;
/// 要播放的网络视频地址
@property (nonatomic, copy) NSString *url;
/// 视频已经播放到的时间点
@property (nonatomic, assign, readonly) float displayPosition;
/// 视频流读取到的时间点
@property (nonatomic, assign, readonly) float streamPosition;
/// 音频播放到的时间点
@property (nonatomic, assign, readonly) float audioPosition;
/// 播放器的 delegate
@property (nonatomic, weak) id<UPAVPlayerDelegate> delegate;
/// 音画同步，默认值 YES
@property (nonatomic) BOOL lipSynchOn;
/// 音视频同步方式, 0:音频向视频同步,视频向标准时间轴同步；1:视频向音频同步，音频按照原采样率连续播放。默认值 为 1。
@property (nonatomic) int lipSynchMode;
///
- (instancetype)initWithURL:(NSString *)url;
/// 设置画面的frame
- (void)setFrame:(CGRect)frame;
/// 连接方法
- (void)connect;
/// 开始播放
- (void)play;
/// 暂停
- (void)pause;
/// 停止, 会清除播放信息
- (void)stop;
/// 拖拽功能 秒为单位
- (void)seekToTime:(CGFloat)position;

@end
