import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/model_project.dart';

class ProjectApiService {
  final String baseUrl;

  ProjectApiService({required this.baseUrl});

  Future<List<ModelProject>> fetchProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/projects.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ModelProject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch projects');
    }
  }

  Future<ModelProject> createProject(ModelProject project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_project.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(project.toJson()),
    );

    if (response.statusCode == 201) {
      return ModelProject.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create project');
    }
  }

  Future<ModelProject> updateProject(ModelProject project) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update_project.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(project.toJson()),
    );

    if (response.statusCode == 200) {
      return ModelProject.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update project');
    }
  }

  Future<void> deleteProject(String idpro) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete_project.php?idpro=$idpro'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete project');
    }
  }
}
