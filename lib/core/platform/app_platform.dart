import 'dart:io' show Platform;

/// Single source of truth for platform capability gating.
///
/// The app targets Android/iOS (full feature set) and Windows desktop
/// (POS-only). Mobile-only features — push notifications, local
/// notifications, background workers, camera barcode scanning, biometric
/// login, camera/gallery photo picking, voice input — are gated behind
/// [isMobile] so the desktop build never invokes plugins it has no
/// implementation for. Where a desktop equivalent exists (e.g. a USB
/// keyboard-wedge scanner typing into a text field), the desktop path is
/// provided instead of simply disabling the feature.
class AppPlatform {
  const AppPlatform._();

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
  static bool get isDesktop => !isMobile;
}
