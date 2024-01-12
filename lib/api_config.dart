class ApiConfig {
  static const String mapboxPublicToken = '';

  static const String mapTemplateDark =
      'https://api.mapbox.com/styles/v1/fjxs/clq4bp73m020001p9ggb52arr/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxPublicToken';
  static const String mapTemplateLight =
      'https://api.mapbox.com/styles/v1/fjxs/clq4c0o8t005401qu8h826m25/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxPublicToken';

  static const String stopLink =
      'https://openmobilitydata-data.s3-us-west-1.amazonaws.com/public/feeds/rigas-satiksme/333/20231023/original/stops.txt';

  static const String RSRoutesLink =
      'https://saraksti.rigassatiksme.lv/riga/routes.txt';
}
