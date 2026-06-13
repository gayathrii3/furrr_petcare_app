class HealthSection {
  final String title;
  final String content;

  const HealthSection({
    required this.title,
    required this.content,
  });

  factory HealthSection.fromJson(Map<String, dynamic> json) {
    return HealthSection(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
  };
}

class HealthArticle {
  final String title;
  final String summary;
  final List<HealthSection> sections;
  final List<String> tags;

  const HealthArticle({
    required this.title,
    required this.summary,
    required this.sections,
    required this.tags,
  });

  factory HealthArticle.fromJson(Map<String, dynamic> json) {
    return HealthArticle(
      title: json['title'] ?? 'Untitled Article',
      summary: json['summary'] ?? '',
      sections: (json['sections'] as List? ?? [])
          .map((s) => HealthSection.fromJson(s))
          .toList(),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'summary': summary,
    'sections': sections.map((s) => s.toJson()).toList(),
    'tags': tags,
  };
}
