/// Trasforma “Testo Qualunque” in “testo_qualunque”
String toSlug(String text) {
  return text
      .toLowerCase()
      .replaceAll(RegExp(r"[^\w\s-]"), '') // rimuove punteggiatura
      .trim()
      .replaceAll(RegExp(r"\s+"), '_');    // spazi → underscore
}
