#import "EmbeddedTailscale.h"
#import "TemporaryHost.h"

// The Go bridge, the sign in screens and the peer picker are gone. See the
// header for why the remaining methods still exist.

static BOOL offLocalNetwork;

@implementation EmbeddedTailscale
+ (BOOL)matchesAddress:(NSString *)address {
    return NO;
}
+ (NSString *)routedAddress:(NSString *)address {
    return address;
}
+ (BOOL)isTailscaleAddress:(NSString *)address {
    if ([address.lowercaseString hasPrefix:@"fd7a:115c:a1e0:"]) {
        return YES;
    }
    NSArray<NSString *> *parts = [address componentsSeparatedByString:@"."];
    if (parts.count != 4 || ![parts[0] isEqualToString:@"100"]) {
        return NO;
    }
    NSInteger second = parts[1].integerValue;
    return second >= 64 && second <= 127;
}
+ (NSString *)lanAddressForPeer:(NSString *)address {
    return nil;
}
+ (void)networkChanged:(BOOL)onLocalNetwork {
    offLocalNetwork = !onLocalNetwork;
}
+ (void)setOnLocalNetwork:(BOOL)onLocalNetwork {
    offLocalNetwork = !onLocalNetwork;
}
+ (BOOL)onLocalNetwork {
    return !offLocalNetwork;
}
+ (NSString *)routeKeyForHost:(TemporaryHost *)host {
    return [@"MoonlightRoute-" stringByAppendingString:host.uuid ?: host.address ?: @""];
}
+ (NSInteger)routePreferenceForHost:(TemporaryHost *)host {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[self routeKeyForHost:host]];
}
+ (void)setRoutePreference:(NSInteger)preference forHost:(TemporaryHost *)host {
    [[NSUserDefaults standardUserDefaults] setInteger:preference forKey:[self routeKeyForHost:host]];
}
+ (NSString *)connectionAddressForHost:(TemporaryHost *)host {
    // Discovery picks the address that answered: the LAN address at home,
    // the Tailscale address elsewhere. Use it; fall back to the registered one.
    return host.activeAddress ?: host.address;
}
@end
