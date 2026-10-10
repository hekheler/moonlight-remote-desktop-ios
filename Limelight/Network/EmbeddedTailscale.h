#import <UIKit/UIKit.h>
@class TemporaryHost;

// What is left of the embedded Tailscale after the Go bridge was removed.
// Tailscale now comes from the system Tailscale app on the iPhone, so no host
// is ever routed through an embedded node. The call sites stay as they were
// and simply take their normal path.
@interface EmbeddedTailscale : NSObject
// Always NO: there is no embedded node to route through
+ (BOOL)matchesAddress:(NSString *)address;
// Returns the address unchanged
+ (NSString *)routedAddress:(NSString *)address;
+ (NSString *)connectionAddressForHost:(TemporaryHost *)host;
// For a PC added through Tailscale: 0 automatic (LAN first), 1 LAN only, 2 Tailscale only
+ (NSInteger)routePreferenceForHost:(TemporaryHost *)host;
// 100.64.0.0/10 or Tailscale's IPv6 range
+ (BOOL)isTailscaleAddress:(NSString *)address;
// Always nil: only an embedded node could report a peer's LAN address
+ (NSString *)lanAddressForPeer:(NSString *)address;
// Wi-Fi/wired vs. cellular, as last reported by the network monitor
+ (void)networkChanged:(BOOL)onLocalNetwork;
+ (BOOL)onLocalNetwork;
+ (void)setOnLocalNetwork:(BOOL)onLocalNetwork;
+ (void)setRoutePreference:(NSInteger)preference forHost:(TemporaryHost *)host;
@end
