class DatasetSettingModel {
  final String apiBaseUrl;
  final String databaseUrl;
  final bool useApi;
  final bool useMock;
  final String updatedBy;

  const DatasetSettingModel({
    required this.apiBaseUrl,
    required this.databaseUrl,
    required this.useApi,
    required this.useMock,
    required this.updatedBy,
  });

  factory DatasetSettingModel.fromJson(Map<String, dynamic> json) {
    return DatasetSettingModel(
      apiBaseUrl: json['apiBaseUrl']?.toString() ?? 'http://localhost:3001',
      databaseUrl: json['databaseUrl']?.toString() ?? '',
      useApi: json['useApi'] == true,
      useMock: json['useMock'] == true,
      updatedBy: json['updatedBy']?.toString() ?? '',
    );
  }
}
