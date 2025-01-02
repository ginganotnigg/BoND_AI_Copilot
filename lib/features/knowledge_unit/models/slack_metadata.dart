import 'package:bond/config/constant.dart';
import 'package:bond/features/knowledge_unit/models/unit_metadata.dart';

class MetadataSlack extends UnitMetadata {
  final String slackBotToken;
  final String slackWorkspace;

  const MetadataSlack({
    required this.slackBotToken,
    required this.slackWorkspace,
  }) : super(type: 'slack');

  factory MetadataSlack.fromJson(Map<String, dynamic> json) {
    return MetadataSlack(
      slackBotToken: json['slack_bot_token'] as String,
      slackWorkspace: json['slack_workspace'] as String,
    );
  }

  @override
  String getType() {
    return "Slack";
  }

  @override
  String getIconPath() {
    return slackImagePath;
  }
}
