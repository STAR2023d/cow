/// The categories a farmer can file an expense under. The database stores
/// the lowercase key; use [label] to show it on screen.
class ExpenseCategory {
  ExpenseCategory._();

  static const feed = 'feed';
  static const vet = 'vet';
  static const labour = 'labour';
  static const transport = 'transport';
  static const other = 'other';

  /// In the order they appear in the picker.
  static const all = [feed, vet, labour, transport, other];

  static const _labels = {
    feed: 'Feed',
    vet: 'Vet & medicine',
    labour: 'Labour',
    transport: 'Transport',
    other: 'Other',
  };

  /// 'feed' -> 'Feed'. An unknown key reads as 'Other'.
  static String label(String key) => _labels[key] ?? 'Other';
}
