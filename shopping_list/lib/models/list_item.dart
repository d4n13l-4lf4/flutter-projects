
class ListItem {
  int id;
  int listId;
  String name;
  String quantity;
  String note;

  ListItem(this.id, this.listId, this.name, this.note, this.quantity);

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'idList': listId,
      'name': name,
      'quantity': quantity,
      'note': note
    };
  }
}