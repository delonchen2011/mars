//
//  MarsXLog.m
//  MarsXLogOC
//
//

#import "MarsXLog.h"
#include <mars/xlog/xlogger.h>
#include <mars/xlog/appender.h>
#include <sys/xattr.h>
#include <stdarg.h>

using namespace mars::xlog;
@implementation MarsXLog

+ (void)config:(nonnull NSString *)logDir namePrefix:(nullable NSString *)namePrefix pubKey:(nullable NSString *)pubKey {
    NSFileManager *fileMananger = [[NSFileManager alloc] init];
    if (![fileMananger fileExistsAtPath:logDir]) {
        [fileMananger createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:NULL error:NULL];
    }
    
    const char* cLogDir = [logDir UTF8String];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    setxattr(cLogDir, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    XLogConfig config;
    config.logdir_ = cLogDir;
    config.nameprefix_ = namePrefix ? [namePrefix UTF8String] : "";
    config.pub_key_ = pubKey ? [pubKey UTF8String] : "";
    appender_open(config);
    xlogger_SetLevel(kLevelInfo);
}

+ (LogLevel)getLogLevel {
    return (LogLevel)xlogger_Level();
}

+ (void)log:(LogLevel)level tag:(nonnull NSString *)tag file:(nonnull NSString *)file func:(nonnull NSString *)func line:(int)line format:(nonnull NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    xlogger2((TLogLevel)level, [tag UTF8String], [file UTF8String], [func UTF8String], line, [formattedString UTF8String]);
}

+ (void)log:(LogLevel)level tag:(nonnull NSString *)tag file:(nonnull NSString *)file func:(nonnull NSString *)func line:(int)line  message:(NSString*)message {
    xlogger2((TLogLevel)level, [tag UTF8String], [file UTF8String], [func UTF8String], line, [message UTF8String]);
}

+ (void)setIsAsyncFlushMode:(BOOL)flag {
    appender_setmode(flag ? kAppenderAsync : kAppenderSync);
}

+ (void)setLogConsole:(LogConsole)logConsole {
    if (logConsole == LogConsoleNone) {
        appender_set_console_log(false);
    } else {
        appender_set_console_log(true);
        appender_set_console_fun((TConsoleFun)logConsole);
    }
}

+ (void)setLogLevel:(LogLevel)level {
    xlogger_SetLevel((TLogLevel)level);
}

+ (void)setMaxCacheTime:(NSTimeInterval)duration {
    appender_set_max_alive_duration(duration);
}

+ (void)setMaxFileSize:(unsigned long long)fileSize {
    appender_set_max_file_size(fileSize);
}

+ (void)flush:(BOOL)isAsync {
    if (isAsync) {
        appender_flush_sync();
    } else {
        appender_flush();
    }
}

@end
