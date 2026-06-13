import 'package:http/http.dart' as http;

void main() async {
  final url = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5nmsHGc7ppZdAAy9mrePmMMccNmh4M_jizLQMkJrfVUZwLKeX-HjXEr4&s=10';
  print('Fetching $url...');
  try {
    final response = await http.get(Uri.parse(url));
    print('Status Code: ${response.statusCode}');
    print('Content Length: ${response.bodyBytes.length}');
    print('Content Type: ${response.headers['content-type']}');
  } catch (e) {
    print('Error: $e');
  }
}
