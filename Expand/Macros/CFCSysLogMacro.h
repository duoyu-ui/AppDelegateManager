

#ifndef _CFC_SYSLOG_MACRO_H_
#define _CFC_SYSLOG_MACRO_H_

/* 控件台打印 */
#ifdef DEBUG
#define FYLog(format, ...) printf("[%s][DEBUG]%s [第%d行] => %s \n", [[CFCSysUtil getCurrentTimeStamp] UTF8String], __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
#else
#define FYLog(__FORMAT__, ...)
#endif


#endif /* _CFC_SYSLOG_MACRO_H_ */

