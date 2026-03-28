/// Centralized asset URLs and image paths.
///
/// Keeps all network image URLs in one place so they can be
/// swapped out during testing, base URL changes, or migration
/// to local assets without hunting through every widget file.
abstract final class AppAssets {
  // ──────────────────────── User Avatars ─────────────────────
  /// Dashboard app bar avatar.
  static const String dashboardAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD05GEMEm65Ig8moGsWgBD0sm44TZETOtkPLN4G8SF9rub5CX3mahQA_DUlC5njMZ0oZwXhR1jJjwdmbX27E52hAF5LBOw3Pk9wXv6BJrF7pcSh3udbeY5YXB2kazHUVJfrp3qj2gIVc-GhRAUIUd0XLfdQztfw94ATZ9qpeGV7rtW-gT140mmTLYi9_uet6yBUzG-3ArdO9Y__JkFQ_UmWs2bNDQjdj1qRxuFA8ZjeEHRC6RDnFALBQn709dq-8VNHY2KoD93zPHs';

  /// Geometry app bar avatar.
  static const String geometryAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC_KY22XTiCNmHx_HltyJkLFpq-4m5HDIU5wN1vt-yo2dGwe6qd7yRqAk1zkCa8xQIvA5Djl0HrFp0udhWo343dBq43bp87KhcZBwNbLrwZrxkaGS99FNgUPL_e_vem2EiLVCQbJd9PinqlwEJtLM7OpVCo692cLQZ1FZoZBZgh1_HhbvUojM5mjEwCrvifzcTmvnhY3NmyCTBEzJNXAcy9Y52v5p_ZgPbNM8ibGJohZpxxkRAafaal3-HA2bgUyYQRppKb6Ze4w0U';

  /// Algebra app bar avatar.
  static const String algebraAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD095CQth2EDB4o9x4Ah4gfRit87Hn0ywbITHd3llGARG9owhftv1ZJ98cB0Sp7zzRebUEdDZNYMOqrP4L0xxc4TLqz0QyihYHQ8YridRViSIycDUu_3tgRllIpSGizNzV48PZdYwd1mtOTUq-lAPM3hQXdBK0MeobYjb6eU_GPwcxyHkVeCeUF-mQDU5swQU7Cizbw1sKtYkPojK0KqsgJl95u6mIA4Optdz8PseEiIh-zE9r-Ixo6mDZYj3Sh43hhqCIQr5RQCW8';

  /// Profile app bar avatar.
  static const String profileAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDz8div5w1Pk9ye0kwi2kuW_XnrX1vZ1-744PVOV0UDX4OoFTq9ld8NiJ-CaaLJXnrF3cqm8j-eH5lRHSjlz9zVkpn4DKcPerzNsyvlnclqj0lRf5sabjOvCrSdmPYIgoeviomsqTmKIH0ebkc4DEq_iuCIvUejea45SfVh0dvy5gyuWBChdJf6QsGxEeCwTsU1gK2W4e6Nscmd5hv6j5DZ7bqc5TCdqn65cTsgyzqsGpZ5LuK5xGBv80qy0EcguWr5dimVbz2mMGY';

  /// Profile hero avatar (used in profile local datasource).
  static const String profileHeroAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBKkvA68Xw_4MMjE_ZeYpjnn_GMFY_6fsx0palG7alaHlcXcKNElydYoC8igJDmRK45fEHqub0Ik-UyISt_8X2hAWiGx6CO96f69H5wjy-_h0wrAOOPPQb2Ee4h26x0d3Rj4fnVfTQ0nl8fVZJrSKQdE_KBqUjSwro_6Y5FXOs_--Q7bWqlMXVa9oxMD80ERceiEMB_L6OmD9KyenXUTIn79Lk-7i1w9tGPRimWM7pFMStyPBZ9JzJY4AGoGKMkjpw8FUFz4PUKUkU';

  // ──────────────────────── Subject Images ───────────────────
  /// Math card image.
  static const String mathSubjectImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDGcnx-d5vE09VCQyyxe3kzAJAjNRe73ZoTvBru_pry7NqFmQuugeUYMjeon5Lg4Ghz2xM-6DYHb4zNIalqBbYz3WSpb4DURHKNlbKuKG3ZZi3hTmiyzg2gkGr4Mz2yP8fLJOmcfd1ttlQrPhmCUKLFci5cCHUYDT0caPE_WTqVQmCnUGIKGO83R44linzTUPsnD6L4POfLkjAOk2SUQcUWA06VzmTxRTdnx0wWMnwgHCF5AuAbNjoJqua4fahjtfTWjqtEDsI52To';
}
