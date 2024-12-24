import 'package:bond/features/knowledge_base/models/knowledge.dart';
import 'package:bond/features/knowledge_base/models/metadata.dart';

class KnowledgeList {
  List<Knowledge> knowledgeList;
  Metadata metadata;
  KnowledgeList({required this.knowledgeList, required this.metadata});

  factory KnowledgeList.fromJson(Map<String, dynamic> json) {
    List<Knowledge> knowledgeList = [];
    for (var knowledge in json['data']) {
      knowledgeList.add(Knowledge.fromJson(knowledge));
    }
    return KnowledgeList(
        knowledgeList: knowledgeList,
        metadata: Metadata.fromJson(json['meta']));
  }
}
