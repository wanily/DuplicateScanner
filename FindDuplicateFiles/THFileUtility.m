//
//  THFileUtility.m
//  FindDuplicateFiles
//
//  Created by TanHao on 12-11-2.
//  Copyright (c) 2012年 tanhao.me. All rights reserved.
//

#import "THFileUtility.h"
#include <sys/stat.h>

@implementation THFileUtility

+ (mode_t)fileTypeByPath:(NSString *)filePath
{
    struct stat stat1;
    if(stat([filePath fileSystemRepresentation], &stat1) == 0)
    {
        mode_t fileType = stat1.st_mode;
        return fileType;
    }
    return S_IFWHT;
}

+ (BOOL)fileIsRegular:(NSString *)filePath
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
    NSString *fileType = [attributes objectForKey:NSFileType];
    return [fileType isEqualToString:NSFileTypeRegular];
}

+ (BOOL)fileIsDirectory:(NSString *)filePath
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
    NSString *fileType = [attributes objectForKey:NSFileType];
    return [fileType isEqualToString:NSFileTypeDirectory];
}

+ (uint64)fileSizeByPath:(NSString *)filePath
{
    uint64 size = 0;
    MDItemRef item = MDItemCreate(kCFAllocatorDefault, (__bridge CFStringRef)filePath);
    if (item)
    {
        NSNumber *sizeNumber = (__bridge_transfer NSNumber*)MDItemCopyAttribute(item,kMDItemFSSize);
        CFRelease(item);
        size = [sizeNumber longLongValue];
        if (size > 0)
        {
            return size;
        }
    }
    
    struct stat stat1;
    if(stat([filePath fileSystemRepresentation], &stat1) == 0)
    {
        size = stat1.st_size;
        if (size > 0)
        {
            return size;
        }
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    size = [fileHandle seekToEndOfFile];
    [fileHandle closeFile];
    
    return size;
}

@end
