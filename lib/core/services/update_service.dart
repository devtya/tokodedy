import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class UpdateInfo {
  final String version;
  final String url;
  final String? notes;
  final String? assetName;

  UpdateInfo({required this.version, required this.url, this.notes, this.assetName});
}

class UpdateService {
  String repoOwner = 'devtya';
  String repoName = 'hend_kasir';
  static const String _assetName = 'app-release.apk';

  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version;

      final uri = Uri.parse(
        'https://api.github.com/repos/$repoOwner/$repoName/releases/latest',
      );
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = json['tag_name'] as String? ?? '';
      final latestVersion = tagName.replaceAll('v', '');
      final body = json['body'] as String?;

      if (_compareVersions(latestVersion, currentVersion) <= 0) return null;

      final assets = json['assets'] as List<dynamic>? ?? [];
      String? downloadUrl;
      String? foundAssetName;

      // Cari aset dengan nama hend*kasir*.apk (bisa pakai underscore atau tidak)
      for (final asset in assets) {
        final name = asset['name'] as String? ?? '';
        final lowerName = name.toLowerCase();
        if (lowerName.startsWith('hend') && lowerName.endsWith('.apk')) {
          downloadUrl = asset['browser_download_url'] as String?;
          foundAssetName = name;
          break;
        }
      }

      // Fallback ke app-release.apk
      if (downloadUrl == null) {
        for (final asset in assets) {
          final name = asset['name'] as String? ?? '';
          if (name == _assetName) {
            downloadUrl = asset['browser_download_url'] as String?;
            foundAssetName = name;
            break;
          }
        }
      }

      if (downloadUrl == null) return null;

      return UpdateInfo(
        version: latestVersion,
        url: downloadUrl,
        notes: body,
        assetName: foundAssetName,
      );
    } catch (_) {
      return null;
    }
  }

  Future<String> downloadApk(
    String url, {
    String? assetName,
    void Function(double progress)? onProgress,
  }) async {
    final dir = await getTemporaryDirectory();
    final fileName = assetName ?? _assetName;
    final file = File('${dir.path}/$fileName');

    final response = await http.Client().send(http.Request('GET', Uri.parse(url)));
    final total = response.contentLength ?? 0;
    var downloaded = 0;

    final sink = file.openWrite(mode: FileMode.write);
    await for (final chunk in response.stream) {
      sink.add(chunk);
      downloaded += chunk.length;
      if (total > 0) {
        onProgress?.call(downloaded / total);
      }
    }
    await sink.close();

    return file.path;
  }

  Future<void> installApk(String filePath) async {
    await OpenFilex.open(filePath);
  }

  int _compareVersions(String a, String b) {
    final partsA = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final partsB = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final len = partsA.length > partsB.length ? partsA.length : partsB.length;
    for (var i = 0; i < len; i++) {
      final va = i < partsA.length ? partsA[i] : 0;
      final vb = i < partsB.length ? partsB[i] : 0;
      if (va != vb) return va - vb;
    }
    return 0;
  }
}
