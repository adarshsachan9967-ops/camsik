class QuestionsResponse {
  final bool success;
  final List<QuestionModel> questions;

  const QuestionsResponse({
    this.success = true,
    required this.questions,
  });

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) {
    final list = json['questions'] as List? ?? [];
    return QuestionsResponse(
      success: json['success'] != false,
      questions: list
          .whereType<Map>()
          .map((e) => QuestionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class QuestionModel {
  final String id;
  final String title;
  final String description;
  final List<Map<String, dynamic>> options;

  const QuestionModel({
    required this.id,
    required this.title,
    required this.description,
    this.options = const [],
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List? ?? [];
    return QuestionModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      options: rawOptions
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'options': options,
    };
  }
}
