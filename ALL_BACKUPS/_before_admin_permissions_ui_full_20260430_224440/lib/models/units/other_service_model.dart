class OtherService {
  final String id;
  final String titleKey;
  final String subtitleKey;
  final String assetPath;
  final bool studentVisible;
  final bool staffVisible;

  const OtherService({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.assetPath,
    this.studentVisible = true,
    this.staffVisible = true,
  });
}
