//
//  JFABaseService.m
//  Pods
//
//  Created by 魏星 on 15/9/24.
//
//

#import "JFABaseService.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if_dl.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <sys/mount.h>
#import "ACSimpleKeychain.h"
#define KEY_ID_1 @"KeyIdentifier_1"
#define KEY_ID_2 @"KeyIdentifier_2"
@implementation JFABaseService
+ (NSString *)udidString
{
    if (IOS7_OR_LATER) {
        
        NSString * idfa = [JFABaseService getIdentifier:KEY_ID_1];
        if (!idfa.length) {
            idfa = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [JFABaseService storeIdentifier:idfa forKey:KEY_ID_1];
        }
        if (idfa&&[idfa length]>0) {
            return idfa;
        }
        return @"";
    } else {
        if ([JFABaseService localAddress]&&[[JFABaseService localAddress] length]>0) {
            return [JFABaseService localAddress];
        }
        return @"";
    }
}

+ (NSString *)udidString2
{
    NSString * uuid2 = [JFABaseService getIdentifier:KEY_ID_2];
    if (!uuid2.length) {
        uuid2 = [JFABaseService uuid];
        [JFABaseService storeIdentifier:uuid2 forKey:KEY_ID_2];
    }
    if (uuid2&&[uuid2 length]>0) {
        return uuid2;
    }
    return @"";
}
+ (NSString*)uuid
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (__bridge NSString *)uuidString;
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
#pragma mark - keychain
+ (NSString *)getIdentifier:(NSString *)keyIdentifier{
    NSString * identifier = nil;
    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
    NSArray *all = [keychain allCredentialsForService:@"AppInstaller" limit:99];
    if (all.count > 0) {
        NSDictionary *userInfoChain = [keychain credentialsForIdentifier:@"identifier" service:@"AppInstaller"];
        if (userInfoChain.count > 0) {
            NSDictionary * userInfo = [userInfoChain safeObjectForKey:ACKeychainInfo];
            if (userInfo.count > 0) {
                identifier = [userInfo safeObjectForKey:keyIdentifier];
            }
        }
    }
    return identifier;
}
+ (void)storeIdentifier:(NSString *)identifier forKey:(NSString *)keyIdentifier{
    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
    if (keychain) {
        
        NSMutableDictionary * mUserInfo = nil;
        ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
        NSArray *all = [keychain allCredentialsForService:@"AppInstaller" limit:99];
        if (all.count > 0) {
            NSDictionary *userInfoChain = [keychain credentialsForIdentifier:@"identifier" service:@"AppInstaller"];
            if (userInfoChain.count > 0) {
                NSDictionary * userInfo = [userInfoChain safeObjectForKey:ACKeychainInfo];
                if (userInfo.count > 0) {
                    mUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
                }
            }
        }
        
        if (mUserInfo) {
            
            [mUserInfo setObject:identifier.length > 0 ? identifier : @"" forKey:keyIdentifier];
        } else {
            
            mUserInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:identifier.length > 0 ? identifier : @"",keyIdentifier, nil];
        }
        
        [keychain storeUsername:@"identifier" password:nil identifier:@"identifier" info:mUserInfo forService:@"AppInstaller"];
    }
}
+ (NSString *) localAddress
{
    int mib[6];
    size_t len;
    char  *buf;
    unsigned char  *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}


+(BOOL)isAppStoreLock
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"APPSTOREKEYFORYOU"]) {
        NSString * conf_onOff = [[NSUserDefaults standardUserDefaults]objectForKey:@"APPSTOREKEYFORYOU"];
        if (conf_onOff&&[conf_onOff length]>0&&[conf_onOff isEqualToString:@"0"]) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES
        ;
    }

}



@end
