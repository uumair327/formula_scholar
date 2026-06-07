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
  static const String profileHeroAvatarUrl = 'assets/images/wolf.png';

  /// Predefined list of advanced avatar options using DiceBear.
  static const List<String> avatarPresets = [
    'assets/images/wolf.png',
    'assets/images/fox.png',
    'assets/images/deer.png',
  ];

  // ──────────────────────── Onboarding Images ─────────────────
  /// Board selection decorative image.
  static const String onboardingBoardImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDVndYcp-dhzz3ArZ3CAUuKu94lnlqG7C_Tc3VUQgi0EwfrhJHPbBSYtFXLRxgu0XK-Rs17YpqSchKdtSV0qqIkfUz-glU6MperNXCZvSa_chXHHephTzzcnHyeDsh8bGusX2da-SQnSuuB2DqSt8gZSGpB619p--ZRONk2YbzTYXS-f0Y7eQke0MR9FJEC2LSUtXSw8_LG6H9ZdQU9Jt30cKMjOGyYQ_FiTzAc8ASVAR6OfzT5KeulC4wuZnY5bsho4VhuHM235mo';

  /// Grade selection decorative image.
  static const String onboardingGradeImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDtblrwDJhjrTHMzKfelpYsibXnTr8-zRVZBT3NgZ4o0kwhR74z8ZxRsjra4pmxuD-PMYLmWTThmFCwW4kT514QsAwQfVokoW7QQg6v3W9d-Hgto9BdfjNf_Cwoaw1FRW-TgxfaL9iIFzDvSQ23rrxk1x79-j3CXhq3AGvqy9Qh18pmBBq5mJ9q8IFOBNpx0PdRWxCoK16ct6F4JhVs2CxJDpxGiKV_AlztNTyeqbDpmjqxRkRDrOg0CgauIUPPV_PnR2YK4De5Z_c';

  /// Dashboard student profile image.
  static const String dashboardStudentProfileUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCjL6vWN18jDze2e5kebHX-lhzRubcD2vHSTKYvdUJHgUC6GS1CyrbrY0GD7bEyk2pROG0rkzlFmsRJLErDZJqP0tQFjFCsRZWvW37cH4xNMrLnGjAhh8EBbcEvqCgTHyjMMPUMaDgjE87j1gEVj1PABYSgG6cd33X-hre7s4fPJRS5CRy8UgVOPbnsz8KxBbpKkiNQnBILFHh5IzOmZYCBycepL_DlHNatUhDsLFpL9CZFkmxUuYa4-pSxDQcEBdbmr7ghugNqK0w';

  // ──────────────────────── Subject Images ───────────────────
  /// Math card image.
  static const String mathSubjectImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDGcnx-d5vE09VCQyyxe3kzAJAjNRe73ZoTvBru_pry7NqFmQuugeUYMjeon5Lg4Ghz2xM-6DYHb4zNIalqBbYz3WSpb4DURHKNlbKuKG3ZZi3hTmiyzg2gkGr4Mz2yP8fLJOmcfd1ttlQrPhmCUKLFci5cCHUYDT0caPE_WTqVQmCnUGIKGO83R44linzTUPsnD6L4POfLkjAOk2SUQcUWA06VzmTxRTdnx0wWMnwgHCF5AuAbNjoJqua4fahjtfTWjqtEDsI52To';

  // ──────────────────────── Practice ──────────────────────────
  /// Pi symbol image for question card background.
  static const String practiceQuestionImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuClyZ-0UYuRRBHxAK0Ii_GxesoYDVyrxZfvJWsymATBzNfEFu_iTlQKrn6WDEUNWXKoitdhKsUElgGpRyyEDswTW9KhMMYs5QimgyHDlitfY1ZJhQhiZOF7b4GxG2HZ-t9M95XrDj9ci-A4O49TQ6E3FzBYrSZEs9k4pH8cjHZeYeZcK5cCJ9fbre1soRe_zMPcEFzy3-XsnbRIvRP-wZLWM3lfBCxO1TpPnNRhgXNZULDzi3iu0pqVs0JAbFAFhDPU1sb6_0jjdHU';

  // ──────────────────────── Saved / Error ─────────────────────
  /// Error state illustration.
  static const String errorIllustrationUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuB-nSvc76fIjpiONFJOm9fo83DD9a60s513jsP18UPrPYXTHUvoywIaKDT-4ycThS-WmDWiBK7tIi8JZmMb-2N-G6sGiSdW8BBTtvFZVlyTdcnxKVhv75vIj4rulOGvZUj6MxoptJzSk49LxTsplI8xGph080qaEz1ojy5TlMhbjJXKhiY6_e5sObnZPNEmLqCAutYNiOLg0q_WAapxUYMQo-jQ42G7UD4HmQnt6erbKGViDMdSdnvJcay9LGbODSoWyAAAsu6vgww';
}
