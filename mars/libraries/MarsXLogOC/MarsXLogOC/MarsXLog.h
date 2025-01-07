//
//  MarsXLog.h
//  MarsXLogOC
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LogConsole) {
    LogConsoleNone,
    LogConsolePrintf = 0,
    LogConsoleNSLog,
    LogConsoleOSLog,
};

typedef NS_ENUM(NSUInteger, LogLevel) {
    LogLevelAll = 0,
    LogLevelVerbose = 0,
    LogLevelDebug,
    LogLevelInfo,
    LogLevelWarn,
    LogLevelError,
    LogLevelFatal,
    LogLevelNone,
};

@interface MarsXLog : NSObject
+ (void)config:(NSString*)logDir
    namePrefix:(nullable NSString*)namePrefix
        pubKey:(nullable NSString*)pubKey;
+ (void)setLogLevel:(LogLevel)level;
+ (LogLevel)getLogLevel;
+ (void)setLogConsole:(LogConsole)logConsole;
+ (void)setMaxFileSize:(unsigned long long)fileSize;
+ (void)setMaxCacheTime:(NSTimeInterval)duration;
+ (void)setIsAsyncFlushMode:(BOOL)flag;
+ (void)flush:(BOOL)isAsync;
+ (void)log:(LogLevel)level
        tag:(NSString*)tag
        file:(NSString*)file
        func:(NSString*)func
        line:(int)line
        format:(NSString*)format, ...;
+ (void)log:(LogLevel)level
        tag:(NSString*)tag
        file:(NSString*)file
        func:(NSString*)func
        line:(int)line
        message:(NSString*)message;
@end

NS_ASSUME_NONNULL_END
