class HomeContentResponse {
  final List<HomeSection> sections;

  HomeContentResponse({required this.sections});

  factory HomeContentResponse.fromJson(Map<String, dynamic> json) {
    // Check if sections are nested inside a 'data' object
    var dataObj = json['data'];
    var sectionsListObj = (dataObj != null && dataObj is Map && dataObj.containsKey('sections')) 
        ? dataObj['sections'] 
        : json['sections'];
        
    var list = sectionsListObj as List? ?? [];
    List<HomeSection> sectionsList = list.map((i) => HomeSection.fromJson(i)).toList();
    return HomeContentResponse(sections: sectionsList);
  }
}

class HomeSection {
  final String title;
  final String type;
  final List<ContentItem> items;

  HomeSection({
    required this.title,
    required this.type,
    required this.items,
  });

  factory HomeSection.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List? ?? [];
    List<ContentItem> itemsList = list.map((i) => ContentItem.fromJson(i)).toList();
    return HomeSection(
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      items: itemsList,
    );
  }
}

class ContentItem {
  final dynamic id;
  final String title;
  final String posterUrl;
  final double rating;
  final String contentType;
  final bool isRecent;

  ContentItem({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.contentType,
    required this.isRecent,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'],
      title: json['title'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      contentType: json['type'] ?? json['contentType'] ?? '',
      isRecent: json['isRecent'] ?? false,
    );
  }
}
