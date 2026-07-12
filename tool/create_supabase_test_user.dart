import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main(List<String> args) async {
  final email = _getArg(args, '--email') ?? 'test@example.com';
  final password = _getArg(args, '--password') ?? 'Test1234!';
  final supabaseUrl = Platform.environment['SUPABASE_URL'];
  final serviceRoleKey = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'];

  if (supabaseUrl == null || serviceRoleKey == null) {
    stderr.writeln('Missing required environment variables.');
    stderr.writeln('Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY before running.');
    stderr.writeln('Example:');
    stderr.writeln('  setx SUPABASE_URL "https://your-project.supabase.co"');
    stderr.writeln('  setx SUPABASE_SERVICE_ROLE_KEY "your-service-role-key"');
    exit(1);
  }

  final uri = Uri.parse('$supabaseUrl/auth/v1/admin/users');
  final body = jsonEncode({
    'email': email,
    'password': password,
    'email_confirm': true,
  });

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'apikey': serviceRoleKey,
      'Authorization': 'Bearer $serviceRoleKey',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    print('Test user created successfully.');
    print('Email: $email');
    print('Password: $password');
  } else {
    stderr.writeln('Failed to create test user.');
    stderr.writeln('Status: ${response.statusCode}');
    stderr.writeln('Response: ${response.body}');
    exit(1);
  }
}

String? _getArg(List<String> args, String name) {
  final index = args.indexOf(name);
  if (index == -1 || index + 1 >= args.length) return null;
  return args[index + 1];
}
